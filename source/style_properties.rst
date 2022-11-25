.. _style-properties:

====================
样式特性(property)
====================

(译者注：property一词通常翻译成“属性”。鉴于文档中的attribute也可以翻译成“属性”。为了防止混淆，将property翻译为“特性”。)

样式特性与 :ref:`样式 <styles>` 相关，控制可视组件的显示方式。样式特性出现时可以没有前缀，这种情况下样式特性应用于所有状态的可视组件；带前缀的样式特性则限制了应用组件的状态。

.. _style-property-prefixes:

样式特性前缀
=======================

增加前缀可以从样式特性名称上就能看出作用于哪些状态的可视组件，比如得到焦点或者被选择状态。例如，某个按钮可以在鼠标悬停其上的时候改变颜色，或者提示按钮对应的选项就是目前使用的选项。

可视组件总共有5种状态可用作样式特性前缀。

:dfn:`insensitive`
    当用户与无法与可视组件互动时使用。

:dfn:`idle`
    当可视组件即没有获得焦点也没有被选中时使用。

:dfn:`hover`
    当可视组件获得焦点但没有被选中时使用。

:dfn:`selected_idle`
    当可视组件未获得焦点但被选中时使用。

:dfn:`selected_hover`
    当可视组件获得焦点且被选中时使用。

按钮和条类可视组件(包括他们的各类变种)在收到事件消息后，会更新自身和子组件的状态。例如，当用户把鼠标移动到某个未被选择的按钮上方，按钮及其子组件都会把状态改为hover。

样式特性前缀名允许外延。这里是一个前缀状态及其能外延的所有可视组件状态映射关系。


.. list-table::
 :header-rows: 1

 * - prefix
   - states implied by prefix

 * - (no prefix)
   - insensitive, idle, hover, selected\_idle, selected\_hover

 * - ``idle_``
   - idle, selected\_idle

 * - ``hover_``
   - hover, selected\_hover

 * - ``selected_``
   - selected\_idle, selected\_hover

 * - ``insensitive_``
   - insensitive

 * - ``selected_idle_``
   - selected\_idle

 * - ``selected_hover_``
   - selected\_hover

 * - ``selected_insensitive_``
   - selected\_insensitive

我们可以使用一个文本按钮实际演示一下。文本按钮使用两个默认的样式： ``button`` 用于按钮本身， ``button_text`` 用于按钮上的文本。 :propref:`background` 样式特性设置按钮的背景， :propref:`color` 特性设置文本颜色：

::

     # 当按钮为insensitive状态时，背景为灰色；hover状态是，背景为浅蓝；
     # 其他情况下，背景为深蓝。
     style button:
         background "#006"
         insensitive_background "#444"
         hover_background "#00a"

     # 当按钮为selected状态时，文本为黄色；其他情况下为白色。
     style button_text:
         color "#fff"
         selected_color "#ff0"

.. _style-property-values:

样式特性的值
=====================

每种样式特性对应每种特定类型的数据。许多特性值都是标准的python数据类型，有一些是novel类型。这里会对这些novel类型的数据进行详细说明。

`position`
    position用于指定以左上角为原点的坐标系中的位置。(对position来说，可用区域由可视组件所在的图层给定，如果没有图层就是整个界面。对anchor来说，可用区域是其自身可视组件的大小。)

    position值的解释方法取决于数据类型：

    int (比如 0, 1, 37, or 42)
        整数被解释为像素数量，从可用区域最左边或顶边算起。
    float (比如 0.0, 0.5, or 1.0)
        浮点数被解释为可用区域的一个比例。例如，0.5表示区域类某条表的中点，1.0表示最右边或者底边。
    absolute (比如 absolute(100.25))
        当使用亚像素精度(subpixel-precise)渲染时，``absolute`` 数被解释为像素数量，从可用区域最左边或顶边算起。

`displayable`
    任意可视组件。若某个可视组件名包含某个类似“[prefix\_]”的子串，就会按照如下描述进行前缀搜索。

`color`
    Ren'Py中的color可以写作以符号(#)开头、后面接十六进制的字符串。十六进制字符串长度可以为3或4的整数倍，分别对应几种颜色。

    十六进制字符串为3的整数倍时，分别对应红、绿、蓝三种颜色。十六进制字符串为4的整数倍时，分别对应红、绿、蓝和alpha通道值。举例：

    * ``"#f00"`` 和 ``"#ff0000"`` 表现为纯红。
    * ``"#0f08"`` 和 ``#00ff0080"`` 表现为某种半透明的绿色。

    颜色代码规律和用于HTML的颜色代码相同。

    color也可以用一个4元素的元组，每个元素都是介于0到255的整数，顺序对应红、绿、蓝和alpha通道值。

    * ``(0, 0, 255, 255)`` 表现为完全不透明的蓝色。

    最后，color可以是 :class:`Color` 类的一个实例。

.. _style-prefix-search:

样式前缀搜索
-------------------

当某个样式特性包含“[prefix\_]”可替换前缀，就会进行前缀搜索。前缀搜索会查找没一种状态前缀，根据原特性已经明确声明过的信息。

举例，如果我们有如下脚本：

::

    style button:
        hover_background "[prefix_]background.png"

样式前缀搜索会分别搜索hover和selected\_hover状态。前缀的搜索基于样式特性定义语句中的state值。

.. list-table::
 :header-rows: 1

 * - state
   - search order

 * - idle
   - "idle\_", ""

 * - hover
   - "hover\_", "",

 * - insensitive
   - "insensitive\_", "", "idle\_"

 * - selected\_idle
   - "selected\_idle\_", "idle\_", "selected\_", ""

 * - selected_hover
   - "selected\_hover\_", "hover\_", "selected\_", ""

 * - selected\_insensitive
   - "selected\_insensitive\_", "hover\_", "selected\_", "", "selected\_idle\_", "idle\_"

样式前缀搜索按上面表格给出的顺序进行。然后Ren'Py会坚持是否有符合那个名称的可加载文件或者图像存在。如果文件或图像存在，样式前缀搜索就会结束，并且使用找到的可视组件。否则，搜索会继续尝试下一个前缀。

样式前缀会传给可视组件，不需要用户输入。

这里是一个样例，演示这个功能如何使用。假设文件“idel\_button.png”和“hover\_button.png”存在(并且不存在其他以“button.png”字符串结尾的其他文件)：

::

    style button:
        background "[prefix_]button.png"

等效于：

::

    style button:
        idle_background "idle_button.png"
        hover_background "hover_button.png"
        insensitive_background "idle_button.png"

        selected_idle_background "idle_button.png"
        selected_hover_background "hover_button.png"
        selected_insensitive_background "idle_button.png"

.. _list-of-all-style-properties:

所有样式特性的列表
============================

样式特性控制各种可视组件的外观。但并不是所有特性都能应用于所有可视组件，所以我们将特性分了几个组。

.. _position-style-properties:

位置样式特性
-------------------------

这类特性可以应用于所有可视组件，大部分通过布局(layout)控制可视组件在区域内的位置，或者不使用布局(layout)时直接控制在整个界面的位置。

.. style-property:: alt string or None

    当self-voicing启用时，备选文本会用于可视组件。详见 :ref:`自动语音 <self-voicing>` 章节内容。

.. style-property:: xpos position

    可视组件相对于可选区域左端的位置。

.. style-property:: ypos position

    可视组件相对于可选区域顶端的位置。

.. style-property:: pos tuple of (position, position)

    将xpos和ypos放入一个元组，分别作为元组的第一个和第二个元素。

.. style-property:: xanchor position

    锚点相对于可选区域左端的位置。

.. style-property:: yanchor position

    锚点相对于可选区域顶端的位置。

.. style-property:: anchor tuple of (position, position)

    将xanchor和yanchor放入一个元组，分别作为元组的第一个和第二个元素。

.. style-property:: xalign float

    将xpos和xanchor设置为相同值。根据该值将可视组件显示在界面的某个相对位置上，0.0表示左对齐，0.5表示居中，1.0表示右对齐。

.. style-property:: yalign float

    将ypos和yanchor设置为相同值。根据该值将可视组件显示在界面的某个相对位置上，0.0表示顶端对齐，0.5表示居中，1.0表示底端对齐。

.. style-property:: align tuple of (float, float)

    将xalign和yalign放入一个元组，分别作为元组的第一个和第二个元素。

.. style-property:: xcenter position

    将xpos设为该特性的值，将xanchor设为0.5。

.. style-property:: ycenter position

    将ypos设为该特性的值，将yanchor设为0.5。

.. style-property:: xoffset int

    给出了水平方向的偏移值，单位为像素。

.. style-property:: yoffset int

    给出了垂直方向的偏移值，单位为像素。

.. style-property:: offset tuple of (position, position)

    同时给出水平和垂直方向的偏移值，分别使用元组的第一个和第二个元素。

.. style-property:: xmaximum int

    指定可视组件水平方向尺寸最大值，单位为像素。

.. style-property:: ymaximum int

    指定可视组件垂直方向尺寸最大值，单位为像素。

.. style-property:: maximum tuple of (int, int)

    使用元组指定可视组件尺寸最大值，水平和垂直方向分别使用元组的第一个和第二个元素。

.. style-property:: xminimum int

    设置可视组件的最小宽度，单位为像素。仅对可以改变尺寸的可视组件有效。

.. style-property:: yminimum int

    设置可视组件的最小高度，单位为像素。仅对可以改变尺寸的可视组件有效。

.. style-property:: minimum tuple of (int, int)

    使用元组设置xminimum和yminimum。

.. style-property:: xsize int

    将xminimum和xmaximum设置为相同值。该特性对可视组件的宽度生效。

.. style-property:: ysize int

    将yminimum和ymaximum设置为相同值。该特性对可视组件的高度生效。

.. style-property:: xysize tuple of (int, int)

    使用元组第一个元素设置xminimum和xmaximum，使用元组的第二个元素设置yminimum和ymaximum。该特性对可视组件的尺寸生效。

.. style-property:: xfill boolean

    若为True，可视组件会在水平方向填满所有可用空间。若不为True，可视组件只占用包含所有子组件的空间。

    仅对可以改变尺寸的可视组件有效。

.. style-property:: yfill boolean

    若为True，可视组件会在垂直方向填满所有可用空间。若不为True，可视组件只占用包含所有子组件的空间。

    仅对可以改变尺寸的可视组件有效。

.. style-property:: area tuple of (int, int, int, int)

    元组内元素可解释为 (`xpos`, `ypos`, `width`, `height`)。如果把某个可视组件的左上角放在 `xpos` 和 `ypos` 对应的位置，那么它的尺寸就是 `width` 和 `height`。

    这个特性会把xpos、ypos、xanchor、yanchor、xmaximum、ymaximum、xminimum、yminimum、xfill和yfill自动设置为合适的值。

    但这个特性并不适用于所有的可视组件和布局(layout)。

.. style-property:: mipmap boolean 或 None

    该特性控制可视组件创建的纹理是否使用mipmap。该特性只适用于某些可视组件，包括 :func:`Text`，:func:`Movie` 和 dissolve。

    若非None，默认值从配置项 :var:`config.mipmap_text`，:var:`config.mipmap_movies` 和
    :var:`config.mipmap_dissolves` 获取。

.. _text-style-properties:

文本样式特性
---------------------

.. style-property:: antialias boolean

    若为True，默认情况，全真字体(truetype font)文本会使用抗锯齿渲染。

.. style-property:: adjust_spacing boolean or str

    若为True，Ren'Py会调整绘制分辨率下文本间隙以匹配虚拟分辨率下渲染的文本间隙，确保frame和其他容器类内的文本不会被改变。

    若设置为False，文本不会改变字号，但确保在任何窗口大小下布局文本都有足够空间，这是创作者的职责。

    当字符串设置为“horizontal”时，仅在水平方向调整文本。
    当字符串设置为“vertical”时，仅在垂直方向调整文本。

    对大多数文本来说都是用默认值True，但在需要 ``input`` 输入的情况下使用False。

.. style-property:: altruby_style style or None

    如果为值非None，这应是一个样式对象。它是给可选上标文字使用的样式。

.. style-property:: black_color color

    当渲染某个基于图像的字体时，黑色会被映射为需要的颜色。这个特性对全真(truetype)字体无效。

.. style-property:: bold boolean

    若为True，使用粗体渲染。对全真(truetype)字体来说，这个特性会会综合提升字体的重量(weight)。这个特性也可能会触发字体映射，使用
    :var:`config.font_replacement_map` 配置的值。

.. style-property:: caret displayable or None

    若非None，其应是一个可视组件。输入部件会使用这个可视组件显示在文本的末尾。若为空，会有一条1像素宽的线在行尾闪烁。

.. style-property:: color color

    文本渲染使用的色彩。当使用某个全真(truetype)字体时，字体会直接使用色彩渲染。当使用基于图像的字体时，白色会映射为指定的色彩。

.. style-property:: first_indent int

    首行缩进量，单位是像素。

.. style-property:: font string

    用于渲染文本的字体名称字符串。

    对于全真(truetype)字体文件来说，该字符串通常就是包含字体的文件名(例如 ``"DejaVuSans.ttf"``)。如果需要使用字体集的第二种字体，就在字体名前面加一个数字和@符号，(例如 ``“0@font.ttc”`` 或 ``“1@font.ttc”``)。对于基于图像的字体来说，该字符串是字体注册时使用的名称。

.. style-property:: size int

    界面中字体的字号。通常字号大小就是字体高度的像素值，字体文件中可能还会插入几个像素。

.. style-property:: italic boolean

    若为True，使用斜体渲染文本。对全真(truetype)字体来说，这个特性会会综合提升字体的倾斜度(slant)。这个特性也可能会触发字体映射，使用
    :var:`config.font_replacement_map` 配置的值。

.. style-property:: justify boolean

    若该值为True，单词之间会插入额外的空白，每行文字左右两端的空白也会增加。段落最后一行的结尾不会发生变化。

.. style-property:: kerning float

    字偶距调整，任意两个字符之间的空白像素数会增加。(如果要缩小字符之间的空白，该值应该是负数。)

.. style-property:: language string

    控制语言文字族断行。合法值如下：

    ``"unicode"`` (default)
        使用unicode断行算法，大多数语言的默认项。

    ``"japanese-strict"``
        使用“strict”法格式化日语文本。禁止在小写的假名和延音记号前断行。

    ``"japanese-normal"``
        使用“normal”法格式化日语文本。允许在小写的假名、延音标记和某些连字符号后断行。

    ``"japanese-loose"``
        使用“loose”法格式化日语文本。允许在小写的假名、延音标记、叠字符号、不可分割字符、中心化标点符号和后缀的后面断行；也允许在前缀的前面断行。

    ``"korean-with-spaces"``
        使用空白定界的韩语文本。防止临近的韩语字符之间出现断行。

    ``"western"``
        只循序在空白处断行。适用于大多数语言。

    三种日语的断行模式来源于 `CSS3文本模块 <http://www.w3.org/TR/css3-text/#line-break>`_。

.. style-property:: layout string

    控制每行单词(字)的分配方式。合法值如下：

    ``"tex"`` (default)
        使用Knuth-Plass断行算法。该算法能让除最后一行之外，各行的长度差异尽可能小。

    ``"subtitle"``
        使用Knuth-Plass断行算法，但会使用空格尽可能让每行长度一致。

    ``"greedy"``
        每行尽可能多得放入单词(字)。

    ``"nobreak"``
        不断行。

.. style-property:: line_leading int

    每行所占空间的像素数。

.. style-property:: line_overlap_split int

    在慢速文本模式下两行文本有重叠部分，这部分重叠像素分配给上面那行文本。如果上面那行文本的底部出现了被裁减的情况，就增加该特性的值。

.. style-property:: line_spacing int

    每一行下面空间的像素数。

.. style-property:: min_width int

    设置每行的最小宽度。如果某行的段度小于该值，会被填充至该值。text_align用于指定填充方式。

.. style-property:: newline_indent boolean

    若为True，  :propref:`first_indent` 的缩进量会应用于每个新行。否则使用 :propref:`rest_indent`
    的缩进量。

.. style-property:: outlines list of tuple of (int, color, int, int)

    这是一个文本后绘制的轮廓线列表。每个元组指定一种轮廓线，轮廓线从后往前绘制。

    列表中包含 (`size`, `color`, `xoffset`, `yoffset`)
    形式的元组。 `Size` 是字体外沿尺寸，单位为像素。 `Color` 是轮廓线色彩。 `xoffset` 和
    `yoffset` 是轮廓线的位移，单位为像素。

    轮廓线功能可以用于给字体添加投影，方法是将size设为0，偏移量设为非0。

    默认情况下， `size`, `xoffset` 和 `yoffset` 会随文本一同拉伸。当我们给定absolute类型时，就能禁止拉伸。举例：

::

        style default:
            outlines [ (absolute(1), "#000", absolute(0), absolute(0)) ]

    这段脚本产生了1像素宽的边界。

    轮廓线只对全真(truetype)字体有效。

.. style-property:: rest_indent int

    指定段落首行之外的缩进量，单位为像素。

.. style-property:: ruby_style style or None

    如果非None，该值是一个样式对象。该样式不能用于ruby文本。

.. style-property:: slow_abortable boolean

    如果为True，能传到文本对象的点击事件会触发退出慢速文本模式，这意味着后面部分的文本会立刻显示。

.. style-property:: slow_cps int or True

    如果是一个整数，表示每秒显示的字符速率。如果为True，使用个性化配置中的“文本速度”。

.. style-property:: slow_cps_multiplier float

    文本显示速度会乘上该值。可以用于表现某个角色的说话速度比正常速率略快的情况。

.. style-property:: strikethrough boolean

    若为True，每行文字会添加删除线。

.. style-property:: text_align float

    当一行文本的宽度比文本组件的宽度小时，该项起作用。其决定文本左边会有多少留白。(也就是文本的对齐。)

    0.0表示左对齐，0.5表示中央对齐，1.0表示右对齐。

.. style-property:: underline boolean

    若为True，文本会添加下划线。

.. style-property:: hyperlink_functions tuple of (function, function, function)

    这是由三个与超链接有关的函数构成的元组。

    第一个元素是超链接样式函数。当使用一个入参(超链接)调用函数时，会返回得到用于该超链接的样式对象，比如 ``style.hyperlink_text`` 。需要注意，样式对象并不是一个字符串。

    第二个元素是超链接点击函数。当超链接被用户选中的时候，该函数会被调用。如果该函数返回一个值并且不是None，这个值也会作为互动行为的返回值。

    第三个元素是超链接焦点函数。当超链接获取焦点时，该函数会被调用，并将超链接作为入参；当超链接失去焦点时，该函数也会被调用，入参使用空值(None)。如果该函数返回一个值并且非空，这个值也会作为互动行为的返回值。

.. style-property:: vertical boolean

    若为True，文本内容会渲染为垂直文本。

.. style-property:: hinting str

    控制字体如何进行微调。可以是以下几个字符串之一：

    "auto"
        默认值，使用Freetype自动微调。
    "bytecode"
        使用字体中的bytecode微调信息。
    "none"
        对字体不进行微调。

.. _window-style-properties:

窗口样式特性
-----------------------

窗口特性用于指定窗口、框架和按钮的外观。

.. style-property:: background displayable or None

    用作窗口背景的可视组件。通常是一个 :func:`Frame`，能根据窗口大小拉伸背景的尺寸。

    若为None，不绘制背景。但其他特性函数会假设背景存在。

.. style-property:: foreground displayable or None

    若不为None，该可视组件会在窗口内容上绘制并覆盖。

.. style-property:: left_margin int

    背景左端的透明空间量，单位为像素。

.. style-property:: right_margin int

    背景右端的透明空间量，单位为像素。

.. style-property:: xmargin int

    等效于将left_margin和right_margin设置为相同的值。

.. style-property:: top_margin int

    背景顶端的透明空间量，单位为像素。

.. style-property:: bottom_margin int

    背景底端的透明空间量，单位为像素。

.. style-property:: ymargin int

    等效于将top_margin和bottom_margin设置为相同的值。

.. style-property:: margin tuple

    如果出现的是2个元素的元组，分别将xmargin和ymargin设置为对应的两个元素值。如果出现的是4元素元组，分别将left_margin、top_margin、right_margin和bottom_margin设置为对应的4个元素值。

.. style-property:: left_padding int

    背景与窗口内容左边的空间量，单位为像素。

.. style-property:: right_padding int

    背景与窗口内容右边的空间量，单位为像素。

.. style-property:: xpadding int

    等效于将left_padding和right_padding设置为相同的值。

.. style-property:: top_padding int

    背景与窗口内容顶边的空间量，单位为像素。

.. style-property:: bottom_padding int

    背景与窗口内容底边的空间量，单位为像素。

.. style-property:: ypadding int

    等效于将top_padding和bottom_padding设置为相同的值。

.. style-property:: padding tuple

    如果出现的是2个元素的元组，分别将xpadding和ypadding设置为对应的两个元素值。如果出现的是4元素元组，分别将left_padding、top_padding、right_padding和bottom_padding设置为对应的4个元素值

.. style-property:: size_group string or None

    若非None，该值是一个字符串。Ren'Py会使用size_group值相同的尺寸渲染所有窗口。

.. style-property:: modal boolean or callable

    若为True，窗口设为模态。鼠标点击事件值对当前窗口内的window或按钮组件有效，不会广播穿透。
    若为False，窗口设为非模态。

    该项也可以是一个可调用的函数。
    其为函数时，入参使用(ev, x, y, w, h)形式的四元元组。其中ev是pygame事件消息，也可能是None笼统表示一个鼠标事件；x和y表示窗口坐标，w和h表示窗口的宽和高。函数返回为True时，窗口视为模态，否则视为非模态。

.. _button-style-properties:

按钮样式特性
-----------------------

.. style-property:: child displayable or None

    若非None，给出的可视组件会替换按钮的子组件。例如，该可视组件(作为insensitive_child)可以用于替换insensitive的按钮图片内容，insensitive表示按钮被锁住无法使用。

.. style-property:: hover_sound string

    当按钮获取焦点时，将播放一个音效。

.. style-property:: activate_sound string

    当按钮被点击时，将播放一个音效。

.. style-property:: hover_sound - string

    当按钮获得焦点时，将播放一个音效。

.. style-property:: activate_sound

    当按钮被激活(点击)时，将播放一个音效。

.. style-property:: mouse string

    鼠标样式用于按钮获得焦点状态。这是定义在 :var:`config.mouse` 中的样式之一。

.. style-property:: focus_mask multiple

    一个mask遮罩，用于控制按钮哪些区域可以获得焦点，哪些区域不响应点击。该特性的类型决定了其如何被解释。

    **Displayable**
        可视组件的不透明区域，可以让按钮获得焦点。

    **True**
        按钮自身用作可视组件(按钮的非透明区域可以让按钮获得焦点)。

    **callable**
        如果一个不可视组件被调用(像函数、方法或者带有__call__方法的对象)，该该函数被使用两个入参调用，从对应可视组件左上角算起，x和y轴的两个偏移量。若函数返回结果为True，可视组件获得焦点。

    **None**
        如果该值为None，整个按钮都可以获得焦点。

.. style-property:: keyboard_focus boolean

   若为True，也是默认值，按钮可以通过键盘的焦点机制获得焦点，前提是这个按钮本身允许获得焦点。若为False，键盘焦点机制会跳过这个按钮。(键盘焦点机制使用键盘或者类似键盘的设备，比如游戏手柄。)

.. style-property:: key_events boolean

    若为True，键盘生成的事件消息会传给键盘的子组件。若为False，这些事件就不会向下广播。默认样式中，按钮上有鼠标悬停时该值为True，其他情况下该值为False。

    将这个值设置为True可以用于广播键盘事件消息至某个按钮内的输入框，而那个按键并不需要获得焦点。


.. _bar-style-properties:

条(bar)样式特性
--------------------

条(bar)是一个左右两边带有沟槽的组件，点击后触发条条内平移一小段距离。滑块与左右两端的间隔就是还允许移动的距离。

滑块是条(bar)中允许用户拖拽的部分。

当绘制一个条(bar)后，滑块的阴影首先被绘制。然后是滑块本身，最后是条(bar)的左/底边和右/顶边。

需要注意条(bar)的边取决于bar_vertical特性的值。若bar_vertical为True，顶边和底边会实际绘制。否则，只有左边和右边。

.. style-property:: bar_vertical boolean

    若为True，纵向条(bar)。若为False，横向条(bar)。

.. style-property:: bar_invert boolean

    若为True，条(bar)上滑块对应的值显示在右/上侧；否则，显示在左/下侧。

.. style-property:: bar_resizing boolean

    若为True，重新调整条(bar)的尺寸。若为False，使用全尺寸渲染各条边，然后裁剪。

.. style-property:: left_gutter int

    左边沟槽尺寸，单位为像素。

.. style-property:: right_gutter int

    右边沟槽尺寸，单位为像素。

.. style-property:: top_gutter int

    顶边沟槽尺寸，单位为像素。

.. style-property:: bottom_gutter int

    底边沟槽尺寸，单位为像素。

.. style-property:: left_bar displayable

    用于左边的可视组件。

.. style-property:: right_bar displayable

    用于右边的可视组件。

.. style-property:: top_bar displayable

    用于顶边的可视组件。

.. style-property:: bottom_bar displayable

    用于底边的可视组件。

.. style-property:: base_bar displayable

    单个可视组件用于left_bar/right_bar或者top_bar/bottom_bar，自动适配。(带滑块的情况下，还可以用作滑动条或者滑动栏。)

.. style-property:: thumb displayable or None

    若非None，这是一个绘制在条(bar)的各条边空间内的可视组件。

.. style-property:: thumb_shadow displayable or None

    若非None，这是一个绘制在条(bar)的各条边空间内的可视组件。

.. style-property:: thumb_offset int

    滑块与条(bar)重叠部分的大小，单位为像素。如果想让条(bar)的左右两边看起来不像被截断的样子，就把滑块的宽度设为条(bar)宽度的一半。

.. style-property:: mouse string

    鼠标样式，用于按钮获得焦点时。该字符串应是 :var:`config.mouse` 定义的样式之一。

.. style-property:: unscrollable string or None

    当无法滚动时，控制条(bar)的行为表现(如果滚动范围设置为0，视点范围内的可视组件小于其自身)。总共有3种可能的值：

    ``None``
        正常渲染条(bar)。

    ``"insensitive"``
        渲染insensitive状态下条(bar)。这个值允许条(bar)改变自身样式，尽管那很少使用。

    ``"hide"``
       不渲染条(bar)。空间会预留给条(bar)，不会那段空间不绘制任何东西。

.. style-property:: keyboard_focus boolean

   若为True，也是默认值，按钮可以通过键盘的焦点机制获得焦点，前提是这个按钮本身允许获得焦点。若为False，键盘焦点机制会跳过这个按钮。(键盘焦点机制使用键盘或者类似键盘的设备，比如游戏手柄。)

.. _box-style-properties:

方框(box)样式特性
--------------------

这些样式特性用于横向和纵向的方块布局。

.. style-property:: spacing int

    方块内成员之间的空间距离，单位为像素。

.. style-property:: first_spacing int

    若非None，表示，方框内的第一个跟第二个成员间的空间距离，单位为像素。该值覆盖spacing特性。

.. style-property:: box_reverse boolean

    若为True，方块内物品位置将被翻转。hbox左右镜像翻转，vbox上线镜像翻转。默认情况下的值为False。

.. style-property:: box_wrap boolean

    若为True，当到达方块最后一行或列时会发生扭转(warp)。若为False，会在每一行的结尾扩展。

.. style-property:: box_wrap_spacing int

    当box_wrap为True时，box_wrap_spacing项用于指定被wrap的行或列的间距。
    (行间距就是被warp的hbox在垂直方向空间，列间距就是被warp的vbox在水平方向的空间。)

.. _grid-style-properties:

网格(grid)样式特性
---------------------

这些特性用于网格(grid)和虚拟样机网格(vpgrid)可视组件中。

.. style-property:: spacing int

    各网格单元之间的空间，单位为像素。

.. style-property:: xspacing int or None

    各网格单元之间水平方向的空间，单位为像素。当这个值不是None时，优先级比spacing特性高。

.. style-property:: yspacing int or None

    各网格单元之间垂直方向的空间，单位为像素。当这个值不是None时，优先级比spacing特性高。


.. _fixed-style-properties:

固定布局的样式特性
----------------------

这些特性用于固定布局(layout)。

.. style-property:: fit_first boolean or "width" or "height"

    若为True，固定宽度的布局所有单元尺寸都会严格等于第一个单元内元素的尺寸。如果是“width”，只有单元格宽度能改变(固定布局会在垂直方向上填满界面)。类似的，“height”值能改变单元跟高度。

.. style-property:: xfit boolean

    若为True，固定布局的尺寸在水平方向会严格匹配最右侧子组件的尺寸。

.. style-property:: yfit boolean

    若为True，固定布局的尺寸在垂直方向会严格匹配最底部子组件的尺寸。

.. style-property:: order_reverse boolean

    若为False，也就是默认值，方框内元素会从前往后绘制，第一个元素下面是第二个元素。若为True，顺序会倒过来，第一个元素会在方框最底层。

.. _margin-style-properties:

边距样式特性
--------------

边距(margin)样式特性用于增加某些可视组件周围的透明空间。可用于：window、frame、button、grid和vpgrid。

.. style-property:: left_margin int

    可视组件左边距，单位为像素。

.. style-property:: right_margin int

    可视组件右边距，单位为像素。

.. style-property:: xmargin int

    等效于，将左边距和右边距设置为相同的值。

.. style-property:: top_margin int

    可视组件上边距，单位为像素。

.. style-property:: bottom_margin int

    可视组件下边距，单位为像素。

.. style-property:: ymargin int

    等效于，将上边距和下边距设置为相同的值。

.. style-property:: margin tuple

    该值可以是一个2元元组，分别设置xmargin和ymargin。
    该值也可以是一个4元元组，分别设置left_margin、top_margin、right_margin和bottom_margin。