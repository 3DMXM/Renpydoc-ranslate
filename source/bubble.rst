.. _speech-bubbles:

气泡式台词
==============

Ren'Py支持将对话以气泡式台词形式显示。气泡式台词可以使用交互式设计，指定在界面上显示的位置。
该功能可以是ADV模式游戏下文本框或NVL模式下全屏对话框之外，一种新的对话表现形式。

To use speech bubbles your game, you'll have to define Characters with
an image tag, a kind of ``bubble``. For example, 
如果要在游戏中使用气泡式台词，需要在定义角色对象是将类似改为 ``bubble``。比如：

::

    define e = Character(None, image="eileen", kind=bubble) # 艾琳
    define l = Character(None, image="lucy", kind=bubble)   # 露西

可以把说话角色的名字显示出来。不过一般说话角色会用气泡的小尾巴来指示，所以就省略角色名了。

定义角色后可以按照正常流程编写角色对话内容。

如果要修改气泡位置，可以按shift+B，显示气泡式对话编辑器。
每个启用对话框的角色，都会在编辑器中有两个按钮。

点击area按钮进入气泡区域编辑模式。此时在屏幕内点击鼠标并拖拽后可以指定一个区域，松开鼠标后气泡就会显示在该区域内。

点击properties按钮可以选择气泡式对话样式。默认的样式主要控制气泡尾部的位置和朝向。

一旦修改了绝对某个角色(或具有相同图像标签的一组角色)的气泡区域或特性后，对应特性将一直生效，除非再次修改或遇到下一个scene语句。

当前对话那行台词的气泡设置区域或特性时，对应的台词会高亮显示。如果台词文本的样式继承自dialogue或默认样式，按钮颜色会被调暗。
鼠标右键点击按钮会阻止当前那行台词应用区域或特性的值。

.. _retained-bubbles:

Retained Bubbles
----------------

Ren'Py supports a mode in which bubbles are retained between lines of
dialogue, so they pop up one by one, until the previous bubbles are
cleared from the screen. To enable this mode, set a bubble character's
`retain` property to True::

    define e = Character(None, image="eileen", kind=bubble, retain=True)

Once that's done, the bubbles will keep popping up. Each bubble will
need to be placed individually, so bubbles don't overlap. In the bubble editor,
pressing the "(clear retained bubbles)" button will remove all of the
retained bubbles from the screen, except for the most recent.

.. _tips:

小贴士
------

气泡式对话使用多语言系统相同的标识符，详见 :ref:`多语言支持贴士 <translation-tips>`。
在下列情况下，对应的标识符会发生改变：

* 该行台词的文本修改。
* 同一脚本标签(label)下新增或删除了同样内容的一行台词。
* 该行台词前新增或删除了一个脚本标签(label)，但新增或删除带有 ``hide`` 从句的脚本标签并不会更改多语言标识符。

如果创作者修改过某个场景的脚本，建议回看检查以确保不会影响气泡式对话的效果。

.. _bubble-configuration-variables:

配置项
-------

气泡式对话系统的控制参数分布在 ``bubble`` 命名空间、``bubble`` 界面定义和相关的样式中。

``bubble`` 命名空间包含下列配置项：

.. var:: bubble.db_filename = "bubble.json"

    数据库文件，存储在game目录下，包含气泡式对话配置信息。

.. var:: bubble.cols = 24

    更改气泡位置时，用于定位的位置和大小的横向分割数，即列数。

.. var:: bubble.rows = 24

    更改气泡位置时，用于定位的位置和大小的纵向分割数，即行数。

.. var:: bubble.default_area = (15, 1, 8, 5)

    台词气泡的默认区域。该值是一个(x, y, w, h)形式的元组，每个元素的单位都是坐标分割后的小方块(cell)。

.. var:: bubble.properties = { ... }

    这些特性(property)与气泡区域无关，可用于定制台词气泡的样式。
    该配置项可以将一个特性名称的集合映射到一个样式和值的字典。
    字典中的特性值会覆盖角色对象中原本的值，并最终应用和展现在 ``bubble`` 界面中。

    该配置项中关于前缀的用法与 :func:`Character` 相同。
    以 ``window_`` 作为前缀的样式将去掉这个前缀后传入bubble界面中id为“window”的可视组件，即气泡的本体。
    以 ``what_`` 作为前缀的样式将去掉这个前缀后传入bubble界面中id为“what”的可视组件，即气泡上的文字。
    以 ``who_`` 作为前缀的样式也类似，会传给角色名称。
    以 ``show_`` 作为前缀的样式会作为bubble界面的入参。

    创建新游戏后，screens.rpy文件中会包含以下内容：
    
    ::

        define bubble.frame = Frame("gui/bubble.png", 55, 55, 55, 95)

        define bubble.properties = {
            "bottom_left" : {
                "window_background" : Transform(bubble.frame, xzoom=1, yzoom=1),
                "window_bottom_padding" : 27,
            },

            "bottom_right" : {
                "window_background" : Transform(bubble.frame, xzoom=-1, yzoom=1),
                "window_bottom_padding" : 27,
            },

            "top_left" : {
                "window_background" : Transform(bubble.frame, xzoom=1, yzoom=-1),
                "window_top_padding" : 27,
            },

            "top_right" : {
                "window_background" : Transform(bubble.frame, xzoom=-1, yzoom=-1),
                "window_top_padding" : 27,
            },
        }

    变量bubble.frame只是为了使bubble.properties的定义更简单一些。
    对应的4种气泡样式，值需要对图片进行不同轴向的翻转就能改变气泡尾部的位置和朝向。
    padding留白空间也是为了留给气泡尾部。

.. var:: bubble.properties_order = [ ]

    一个特性集合的名称的列表，会被气泡式台词编辑器顺序循环遍历。
    如果没有指定某个样式集合的名称，其内部将会按拉丁字母顺序遍历以匹配对应特性。

.. var:: bubble.properties_callback = None

    若不是None，该项应是一个函数，入参为一个图像标签(image tag)，返回值是一个特性名称列表或元组，
    以列表或元组中的顺序，最终应用到对应图像标签上。
    该项的优先级高于 bubble.properties_order ，可以定制角色台词气泡的各种样式。

.. var:: bubble.expand_area = { ... }

    将某个特性集合的名称映射为一个(left, top, right, bottom)元组。
    如果在对应集合中找到同名集合，则台词气泡会根据指定的数值向外扩展对应的像素数。

    这项设置会让气泡比拖拽选定的区域会更大一些。这样设计的主要原因是，拖拽选择的区域可以不用考虑台词气泡的尾部需要占据空间，
    以及台词文本更不容易跑出气泡范围，尤其是样式集合发生变化和气泡尾部位置变动的情况。

    默认的扩展值配置为：

    ::

        define bubble.expand_area = {
            "bottom_left" : (0, 0, 0, 22),
            "bottom_right" : (0, 0, 0, 22),
            "top_left" : (0, 22, 0, 0),
            "top_right" : (0, 22, 0, 0),
        }

.. _bubble-screen:

bubble界面
----------

默认的 ``bubble`` 界面可以在 ``screens.rpy`` 文件中找到。类似于默认的 ``say`` 界面：

::

    screen bubble(who, what):
        style_prefix "bubble"

        window:
            id "window"

            if who is not None:

                window:
                    id "namebox"
                    style "bubble_namebox"

                    text who:
                        id "who"

            text what:
                id "what"

从say界面分离出来后，bubble界面可以使用自己的样式集，包括``bubble_window``、``bubble_what``、``bubble_namebox`` 和 ``bubble_who``。
这些样式都可以直接在 :var:`bubble.properties` 中定制。

.. _adding-bubble-support-to-a-game:

在游戏中添加气泡式对话
-------------------------------

使用8.1版之前的Ren'Py创建的游戏，默认的界面设置并不能使用台词气泡系统。
需要做两步工作才能使用台词气泡系统。

第一步，下载下面两个文件：

* https://raw.githubusercontent.com/renpy/renpy/master/gui/game/gui/bubble.png
* https://raw.githubusercontent.com/renpy/renpy/master/gui/game/gui/thoughtbubble.png

(译者注：国内网络正常无法访问以上两个地址，请保存下面两个图片即可。)

.. ifconfig:: renpy_figures

    .. figure:: bubble/bubble.png
        :width: 100%

        bubble.png

    .. figure:: bubble/thoughtbubble.png
        :width: 100%

        thoughtbubble.png


将以上两张图片放置在 ``game/gui`` 目录下。

第二步，在screens.rpy文件结尾添加以下内容：

::

    ## 气泡式对话界面 ######################################################################
    ##
    ## 气泡式对话界面用于以对话气泡的形式向玩家显示对话。
    ## 气泡式对话界面的参数与 say 界面相同，必须创建一个 id 为 what 的可视组件，
    ## 并且可以创建 id 为 namebox、who 和 window 的可视组件。
    ##
    ## https://www.renpy.cn/doc/bubble.html#bubble-screen

    screen bubble(who, what):
        style_prefix "bubble"

        window:
            id "window"

            if who is not None:

                window:
                    id "namebox"
                    style "bubble_namebox"

                    text who:
                        id "who"

            text what:
                id "what"

    style bubble_window is empty
    style bubble_namebox is empty
    style bubble_who is default
    style bubble_what is default

    style bubble_window:
        xpadding 30
        top_padding 5
        bottom_padding 5

    style bubble_namebox:
        xalign 0.5

    style bubble_who:
        xalign 0.5
        textalign 0.5
        color "#000"

    style bubble_what:
        align (0.5, 0.5)
        text_align 0.5
        layout "subtitle"
        color "#000"

    define bubble.frame = Frame("gui/bubble.png", 55, 55, 55, 95)
    define bubble.thoughtframe = Frame("gui/thoughtbubble.png", 55, 55, 55, 55)

    define bubble.properties = {
        "bottom_left" : {
            "window_background" : Transform(bubble.frame, xzoom=1, yzoom=1),
            "window_bottom_padding" : 27,
        },

        "bottom_right" : {
            "window_background" : Transform(bubble.frame, xzoom=-1, yzoom=1),
            "window_bottom_padding" : 27,
        },

        "top_left" : {
            "window_background" : Transform(bubble.frame, xzoom=1, yzoom=-1),
            "window_top_padding" : 27,
        },

        "top_right" : {
            "window_background" : Transform(bubble.frame, xzoom=-1, yzoom=-1),
            "window_top_padding" : 27,
        },

        "thought" : {
            "window_background" : bubble.thoughtframe,
        }
    }

    define bubble.expand_area = {
        "bottom_left" : (0, 0, 0, 22),
        "bottom_right" : (0, 0, 0, 22),
        "top_left" : (0, 22, 0, 0),
        "top_right" : (0, 22, 0, 0),
        "thought" : (0, 0, 0, 0),
    }