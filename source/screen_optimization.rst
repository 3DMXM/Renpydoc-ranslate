.. _screen-language-optimization:

============================
界面语言优化
============================

Ren'Py有一些技巧能优化界面语言的速度。当使用Ren'Py创建复杂的接口时，例如模拟游戏使用的接口，理解界面语言的工作机制有助于你实现最佳的画面表现。

这篇指导适用于界面语言的第二种工具，是在Ren'Py的6.18版本中加入的。如果你的项目使用Ren'Py6.17或者更早的版本创建，最好在启动器(launcher)选择“强制重新编译”，确保界面工具升级到最新版本。

本指导并不能替代良好养成编程习惯的练习。如果某个界面使用循环嵌套实现一大堆无效的工作，就会比不需要这种循环的界面运行得慢。由于理解本指导中的技巧十分重要，完全避免这种辣鸡行为总是比让Ren'Py优化你的项目代码更好。

.. _parameter-list:

参数列表
==============

为了实现最好的画面效果，所有界面都应该定义一个参数列表。如果某个界面不使用参数，应该使用一个空的参数列表。这个界面：

::

    screen test():
        vbox:
            for i in range(10):
                text "[i]"

比下面那个运行得更快：

::

    screen test:
        vbox:
            for i in range(10):
                text "[i]"

当不使用参数列表定义一个界面时，界面使用的任何名称都可以在界面显示时被重定义。这要求Ren'Py分析界面时更加保守，限制优化级别。

.. _prediction:

预加载
==========

提前预加载界面可以提升表现效果。因为Ren'Py在预加载时间内依然会执行界面，并加载界面使用的图像。

总共有两种Ren'Py自动预加载界面的方法：

* Ren'Py会预加载通过 ``show screen`` 和 ``call screen`` 语句显示的界面。
* Ren'Py会预加载通过 :func:`Show` 和 :func:`ShowMenu` 动作显示的界面。

如果界面直接通过Python语句显示，最好在显示之前就开始预加载界面。开始预加载某个界面可以使用
:func:`renpy.start_predict_screen` 函数。停止预加载某个界面可以使用 :func:`renpy.stop_predict_screen`  函数。

.. _displayable-reuse:

可视组件的复用
=================

当编译解释界面语言中创建某个可视组件时，Ren'Py会检查固定位置参数和特性(property)是否与最近编译解释过的语句中有一样的。如果存在同样的可视组件，Ren'Py就不会创建新的，而是复用原来的。

可视组件的复用具有一系列性能表现方面的含义。它节省了创建新可视组件的消耗，很明显新创建可视组件包含大量的内部环节。更为重要的是，很多情况下的可视组件复用，Ren'Py显示时就不需要重新渲染了，可以导致另一项明显的速度提升。

要比较固定位置参数和特性(property)时，Ren'Py使用的相等概念即Python内嵌的 “==” 操作符。我们已经扩展了动作(action)的相等概念，可以判断两个动作是否相等，也就是动作间没有差异的情况——当无论哪个动作被调用，动作的需求和最终作用于组件的可用性和可选择性都相同。

所有Ren'Py提供的动作(action)都符合该定义。当定义你自己的动作(action)时，也需要让动作符合同样的相等概念。可以通过提供一个合适的 ``__eq__`` 函数实现。例如：

::

    class TargetShip(Action):
        def __init__(self, ship):
            self.ship = ship

        def __eq__(self, other):
            if not isinstance(other, TargetShip):
                return False

            return self.ship is other.ship

        def __call__(self):
            global target
            target = self.ship

认真定义 ``__eq__`` 函数很重要，确保这个函数可以比较动作的所有字段(field)，并可以合适地使用相等符号(==)和标识(is)比较。

.. _const-expressions-and-pure-functions:

常表达式和纯函数
====================================

Ren'Py可以检索常变量和纯函数的特性(property)，并提升界面赋值式的运行速度，且避免界面某些部分的赋值运算。

.. _definitions:

定义
-----------

如果一个表达式计算结果总是同样的值，那么这个表达式就是 **const** 的(constant常量的缩写)。出于Ren'Py的需要，只有在表达式计算结果为常量或者表达式被定义为常量时，表达式才是常表达式。

* 将任何一元，二元或三元运算符应用于表达式，前提是其他操作数也是常量。
* 访问表达式上的字段。
* 使用数字或对象为表达式建立索引。

Python的数值和字符串都是常量，由常量数值和字符串组成的列表、元组、集和字典类型数据也都是常量。Ren'Py中使用 ``define`` 语句将变量定义为常量。
:func:`renpy.const` 和 :func:`renpy.not_const` 函数可以用于在Ren'Py判断是否为常量的问题上进行更细致的操作。在下面的 :ref:`常量名称 <const-names>`
中会列出默认的常量名。

如果你使用的某个变量从来不会改变，使用 ``define`` 将其定义和声明为常量是合理的。例如：

::

    define GRID_WIDTH = 20
    define GRID_HEIGHT = 10

当某个可调用的函数、类(class)或者动作(action)的入参都是常量，返回值也始终是同一个常量，那么这个函数、类或者动作就是 **pure** (纯粹的)。除此之外，一个使用常表达式调用纯函数的表达式也总是一个常表达式。

大量的默认函数、类和动作都已被标记为“pure”。这些函数会在后面的 :ref:`纯函数名 <pure-names>`
章节中列出。

函数可以使用 :func:`renpy.pure` 定义为纯函数，并在默认存储区中用作函数修饰器(decorator)。

常表达式和纯函数在下列事件消息中不需要可以维护同一个值：

* 初始化段落的结尾。
* 语言的改变。
* 重建样式。

.. _how-const-optimizes-screen-language:

如何使用常量优化界面语言
-----------------------------------

确保界面语言入参和特性(property)是常量，会带来三点优势。

第一点优势是，常量入参和特性(property)在界面准备阶段就可以计算和简化，比如在初始化阶段结束时、语言改变时、重建样式时。在那之后，就不需要再浪费时间计算常量入参和特性了。

第二点优势是，常量与可视组件复用功能的相性很好。如果某个可视组件的入参和特性都是常量，那么这个可视组件就总是可以被复用的，获得了可视组件复用的最大收益。

最后一点优势是，当Ren'Py遇到可视组件的树(tree)，整个树的所有入参、特性和作用主控流程的表达式都是常量的话，Ren'Py就不在重新计算表达式或创建新的可视组件，而会重用整个树。这种规格的复用会带来明显的性能飞升。

例如，下列的界面不执行任何Python语句，仅在首次预加载或者显示时创建可视组件：

::

    screen mood_picker():
        hbox:
            xalign 1.0
            yalign 0.0

            textbutton "Happy" action SetVariable("mood", "happy")
            textbutton "Sad" action SetVariable("mood", "sad")
            textbutton "Angry" action SetVariable("mood", "angry")

.. _const-text:

常量文本
----------

定义文本时请注意，包含新样式文本替代的字符串都是常量：

::

    $ t = "Hello, world."
    text "[t]"

直接包含某个文本变量的字符串，一般不是常量：

::

    $ t = "Hello, world."
    text t

使用百分号替代格式的字符串，也不是常量：

::

    $ t = "Hello, world."
    text "%s" % t

最后需要注意的是，文本多语言支持函数下划线(_)是纯函数，所以如果这个函数包含一个字符串，整个表达式是常表达式：

::

    text _("Your score is: [score]")

.. _const-functions:

常函数
----------------

.. function:: renpy.const(name)

  将某个存储区的变量声明为常量。

  如果没有什么可以改变一个变量的值，或者无法建立索引抵达变量，或者不能存取变量的各种属性(attribute)，那这个变量就是常量。变量必须在定义、初始化和多语言支持Python语句块(block)之外保持一个常值。

  `name`
    一个字符串，表示声明为常量的变量名。

.. function:: renpy.not_const(name)

  将某个存储区的变量声明不是常量。

  这个函数会取消 :func:`renpy.const()` 和 :func:`renpy.pure()` 的效果。

  `name`
    声明不为常量的变量名。

.. function:: renpy.pure(fn)

  声明某个函数为纯函数。纯函数必须在定义、初始化和多语言支持Python语句块(block)之外总是使用同样的入参并返回同样的值。

  `fn`
    声明为纯函数的函数名。可以是包含函数名的字符串，或者函数本身。

  返回 *fn* ，允许函数用作修饰器(decorator)。

.. _profiling:

性能分析
=========

Ren'Py支持使用 ``renpy.profile_screen`` 函数对界面执行进行性能分析。

.. function:: renpy.profile_screen(name, predict=False, show=False, update=False, request=False, time=False, debug=False, const=False)

  请求对名为 *name* 的界面进行界面分析， *name* 必须是个字符串。

  除了 *name* ，所有入参都必须以关键词入参形式提供。该函数使用三组入参。

  `predict`
    若为真(True)，在界面预加载时进行性能分析。

  `show`
    若为真(True)，在界面第一次显示时进行性能分析。

  `update`
    若为真(True)，在界面更新时进行性能分析。

  `request`
    若为真(True)，在按下F8时进行性能分析。

  第二组入参控制性能分析的输出结果。

  `time`
    若为真(True)，Ren'Py会记录界面运算消耗的时间。

  `debug`
    若为真(True)，Ren'Py会记录界面运算的相关信息，包括：

    - 哪些可视组件被Ren'Py处理为常量。
    - 哪些入参需要被运算。
    - 哪些可视组件被复用。

    产生和记录这些调试信息会消耗可观的时间。所以当 *debug* 为真(True)时，输出的 *time* 时间应该就不是完全可信的。

  最后一组入参控制每次Ren'Py运行时的输出结果。

  `const`
    显示在界面中标记为常量和非常量的变量。

  所有性能分析输出都会记录在游戏目录的profile_screen.txt文件中。


.. _const-names:

常量名
===========

以下是默认的常量名：

- False
- None
- True
- config
- style


.. _pure-names:

纯函数名
==========

以下是默认为纯函数或常量名。

- ADVCharacter
- ADVSpeaker
- AddToSet()
- Alpha
- AlphaBlend()
- AlphaDissolve()
- AlphaMask()
- AnimatedValue()
- Animation
- At()
- AudioPositionValue()
- Call()
- Character()
- Color
- ComposeTransition()
- ConditionSwitch()
- Confirm()
- CropMove()
- DictInputValue()
- DictValue()
- DisableAllInputValues()
- Dissolve()
- Drag
- DynamicCharacter
- DynamicDisplayable()
- EndReplay()
- FactorZoom
- Fade()
- FieldInputValue()
- FieldValue()
- FileDelete()
- FilePage()
- FilePageNameInputValue()
- FileTakeScreenshot()
- Fixed()
- Flatten()
- FontGroup()
- Frame()
- Grid()
- HBox()
- Help()
- Hide()
- HideInterface()
- If()
- Image()
- ImageDissolve()
- ImageReference
- InputValue
- InvertSelected()
- Jump()
- Language()
- LiveComposite()
- LiveCrop()
- LiveTile()
- MainMenu()
- MixerValue()
- Motion
- MouseMove()
- Move
- MoveFactory
- MoveIn
- MoveOut
- MoveTransition()
- Movie()
- MultipleTransition()
- NVLCharacter
- Notify()
- Null()
- NullAction()
- OldMoveTransition
- OpenURL()
- Pan
- ParameterizedText()
- Particles
- Pause()
- PauseAudio()
- Pixellate()
- Play
- PlayCharacterVoice()
- Position
- Preference()
- PushMove()
- Queue()
- QueueEvent()
- QuickLoad()
- QuickSave()
- Quit()
- RemoveFromSet()
- Replay()
- RestartStatement()
- Return()
- Revolve
- RevolveInOut
- RollForward()
- Rollback()
- RotoZoom
- ScreenVariableValue()
- Screenshot()
- SelectedIf()
- SensitiveIf()
- SetCharacterVolume()
- SetDict()
- SetField()
- SetMixer()
- SetMute()
- SetScreenVariable()
- SetVariable()
- SetVoiceMute()
- Show()
- ShowMenu()
- ShowTransient()
- ShowingSwitch()
- SizeZoom
- Skip()
- SnowBlossom()
- Solid()
- Speaker
- Start()
- StaticValue()
- Stop
- StylePreference()
- SubTransition
- Text()
- ToggleDict()
- ToggleField()
- ToggleMute()
- ToggleScreen()
- ToggleScreenVariable()
- ToggleSetMembership()
- ToggleVariable()
- ToggleVoiceMute()
- Transform
- Update
- VBox()
- VariableInputValue()
- VariableValue()
- Viewport
- VoiceReplay()
- Window
- Zoom
- ZoomInOut
- _()
- _DisplayReset
- _InputValueAction
- _m1_00gallery__GalleryAction
- _m1_00gallery__GalleryToggleSlideshow
- _m1_00musicroom__MusicRoomPlay
- _m1_00musicroom__MusicRoomRandomPlay
- _m1_00musicroom__MusicRoomStop
- _m1_00musicroom__MusicRoomTogglePlay
- _m1_00preferences__DisplayAction
- _movebottom
- _moveleft
- _moveright
- _movetop
- _narrator
- _notify_transform
- _p()
- abs
- all
- any
- apply
- bin
- blinds
- bool
- bytes
- callable
- centered
- chr
- cmp
- color
- dict
- dissolve
- divmod
- fade
- filter
- float
- frozenset
- getattr
- globals
- gui.SetPreference()
- gui.TogglePreference()
- gui.preference()
- hasattr
- hash
- hex
- hpunch
- int
- irisin
- irisout
- isinstance
- len
- list
- long
- map
- max
- min
- name_only
- narrator
- oct
- ord
- pixellate
- pow
- pushdown
- pushleft
- pushright
- pushup
- range
- reduce
- renpy.Keymap
- renpy.ParameterizedText()
- renpy.check_text_tags()
- renpy.curried_call_in_new_context
- renpy.curried_invoke_in_new_context
- renpy.curry
- renpy.easy_displayable
- renpy.exists()
- renpy.filter_text_tags()
- renpy.fsdecode()
- renpy.fsencode()
- renpy.get_all_labels()
- renpy.has_label()
- renpy.has_screen
- renpy.image_exists
- renpy.image_size()
- renpy.known_languages()
- renpy.license
- renpy.list_files()
- renpy.loadable()
- renpy.munged_filename
- renpy.partial
- renpy.unelide_filename
- renpy.variant()
- renpy.version()
- renpy.version_name
- renpy.version_only
- renpy.version_string
- renpy.version_tuple
- repr
- round
- set
- slideawaydown
- slideawayleft
- slideawayright
- slideawayup
- slidedown
- slideleft
- slideright
- slideup
- sorted
- squares
- str
- sum
- tuple
- ui.callsinnewcontext
- ui.gamemenus
- ui.invokesinnewcontext
- ui.jumps
- ui.jumpsoutofcontext
- ui.returns
- unichr
- unicode
- vars
- vcentered
- vpunch
- wipedown
- wipeleft
- wiperight
- wipeup
- zip
- zoomin
- zoominout
- zoomout
