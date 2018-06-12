.. _text:

====
文本
====

Ren'Py内涵多种方式用于显示文本。 :ref:`say <say-statement>`
和 :ref:`menu <menu-statement>` 语句就会用到文本显示。 用户接口通常都包含文本，显示时使用 :ref:`text <sl-text>`， :ref:`textbutton <sl-textbutton>`，
和 :ref:`label <sl-label>` screen语言语句。这些screen语句加上其他的函数，可以创建 :func:`Text()` 文本组件，并在界面上展示出来。

文本组件用于管理显示给用户的文本内容。文本组件按以下顺序执行动作：


1. 转化文本。
2. 在文本中插入数据
3. 使用样式和文本标签将文本样式化。
4. 给样式化后的文本布局。
5. 将文本内容绘制到界面上。

本节内容讨论在Ren'Py中处理文本显示问题的过程。

.. _escape-characters:

转义字符
=================

对Ren'Py来说，有3个特殊字符能控制文本显示。创作者需要注意，这3个字符的写法不要让引擎产生曲解。

\ (反斜杠)
    反斜杠用于Ren'Py字符串中的字符转义。一些常见的转义符号如下：

    \\" (反斜杠双引号)
        两端用双引号标识的字符串中含有一个双引号。

    \\' (反斜杠单引号)
        两端用单引号标识的字符串中含有一个单引号。

    \\\  (双引号空格)
          在Ren'Py字符串中含有一个额外的空格。默认情况下，Ren'Py脚本会将一段连续的空白转为一个空格字符。

    \\n (反斜杠-字符n)
        文本含有一个换行符。

    \\\\ (反斜杠-反斜杠)
        文本含有一个反斜杠字符。

[ (左方括号)
    左方括号用于转义在文本中插入的值。如果要在文本中包含左方括号，需要写两个左方括号 —— ``[[`` 。

{ (左花括号)
    左花括号用于转义文本标签(tag)。如果要在文本中包含左花括号，需要写两个左花括号 —— ``{{`` 。


.. _text-interpolation:

插入数值
==================

Ren'Py支持在文本字符串中插入数值。例如，假设用户名字存储在 ``playername`` 变量中，我们可以写这样一行对话：

::

    g "欢迎来到猫耳协会， [playername] ！"

Ren'Py会在全局存储区寻找同名变量并插入到文本中。当我们在某个界面使用一个文本控件时，Ren'Py也会将预定义的界面本地变量值插入到控件中。(这个值也可以通过向文本控件传入一个explicit scope参数来覆盖。)

Ren'Py并不限制只允许插入简单变量值，也支持插入字段(field)和元组元素值。以下写法也是可以的：

::

    g "我姓 [player.names[0]]。"

显示数值之前可以先进行格式化。下面的例子显示的是一个保留小数点后两位的浮点数：

::

    $ percent = 100.0 * points / max_points
    g "我百分之 [percent:.2] 喜欢你！"

Ren'Py字符串的数值插入符合 :pep:`3101` 的字符串格式规范。 Ren'Py字符串插入使用  ``[`` ，因为 ``{`` 被用于文本标签(tag)了。

还有，Ren'Py支持!s、!r、!q和!t等转换标记。!q转换标记表示文本标签(tag)内引号已经正确匹配和使用，显示字符串时不会转义为不希望出现的格式。举例：

::

    g "Don't pull a fast one on me, [playername!q]."

!t转换标记会转换或计算插入字符串的值：

::

    if points > 5:
        $ mood = _("高兴")
    else:
        $ mood = _("头大")

    g "见到你我很 [mood!t] 。"

.. _styling-and-text-tags：

样式化和文本标签(tag)
=====================

在Ren'Py中，文本有两种方式获取样式(style)信息。第一种是，根据整个文本段落(block)应用的样式获取。请详见 :ref:`样式系统 <styles>` 及 :ref:`文本样式特性 <text-style-properties>` 部分的内容。

第二种是，通过使用文本标签(tag)。文本标签(tag)可用于一个文本段落(block)中一部分的样式化，也可以用于程序中所有文本段落中一部分的样式化。如果你发现自己在文本的每一行里都应用了同样的文本标签，可以考虑使用样式代替这种做法。

总共有两种文本标签。某些文本标签是自闭合的，而有些文本标签需要成对的闭合标签。当多个成对的闭合标签出现时，闭合顺序必须是后出现的标签先闭合——Ren'Py会拒绝不正确匹配。例如：

::

    # 这行是正确的
    "Plain {b}Bold {i}Bold-Italic{/i} Bold{/b} Plain"

    # 这行是不正确的，并会引起报错或不正确的画面表现
    "Plain {b}Bold {i}Bold-Italic{/b} Italic{/i} Plain"

某些文本标签可以带一个入参。带入参的文本标签后面会带一个等号(=)，后面跟参数值。入参不能含有右花括号(})。入参的含义根据不同的文本标签而不同。

.. _general-text-tags:

通用文本标签
-----------------

通用文本标签可以应用于如下文本：

.. _a-tag:
.. text-tag:: a

    锚点标签在其自身和自己的闭合标签内，创建了一个超链接。超链接的行为表现由
    :propref:`hyperlink_functions` 样式特性控制。 默认的处理包含以下行为：

    * 当入参以“jump:”开头，入参的其余部分是要跳转的脚本标签(label)名。

    * 当入参以“call:”开头，入参的其余部分是要调用的脚本标签(label)名。通常来说，call执行完后会回到当前的Ren'Py语句。

    * 当入参以“call_in_new_context:”开头，入参的其余部分是某个新的上下文(使用 :func:`renpy.call_in_new_context` 函数)中需要调用的脚本标签名。

    * 除了以上情况，入参是一个URL，可以使用系统web浏览器打开。

    如果在入参中没有显式的协议头， :var:`config.hyperlink_protocol`
    中配置的值会自动添加到入参头部。如果 :var:`config.hyperlink_protocol` 已经被配置为“jump”，{a=label}跟{a=jump:label}就是等价的。创作者可以使用 :var:`config.hyperlink_handlers` 配置一个新的协议名称。

    ::

        label test:

            e "你可以访问 {a=https://renpy.org}Ren'Py's 主页{/a}。"

            e "或者 {a=jump:more_text}这里来得到更多信息{/a}."

            return

        label more_text:

            e "在阿肯萨斯的温泉，有一座可以作为拍照景点的阿尔·卡彭雕像。"

            e "这就是更多信息，但不是你想要的那种对不？"

            return


.. text-tag:: alpha

    alpha文本标签(tag)指定一个透明度，渲染范围为自身及其闭合标签内的文本。透明度是一个介于0.0和1.0之间的数值，分别对应完全透明和完全不透明。若这个数值前缀带有+或者-，则表示是在原有透明度基础上做相应增减。若这个数值前缀带有 \*, 该数值与原值相乘的积作为透明度。 ::

        "{alpha=0.1}这字完全不能看！{/alpha}"
        "{alpha=-0.1}现在字的透明度少了10%{/alpha}"
        "{alpha=*0.5}字的透明度是默认的50%。{/alpha}"


.. text-tag:: b

    粗体标签，将自身及其毕业标签内的文本渲染为粗体。 ::

        "一个 {b}粗体测试{/b}。"

.. text-tag:: color

    颜色文本标签将自身及其闭合标签内的文本渲染为特定的颜色值。颜色值使用#rgb、#rgba、#rrggbb或#rrggbbaa格式。 ::

        "{color=#f00}红色{/color}, {color=#00ff00}绿色{/color}, {color=#0000ffff}蓝色{/color}"

.. text-tag:: cps

    “每秒钟字符数”标签设置了文本显示速度，作用范围为标签自身及其闭合标签范围内文本。若入参开头带有一个星号和数字n，表示使用文本n倍速显示。如果没有星号，则数字n表示每秒显示n个字符。 ::

        "{cps=20}固定速度{/cps} {cps=*2}两倍速{/cps}

.. text-tag:: font

    字体标签将标签自身及其闭合区间之间的文本渲染为指定的字体。入参即使用的字体文件名。 ::

        "尝试使用字体 {font=mikachan.ttf}mikachan font{/font}。"

.. text-tag:: i

   斜体标签将自身及其闭合标签之间的文本渲染为斜体。 ::

       "游览 {i}比萨斜塔{/i}。"

.. text-tag:: image

   图片标签是一个自闭合标签，作用是在文本中插入一个图片。插入的图片高度应该和单行文本的高度一致。入参可以是图片文件名，或者使用image语句定义的图像名。 ::

       g "见到你真好！ {image=heart.png}"

.. text-tag:: k

   字偶距标签调整文本字偶距，作用范围为其自身及其闭合标签之间的文本。其使用一个浮点数值作为入参，该值给定了字符之间增加的距离，单位是像素(该值也可以是负值，表示字符之间缩小的距离)。 ::

       "{k=-.5}Negative{/k} Normal {k=.5}Positive{/k}"


.. text-tag:: outlinecolor

    outlinecolor将文本的所有描边（包括阴影）颜色改为指定颜色，颜色格式为 #rgb、#rgba、#rrggbb或#rrggbbaa。 ::

        "让我们加一个{outlinecolor=#00ff00}绿色{/outlinecolor} 描边。"

.. text-tag:: plain

   纯文本标签保证文本没有任何加粗、斜体、下划线或删除线样式。 ::

       "{b}加粗。{plain}没有效果。{/plain} 加粗。{/b}"

.. text-tag:: rb

   可选的下标字符标识了标签自身及其闭合标签范围内文本。详情参考 :ref:`Ruby Text <ruby-text>` 。

.. text-tag:: rt

   可选的上标字符标识了标签自身及其闭合标签范围内文本。详情参考 :ref:`Ruby Text <ruby-text>` 。

.. text-tag:: s

   删除线标签在其自身及其闭合标签之间的文本上画一条删除线。 ::

       g "很高兴 {s}见到你{/s}。"

.. text-tag:: size

   字号标签改变了其自己及其闭合标签内的文本字号。入参应该是一个整数，可前缀+或者-。如果入参只是一个整数，那么字体高度就是那个整数的值，单位为像素。如果带有+或者-的话，字号在原值基础上进行增缩。 ::

       "{size=+10}变大{/size} {size=-10}变小{/size} {size=24}24 px{/size}."

.. text-tag:: space

   空白标签是一个自闭合标签，在一行文本内插入一段水平的空白。入参是一个整数，表示插入的空白宽度，单位为像素。 ::

       "空白之前。{space=30}空白之后。"

.. text-tag:: u

   下划线标签在其自身及其闭合标签之间的文本添加下划线。 ::

      g "很高兴 {u}见到{/u} 你。"

.. text-tag:: vspace

   垂直空白标签是一个自闭合标签，在文本的两行之间插入一段竖直的空白。入参是一个整数，表示插入的空白高度，单位为像素。 ::

      "第一行{vspace=30}第二行"

.. text-tag:: #

   以#符号开头的文本标签会被忽略，可以用于脚本调试。 ::

      "New{#playlist}"

.. _dialogue-text-tags:

对话文本标签
------------------

只能应用于对话的文本标签如下：

.. text-tag:: fast

    如果一行文本中出现了fast标签，在该标签前面的文本内容会立即显示，即使文本显示速度被设置为低速模式。fast标签是一个自闭合的标签。 ::

        g "看上去他们{nw}"
        show trebuchet
        g "看上去他们{fast} 又在玩投石机。"

.. text-tag:: nw

    “不等待”标签是一个自闭合标签，该标签前的那行文本内容在显示一次后会立刻消失。 ::

        g "看上去他们{nw}"
        show trebuchet
        g "看上去他们{fast} 又在玩投石机。"

    “不等待”标签依然会等待语音播放完再执行文本消失行为。

.. text-tag:: p

    段落暂停标签是一个自闭合标签，在当前文本段落中插入一个终止标记，等待用户点击后继续显示后面的内容。如果标签中带有一个入参，入参是一个数值，代表等待用户点击的时间(单位为秒)。等待期间用户没有点击行为的话，等待时间结束后也会自动进入后续内容。 ::

        "Line 1{p}Line 2{p=1.0}Line 3"

.. text-tag:: w

    等待标签是一个自闭合的标签，等待用户点击后继续显示后面的内容。如果标签中带有一个入参，入参是一个数值，代表等待用户点击的时间(单位为秒)。等待期间用户没有点击行为的话，等待时间结束后也会自动进入后续内容。 ::

        "Line 1{w} Line 1{w=1.0} Line 1"

也可以使用Python定义出 :ref:`custom text tags <custom-text-tags>` 。

.. _style-text-tags:

样式文本标签
---------------

Ren'Py支持文本标签使用各种样式。需要使用的话，标签的入参被用作样式名称。例如，{=mystyle}标签就会使用 ``mystyle`` 样式。

在标签和其对应的闭合标签之间的文本，将会拥有定义在样式中的以下特性(property)：

* antialias
* font
* size
* bold
* italic
* underline
* strikethrough
* color
* black_color
* kerning

.. _non-english-languages:

非英语
=====================

Ren'Py包含英语和很多其他语言的默认字体。考虑到字体库大小问题，Ren'Py没有包含需要渲染的语种，包括中日韩语。如果需要支持那些语言，在项目开头就需要更改使用的字体。

Ren'Py在之后的版本可能会支持世界上绝大多数的语言，而不需要做特别配置。韩语是在各个字之间不带空格书写的语言。Ren'Py有一个特殊模式可以支持带空格的韩语，可以做如下设置启用：

::

    define gui.language = "korean-with-spaces"

这也可以通过修改gui.rpy文件中“unicode”项的默认值实现。

日语在换行方面有许多规则。我们推荐开始先设置为“japanese-normal”，进阶使用“japanese-loose”或者“japanese-strict”，分别对应换行比较多或者比较少的情况。::

    define gui.language = "japanese-loose"

表意文字语言经常含有大量换行。要启用更快但运算量更少的换行算法的话，使用如下配置：

::

    define gui.language = "greedy"

这种更快的换行算法并不一定要启用，除非游戏中需要一次显示海量文本，例如在NVL模式下。

后续也可以使用
:func:`renpy.language_tailor` 函数配置换行算法。

.. _vertical-text:

垂直文本
-------------

当配置了 :propref:`vertical` 样式特性，Ren'Py就能生成原生的垂直文本。垂直文本的书写顺序是从上到下，从右往左。

这里有两个文本标签与垂直文本相关。

.. text-tag:: horiz

    在垂直文本中包含原生水平文本。

.. text-tag:: vert

    在水平文本中包含原生的垂直文本。(该标签不会旋转原生垂直文本内容。)

.. note::

    如果字体中没有包含垂直文本的字符间隔信息，Ren'Py会尝试从水平文本信息自动计算出垂直文本的字符间隔。在不同的Ren'Py版本中，实际的字符间隔可能并不一致。


.. _ruby-text:

Ruby文本
=========

Ruby文本(较常用来标明假名或者注音)是一种在某个字符或单词上方显示小号文本的文本。以下是几个步骤可以让你的游戏支持Ruby文本。

首先，你必须配置Ruby文本的样式(style)。需要修改以下样式特性：

1. :propref:`line_leading` 特性必须为Ruby文本预留足够的高度。
2. 创建一个新的自定义名的样式(style)。该样式的特性，比如 :propref:`size` 需要适合Ruby文本。
3. 新样式的yoffset必须特别设置，这是为了将Ruby文本升到一般文本基线之上。
4. 文本样式的 :propref:`ruby_style` 域应该被设置为上面新创建的样式。

举例：

::

  init python:
      style.default.line_leading = 12

      style.ruby_style = Style(style.default)
      style.ruby_style.size = 12
      style.ruby_style.yoffset = -20

      style.default.ruby_style = style.ruby_style

完成Ren'Py的相关配置后，我们就可以使用rt和rb文本标签，在脚本中包含Ruby文本了。rt标签用于标识一些字符将被显示为Ruby文本。如果在Ruby文本前面出现了rb标签，Ruby文本会与rb标签内的所有文本中央对齐。如果没有rb标签，Ruby文本会与对应的字符左对齐。

举例：

::

    e "Ruby 可以用来标识假名(東{rt}とう{/rt} 京{rt}きょう{/rt})。"

    e "也可以用来翻译 ({rb}東京{/rb}{rt}Tokyo{/rt})."

确保Ruby文本不会与其他文本内容重叠是创作者的职责。为了防止这种问题的出现，最好在文本上方多预留一些空间。

.. _fonts:

字体
=====

Ren'Py支持TrueType/OpenType字体和字体集，以及基于图形的字体。

TrueType或OpenType字体会给定字体文件名。那个字体文件必须被放在game文件夹里，或者某个归档文件中。

Ren'Py也支持TrueType/OpenType字体集。一个字体集中定义了多种字体。当我们接入一个字体集时，使用从0开始的字体下标，后面跟@符号和文件名。例如，“0@font.ttc”是字体集font的第一种字体，“1@font.ttc”是字体集font的第二种字体，以此类推。

.. _font-replacement:

字体替换
----------------

:var:`config.font_replacement_map` 配置项用于字体map图。字体文件、加粗和斜体会使用map图捆绑为一个组合。这个组合就用指定的斜体效果代替系统自动生成的斜体。

这种替换可以实现将“Deja Vu Sans”版本的斜体换成官方的“oblique”版本。(当然你需要先在网上下载“oblique”字体。)

::

    init python:
        config.font_replacement_map["DejaVuSans.ttf", False, True] = ("DejaVuSans-Oblique.ttf", False, False)

完成替换后可以提升斜体文本的感官效果。

.. _image-based-fonts:

基于图形的字体
-----------------

通过调用以下字体注册函数之一，可以注册基于图形的字体。注册时，需要指定字体的名称、字号、粗体、斜体和下划线。当所有特性都匹配时，注册后的字体才可以使用。

.. function:: renpy.register_bmfont(name=None, size=None, bold=False, italics=False, underline=False, filename=None)

  该函数注册了一个给定明细的BMFont(位图字体)。请注意，字号、粗体、斜体和下划线入参只是询问性质的(用于特性匹配)，并不会改变字体的实际效果。

  请查看 `BMFont首页 <http://www.angelcode.com/products/bmfont/>`_ 可以找到创建BMFonts的工具。Ren'Py需要filename参数是BMFont文本格式的，其描述了一个32比特字体的信息。alpha通道应该包含字体信息，而红绿蓝颜色通道应该被设置为1。图形文件、字偶距和其他控制信息都可以从BMFont文件中读取。

  我们推荐你创建的BMFont中包含拉丁字母和主要的标点符号，并确保在Ren'Py的接口上可以正确渲染。

  `name`
    一个字符串，注册的字体名称。

  `size`
    一个整数，注册字体的字号。

  `bold`
    一个布尔值，标识注册字体是否为粗体。

  `italics`
    一个布尔值，标识注册字体是否为斜体。

  `underline`
    可以忽略的参数。

  `filename`

    包含BMFont控制信息的文件。

.. function:: renpy.register_mudgefont(name=None, size=None, bold=False, italics=False, underline=False, filename=None, xml=None, spacewidth=10, default_kern=0, kerns={})

  该函数注册了一个给定明细的MudgeFont。请注意，字号、粗体、斜体和下划线入参只是询问性质的(用于特性匹配)，并不会改变字体的实际效果。

  请查看 `MudgeFont首页 <http://www.larryhastings.com/programming/mudgefont/>`_ 可以找到创建BMFonts的工具。Ren'Py假设MudgeFont的xml文件中的字符带都unicode字符数值，并会忽略所有负值。

  `name`
    一个字符串，注册的字体名称。

  `size`
    一个整数，注册字体的字号。

  `bold`
    一个布尔值，标识注册字体是否为粗体。

  `italics`
    一个布尔值，标识注册字体是否为斜体。

  `underline`
    可以忽略的参数。

  `filename`
    一个字符串，表示包含MudgeFont图形的文件。该图形通常是一个TGA文件，也可能是一个PNG或者其他Ren'Py支持的图片格式。

  `xml`
    包含MudgeFont工具生成信息的xml文件。

  `spacewidth`
    表示空格字符的宽度的整数，单位是像素。

  `default_kern`
    字符间距的默认值，单位是像素。

  `kerns`
    两字型字符串中字符间距的值。

.. function:: renpy.register_sfont(name=None, size=None, bold=False, italics=False, underline=False, filename=None, spacewidth=10, default_kern=0, kerns={}, charset=u'!"#$%&'()*+, -./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~')

  该函数注册了一个给定明细的SFont。请注意，字号、粗体、斜体和下划线入参只是询问性质的(用于特性匹配)，并不会改变字体的实际效果。

  `关于SFont的更多详情 <http://www.linux-games.com/sfont/>`_ 。

  `name`
    一个字符串，注册的字体名称。

  `size`
    一个整数，注册字体的字号。

  `bold`
    一个布尔值，标识注册字体是否为粗体。

  `italics`
    一个布尔值，标识注册字体是否为斜体。

  `underline`
    可以忽略的参数。

  `filename`
    一个字符串，包含SFont图形的文件名。

  `spacewidth`
    表示空格字符的宽度的整数，单位是像素。

  `default_kern`
    字符间距的默认值，单位是像素。

  `kerns`
    两字型字符串中字符间距的值。

  `charset`
    字体的字符集。这是一个字符串，可以按照字符串中包含的字符顺序在图像文件中找到对应的字符。more的SFont字符集如下：

    ::

        ! " # $ % & ' ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : ; < = > ?
        @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _
        ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~

由于BMFont是Ren'Py支持的所有三种图形文字中完成度最高的，所以我们推荐新建项目使用BMFont。一个BMFont的使用样例如下：

::

    init python:
        renpy.register_bmfont("bmfont", 22, filename="bmfont.fnt")

    define ebf = Character('Eileen', what_font="bmfont", what_size=22)

    label demo_bmfont:

        ebf "Finally, Ren'Py supports BMFonts."

.. _font-groups:

字体组
-----------

创建一个多语言游戏时，有时无法找到单一的字体能够包含所有文字并保持创作者想要表现的氛围。
因此，Ren'Py支持将“字体组”的形式，将两种或更多字体合并为一种字体。

创建字体组时，需要创建一个FontGroup对象并调用逐次调用 ``.add`` 方法。FontGroup对象可以直接当作字体使用。
add方法会查看指定范围内的unicode字符，并采用最先能匹配到的unicode字符范围对应的字体。


举例：

::

    style default:
         font FontGroup().add("english.ttf", 0x0020, 0x007f).add("japanese.ttf", 0x0000, 0xffff)

.. class:: FontGroup()

  可以将一组字体当作一种字体使用。

  .. method:: add(font, start, end)

    说明字体中字符的unicode范围。

    `start`
      unicode范围起点。可以是一个单字符的字符串，也可以是一个unicode字符对应的整数值。

    `end`
      unicode范围终点。可以是一个单字符的字符串，也可以是一个unicode字符对应的整数值。

    当多个 ``.add()`` 调用中包含同一个字符时，使用第一个包含这个字符的add方法中的字体。

    这个方法会返回FontGroup对象，所以能多个 ``.add()`` 串联使用。

.. _text-displayables:

文本组件
=================

文本也可以用作一个 :ref:`displayable <displayables>`，这意味着你可以在文本上应用各种表单格式(transform)，可以当作一个图片显示并在界面上移动它的位置。

.. function:: renpy.ParameterizedText(style='default', `properties)

  该函数创建一个可视组件对象，可以带一个字符串做为入参，根据入参字符串生成的对象能当作图像显示。常用作预定义的 ``文本`` 图片的一部分。

  举例，我们可以这样写：

  ::

      show text "Hello, World" at truecenter
      with dissolve
      pause 1
      hide text
      with dissolve

  你可以使用ParameterizedText函数，采用不同的样式特性，直接定义出一些类似的图片。举例，我们可以这样写：

  ::

      image top_text = ParameterizedText(xalign=0.5, yalign=0.0)

.. function:: Text(text, slow=None, scope=None, substitute=None, slow_done=None, **properties)

  创建一个可视组件，在界面上显示文本。

  `text`
    在界面上显示的文本内容。该参数可以是一个字符串，或者一个字符串和可视组件的列表。

  `slow`
    决定文本是否缓慢显示，即在界面上逐个显示出每个字符。若为None，缓慢文本模式取决于slow_cps样式特性。否则，是否启用缓慢文本模式由此处参数slow决定。

  `scope`
    若不为None，该值应该是一个字典型数值，提供了额外的视角(scope)供文本插入(interpolation)的使用。

  `substitute`
    若该值为真(true)，则应用文本插入(interpolation)。若该值为假(false)，不应用文本插入。若该值为None，由config.new_substitutions控制文本插入表现。

.. _text-utility-functions:

文本功用函数
======================

.. function:: renpy.filter_text_tags(s, allow=None, deny=None)

  返回入参s的一个拷贝，其是文本标签过滤后的结果。allow和deny关键词参数至少需要给出1个。

  `allow`
    允许通过的标签的集。如果某个标签不在该列表中，将会被移除。

  `deny`
    禁止通过的标签的集。如果某个标签不在该列表中，将会保留在字符串中。

.. _slow-text-concerns:

慢速文本的顾虑
==================

Ren'Py允许创作者或者用于指示某些文本以慢速显示。这种情况下，Ren'Py会将文本渲染至某个纹理(texture)，然后将纹理的矩形区域绘制到界面上。

不幸的是，这意味着字符间的重叠区域会被渲染成工件(artifact)。为了尽可能减少这种渲染工件(artifact)，需要尽可能保证 :propref:`line_leading` 和
:propref:`line_spacing` 值足够大，各行之间没有覆盖的区域。如果首行缩进文本，特别是line_spacing为负值的情况，我们需要考虑增大
:propref:`line_overlap_split` 的值。

水平工件(artifact)也可能由于字偶距原因而挤在一起，不过这不是什么严重的问题，毕竟相邻字符之间显示的时间差不过1帧而已。

对于静态文本来说工件(artifact)不是什么问题，比如菜单等用户界面部分。

.. _text-overflow-logging:

文本溢出日志
---------------------

Ren'Py可以记录文本溢出所在区域的日志。要启用文本溢出日志功能的话，需要经过以下步骤：

1. 将 :var:`config.debug_text_overflow` 配置项设为true。
2. 设置 :propref:`xmaximum` 和 :propref:`ymaximum` 样式特性，该样式特性配置在文本组件上，或者包含文本组件的容器上。
3. 运行游戏。

一旦文本显示溢出了可用区域，Ren'Py就会把错误记录在 ``text_overflow.txt`` 文件中。
