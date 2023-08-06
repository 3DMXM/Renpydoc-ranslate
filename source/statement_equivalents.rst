.. _statement-equivalents:

=====================
等效语句
=====================

为了允许Ren'Py能够在Python中脚本化，每个Ren'Py语句都有一条等效的Python语句。每条等效Python语句通常包含一个Python函数，也可能包含一个Python正则表达式，执行一个等效行为。

注意，在使用原生Python等效语句的地方，往往会移除 :ref:`lint` 检查和预加载优化，让游戏不利于检查问题并可能运行不那么流畅。某些情况下会导致部分功能特性不可用。

.. _state-equi-dialogue:

对话
========

.. warning::

    某些功能特性，比如快速跳过已看过对话，不能使用Python语句，只能使用原生say语句。

Ren'Py的 :ref:`say-statement` 等效于以一个函数的形式调用角色对象。显示旁白也使用了同样的办法，用的是 ``narrator`` 角色。：

::

    e "Hello, world."
    $ e("Hello, world.")

    "And then the sun exploded."
    $ narrator("And then the sun exploded.")

.. _say-proxy:

代理函数
---------

角色和函数对象的等效语句在其他方面也能正常运行。还可以定义一个Python函数，然后在角色对象的地方使用那个函数。例如，下面定义的函数使用一个变量，在两个角色中选择一个。

::

    define lucy_normal = Character("Lucy")
    define lucy_evil = Character("Evil Lucy")

    init python:

        def l(what, **kwargs):
            if lucy_is_evil:
                lucy_evil(what, **kwargs)
            else:
                lucy_normal(what, **kwargs)

    label start:

        $ lucy_is_evil = False

        l "大多数情况下，我都是个普通人。"

        $ lucy_is_evil = True

        l "不过有时候，疯起来我自己都害怕！"

这种使用函数的方式，要么忽略未知的关键词入参，要么将那些入参传给某个角色函数。这样做可以在未来版本的Ren'Py出现新关键词入参时，使游戏依然能运行。

注意，与其他语句不同，``interact=True`` 总是会传入该函数，除非手工传入 ``(interact=False)``。
:ref:`say-with-arguments` 章节可以看到传入参数的情况，例如：

::

    e "Hello, world." (what_size=32)

完全展开的话是：

::

    e("Hello, world.", what_size=32, interact=True)

调用角色对象时不需要显式传入 ``interact=True``。下面这种写法没有问题：

::

    $ e("Hello, world.", what_size=32)

若e是一个角色对象，还可以进一步等效为：

::

    $ Character(kind=e, what_size=32)("Hello, world.")

但可能需要使用 :var:`config.say_arguments_callback` 或将 ``e`` 扭转为某个角色对象才能实现其他功能。

还有一种在Python中替代say语句的方法：

.. function:: renpy.say(who, what, *args, **kwargs)

    say语句的等效语句。

    `who`
        None表示旁白，不然是发言角色对象，或表示角色名的字符串。最后那种情况， func:`say()` 函数会创建发言角色。

    `what`
        一行发言内容的字符串。字符串里带百分号(%)的部分会被替换(substitution)。

    `interact`
        若为True，Ren'Py显示对话并等待用户输入。若为False，Ren'Py显示对话，但不执行互动行为。(互动行为会以关键词入参传入相应的处理函数。)

    该函数极少直接使用，因为下面三行语句是完全等效的。

    ::

        e "Hello, world."
        $ renpy.say(e, "Hello, world.")
        $ e("Hello, world.")

.. _equivalent-dialogue-window-management:

对话窗口管理
-------------

通过设置 :var:`_window` 和 :var:`_window_auto` 可以实现 :ref:`窗口管理 <dialogue-window-management>`。
下面两个函数也用于对话窗口管理：

.. function:: _window_hide(trans=False, auto=False)

    ``window hide`` 语句的Python等效。

    `trans`
        若为False，使用默认的窗口隐藏转场。
        若为None，不使用转场。
        否则，使用指定的转场。

    `auto`
        若为True，此函数等效于 ``window auto hide`` 语句。

.. function:: _window_show(trans=False, auto=False)

    ``window show`` 语句的Python等效。

    `trans`
        若为False，使用默认的窗口显示转场。
        若为None，不使用转场。
        否则，使用指定的转场。

    `auto`
        若为True，此函数等效于 ``window auto show`` 语句。

.. _state-equi-choice-menus:

选项菜单
============

:doc:`menu语句 <menus>` 有一个等效的Python函数。

.. function:: menu(items, interact=True, screen="choice")

    该函数向用户显示一个菜单。 *item* 应该是一个二元元组列表。在每个元组中，第一个元素是一个文本标签(label)，第二个参数是该元素被选中时的返回值。如果返回值是None，第一个元素会用作整个菜单的标题。

    该函数使用多个入参，这份文档中只列出了其中一部分。除了 *items* 之外，所有都是关键字入参。

    `interact`
        若为False，显示菜单，但不执行任何互动行为。

    `screen`
        显示菜单的界面名。

.. function:: renpy.display_menu(items, interact=True, screen="choice")

    该函数向用户显示一个菜单。 *item* 应该是一个二元元组列表。在每个元组中，第一个元素是一个文本标签(label)，第二个参数是该元素被选中时的返回值。如果返回值是None，第一个元素会用作整个菜单的标题。

    该函数使用多个入参，这份文档中只列出了其中一部分。除了 *items* 之外，所有都是关键字入参。

    `interact`
        若为False，显示菜单，但不执行任何互动行为。

    `screen`
        显示菜单的界面名。

.. _state-equi-displaying-images:

显示图像
=================

image、scene、show和hide语句都一个等效的Python函数(详见 :doc:`displaying_images`)。

.. function:: renpy.get_at_list(name, layer=None)

    将图层 *layer* 上图像标签名为 *tag* 的图像所应用的变换(transform)，以列表形式返回。如果没有使用任何变换(transform)则返回一个空列表，如果图像不显示则返回None。

    如果 *layer* 为None，就是用给定图像标签(tag)所在的默认图层。

.. function:: renpy.hide(name, layer=None)

    从某个图层中隐藏某个图像。hide语句的等效Python语句。

    `name`
        需要隐藏的图像名称。只是用图像标签(tag)，所有带相同标签的图像都将被隐藏(图像全名不重要)。

    `layer`
        该函数操作的图层名。若为None，使用图像标签(tag)关联的默认图层。

.. function:: renpy.image(name, d)

    定义一个图像。该函数是image语句的等效Python语句。

    `name`
        需要显示的图像名称，是一个字符串。

    `d`
        与图像名关联的可视组件。

    该函数可能仅能在init语句块(block)中运行。游戏开始后运行该函数会触发一个报错。

.. function:: renpy.scene(layer='master')

    从图层 *layer* 移动所有可视组件。当scene语句没有指定一个需要显示的图像时，这是scene语句的等效Python语句。

    一个完整的scene语句等效于调用renpy.scene之后再调用 :func:`renpy.show()` 。举例：

    ::

        scene bg beach

    等效于：

    ::

        $ renpy.scene()
        $ renpy.show("bg beach")

.. function:: renpy.show(name, at_list=[], layer='master', what=None, zorder=0, tag=None, behind=[])

    在某个图层上显示某个图像。这是show语句的等效Python语句。

    `name`
        需要显示的图像名称，是一个字符串。

    `at_list`
        应用于图像的变换(transform)列表。等效于 ``at`` 特性(property)。

    `layer`
        一个字符串，表示图像显示使用的图层名。等效于 ``onlayer`` 特性(property)。若为None，使用图像标签(tag)关联的默认图层。

    `what`
        若非None，这是一个代替图像的可视组件。(等效于show表达式语句。)当给定了一个 *what* 参数时， *name* 可以用于将图像与标签(tag)关联。

    `zorder`
        一个整数，等效于 ``zorder`` 特性(property)。若为None，zorder会保留之前的值，否则设置为0。

    `tag`
        一个字符串，用于指定显示图像的标签(tag)。等效于 ``as`` 特性(property)。

    `behind`
        一个字符串列表，表示需要显示的图像在哪些图像标签(tag)后面。等效于 ``behind`` 特性(property)。

.. function:: renpy.show_layer_at(at_list, layer='master', reset=True)

    ``show layer`` *layer* ``at`` *at_list* 语句的等效Python语句。

    `reset`
        若为True，当图层显示时，变换(transform)状态会重置为开始状态。若为False，变换状态会保持，允许新的变换更新状态。

.. _state-equi-transitions:

转场
===========

:ref:`with-statement` 等效于 :func:`renpy.with_statement` 函数。

.. function:: renpy.with_statement(trans, always=False)

    触发一个转场(transition)。这是with语句的Python等效语句。

    `trans`
        转场(transition)名。

    `always`
        若为True，在用户禁用转场的情况下依然显示转场效果。

    当用户中断转场时该函数返回True，其他情况返回False。

.. _jump:

jump语句
========

:ref:`jump-statement` 的等效于 :func:`renpy.jump` 函数。

.. function:: renpy.jump(label)

    结束当前语句，并让主控流程跳转到给定的脚本标签(label)。

.. _call:

call语句
========

:ref:`call-statement` 的等效于 :func:`renpy.call` 函数。

.. function:: renpy.call(label, *args, **kwargs)

    结束当前Ren'Py语句，并跳转到 *label* 处。当jump返回后，主控流程会返回到之前的语句。

    `from_current`
        若为True，主控流程会返回到当前语句，而不是当前语句的下一句。(这会导致当前语句运行两次。这项必须作为关键词入参传入。)

.. function:: renpy.return_statement()

    触发Ren'Py从当前Ren'Py级别的调用返回。

pause语句
=========

:ref:`pause-statement` 语句等效于 :func:`renpy.pause` 函数。

.. function:: renpy.pause(delay=None, *, hard=False, predict=False, modal=False)

    使Ren'Py暂停。用户点击使暂停结束将返回True，暂停超过设定时间或暂停被跳过则返回False。

    `delay`
        指定Ren'Py暂停时间。单位为秒。

    下列是关键词参数：

    `hard`
        必须作为关键词参数传入。该入参为True时，Ren'Py将屏蔽用户点击操作，暂停无法被取消。
        如果用户启用了跳过(skipping)，此暂停依然可以跳过。
        某些情况下hard暂停会提早结束后无法正常屏蔽用户操作，这些都不是bug。

        总体来说，使用hard暂停是鲁莽的。当用户使用点击推进游戏时——这算一种明确的需求，用户希望游戏剧情可以前进。
        在用户需求之上做功能设计的前提是，创作者比用户自己更了解用户需求。

        调用renpy.pause可以保证界面内容至少显示1帧，以让用户能够确实看到内容。

        总结：尽量不要调用 renpy.pause 时 hard=True。

    `predict`
        若为True，Ren'Py会等到所有预加载完成后再暂停。
        预加载包括使用 :func:`renpy.start_predict` 和 :func:`renpy.start_predict_screen` 函数的场景。

        将该项设置为True时，Ren'Py在暂停期间将优先处理预加载任务，而将图像平滑显示的任务放在预加载后面。
        因为推荐不要在预加载期间播放动画动效。

    `modal`
        若为True或None，显示某个模态界面将不会结束此次暂停。
        若为False，显示某个模态界面将结束此次暂停。

.. _layeredimage:

层叠式图像
============

group语句没有直接的等效语句：group名称需要通过 :class:`Attribute` 类赋值，
``auto`` 功能需要使用 :func:`renpy.list_images` 函数实现。

.. class:: Attribute(group, attribute, image=None, default=False, group_args={}, **kwargs)

    该类用于表示LayeredImage对象中受某个属性控制的图层。单个属性可以控制多个图层，使这些图层同时显示或隐藏。

    `group`
        一个字符串，表示属性所属的组(group)名称。可以是None，表示 `group` 与 `attribute` 相同。

    `attribute`
        一个字符串，表示属性名称。

    `image`
        若不是None，该入参应该是与属性关联显示的某个可视组件。

    `default`
        若为True并且组中没有其他属性时，这就是默认的属性。

    下列关键词入参与层叠式图像语句的group定义相同：

    `at`
        应用于图层的一个变换(transform)或变换的列表。

    `if_all`
        属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都出现时，才显示图层(layer)。

    `if_any`
        属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只要有任意特定的属性出现时，就显示图层(layer)。

    `if_not`
        属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都不出现时，才显示图层(layer)。

    其他关键词入参会当作变换特性使用。这种情况下，就是用变换对象处理图像。
    (例如，入参 pos=(100, 200) 会用来将图像分别向水平方向平移100像素、垂直方向平移200像素。)

    如果 `image` 参数被省略或值为None，且LayeredImage对象被指定了 `image_format` 参数，
    那么image_format参数用于生成图片文件名。

.. class:: Condition(condition, image, **kwargs)

    当条件表达式结果为True时，显示图层。否则，不显示图层。

    该类用于实现layeredimage语句中的单条 ``if``、``elif`` 或者 ``else`` 条件表达式(遇到 ``else`` 的情况必须为“True”)，
    将一些Condition对象传入 :class:`ConditionGroup` 可以模拟一套完整的 if/elif/else 条件语句。

    `condition`
        该参数是一个字符串，表示一个Python条件表达式，判断图层是否显示。

    `image`
        若不是None，该参数应是一个可视组件，当条件表达式为True时显示。

    `if_all`
        属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都出现时，才显示图层(layer)。

    `if_any`
        属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只要有任意特定的属性出现时，就显示图层(layer)。

    `if_not`
        属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都不出现时，才显示图层(layer)。

    `at`
        应用于图层的一个变换(transform)或变换的列表。

    其他关键词入参会当作变换特性使用。这种情况下，就是用变换对象处理图像。
    (例如，入参 pos=(100, 200) 会用来将图像分别向水平方向平移100像素、垂直方向平移200像素。)

.. class:: ConditionGroup(conditions)

    将一个 :class:`Condition` 类型的列表组合为一个 :func:`ConditionSwitch`。

    实现 if/elif/else 语句。

.. class:: LayeredImage(attributes, at=[], name=None, image_format=None, format_function=None, attribute_function=None, offer_screen=None, **kwargs)

    这是一个类似图像的对象，可以使用合适的属性集，显示可视组件。此可视组件由关联属性合成。

    `attributes`
        This must be a list of Attribute, Condition, ConditionGroup or
        :doc:`displayable <displayables>` objects. Each one
        reflects a displayable that may or may not be displayed as part
        of the image. The items in this list are in back-to-front order,
        with the first item further from the viewer and the last
        closest.
        Passing a displayable directly is the equivalent of the `always`
        layeredimage statement.
        该参数必须是一个Attribute对象、Condition对象、ConditionGroup对象或 :doc:`displayable <displayables>` 对象构成的列表。

    `at`
        一个变换(transform)或变换的列表，会参数化之后应用到可视组件。

    `name`
        层叠式图像名称，是完整图像组件名的一部分。

    `image_format`
        当给定的图像是一个字符串，同时提供了此参数时，会使用文件名加上 `image_format` 生成图片文件名。
        例如，“sprites/eileen/{image}.png”会在对应的目录中搜索图片。(不会被auto组使用，auto组只搜索图像对象而不搜索图片文件。)

    `format_function`
        此函数用于代替  `layeredimage.format_function` 将图像信息格式为可视组件。

    `attribute_function`
        若不是None，此参数是一个函数。使用一个属性集作为参数调用该函数并应用到指定图像，函数返回一个属性集用于选择图层。
        在选择完属性之后，判断图层是否显示时会调用该函数。该函数可用于处理属性之间复杂的依赖关系，或者需要随机性的情况。

    `offer_screen`
        该参数决定子组件的位置和大小是否要根据目标区域做调整。若该项为False则进行调增，若为True则保持原状。
        若为None，则根据配置项 :var:`config.layeredimage_offer_screen` 决定。

    额外的关键词入参可能包含变换特性(transform property)。如果出现这种情况，将创建变换对象并处理结果图像。
    剩下的关键词入参将传给一个Fixed组件用于放置图层。除非显式覆盖，该Fixed组件的xfit和yfit特性会设置为True，
    将会在使用最小尺寸填充指定区域以匹配图层上所有显示图像。

    LayeredImage对象不是可视组件，也不能完全跟可视组件一样使用。因为LayeredImage对象必须有图像名称(大多数时候还必须有图像属性)。
    所以，其要么使用scene或show语句来显示，要么像可视组件一样通过图像名字符串来调用。

    .. method:: add(a)

        `a`
            一个Atrribute、Condition、ConditionGroup或 :doc:`displayable <displayables>` 对象。

        该方法为图层指定了层叠式图像的图层列表，会作为 `attributes` 入参传给构造器。