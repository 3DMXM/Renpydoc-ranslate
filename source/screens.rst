.. _screens:

.. _screens-and-screen-language:

===========================
界面和界面语言
===========================

用户在Ren'Py游戏中所有的可见元素可以分为图像和用户接口两大类。图像通过scene、show和hide语句向用户展示，也是故事叙述的大头。其他所有可见的元素都属于用户接口。用户接口可以通过界面实现定制化。

界面有下列4种方式显示：

* 隐含在脚本语句执行中。例如，say语句会触发 `say` 界面的显示。
* 自动显示。例如，Ren'Py启动后或者用户退回到主菜单时，会显示 `main_menu` 界面。
* 作为一个用户行为，与按钮、鼠标按键或者键盘按键相关联。默认情况下， `save` 界面是用户鼠标右击或者按下退出(Esc)键才会展示。也可以定义一个on-screen按钮用于显示 `save` 界面。
* 明确使用某些语句触发界面显示的情况。

可以一次显示多个界面。

界面有两个主要功能。第一个是向用户显示信息。信息的显示可以使用文本、条(bar)和图像(image)。使用这种方法显示某些信息是游戏的需要。例如， `say` 界面用于向用户显示对话，包括说话人的名字和说话内容。

界面的另一个功能是允许用户与游戏交互。按钮和条(bar)允许用户触发某些行为(action)和调整数值。Ren'Py包含一个预定义行为的池，允许用户快进、个性化控制、读档和存档等。创作者还可以使用Python编写新的行为。

每次交互行为的启动或重启，都会更新界面。注意 ``with None`` 语句不会触发互动，也不会更新界面。

**界面的改变不应该引发界面之外可视区域的副作用。** Ren'Py会根据需要多次运行同一个界面。Ren'Py会在界面显示之前运行一些运行图像预加载进程。因此，如果界面有副作用，在预加载阶段就会发生。

每个界面有一个作用范围(scope)与其关联，并有一些给定的变量值。如果某些界面中包含变量，首先在界面的作用范围(scope)内查找变量，然后再查找全局变量。

.. _screen-language:

界面语言
===============

界面语言是显示界面最正式的办法。它包含定义新界面的语句、添加可视组件至界面的语句和控制型语句。

这是一个界面的样例：

::

    screen say(who, what):
        window id "window":
            vbox:
                spacing 10

                text who id "who"
                text what id "what"

这段脚本的第一行是一个screen语句。Ren'Py中使用screen语句定义一个界面。界面的名字是
`say`，所以该界面用于显示对话。其有两个入参，分别是 `who` 和 `what`。

界面包含一个窗口，窗口id就叫“window”。窗口中包含一个垂直的框(box)，框内的空间为10个像素。它包含两个文本字段(field)，一个是发言者的名字，另一个是发言者的id。

.. _screen-language-syntax:

界面语言语法
----------------------

大多数界面语言语句使用通用的语法。(某些控制语句使用其他语法。)语句的开头以某个关键词进入。

如果语句使用参数，参数就跟着开头的关键词后面。参数列表是使用空格分隔的简单表达式，除非有特殊情况。

固定位置参数后面会跟一个特性(property)列表。一个特性包括特性名称和特性值组成。特性值是简单表达式，除非有特殊情况。特性列表中各个特性使用空格分隔。

如果某个语句以英文冒号(:)结尾，后面就会跟一个语句块(block)。语句块的每一行可能是以下两者之一：

* 一个特性列表。
* 一条界面语言语句。

.. _screen-statement:

screen语句
----------------

``screen`` 语句在Ren'Py脚本语言中用于定义一个新的界面。其使用界面语言通用语法。

screen语句使用一个参数，即界面名。界面名不是一个简单表达式，可以使用以下特性：

`modal`
    若为True，该界面是一个模态框(modal)。一个模态框界面防止用于与它下层的可视组件发生互动，除了默认的keymap类。

`sensitive`
    决定界面是否被启用的表达式。每次交互行为时，该表达式都至少会被计算一次。

`tag`
    被当作一个变量名处理，而不是一个表达式。该特性指定一个与界面关联的图像标签(tag)。显示某个界面会替换带用相同图像标签的其他界面。这可以用来确保在相同的上下文环境下，同一时间只有显示一个菜单界面。

`zorder`
    该特性用于控制向用户显示界面的远近。数值越大，界面距离用户越近。默认值是0。

`variant`
    如果该特性出现，应该是一个字符串或者字符串的列表，给定了待定义的变种界面。详见 :ref:`界面变种 <screen-variants>`。

`style_prefix`
    该特性是一个字符串，用于向界面所有子组件的样式提供一个前缀， :ref:`如下描述 <style-prefix>`。

`layer`
    该特性是一个字符串，给定了显示界面的默认图层(layer)名。

`roll_forward`
    若为True，使用 ``call screen`` 语句时将启用前向滚动。
    若为False，禁用前向滚动。
    若为None或没有指定，则使用 :var:`config.call_screen_roll_forward` 的值。

    使用 ``call screen`` 语句启用前向滚动后，将保留返回值和待跳转标签，但不会引发副作用。
    这意味着，如果界面中只包含 :func:`Jump` 和 :func:`Return` 行为，启用 `roll-forward` 是安全的。
    其他行为则在前向更难懂时可能会引发副作用。

::

    screen hello_world():
        tag example
        zorder 1
        modal False

        text "Hello, World."

界面可以使用一个参数列表：

::

    screen center_text(s, size=42):
        text s size size

如果界面不带任何参数，依然需要给一堆空的圆括号。
如果其他界面用 ``use`` 语句直接引用该界面并不带参数，详细的差异在 :ref:`use语句 <sl-use>` 中有说明。
其实不是用 ``use`` 语句引用界面或不带圆括号的界面，都会是Ren'Py内部效率降低，详见 :doc:`界面优化 <screen_optimization>` 章节。

.. _user-interface-statements:

用户接口语句
=========================

用户接口语句用于创建可视组件并添加至界面或某个封闭的可视组件。它们允许向用户显示信息，用户与游戏的互动，以及游戏中各种事件消息的相互作用。

.. _common-properties:

所有用户接口语句使用下列通用特性：

`at`
    一个transform、transform的列表或者匿名transform(未定义直接在at中使用的transform)。

    ::

        transform hello_t:
            align (0.7, 0.5) alpha 0.0
            linear 0.5 alpha 1.0

        screen hello_title():
            text "Hello." at hello_t
            text "Hello.":
                at transform:
                    align (0.2, 0.5) alpha 0.0
                    linear 0.5 alpha 1.0

    可用于wrap可视组件。show、hide、replace和replaced external事件消息会传入transform，前提是transform是被直接添加到界面上的。

    例如，如果某个vbox在某transform中被wrap，并直接添加到界面上，事件消息就会传给那个transform。但如果某个按键文本是添加到vbox再被加入transform中被warp，那么第二层的transform就不会接收到事件消息。

`default_focus`
    如果出现了该特性，并且值为True，默认情况下该可视组件会得到焦点。只有一个可视组件可以拥有该特性。

    只有当最后一次互动不是鼠标点击、鼠标移动或触控点击时，才会使用默认焦点。

`id`
    用户接口语句的标识号。当某个界面显示时，特性值可以通过给定的标识符提供给可视组件。某些界面会根据创建的标识号请求某个可视组件。

    默认情况下，这个 ``id`` 是自动生成的。

`style`
    应用于可视组件的样式名。其可能是一个字符串名，也可能是一个样式对象。该样式指定样式特性的默认值。

`style_prefix`
    .. _style-prefix:

    向可视组件及其子组件的样式提供了一个前缀，例外情况是某些子组件用一个指定的样式或样式前缀。

    样式名由样式前缀、下划线和样式后缀组成。样式后缀通过样式后缀
    `style_suffix` 或可视组件决定。

    例如，如果某个vbox有一个样式前缀 ``"pref"`` ，这个vbox的样式名就是 ``"pref_vbox"`` 。除非设置了某个指定的样式或者样式前缀，vbox内的按钮会用样式
    ``"pref_button"``。

    如果样式不存在的话，使用这种方式接入的样式会被自动创建。将前缀设置为 ``None`` 会将可视组件及其子组件的所有前缀都移除。

`style_group`
    `style_prefix` 的一个别名，用在旧版本的Ren'Py中。

`style_suffix`
    指定后缀，与 `style_prefix` 连在一起创建一个样式名。如果后缀是 ``"small_button"`` ，前缀是 ``"pref"`` ，实用的样式名就是 ``"pref_small_button"`` 。

    如果不使用样式前缀，就是直接使用样式名。样式后缀就会只应用于某一个可视组件，而不会用于其子组件。

`focus`
    该特性使用一个字符串或整数，并出于获取焦点的需求，给出一个可视组件的名称。Ren'Py会搜索与focus结构相似的特性名，并决定在某交互行为开始后最先获取到focus的可视组件。如果某个框(box)给定了一个focus名，并且框内的第三个按钮在交互行为结束时获取到焦点，某个同名框(box)的第三个按钮会在下一个交互行为开头显示为高亮。

`tooltip`
    声明某个可视组件的工具提示框。当可视组件获得焦点时，该特性值会启用
    :func:`GetTooltip` 函数。详见 :ref:`tooltips` 章节。
    传入工具提示框的对象必须支持相等性(equality)。如果不支持比较相等，可能会导致无限死循环。

`arguments`
    一个元组或列表，包含传入可视组件的额外固定位置入参。

`properties`
    一个字典，包含传入可视组件的额外特性。

许多用户接口语句使用样式特性类或者transform特性。这些特性可以使用相关联的样式前缀，前缀决定了特性被应用的时机。例如，如果带有 ``hover_size`` 特性，就会设置文本在鼠标悬停状态时的文本字号。

UI语句可以使用 ``as`` 从句，后面带一个变量名，不需要引号。
语句创建的可视组件对象将声明为变量。(在这里可以找到一个样例 :ref:`拖拽组件 <as-example>`.)

.. _sl-bar:

bar
--------

创建一个原本水平的条(bar)，可用于查看和调整数据。其使用以下特性：

`value`
    条(bar)的当前值。可以是一个 :ref:`条(bar)值 <input-values>`
    对象，或者一个数值。

`range`
    条(bar)的最大值。如果 `value` 是一个数值的话，这个特性是必须的。

`adjustment`
    该条(bar)所调整的 :func:`ui.adjustment` 对象。

`changed`
    若该值存在，应该是一个Python函数。当 *adjustment* 改变时，这个函数会用调整后的值被调用。

`hovered`
    当条(bar)获取焦点后的行为。

`unhovered`
    当条(bar)失去焦点后的行为。

`released`
    在条(bar)被释放时执行指定的行为。甚至条的数值没有发生变化时依然会被调用执行。


`value` 或者 `adjustment` 之一必须给定。除此之外，该函数还是用以下特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`条(bar)样式特性 <bar-style-properties>`

条(bar)不包含任何子组件。

::

    screen volume_controls():
        frame:
            has vbox

            bar value Preference("sound volume") released Play("sound", "audio/sample_sound.ogg")
            bar value Preference("music volume")
            bar value Preference("voice volume")

.. _sl-button:

按钮(button)
-------------

创建界面的一块区域，可以通过点击激活并运行一个行为。按钮(button)不接受参数，可以使用下列特性。

`action`
    当按键激活时会执行的行为。按钮被点击时会被激活，用户也可以使用其他方法选中按钮并按下键盘“Enter”键。在 `sensitive`
    特性没有提供的情况下，它还能控制让按钮改为sensitive(启用)状态；同样，在 `selected` 特性没有提供的情况下，它也能控制按钮被选中。

`alternate`
    使用转化过的办法在按钮激活后运行的行为。当用户在基于鼠标的平台上那个点击鼠标右键，或者用户在基于触控的平台上长按某个按钮，都会触发。

`hovered`
    当按钮获取焦点时运行的行为。

`unhovered`
    当按钮失去焦点时运行的行为。

`selected`
    决定按钮是否被选择的表达式。每次交互行为时，该表达式都至少会被计算一次。如果该特性没有提供，用户行为会最终决定按钮是否被选择。

`sensitive`
    决定按钮是否被启用的表达式。每次交互行为时，该表达式都至少会被计算一次。如果该特性没有提供，用户行为会最终决定按钮是否被启用。

`keysym`
    给定了一个 :doc:`keysym <keymap>` 的字符串。字符串描述了键盘对应的按键，当那个按键被按下后，会调用按钮的行为。

`alternate_keysym`
    给定了一个 :doc:`keysym <keymap>` 的字符串。字符串描述了键盘对应的按键，当那个按键被按下后，会调用按钮的可选变换行为。

它还可以使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`窗口样式特性 <window-style-properties>`
* :ref:`按钮样式特性 <button-style-properties>`

按钮使用一个子组件。如果0个、两个或者更多子组件被应用，他们全部会自动整合为一个固定布局(fixed)，并添加到按钮上。

.. _sl-dismiss:

dismiss
-------

``dismiss`` 语句创建一个高度特化的dismiss可视组件，在其他可视组件都没有获得焦点时，dismiss组件就会获得焦点，并在激活后执行一个行为。
从效果上来说类似say语句。

dismiss组件的应用场景不多，大多数时候与某个模态frame搭配，当用户点击frame之外的区域时激活dismiss。此外，偶尔也能用作弹窗。

该组件可使用下列特性：

`action`
    当dismiss组件激活时执行的行为。该特性必须指定。

`keysym`
    指定一个字符串，代替默认的 :doc:`keysym <keymap>` 字典中dismiss键对应的值。

`modal`
    默认情况下，dismiss组件是模态的，不允许向其“背后”的其他可视组件传递事件消息。


该组件还可使用下列特性：

* :ref:`通用特性 <common-properties>`
* :propref:`hover_sound` 和 :propref:`activate_sound` 样式特性。

这是一个dismiss的使用样例：

::

    screen dismiss_test():

        dismiss action Return()

        frame:
            modal True

            align (.5, .3)
            padding (20, 20)

            has vbox

            text "这是一条非常重要的信息。":
                xalign 0.5
                text_align 0.5

            # Dismiss can be confusing on its own, so we'll add a button as well.
            # 译者注：上面一句注释似乎是作者在玩梗，但是太冷导致不知道如何翻译。
            textbutton "Dismiss":
                xalign 0.5
                action Return()

dismiss组件还可以与 :ref:`nearrect <sl-nearrect>` 协同实现其他效果。

.. _sl-fixed:

fixed
-----

fixed创建了一块用于添加子组件的区域。默认情况下，固定布局(fixed)会扩展并填充整个可用区域，但 :propref:`xmaximum`
和 :propref:`ymaximum` 特性可以改变这点。

子组件们使用自身的位置样式特性实现布局。如果没有合适的设置位置，它们可能会重叠。

fixed语句不接受参数，后面跟以下特性：

* :ref:`通用特性  <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`固定布局的样式特性 <fixed-style-properties>`

fix使用多个子组件，它们会被添加到固定布局中。

显示创建一个固定布局可视组件通常并不是必要的。每个界面都被包含在一个固定布局可视组件中，并且很多界面语言语句会自动创建一个固定布局的可视组件，前提是他们有两个或更多子组件。

::

    screen ask_are_you_sure:
        fixed:
             text "Are you sure?" xalign 0.5 yalign 0.3
             textbutton "Yes" xalign 0.33 yalign 0.5 action Return(True)
             textbutton "No" xalign 0.66 yalign 0.5 action Return(False)


.. _sl-frame:

框架(frame)
------------

框架(frame)是窗口，该窗口包含一个背景，可用于显示用户接口元素，例如按钮、条(bar)和文本。其使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`窗口样式特性 <window-style-properties>`

frame使用一个子组件。如果0个、两个或者更多子组件被应用，他们全部会自动整合为一个固定布局(fixed)，并添加到按钮上。

::

    screen test_frame():
        frame:
            xpadding 10
            ypadding 10
            xalign 0.5
            yalign 0.5

            vbox:
                text "Display"
                null height 10
                textbutton "Fullscreen" action Preference("display", "fullscreen")
                textbutton "Window" action Preference("display", "window")

.. _sl-grid:

grid
----

grid在一个网格系统中显示其子组件。每个子组件都会分配相同的区域大小，这个区域大小可以容纳最大的子组件。

grid使用两个参数。第一个参数是网格的行号，第二个参数是网格的列号。其使用下列特性：

`transpose`
    若值为False，网格转置。

其还使用以下特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`网格样式特性 <grid-style-properties>`

grid中必须给定“行数×列数”的子组件。如果给出其他数量的子组件会发生错误。

::

    screen grid_test:
         grid 2 3:
             text "Top-Left"
             text "Top-Right"

             text "Center-Left"
             text "Center-Right"

             text "Bottom-Left"
             text "Bottom-Right"

.. _sl-hbox:

hbox
----

hbox的各个子组件会边靠着边显示，都在一个不可见的水平方块(box)内。其不接受参数，后面跟以下特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`方框样式特性 <box-style-properties>`

UI可视组件的子组件会被添加到方框(box)中。

::

   screen hbox_text():
       hbox:
            text "Left"
            text "Right"


.. _sl-imagebutton:

图片按钮(imagebutton)
----------------------

创建一个包含图像的按钮，当指针悬停在按钮上时，图像状态会发生改变。其不接受参数，使用下列特性：

`auto`
    按钮使用图片自动定义。这个特性是个包含 %s 的字符串。如果某个图片特性是省略的，%s会被替换为对应特性名称，并使用对应值作为对应特性的默认值。

    例如，如果 `auto` 是 "button_%s.png"，并且  `idle` 特性省略，那么idle的默认值就是 "button_idle.png"。类似的，如果 `auto` 是"button %s"，那么 ``button idle`` 图像就会被应用。

    `auto` 特性的具体行为可以修改
    :var:`config.imagemap_auto_function` 实现定制化。


`insensitive`
    当按钮不可用状态时，使用在按钮上的图像。

`idle`
    当按钮没有得到焦点状态时，使用在按钮上的图像。

`hover`
    当按钮得到焦点状态时，使用在按钮上的图像。

`selected_idle`
    当按钮被选中但是没有得到焦点状态时，使用在按钮上的图像。

`selected_hover`
    当按钮被选中而且得到焦点状态时，使用在按钮上的图像。

`action`
    当按钮被激活时运行的行为。当  `sensitive` 和  `selected` 特性没有提供的情况下， *action* 特性也控制那两种特性表现。

`alternate`
    使用转化过的办法在按钮激活后运行的行为。当用户在基于鼠标的平台上那个点击鼠标右键，或者用户在基于触控的平台上长按某个按钮，都会触发。

`hovered`
    当按钮获取焦点时运行的行为。

`unhovered`
    当按钮失去焦点时运行的行为。

`selected`
    决定按钮是否被选择的表达式。每次交互行为时，该表达式都至少会被计算一次。如果该特性没有提供，用户行为会最终决定按钮是否被选择。

`sensitive`
    决定按钮是否被启用的表达式。每次交互行为时，该表达式都至少会被计算一次。如果该特性没有提供，用户行为会最终决定按钮是否被启用。

`keysym`
    给定了一个 :doc:`keysym <keymap>` 的字符串。字符串描述了键盘对应的按键，当那个按键被按下后，会调用按钮的行为。

`alternate_keysym`
    给定了一个 :doc:`keysym <keymap>` 的字符串。字符串描述了键盘对应的按键，当那个按键被按下后，会调用按钮的变换行为。

它还可以使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`窗口样式特性 <window-style-properties>`
* :ref:`按钮样式特性 <button-style-properties>`

图片按钮没有子组件。

::

    screen gui_game_menu():
         vbox xalign 1.0 yalign 1.0:
              imagebutton auto "save_%s.png" action ShowMenu('save')
              imagebutton auto "prefs_%s.png" action ShowMenu('preferences')
              imagebutton auto "skip_%s.png" action Skip()
              imagebutton auto "afm_%s.png" action Preference("auto-forward mode", "toggle")


.. _sl-input:

输入框(input)
--------------

创建一个文本输入区域，允许用户输入文本。当用户按下回车键，输入的文本会通过交互行为返回。(如果界面是通过 ``call screen`` 唤起的，输入结果会存放在 ``_return`` 变量中。)

受限于支持的库，在安卓和Web平替上，输入框只支持英文字母。

input语句不接受参数，可以跟下列特性：

`value`
    此次输入使用的 :ref:`input value <input-values>` 对象。输入值对象决定了以下情况的默认处理方式：默认值从哪里获取，文本改变时会发生什么，用户输入回车后会发生什么，以及文本是否可编辑。

    `value` 应跟 `default` 和 `changed` 在相同的时间点给定。

`default`
    在输入框中的默认文本。

`length`
    输入框中允许的最大文本长度。

`pixel_width`
    输入框最大像素宽度。如果输入一个字符会导致输入超出这个宽度，按键(keypress)事件消息就会被忽略。

`allow`
    包含所有允许输入字符的字符串。(默认情况下允许输入任何字符。)

`exclude`
    包含不允许输入字符的字符串。(默认情况下为空“{}”。)

`copypaste`
    若为True，可以在这个输入栏中启用复制粘贴功能。(默认禁用。)

`prefix`
    一个不可变的字符串，自动添加在用户输入前面。

`suffix`
    一个不可变的字符串，自动添加在用户输入后面。

`changed`
    当用于输入字符串改变时，使用输入字符串调用的一个Python函数。

`mask`
    该值是一个字符串，可将文本中的字符都替换显示为指定字符串。可用于表现一个密码。

`caret_blink`
    若非False，指定光标闪烁间隔时间。此项将覆盖 :var:`config.input_caret_blink` 配置项。



输入框还使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`文本样式特性 <text-style-properties>`

输入框不包含子组件。

::

    screen input_screen():
        window:
            has vbox

            text "Enter your name."
            input default "Joseph P. Blow, ESQ."


.. _sl-key:

key语句
---------

key语句创建一个键盘按键绑定，可以通过按键运行某个行为。key语句的应用场景比较宽泛，可以支持手柄和鼠标事件。

key语句有一个固定位置参数，一个需要绑定的按键名字符串。详见 :doc:`keymap` 。key语句使用两个特性：

`action`
    这个特性给定了按键(keypress)事件发生后触发的行为。该特性必须存在。

`capture`
    若为True，即默认值，捕获事件并不会由其他可视组件处理。
    若为False，则按键行为不会结束此次交互，其他可视组件会处理事件。

key不包含子组件。

::

    screen keymap_screen():
        key "game_menu" action ShowMenu('save')
        key "p" action ShowMenu('preferences')
        key ["s", "w"] action Screenshot()


.. _sl-label:

脚本标签(label)
----------------

使用脚本标签(label)样式创建一个窗口(window)，并且将文本内容放置在窗口内。这种联合体用于在某个框架(frame)中将某些元素标签化。

label语句包含一个固定位置参数，即标签的文本。其使用下列特性：

`text_style`
    用于按钮文本的样式名。如果未提供并且样式特性是一个字符串的话， ``"_text"`` 会自动添加到字符串后面作为默认的文本样式。

`text_`-
   其他有 text_ 前缀的特性会把前缀去掉，然后传给文本组件(text displayable)。

label语句还可以使用以下特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`窗口样式特性 <window-style-properties>`

label语句不包含任何子组件。

::

    screen display_preference():
        frame:
            has vbox

            label "Display"
            textbutton "Fullscreen" action Preference("display", "fullscreen")
            textbutton "Window" action Preference("display", "window")


.. _mousearea:
.. _sl-mousearea:

mousearea
---------

mousearea是界面上划出一块区域，用于检测鼠标的进入或离开。与按钮(button)不同的是，鼠标区域不能获得焦点，所以在按钮内部可以存在一块鼠标区域。mousearea语句不接受参数，可以使用下列特性：

`hovered`
    当鼠标进入鼠标区域时运行的行为。

`unhovered`
    当鼠标离开鼠标区域时运行的行为。

`focus_mask`
    :propref:`focus_mask` 样式特性，可以是某个可视组件或者None。如果是一个可视组件，鼠标区域值应只放在可视组件不透明的部分上面。(那个可视组件不会展示给用户。)

mousearea语句使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`

mousearea语句不含子组件。

通常来说，mousearea语句会给定区域样式特性，控制鼠标区域的大小和坐标。如果不控制鼠标区域大小，就会自动占用整个界面，那种行为的用处比较小。

.. note::

    由于Ren'Py游戏可以使用键盘和手柄，所以复用鼠标区域功能就往往有其他的意义。

::

    screen button_overlay():
        mousearea:
            area (0, 0, 1.0, 100)
            hovered Show("buttons", transition=dissolve)
            unhovered Hide("buttons", transition=dissolve)

    screen buttons():
        hbox:
            textbutton "Save" action ShowMenu("save")
            textbutton "Prefs" action ShowMenu("preferences")
            textbutton "Skip" action Skip()
            textbutton "Auto" action Preference("auto-forward", "toggle")

    label start:
        show screen button_overlay

.. _sl-nearrect:

nearrect
--------

``nearrect`` 语句后面带一个字组件名，并把对应的子组件放在附近的一个矩形区域中。
通常使用 :func:`CaptureFocus` 行为函数获取焦点附近的矩形区域。
nearrect可以用于提示信息和下落、下拉菜单。

nearrect组件使用下列特性：

`rect`
    若给定，参数应该是一个(x, y, w, h)形式的矩形，将子组件的位置信息与矩形关联。具体关联方式见下面的描述。

`focus`
    若给定，该参数应该是一个字符串。字符串传递给 :func:`GetFocusRect` 函数并寻找合适的矩形区域。
    若找到了合适的矩形，则渲染对应子组件。

    将参数设置为“tooltip”时，将会在最后获得焦点的可视组件位置显示提示信息。

`prefer_top`
    若给定，将子组件的位置设置为获得焦点矩形区域的上层。

该组件还可使用下列特性：

* :ref:`通用特性 Common Properties <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`

nearrect与其他组件布局的位置计算方式不同，不把其子组件放在指定矩形区域内，而是放在指定矩形区域附近。
子组件首先计算可用宽度，然后计算矩形区域上方和下方分别可能的最大可用高度。最后根据下面的原则计算结果确定y轴方向的位置。

* 如果子组件可以放在矩形区域上方，并且入参给定 `prefer_top`，子组件将直接放在矩形区域上方。
* 否则，弱如果子组件可以放在矩形区域下方，直接放在矩形下方。
* 否则，子组件直接放在矩形上。

x轴方向的位置使用通用准则计算，可以设置子组件的 :propref:`xpos` 、 :propref:`xanchor` 和 :propref:`xalign` 特性。
位置特性的值与矩形区域的x坐标相关。如果是浮点值，则与矩形区域的宽度相关。

:propref:`xoffset` 和 :propref:`yoffset` 特性的应用方式与其他组件相同。

如果nearrect组件的子组件是一个变换(transform)，变换指定了 ``show`` 和 ``hide`` 事件响应。
但是，实际位置会发生改变。
nearrect最好放置在界面顶层，变换和位置特性应用到其子组件上，而不是nearrect自身。

这是一个下拉菜单的样例：

::

    default difficulty = "简单"

    screen select_difficulty():

        # 根据实际需要，此处的frame可以拥有非常复杂的布局。
        frame:
            align (.5, .3)
            padding (20, 20)

            has vbox

            # 点击此按钮激活下拉菜单
            textbutton "选择难度: [difficulty]":

                # 该行为捕获获取焦点的矩形区域，并显示下拉菜单
                action CaptureFocus("diff_drop")

            textbutton "完成":
                action Return()

        # 其他界面元素可以写在这里，但nearrect相关的元素需要写在最上层。
        # nearrect的子组件最后显示，只能要分开写。

        # 仅当焦点区域捕获成功，才显示下拉菜单。
        # 可以使用showif替代基本的if语句。
        if GetFocusRect("diff_drop"):

            # 如果玩家点击了frame之外的区域，使用dismiss关闭下拉菜单。
            # 此处使用ClearFocus行为函数关闭。
            dismiss action ClearFocus("diff_drop")

            # nearrect组件的位置放在之前定义的按钮附近(通常是下方)。
            nearrect:
                focus "diff_drop"

                # Finally, this frame contains the choices in the dropdown, with
                # each using ClearFocus to dismiss the dropdown.
                # 最后，下拉菜单里的各个选项放在一个frame中。
                # 每个选项行为都使用ClearFocus，以隐藏下拉菜单。
                frame:
                    modal True

                    has vbox

                    textbutton "简单" action [ SetVariable("difficulty", "简单"), ClearFocus("diff_drop") ]
                    textbutton "正常" action [ SetVariable("difficulty", "正常"), ClearFocus("diff_drop") ]
                    textbutton "困难" action [ SetVariable("difficulty", "困难"), ClearFocus("diff_drop") ]
                    textbutton "噩梦" action [ SetVariable("difficulty", "噩梦"), ClearFocus("diff_drop") ]

下拉菜单可以通过样式提升观感，此处不做具体演示了。

.. _sl-null:

null
----

null语句在界面中插入了一块空的区域。其可以用于物体分隔开。null语句不包含参数，可以使用下列特性：

`width`
    空区域的宽度，单位是像素。

`height`
    空区域的高度，单位是像素。

null语句可以使用以下样式：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`

null语句不包含子组件：

::

    screen text_box():
        vbox:
             text "这是标题。"
             null height 20
             text "这是正文。"

.. _sl-side:

side
----

side语句把可视组件放置在一个网格的角落或者中间。其使用一个字符串型参数，字符串内包含空格样式的位置信息列表，用于配置子组件。列表中的每个元素都应该是下列字符串之一：

    'c', 't', 'b', 'l', 'r', 'tl', 'tr', 'bl', 'br'

'c'表示中间，'t'表示上部，'tl'表示左上，'br'表示右下，以此类推。

side语句使用下列的特性：

`spacing`
    网格中各行和各列之间的间隔。


side语句还可以使用如下特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`

当渲染时，先渲染四角，然后是四边，最后是中间。四角和四边在渲染阶段的初始可用区域是0，所以有必要提供一个最小尺寸(使用
:propref:`xminimum` 或 :propref:`yminimum`)，以确保渲染成功。

添加子组件的顺序(或者使用入参的子字符串顺序)控制显示顺序，最后添加的显示在最上层。
可以通过配置项 :var:`config.keep_side_render_order` 禁用。

使用各子组件时分别占据网格单元列表中的一个位置，所以网格单元应与子组件数量相同。

::

    screen side_test():
         side "c tl br":
              text "Center"
              text "Top-Left"
              text "Bottom-Right"

.. _sl-text:

text
----

text语句会显示文本。其使用一个参数，就是用于显示的文本内容。其也使用下列特性：

* :ref:`通用特性 Common Properties <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`文本样式特性 <text-style-properties>`

text语句没有子组件。

::

    screen hello_world():
        text "Hello, World." size 40

.. _sl-textbutton:

textbutton
----------

创建一个包含脚本标签(label)的按钮。按钮使用一个参数，即按钮内显示的文本内容。其可以使用下列特性：

`action`
    当按钮被激活时运行的行为。当 `sensitive` 和 `selected` 特性没有提供的情况下， *action* 特性也控制那两种特性表现。

`alternate`
    使用转化过的办法在按钮激活后运行的行为。当用户在基于鼠标的平台上那个点击鼠标右键，或者用户在基于触控的平台上长按某个按钮，都会触发。

`hovered`
    当按钮获取焦点时运行的行为。

`unhovered`
    当按钮失去焦点时运行的行为。

`selected`
    决定按钮是否被选择的表达式。每次交互行为时，该表达式都至少会被计算一次。如果该特性没有提供，用户行为会最终决定按钮是否被选择。

`sensitive`
    决定按钮是否被启用的表达式。每次交互行为时，该表达式都至少会被计算一次。如果该特性没有提供，用户行为会最终决定按钮是否被启用。

`keysym`
    给定了一个 :doc:`keysym <keymap>` 的字符串。字符串描述了键盘对应的按键，当那个按键被按下后，会调用按钮的行为。

`alternate_keysym`
    给定了一个 :doc:`keysym <keymap>` 的字符串。字符串描述了键盘对应的按键，当那个按键被按下后，会调用按钮的变换行为。

`text_style`
    用于按钮文本的样式名。如果未提供并且样式特性是一个字符串的话， ``"_text"`` 会自动添加到字符串后面作为默认的文本样式。

`text_`-
   其他有 text_ 前缀的特性会把前缀去掉，然后传给文本组件(text displayable)。

textbutton还可以使用如下特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`窗口样式特性 <window-style-properties>`
* :ref:`按钮样式特性 <button-style-properties>`

其不包含子组件。

::

    screen textbutton_screen():
        vbox:
            textbutton "Wine" action Jump("wine")
            textbutton "Women" action Jump("women")
            textbutton "Song" action Jump("song")

.. _sl-timer:

timer
-----

timer语句会创建一个计时器，当预订的时间结束后运行某个行为。其使用一个固定位置参数，给出计时的时间值，单位为秒。timer语句使用下列特性：

`action`
    计时结束后会运行的行为。这项特性是必须存在的。

`repeat`
    若为True，计时结束后重置时间并重新开始计时。

`modal`
    若为True，模态界面不会触发计时器。若为False或没有指定值，模态界面显示状态下依然进行计时。

timer不包含子组件。

::

    screen timer_test():
        vbox:
             textbutton "Yes." action Jump("yes")
             textbutton "No." action Jump("no")

        timer 3.0 action Jump("too_slow")

.. _sl-transform:

transform
---------

将一个transform应用于其子组件。transform没有参数，可以使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`Transform特性列表 <transform-properties>`

transform下有一个子组件。


.. _sl-vbar:

vbar
----

等效于原生垂直的 `bar`_ 。 使用特性与条 `bar` 一样。

::

    screen volume_controls():
         frame:
             has hbox

             vbar value Preference("sound volume")
             vbar value Preference("music volume")
             vbar value Preference("voice volume")


.. _sl-vbox:

vbox
----

纵向排列子组件的不可是垂直方框(box)。vbox不接受参数，可以使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`方框样式特性 <box-style-properties>`

UI可视组件作为子组件添加到vbox：

::

    screen vbox_test():
        vbox:
             text "Top."
             text "Bottom."


.. _sl-viewport:

viewport
--------

视口(viewport)是界面中的某块区域，可以使用鼠标滚轮或者滚动条进行滚动。视口可以用于显示某些比界面更大的东西。其使用以下特性：

`child_size`
    待渲染子组件的尺寸，是一个 (`xsize`,
    `ysize`) 形式的元组。该值通常是省略的，子组件可以自己计算尺寸。如果所有组件的尺寸特性都为空，则使用子组件的尺寸信息。

`mousewheel`
    该值可以是下列之一：

    False
        忽略鼠标滚轮。(默认值。)
    True
        垂直滚动。
    "horizontal"
        水平滚动。
    "change"
        垂直滚动视口，只有使用change操作才能触发视口移动。如果change为空，鼠标滚轮时间会传给其他用户接口。(例如，如果给定change的值，并在viewport语句之前放了  ``key "viewport_wheeldown" action Return()`` ，当视口滚动到底部时就会触发界面返回。)
    "horizontal-change"
        与change模式一同使用，决定水平滚动的情况。

`draggable`
    若为True，鼠标拖动就能滚动视口。
    该项可以设置为 :ref:`variant <screen-variants>`，这样视口也可以拖动。(例如，设置为 ``draggable "touch"``。)

`edgescroll`
    当鼠标到达视口边缘时，控制滚动行为。若该值非空，应该是一个2元或者3元的元组。

    * 元组内第一个元素是从视口边缘到edgescroll开始生效处的距离，单位是像素。

    * 元组内第二个元素是滚动率最大值，单位是像素每秒。

    * 如果元组内存在第三个元素，它是一个调整滚动速度的函数，取决于鼠标指针与界面边缘的距离。函数入参为一个介于-1.0和1.0之间的数值，返回一个同样区间内的数值。函数默认值与输入相同，且按比例进行滚动。函数返回值是-1.0还是1.0，取决于输入值的符号，并实现匀速滚动。

`xadjustment`
    :func:`ui.adjustment` 对象，用作视口x轴的调整。当该特性省略时，就会创建一个新的adjustment对象。

`yadjustment`
    :func:`ui.adjustment` 对象，用作视口y轴的调整。当该特性省略时，就会创建一个新的adjustment对象。

`xinitial`
    视口初始水平偏移量。其可以是一个整数，表示像素数；也可以是一个浮点数，表示一个可能的偏移比例。

`yinitial`
    视口初始垂直偏移量。其可以是一个整数，表示像素数；也可以是一个浮点数，表示一个可能的偏移比例。

`scrollbars`
    若不为None，滚动条会添加到视口上。scrollbar会创建一个单边布局(layout)，并把视口放在单边的中间。如果 `scrollbars` 的值是 "horizontal"，就在视口上创建一个水平的滚动条。如果 `scrollbars`
    的值是 "vertical"，就在视口上创建一个垂直的滚动条。如果 `scrollbars` 的值是 "both"，水平和垂直滚动条都会被创建。

    若 `scrollbars` 不为None，`viewport` 将使用以下特性前缀：

    * 前缀为 ``viewport_`` 的特性穿给视口。
    * 前缀为 ``side_`` 的特性传给side。
    * 前缀为 ``scrollbar_`` 传给水平滚动条。
    * 前缀为 ``vscrollbar_`` 传给垂直滚动条。

    没有前缀的特性也会被接受。
    :ref:`position-style-properties` 会传给side，其他无前缀特性会应用到视口。

`arrowkeys`
    若为True，视口可以使用上下左右方向键进行滚动。这种情况下方向键的作用优先于方向键的其他功能。当视口到达限制时，方向键会改变焦点。

`pagekeys`
    若为True，视口可以使用翻页键向上和向下滚动。这会让翻页键原本的功能失效。原本的功能是回滚和前进。

除此之外，视口还使用以下特性。

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`

视口含有一个子组件。如果实际上提供的子组件并非一个，那就会创建一个固定位置布局容纳所有子组件。

想让一个视口可滚动，最好的办法通常是声明一个视口id，然后使用 :func:`XScrollValue` 和 :func:`YScrollValue` 。

::

    screen viewport_example():
        side "c b r":
             area (100, 100, 600, 400)

             viewport id "vp":
                 draggable True

                 add "washington.jpg"

             bar value XScrollValue("vp")
             vbar value YScrollValue("vp")


.. _sl-vpgrid:

vpgrid
------

vpgrid(viewport grid)将视口与网格(grid)结合为单个的可视组件。vpgrid(像grid一般)包含多个子组件，并且经过优化使得视口内只有可以显示的子组件才会被渲染。

vpgrid假设是由子组件都是相同尺寸，该尺寸来源于第一个子组件。若某个vpgrid渲染结果不正确，请检查并确保所有子组件的尺寸是相同的。

vpgrid必须至少给定  `cols` 和 `rows` 特性。如果有其中之一省略或者是None，另一个特性就会根据子组件的尺寸、空间和数量自动决定。

vpgrid使用下列特性：

`cols`
    网格(grid)的行数。

`rows`
    网格(grid)的列数。

`transpose`
    若为True，单位网格按列填充。该特性的默认值取决于 `cols` 和 `rows` 的特性。如果 `cols` 出现，单元网格会先按列填充，否则按行填充。

除此之外，vpgrid使用所有 :ref:`视口 <sl-viewport>` 可使用的特性，以及下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`网格样式特性 <grid-style-properties>`

当指定 `scrollbar` 特性时，有前缀的特性会以类似视口(viewport)的方式传给vpgrid。
(前缀为 `viewport_`` 的特性也会传给vpgrid。)

::

    screen vpgrid_test():

        vpgrid:

            cols 2
            spacing 5
            draggable True
            mousewheel True

            scrollbars "vertical"

            # 由于我们有scrollbar，所以我们必须设置“边”的位置，而不需要设置vpgrid。
            xalign 0.5

            for i in range(1, 101):

                textbutton "Button [i]":
                    xysize (200, 50)
                    action Return(i)

.. _sl-window:

window
------

window是个包含背景的窗口，用于显示游戏内对话。其使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`窗口样式特性 <window-style-properties>`

window含有一个子组件。如果实际上提供的子组件并非一个，那就会创建一个固定位置布局容纳所有子组件。

::

    screen say(who, what):
        window id "window"
            vbox:
                spacing 10

                text who id "who"
                text what id "what"


imagemap语句
===================

创建界面的简易方法，特别是对于那些想要创建可视化imagemap的人。当创建一个imagemap时，imagemap语句用于指定至多6个图像(image)。hotspot和hotbar用于从整个图像中分割出矩形区域，并为那些区域添加行为和值。

这是一个preferences界面使用imagemap的样例：

::

    screen preferences():

        tag menu
        use navigation

        imagemap:
            auto "gui_set/gui_prefs_%s.png"

            hotspot (740, 232, 75, 73) action Preference("display", "fullscreen") alt _("Display Fullscreen")
            hotspot (832, 232, 75, 73) action Preference("display", "window") alt _("Display Window")
            hotspot (1074, 232, 75, 73) action Preference("transitions", "all") alt _("Transitions All")
            hotspot (1166, 232, 75, 73) action  Preference("transitions", "none") alt _("Transitions None")

            hotbar (736, 415, 161, 20) value Preference("music volume") alt _("Music Volume")
            hotbar (1070, 415, 161, 20) value Preference("sound volume") alt _("Sound Volume")
            hotbar (667, 535, 161, 20) value Preference("voice volume") alt _("Voice Volume")
            hotbar (1001, 535, 161, 20) value Preference("text speed") alt _("Text Speed")


.. _sl-imagemap:

imagemap
--------

imagemap语句用于指定一个imagemap。其不接受参数，后面跟下列特性：

`auto`
    自动定义imagemap使用的图像。图像名是一个字符串，包含“%s”。如果文件存在，且某个图像特性是省略的，“%s”会使用对应特性名替换，其值作为特性的默认值。

    例如，如果 `auto` 后面的字符串是 "imagemap_%s.png"，且  `idle` 省略，idle的默认值就是 "imagemap_idle.png"。如果 `auto` 后面的字符串是 "imagemap %s"就使用
    ``imagemap idle`` 图像。

    `auto` 的行为可以修改
    :var:`config.imagemap_auto_function` 实现定制化。

`ground`
    用于imagemap的背景图像，即不是hotspot也不是hotbar。

`insensitive`
    当hotspot或者hotbar不启用时使用的图像。

`idle`
    当hotspot没有被选中且没有获得焦点时使用的图像，也用于没有获得焦点hotbar空的部分。

`hover`
    当hotspot没有被选中但获得焦点时使用的图像，也用于获得焦点hotbar空的部分。

`selected_idle`
    当hotspot被选中但没有获得焦点时使用的图像，也用于没有获得焦点hotbar满的部分。

`selected_hover`
    当hotspot被选中且获得焦点时使用的图像，也用于获得焦点hotbar满的部分。

`alpha`
    若为True，也就是默认值，只有当鼠标悬停在不透明图像上方时，hotspot才会获得焦点。若为False，无论鼠标是否在imagemap矩形区域中，hotspot都会获得焦点。

`cache`
    若为True，也就是默认值，hotspot数据会缓存，用于提升应用性能，代价是会消耗额外的磁盘空间。

imagemap使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`位置样式特性 <position-style-properties>`
* :ref:`固定布局的样式特性 <fixed-style-properties>`

imagemap会创建一个固定位置布局，允许任意子组件被添加到那个布局(不仅限于hotspot和hotbar)。


.. _sl-hotspot:

hotspot
-------

hotspot是由imagemap内一部分图像组成的按钮。其使用一个参数，一个(x, y, width, height)形式的元组，给定了imagemap内组成按钮的区域。其也使用下列特性：

`action`
    当button激活时运行的行为。这也可用于控制按钮启用状态下，被选中时的行为。

`alternate`
    当hotspot使用变换方法激活时运行的行为。变换激活发生在两种情况下，基于鼠标平台时用户点击鼠标右键，基于触控平台时用户长按。

`hovered`
    当按钮获得焦点时运行的行为。

`unhovered`
    当按钮失去焦点时运行的行为。

`selected`
    一个决定按钮是否被选中的表达式。每次交互行为，这个表达式都会至少被计算一次。如果没有提供表达式，这个行为会用于决定按钮被选中。

`sensitive`
    一个决定按钮是否被启用的表达式。每次交互行为，这个表达式都会至少被计算一次。如果没有提供表达式，这个行为会用于决定按钮启用。

`keysym`
    给出一个 :doc:`keysym <keymap>` ，当对应键盘的按键被按下后，调用对应的按键行为。

`alternate_keysym`
    给出一个 :doc:`keysym <keymap>` ，当对应键盘的按键被按下后，调用对应的变换按键行为。

hotspot使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`按钮样式特性 <button-style-properties>`

hotspot会创建一个固定位置布局，允许子组件被添加到那个布局。固定位置布局有一个与hotspot尺寸大小相同的区域，这意味着所有子组件都会根据hotspot放置。

hotspot可以被赋予 ``alt`` 样式特性，允许Ren'Py的自动语音特性能工作。

.. _sl-hotbar:

hotbar
------

hotbar是由imagemap内一部分图像组成的条(bar)。其使用一个参数，一个(x, y, width, height)形式的元组，给定了imagemap内组成条(bar)的区域。其也使用下列特性：

`value`
    条(bar)的当前值。可以是一个 :ref:`条(bar)值 <input-values>`
    对象，也可以是一个数值。

`range`
    条(bar)的最大值。当 `value` 是一个数值的情况下，`range` 是必须的。

`adjustment`
    一个用于该条(bar)调整的 :func:`ui.adjustment` 对象。

hotbar必须给定一个 `value` 或者一个 `adjustment` 对象。除此之外，还可以使用下列特性：

* :ref:`通用特性 <common-properties>`
* :ref:`条(bar)样式特性 <bar-style-properties>`

hotbar没有子组件。

hotbar可以被赋予 ``alt`` 样式特性，允许Ren'Py的自动语音特性能工作。

.. _sl-add:

add
---

在界面上添加一个图像或其他的可视组件。添加时可以选择使用 :ref:`transform特性列表 <transform-properties>`。如果至少使用了一项 :class:`Transform` 特性，用于wrap图像的transform就会被创建，特性值会赋予这个transform。

如果可视组件为None，那不会有任何东西添加到界面上。

add语句不使用任何子组件。

::

    screen add_test():
        add "logo.png" xalign 1.0 yalign 0.0

.. _sl-advanced-displayables:

高级可视组件
=====================

除了以上常用语句，界面语言还有一些语句针对高级可视组件。从可视组件到具体语句的映射是简单的。可视组件的固定位置参数可以直接用作语句的固定位置参数。可视组件的关键词参数和等效样式特性可转为界面语言特性。

高级可视组件语句包括：

``drag``
    创建一个 :class:`Drag` 对象。drag对象可以给定一个可选的子组件，或者可以用于这个子组件的 :propref:`child` 样式特性，以及子组件获得变相获得焦点的行为。drag也能使用 :propref:`focus_mask`
    样式特性。

``draggroup``
    创建一个 :class:`DragGroup` 组。drag组可以有任意个drag作为其子组件。


.. _sl-has:

has语句
=============

has语句允许你指定一个容器用于容纳单个子组件，而不使用固定网格(fixed)。has语句只能用在语句内部包含一个子组件的情况。关键词 ``has`` 后面(同一个逻辑行)会接另一个语句，那个语句会创建一个包含多个子组件的容器型可视组件。

has语句改变了包含它的语句块(block)的处理方式。在语句块(block)中创建为子组件的可视组件会被添加到容器中，而不是父组件中。父组件的关键词参数不允许出现在has语句后面。在一个语句块(block)中可以使用多个has语句。

has语句可以使用下列语句创建的子组件：

* button
* frame
* window

has语句可以使用下列语句创建的容器：

* fixed
* grid
* hbox
* side
* vbox

::

   screen volume_controls():
        frame:
            has vbox

            bar value Preference("sound volume")
            bar value Preference("music volume")
            bar value Preference("voice volume")

.. _sl-control-statements:

控制语句
==================

界面语言包括了各种控制语句，用于条件执行、循环、包含其他界面、事件消息触发行为和执行任意的Python语句。

.. _sl-default:

default
-------

``default`` 语句在第一个界面设置某个变量的默认值。:func:`SetScreenVariable`

某个变量不会作为该界面的入参或者需要我们使用use语句继承自某个界面的情况下，default语句设置变量的默认值。

::

    screen scheduler():
        default club = None
        vbox:
             text "What would you like to do?"
             textbutton "Art Club" action SetScreenVariable("club", "art")
             textbutton "Writing Club" action SetScreenVariable("club", "writing")

             if club:
                 textbutton "Select" action Return(club)


.. _sl-for:

for
---

``for`` 语句类似于Python中的 ``for`` 语句，差别在于这里的for语句不支持 ``else``、``continue`` 和 ``break`` 分句。for语句支持使用数组型表达式，效果与使用变量一样。

::

    $ numerals = [ 'I', 'II', 'III', 'IV', 'V' ]

    screen five_buttons():
        vbox:
            for i, numeral in enumerate(numerals):
                textbutton numeral action Return(i + 1)


for语句支持index子句：

::


    screen five_buttons():
        vbox:
            for i, numeral index numeral in enumerate(numerals):
                textbutton numeral action Return(i + 1)

如果有 ``index`` 分句，应该包含返回一个可排列且可比较的值的表达式，对列表中的每一行都是唯一的。
Ren'Py 使用这个值来确保变换和其他状态与正确的迭代相关联。 如果在元素添加到正在迭代的列表中或从中删除元素时看到奇怪的表现，则可能需要使用index子句。


.. _sl-if:

if
--

界面语言 ``if`` 语句与Python/Ren'Py的 ``if`` 语句相同。其支持 ``if``、``elif`` 和 ``else`` 分句。

::

    screen skipping_indicator():
        if config.skipping:
             text "Skipping."
        else:
             text "Not Skipping."

.. _sl-on:

on
--

``on`` 语句允许某个事件消息发生时，界面执行某个行为。其使用一个参数，即事件消息名的字符串。事件名包括：

* ``"show"``
* ``"hide"``
* ``"replace"``
* ``"replaced"``

on语句使用 一个action特性，给定了事件发生时运行的行为。

::

    screen preferences():
        frame:
            has hbox

            text "Display"
            textbutton "Fullscreen" action Preferences("display", "fullscreen")
            textbutton "Window" action Preferences("display", "window")

        on "show" action Show("navigation")
        on "hide" action Hide("navigation")


.. _sl-use:

use
---

``use`` 语句允许一个界面包含另一个界面。其使用待use的界面名作为参数，也可以使用圆括号内的一个参数列表。


如果被use语句使用的界面没有需要插入的参数，其只会读写当前界面的变量作用域，并根据 ``use`` 语句中的关键词入参。
否则，其作用域内的变量将会将使用对应入参的值进行初始化。

::

    screen file_slot(slot):
        button:
            action FileAction(slot)

            has hbox

            add FileScreenshot(slot)
            vbox:
                text FileTime(slot, empty="Empty Slot.")
                text FileSaveName(slot)


     screen save():
         grid 2 5:
             for i in range(1, 11):
                  use file_slot(i)


use语句可能使用一个特性， ``id``，可能出现在参数列表之后。仅当两个带有相同标签(tag)的界面需要使用同一个界面的情况下才有用。那时，如果其中一个界面替换为另一个界面，使用界面的状态会从old变为new。

::

    transform t1():
        xpos 150
        linear 1.0 xpos 0

    screen common():
        text "Test" at t1

    screen s1():
        tag s
        use common id "common"
        text "s1" ypos 100

    screen s2():
        tag s
        use common id "common"
        text "s2" ypos 100

    label start:
        show screen s1
        pause
        show screen s2
        pause
        return

除了直接使用界面的名称，还可以使用关键词 ``expression`` 然后接一个表达式描述使用的界面名称。
如果需要传入参数，必须使用 ``pass`` 关键词分割在表达式内分割参数。

::

    screen ed(num):
        text "Ed"
        text "Captain"

    screen kelly(num):
        text "Kelly"
        text "First Officer"

    screen bortus(num):
        text "Bortus"
        text "Second Officer"

    screen crew():
        hbox:
            for i, member in enumerate(party):
                vbox:
                    use member.screen pass (i+1)


.. _use-and-transclude:

use和transclude语句
^^^^^^^^^^^^^^^^^^^^^

use语句也可以包含一个界面语言的语句块(block)，语句块中可能存在 ``transclude``
语句。 ``transclude`` 语句会被替换为use语句块内容。

这就可以定义可复用的界面布局(layout)。例如，界面：

::

    screen movable_frame(pos):
        drag:
            pos pos

            frame:
                background Frame("movable_frame.png", 10, 10)
                top_padding 20

                transclude

就意味着一个可复用的组件，可以warp其他组件。这是一个如何复用的样例：

::

    screen test:
        use movable_frame((0, 0)):
            text "你可以拖拽我。"

        use movable_frame((0, 100)):
            vbox:
                text "你也可以拖拽我。"
                textbutton "搞定！" action Return(True)

use和transclude结构是
:ref:`创作者定义的界面语言语句 <creator-defined-sl>` 的基础。

.. _sl-python:

Python
------

界面语言也可以包含单行和多行的Python语句。Python语句在对应界面的作用域范围内运行。

**Python禁止在界面之外引发可视的副作用。** Ren'Py在必要的情况下会多次运行某个界面。图像会在界面正式显示之前先预加载。因此，如果界面有副作用，在预加载阶段就会出现。

::

    screen python_screen:
        python:
            test_name = "Test %d" % test_number

        text test_name

        $ test_label = "test_%d" % test_label

        textbutton "Run Test" action Jump(test_label)


.. _sl-showif:

showif语句
================

``showif`` 语句含有一个条件判断。只有当条件为True时，其子组件会显示；条件为False时，子组件隐藏。当showif的子组件含有transform时，其会向子组件提供ATL事件，用于管理子组件的显示和隐藏。Ren'Py也可以据此实现显示和隐藏的序列化。

``showif`` 语句将它的子组件装进一个可视组件并管理显示和隐藏过程。

多个showif语句可以组成一个 ``showif`` / ``elif`` / ``else`` 结构体，类似于一个if语句。 **与if语句不同之处在于，showif执行其下所有的语句块(block)，包括Python语句，尽管某些条件结果是False。** 这是由于showif语句需要先创建子组件然后再隐藏子组件。

showif语句会向其子组件传送三种事件消息：

``appear``
    若条件判断为True，首先显示界面时，会传送并立刻显示子组件。

``show``
    当条件判断由False变为True时，会传送给子组件。

``hide``
    当条件判断由True变为False时，会传送给子组件。

基于这些需求，当if的主条件判断为True时 ``elif`` 语句的条件判断分句总是为False，而else分句只有当所有主要条件判断都为False时才会为True。

举例：

::

    transform cd_transform:
        # 这句会在appear、show或hide之前运行
        xalign 0.5 yalign 0.5 alpha 0.0

        on appear:
            alpha 1.0
        on show:
            zoom .75
            linear .25 zoom 1.0 alpha 1.0
        on hide:
            linear .25 zoom 1.25 alpha 0.0

    screen countdown():
        default n = 3

        vbox:
            textbutton "3" action SetScreenVariable("n", 3)
            textbutton "2" action SetScreenVariable("n", 2)
            textbutton "1" action SetScreenVariable("n", 1)
            textbutton "0" action SetScreenVariable("n", 0)

        showif n == 3:
            text "Three" size 100 at cd_transform
        elif n == 2:
            text "Two" size 100 at cd_transform
        elif n == 1:
            text "One" size 100 at cd_transform
        else:
            text "Liftoff!" size 100 at cd_transform

    label start:
        call screen countdown

.. _screen-statements:

screen语句
=================

除了screen语句，还有三种Ren'Py脚本语言语句可以唤起界面。

其中两种使用一个关键词入参列表。这个列表是Python入参列表，使用圆括号，只由关键词参数组成。固定位置参数，额外的固定位置参数 (*)，以及额外的关键词参数 (**) 都不允许存在。

.. _show-screen:

show screen
-----------

``show screen`` 语句会触发某个界面的显示。其使用一个界面名作为参数，后面还有一个可选的Pythone入参列表。如果入参列表出现，这些参数用作初始化界面作用域(scope)内的变量。
还有几个特殊关键词会传入 :func:`show_screen` 和 :func:`call_screen` 函数。

如果指定了关键词 ``expression``，后面的表达式会计算实际显示的界面名称。
为了将表达式关键词和入参同时传入界面，需要使用 ``pass`` 关键词分割。

::

    $ screen_name = "my_screen"
    show screen expression screen_name
    # 如果需要入参
    show screen expression screen_name pass ("Foo", message="Bar")

show screen语句使用一个可选的 ``nopredict`` 关键词，以防止界面预加载。当界面预加载时，传入界面的入参会被计算。请确保作为界面入参的表达式不会引起不希望出现的副作用。

.. warning::

    如果计算入参表达式会引发界面的副作用，你的游戏可能会表现出不希望出现的情况。

使用这种方式的界面会一直显示，除非有明确的语句隐藏界面。这个设计可以用作界面的互相覆盖。

::

    show screen overlay_screen
    show screen clock_screen(hour=11, minute=30)

    if rare_case:
        show rare_screen nopredict

``show screen`` 语句可以使用with分句，语法与 ``show`` 语句相同。

::

    show screen clock_screen with dissolve

.. _hide-screen:

hide screen
-----------

``hide screen`` 语句用于隐藏当前正在显示的界面。如果指定的界面并没有显示，不会发生任何事。
如果带有 ``with`` 分句，则与show语句的语法相同。

与 ``show screen`` 语句类似，``hide screen`` 语句也可以使用 ``expression`` 关键词，可以通过表达式计算界面名称。

::

    hide screen rare_screen
    hide screen clock_screen with dissolve
    hide screen overlay_screen
    $ screen_name = "some_screen"
    hide screen expression screen_name

.. _call-screen:

call screen
-----------

``call screen`` 语句会显示一个界面，在当前互动行为之后会隐藏这个界面。如果界面会返回一个值，返回值会放在 ``_return`` 中。

这可以用来显示一个imagemap。imagemap可以使用 :func:`Return` 行为将一个值放入 ``_return`` 变量，或者使用 :func:`Jump` 行为跳转到某个脚本标签(label)。

call screen语句使用一个可选的 ``nopredict`` 关键词，以防止界面预加载。当界面尝试预加载时，传入界面的参数会被计算。请确保作为界面入参的表达式不会引起不希望出现的副作用。

call screen语句使用一个可选的 ``with`` 关键词，后面跟一个转场(transition)。

由于调用一个界面属于一个交互行为，交互触发器需要显式带有 ``with None`` ，因为在 ``call screen`` 后面使用 ``with`` 语句将不能使原界面正确使用转场消失，毕竟之前的界面已经没了。
若要禁用 ``with None`` 转场，则使用 ``_with_none=False`` 特殊关键词作为参数传入对应界面，详见后面的样例。

其他交互转场方式也能生效，例如使用 ``[ With(dissolve), Return() ]`` 行为列表。

与 ``show screen`` 语句类似，``hide screen`` 语句也可以使用 ``expression`` 关键词，可以通过表达式计算界面名称。

.. warning::

    如果评估屏幕上的参数会导致副作用发生，你的游戏可能会出现不希望出现的情况。

::

    call screen my_imagemap

    call screen my_screen(side_effect_function()) nopredict

    # 使用dissolve显示界面
    call screen my_other_screen with dissolve
    # 使用None方式隐藏界面，使用pixellate转场执行。
    with pixellate

    # 使用dissolve显示界面，使用pixellate隐藏界面。
    call screen my_other_screen(_with_none=False) with dissolve
    with pixellate

    $ screen_name = "my_screen"
    call screen expression screen_name pass (foo="bar")

.. _screen-variants:

界面变种
===============

Ren'Py可以同时运行在两种平台上：一种是传统的键鼠设备平台，比如Windows系统、Mac系统和Linux PC版；另一种是新的触控设备平台，比如基于安卓系统的智能手机和平板。界面变种允许一个游戏根据不同的硬件信息提供不同版本的界面。

Ren'Py通过顺序搜索 :var:`config.variants` 中的variant项来选择使用何种界面，并使用找到第一个variant。

如果环境变量 RENPY_VARIANT存在，config.variants就会使用RENPY_VARIANT中用空格分隔的各项值进行初始化。将RENPY_VARIANT设置为针对安卓设备的
``"medium tablet touch"`` 或 ``"small phone touch"`` ，就可以在PC端调测了。

如果环境变量不存在，变种列表会自动建立。建立时，会按顺序搜索下表，找到匹配项后选择对应平台的入口。

``"steam_deck"``
    在Steam Deck或相同的硬件上运行时为True。

``"steam_big_picture"``
    True if running in Steam Big Picture mode.
    在Steam大屏幕模式运行时为True.

``"large"``
   屏幕足够大，字体小的文本也能轻松阅读，按钮可以被很容易点中。这主要用于电脑屏幕。

``"medium"``
   屏幕不大，比较小的字体可以阅读，但按钮可能需要增大尺寸才能被比较舒服地按下。这用于平板。

``"small"``
   屏幕比较小，文本必须放大才能阅读。这用于手机和电视机。(电视机屏幕虽然比较大，但使用时距离用户较远，不利于阅读文本。)

``"tablet"``
   不小于6英寸的触控屏设备。(大多数情况下， ``"medium"`` 应代替 ``"tablet"`` 。)

``"phone"``
   小于6英寸的触控屏设备。在这样小的设备上，将按钮做得足够大才能让用户轻松选中。(大多数情况下， ``"small"`` 应代替 ``"phone"`` 。)

``"touch"``
   触控屏设备。

``"tv"``
   电视机设备。

``"firetv"``
   亚马逊的Fire TV主机。(表示同时为 ``"tv"`` 和 ``"small"``)

``"chromeos"``
    在Chromebook设备上运行安卓app。

``"android"``
   安卓设备。

``"ios"``
   iOS设备，像iPad(表示同时为 ``"tablet"`` 和 ``"medium"``)和iPhone(表示同时为 ``"phone"`` 和 ``"small"``)。

``"mobile"``
   手机平台，比如安卓、iOS手机和手机web浏览器。

``"pc"``
   Windows、Mac OS X和Linux平台。PC表示会有键鼠设备，允许鼠标悬停(hover)状态和精确点击。

``"web"``
   在web浏览器上运行。
 
``None``
   默认定义。

定义一个界面变种的样例如下：

::

   # 一个变种的hello_world界面，使用小型触屏设备。
   screen hello_world():
        tag example
        zorder 1
        modal False
        variant "small"

        text "Hello, World." size 30

.. _see-also:

其他参考
========

:doc:`screen_actions` ：一个综合行为和其他工具的综合列表，可以被界面调用。

:doc:`screen_optimization` ：让界面尽可能高效运行的某些方案。

:doc:`screen_python` ：使用Ren'Py预定义的工具，扩展Ren'Py。