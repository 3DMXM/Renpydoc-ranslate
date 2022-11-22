.. _atl:

=====================================
动画和变换语言
=====================================

动画和变换语言(简称ATL)提供了一种高级方式实现可视组件的展示、界面布置、应用各种变换(比如旋转、alpha遮罩)等。ATL语言可以根据时间变化实现那些效果，也可以对事件类消息做出响应。

在Python中，与ATL变换等效的是 :func:`Transform`
类组件。目前没有办法通过编程创建一个ATL变换效果。

.. _ren-py-script-statements:

Ren'Py脚本语句
========================

ATL可以包含在Ren'Py脚本语句中。

.. _transform-statement:

transform语句
-------------------

``transform`` 语句创建了一个变换(transform)效果，可以在某个at分句中使用。transform语句的语法如下：

.. productionlist:: script
    atl_transform : "transform" `name` "(" `parameters` ")" ":"
                  :    `atl_block`

transform语句必须在初始化时运行。如果在 ``init`` 语句块(block)之外发现transform语句，其会被自动放入一个 ``init`` 语句块中并设置其优先级为0。定义的transform可能需要一些参数，被调用时必须提供。

`name` 必须是一个Python标识符。使用ATL创建出的transform与 *name* 绑定。::

   transform left_to_right:
       xalign 0.0
       linear 2.0 xalign 1.0
       repeat

.. _atl-image-statement:

带ATL语句块的image语句
------------------------------

使用ATL的另一种方法是，在 ``image`` 语句中包含ATL语句块。这将某个图像与给定的transform绑定。由于没有办法向该transform传入参数，所以只在transform自身定义了某个动画的情况下才有用。带ATL语句块的image语句语法如下：

.. productionlist:: script
    atl_image : "image" `image_name` ":"
              :    `atl_block`

::

    image eileen animated:
        "eileen_happy.png"
        pause 1.0
        "eileen_vhappy.png"
        pause 1.0
        repeat

.. _scene-and-show-statements-with-atl-block:

带ATL语句块的scene和show语句
----------------------------------------

最后一种使用ATL的方法是，包含在 ``scene`` 或者 ``show`` 语句中。这种方法可以通过ATL变换扭曲图像。

.. productionlist:: script
    atl_scene : `stmt_scene` ":"
              :     `atl_block`
    atl_show  : `stmt_show` ":"
              :     `atl_block`


::

    scene bg washington:
        zoom 2.0

    show eileen happy:
        xalign 1.0

.. _atl-syntax-and-semantics:

ATL语法和语义
========================

一个ATL语句块(block)由一个或多个逻辑行组成，使用相同的缩进量。每个ATL语句块中的逻辑行都必须包含一条或多条ATL语句。

总共有两种ATL语句：简单ATL语句和复杂ATL语句。简单语句不使用ATL语句块。单条逻辑行就可能包含一条或多条ATL语句，使用英文逗号分隔。复杂语句会包含语句块(block)。复杂语句的第一行会以英文冒号( ``":"`` )结尾：

默认情况下，语句块(block)里会从第一条语句开始顺序执行所有语句。当整个语句块达到结尾时执行就会被终止。time语句会改变这种执行逻辑，详见后面的段落。

当语句块(block)中所有语句都终止时，语句块的执行也就被终止了。

如果ATL语句需要某个表达式赋值，只能在transform初次加入场景列表时进行赋值。(比如使用 ``show`` 语句或者 ``ui`` 的函数时。)

.. _atl-statements:

ATL语句
==============

下面这些都是ATL语句。

.. _interpolation-statement:

interpolation语句
-----------------------

interpolation语句语句是ATL控制变换的主要方式。

.. productionlist:: atl
    atl_interp : ( `warper` `simple_expression` | "warp" `simple_expression` `simple_expression` )?
               : ( `property` `simple_expression` ( "knot" `simple_expression` )*
               : | "clockwise"
               : | "counterclockwise"
               : | "circles" simple_expression
               : | simple_expression )*

interpolation语句的第一部分用于选择使用的time-warp函数。(即，将线性时间转为非线性时间。)可以使用在ATL注册的warp类函数名，或者使用关键词“warp”开头的某个表达式代表的函数。无论使用的是哪种函数，后面跟着的数字表示整个interpolation过程消耗的时间，单位为秒。

如果没有给定warp类函数，interpolation过程会瞬间完成。否则就会持续给定的那段时间，至少一帧。

时间warp和范围值常用于计算完成的进度。这个进度通过各项interpolation占据整个interpolation语句的总进度来计算。每个interpolation执行前，先取进度值。warp类返回的结果就是完成进度。

interpolation语句可以包含一些其他分句。若出现了特性(property)和对应的值，在interpolation结尾，特性(property)就能获得那个值。该值的获得可以通过以下几种方式：

* 如果那个值后面跟着一个或者两个节点，就使用样条(spline)运动。整个interpolation开头的特性值就是起点，上文提到的特性值就是终点，连接符用于控制样条(spline)。(译者注：在CAD和CG中，样条spline通常是指分段定义的多项式参数曲线。)

* 如果interpolation语句包含一个“clockwise”或者“counterclockwise”分句，就使用圆周(circular)运动，后面会解释这点。

* 除了以上两种情况，根据完成度均分，并将对应的值interpolate插入到起点与终点之间。

如果出现的是简单表达式，其可以简化为一个变换(transform)，这个变换是一个最简单的interpolate语句，不包含warp、spline或者circular行为。变换(transform)中的各项特性(property)会如同直接包含在interpolation语句中一般被处理。

一些interpolation语句样例如下：

::

    show logo base:
         # 在界面的右上角显示logo。
         xalign 1.0 yalign 0.0

         # 将某物平移到左端，耗时1.0秒。
         linear 1.0 xalign 0.0

         # 将某物移动至正中央(truecenter)，耗时1秒。使用ease的warp效果实现。
         ease 1.0 truecenter

         # 暂停1秒。
         pause 1.0

         # 设置旋转圆心
         alignaround (.5, .5)

         # 使用circular运动带着我们旋转并从界面顶端离开。
         # 耗时2秒钟。
         linear 2.0 yalign 0.0 clockwise circles 3

         # 使用spline运动环绕界面移动。
         linear 2.0 align (0.5, 1.0) knot (0.0, .33) knot (1.0, .66)

一种重要的特殊情况是暂停warper，pause后面只跟一个时间值，触发ATL暂停对应的时间。

有些特性(property)可以使用多种类型的值。例如，xpos特性可以是int、float或者absolute类型。如果某个interpolation特性的新旧两个值是不同的数据类型，具体表现是未定义的。

.. _time-statement:

time语句
--------------

``time`` 语句是一种简单控制语句。其包含一个简单表达式，可以简化为一个给定的时间，单位为秒。这个给定的时间表示其所在语句块(block)的执行总时长。

.. productionlist:: atl
    atl_time : "time" `simple_expression`

当time语句中给定的“time”结束后，后面的语句才会开始执行。在上一个语句还在执行的情况下，这种控制转换依然会执行，也能强行终止任意优先级的语句。

time语句也暗示了可以放在pause语句前面，就可以实现暂停无限长时间。这表示如果主控流程不能抵达time语句处，它就会保持等待直到time语句获取流程控制权。

当一个语句块(block)中存在多个time语句时，它们会严格按顺序叠加。

::

    image backgrounds:
        "bg band"
        time 2.0
        "bg whitehouse"
        time 4.0
        "bg washington"


.. _expression-statement:

表达式语句
--------------------

表达式语句是一种以简单表达式开头的简单语句。可能会带一个分句，是另一个简单表达式。

.. productionlist:: atl
    atl_expression :  `simple_expression` ("with" `simple_expression`)?

第一个简单表达式可能等效的东西有三种：

* 如果是一个变换(transform)，该变换会被执行。with分句会被忽略。

* 如果是一个整数或者浮点数，会执行对应时间(单位为秒)的暂停。

* 以上都不是的话，表达式会被看作一个可视组件。当分句执行时，该组件替换变换(transform)的子组件，使其可以用作动画。如果出现了with分句，第二个表达式会被认为一个转场(transition)，并应用于新旧可视组件的替换表现。

::

    image atl example:
         # 显示logo_base.png
         "logo_base.png"

         # 暂停1.0秒
         1.0

         # 使用溶解效果显示logo_bw.png
         "logo_bw.png" with Dissolve(0.5, alpha=True)

         # 运行名为move_right的tranform.
         move_right

.. _pass-statement:

pass语句
--------------

.. productionlist:: atl
    atl_pass : "pass"

``pass`` 语句是一个简单语句，不会触发任何效果。pass语句可以用于分隔其他语句。比如出现两套choice语句的时候，如果不用pass语句，选项会混在一起。

.. _repeat-statement:

repeat语句
----------------


``repeat`` 语句是一种简单语句，包含它的语句块(block)会从开头重新执行。如果repeat中出现了一个表达式，该表达式可以计算出一个整数。这个整数就是整个语句块(block)重复执行的次数。(“repeat 2”表示语句块最多会执行2次。)

.. productionlist:: atl
    atl_repeat : "repeat" (`simple_expression`)?

repeat语句必须是一个语句块(block)的最后一个语句：

::

    show logo base:
        xalign 0.0
        linear 1.0 xalign 1.0
        linear 1.0 xalign 0.0
        repeat


.. _block-statement:

block语句
---------------

``block`` 语句是一种复杂语句，包含了ATL语句块(block)。block语句用于对需要重复运行的语句分组。

.. productionlist:: atl
    atl_block_stmt : "block" ":"
                   :      `atl_block`

::

    label logo base:
        alpha 0.0 xalign 0.0 yalign 0.0
        linear 1.0 alpha 1.0

        block:
            linear 1.0 xalign 1.0
            linear 1.0 xalign 0.0
            repeat

.. _choice-statement:

choice语句
----------------

``choice`` 语句是一种复杂语句，其定义了一个所有可选项的集合。Ren'Py会选取集合中的某一个选项，执行与该选项相关的ATL语句块(block)，之后跳转到choice语句块结束处。

.. productionlist:: atl
   atl_choice : "choice" (`simple_expression`)? ":"
              :     `atl_block`

choice语句会将语句块(block)中连续出现的多个choice选项都放入一个选项集之中。如果选项后面出现一个简单表达式，这个表达式的值应该是一个浮点数，表示对应选项的权重；如果没有权重表达式，默认值为1.0。

::

    image eileen random:
        choice:
            "eileen happy"
        choice:
            "eileen vhappy"
        choice:
            "eileen concerned"

        pause 1.0
        repeat

.. _parallel-statement:

parallel语句
------------------

``parallel`` 语句用于定义一个可以并行执行的ATL语句块的集。

.. productionlist:: atl
    atl_parallel : "parallel" ":"
                 :    `atl_block`

parallel语句会将语句块(block)中连续出现的多个parallel项都放入一个并行集之中。当整个语句块中所有语句都执行完后，parallel语句才会终止。

语句块中的所有并行语句都应各自独立，并使用不同的特性(property)参数。当两个并行分支修改了同一项特性(property)，会产生无法预料的结果。

::

    show logo base:
        parallel:
            xalign 0.0
            linear 1.3 xalign 1.0
            linear 1.3 xalign 0.0
            repeat
        parallel:
            yalign 0.0
            linear 1.6 yalign 1.0
            linear 1.6 yalign 0.0
            repeat

.. _event-statement:

event语句
---------------

``event`` 语句是一个简单语句，其会使用给定的名称触发一个事件(event)。

.. productionlist:: atl
    atl_event : "event" `name`

当在某个语句块(block)运行过程中出现某个事件(event)时，语句块会检查自身是否存在对应事件名的处理器(handler)。如果处理器存在，主控流程会切换到对应的事件处理器。否则，事件会广播至所有事件处理器。

.. _on-statement:

on语句
------------

``on`` 语句是一种复杂语句，其定义事件处理器(handler)。on语句会将语句块(block)中连续出现的多个on项都放入一个事件集之中。on语句可以只处理某一个事件名，或者使用逗号分隔的事件名列表。

.. productionlist:: atl
   atl_on : "on" `name` [ "," `name` ] * ":"
          :      `atl_block`

on语句用于处理各种事件(event)。当某个事件被处理后，其他的事件处理就会停止，并且会立即进入新事件的处理流程。当某个事件处理器没有新的待处理事件，就会产生 ``default`` 事件(已经处理 ``default`` 事件的情况除外)。

on语句的执行不会自然终止。(但是其可以被time语句，或者关联的事件处理器终止。)

::

    show logo base:
        on show:
            alpha 0.0
            linear .5 alpha 1.0
        on hide:
            linear .5 alpha 0.0

    transform pulse_button:
        on hover, idle:
            linear .25 zoom 1.25
            linear .25 zoom 1.0

.. _contains-statement:

contains语句
------------------

``contains`` 语句将可视组件安置在ATL的transform中。(作为transform的子组件。)总共有两类contains语句的变种。

contains表达式变种使用某个表达式，将表达式设为transform的子组件。当希望ATL的transform容纳而不是引用另一个ATL的transform时，这个变种就会有用。

.. productionlist:: atl
    atl_contains : "contains" `expression`

::

    transform an_animation:
        "1.png"
        pause 2
        "2.png"
        pause 2
        repeat

    image move_an_animation:
        contains an_animation

        # 如果我们不使用contains语句，
        # 就会一直处于循环中并不能抵达这里
        xalign 0.0
        linear 1.0 yalign 1.0


contains语句块(block)允许我们定义一个ATL语句块(block)用作ATL transform的子组件。一个或多个contains语句块(block)会被组合，在 :func:`Fixed` 函数中扭曲(warp)，并设置为该transform的子组件。

.. productionlist:: atl
    atl_counts : "contains" ":"
         `atl_block`

每个语句块都应该定义一个使用的可视组件，或者可能发生的错误。contains语句的执行是即时的，不会等待子组件的完成。contains语句可以说是语法糖，使我们很容易将参数传给它的子组件。
(译者注：语法糖(Syntactic Sugar)，也称作糖衣语法。由英国计算机科学家彼得·约翰·兰达(Peter J. Landin)发明。指计算机语言中添加的某种语法，对语言的功能并没有影响，能更方便程序员使用。通常来说使用语法糖能够增加程序的可读性，从而减少程序代码出错的机会。)

::

    image test double:
        contains:
            "logo.png"
            xalign 0.0
            linear 1.0 xalign 1.0
            repeat

        contains:
            "logo.png"
            xalign 1.0
            linear 1.0 xalign 0.0
            repeat

.. _function-statement:

function语句
------------------

``function`` 语句允许ATL使用Python函数控制ATL特性(property)。

.. productionlist:: atl
    atl_function : "function" `expression`

这些函数与 :func:`Transform` 具有相同的识别标志：

* 第一个入参是一个transform对象。transform特性可以通过该对象进行设定。

* 第二个入参是显示时间轴，表示函数开始执行到现在经过的秒数。

* 第三个入参是动画时间轴，表示具有相同标签(tag)的某物在整个界面上已存在的秒数。

* 如果函数返回一个数值，其会在数值对应的时间(秒)后再次被调用。(0秒表示尽可能快地调用该函数。)如果函数返回空值(None)，主控流程会跳到下一个ATL语句。

除了修改第一个入参中的Transform对象之外，该函数不应该包含其他作用。
在可以在任意时间传入任意值，以启用预加载。

::

    init python:
        def slide_function(trans, st, at):
            if st > 1.0:
                trans.xalign = 1.0
                return None
            else:
                trans.xalign = st
                return 0

    label start:
        show logo base:
            function slide_function
            pause 1.0
            repeat

.. _animation-statement:

animation语句
-------------------

使用 ``animation`` 语句时，必须将其放在整个ATL语句块的开头，告诉Ren'Py该语句将使用动画时间轴。

.. productionlist:: atl
    atl_animation : "animation"

与普通的现实时间轴相比，在带有相同标签(tag)的图像(image)或界面(screen)开始显示的那一刻，animation时间轴就将进行计时并被所有相同标签(tag)的图像和界面共享。
animation时间轴常用于动画过程中的图像替换。例如：

::

    image eileen happy moving:
        animation
        "eileen happy"
        xalign 0.0
        linear 5.0 xalign 1.0
        repeat

    image eileen vhappy moving:
        animation
        "eileen vhappy"
        xalign 0.0
        linear 5.0 xalign 1.0
        repeat

    label start:

        show eileen happy moving
        pause
        show eileen vhappy moving
        pause

这个例子中，艾琳的立绘表情将在第一个 pause 语句处改变，但她的位置不会改变。
因为两个动画使用相同的animation时间轴，避免了更换立绘后出现图像位置不连续。
不使用 animation 语句的话，用户通过点击鼠标或屏幕后，角色的立绘位置将发生一次重置。

.. _warpers:

warpers
=======

warper是一类函数，其可以改变interpolation语句中定义的时间值。以下warper都是默认定义的。他们将时间t转换为t'，t和t'都是浮点数，t会将给定的时间值标准化为0.0到1.0。(如果该语句给定的原时长是0，那运行时t就是1.0。)t'的初始取值范围也是0.0到1.0，不过可以超出这个范围。

``pause``
    暂停，然后跳转到新值。如果t等于1.0，则t'等于1.0；否则t'等于0.0。

``linear``
    线性插值。t' = t

``ease``
    开头慢，中间加速，之后又减速。t' = .5 - math.cos(math.pi * t) / 2.0

``easein``
    开头快，然后减速。t' = math.cos((1.0 - t) * math.pi / 2.0

``easeout``
    开头慢，然后加速。t' = 1.0 - math.cos(t * math.pi / 2.0)

除此之外，Robert Penner的easing函数都是支持的。为了避免与上面的几个函数名重复，有些函数名字修改过。这些标准函数的图像可以在这个网站上查看 http://www.easings.net/

===============     ===================
Ren'Py中函数名      easings.net中函数名
===============     ===================
ease_back           easeInOut_back
ease_bounce         easeInOut_bounce
ease_circ           easeInOut_circ
ease_cubic          easeInOut_cubic
ease_elastic        easeInOut_elastic
ease_expo           easeInOut_expo
ease_quad           easeInOut_quad
ease_quart          easeInOut_quart
ease_quint          easeInOut_quint
easein_back         easeOut_back
easein_bounce       easeOut_bounce
easein_circ         easeOut_circ
easein_cubic        easeOut_cubic
easein_elastic      easeOut_elastic
easein_expo         easeOut_expo
easein_quad         easeOut_quad
easein_quart        easeOut_quart
easein_quint        easeOut_quint
easeout_back        easeIn_back
easeout_bounce      easeIn_bounce
easeout_circ        easeIn_circ
easeout_cubic       easeIn_cubic
easeout_elastic     easeIn_elastic
easeout_expo        easeIn_expo
easeout_quad        easeIn_quad
easeout_quart       easeIn_quart
easeout_quint       easeIn_quint
===============     ===================

我们可以在一个 ``python early`` 语句块中，使用 ``renpy.atl_warper`` 构造器定义新的warper函数。定义warper函数文件需要在使用那个函数的其他任何文件之前被处理。定义的代码如下：

::

    python early hide:

        @renpy.atl_warper
        def linear(t):
            return t

.. _transform-properties:

transform特性列表
============================

transform存在以下特性(property)：

当给定的数据类型当作一个坐标时，其可能是一个整型、 ``absolute`` 类型或者浮点型。如果是一个浮点型，其可以用作某块区域(用作坐标 :propref:`pos` )或者可视组件(用作锚点 :propref:`anchor` )的比例数值。

需要注意的是，并非所有特性都是完全独立的。例如， :propref:`xalign` 和 :propref:`xpos` 都会更新同一批底层数据。在parallel语句中，只有一个语句块(block)能调整水平坐标，而另一个语句块只能调整垂直坐标。(这些可能都是在同一个语句块中。)angle和radius特性同时设置水平和垂直坐标。

.. transform-property:: pos

    :type: (position, position)
    :default: (0, 0)

    相对坐标，以整个区域左上角为原点。

.. transform-property:: xpos

    :type: position
    :default: 0

    水平坐标，以整个区域的左边为坐标零点。

.. transform-property:: ypos

    :type: position
    :default: 0

    垂直坐标，以整个区域的顶边为坐标零点。

.. transform-property:: anchor

    :type: (position, position)
    :default: (0, 0)

    锚点坐标，以可视组件左上角为原点。

.. transform-property:: xanchor

    :type: position
    :default: 0

    锚点的水平坐标，以可视组件左边为坐标零点。

.. transform-property:: yanchor

    :type: position
    :default: 0

    锚点的垂直位置，以可视组件顶边为坐标零点。

.. transform-property:: align

    :type: (float, float)
    :default: (0.0, 0.0)

    将pos和anchor设置为相同的值。

.. transform-property:: xalign

    :type: float
    :default: 0.0

    将xpos和xanchor设置为相同的值。

.. transform-property:: yalign

    :type: float
    :default: 0.0

    将ypos和yanchor设置为相同的值。

.. transform-property:: xoffset

    :type: float
    :default: 0.0

    可视组件在水平方向偏离的像素数。向右偏离时是正数。

.. transform-property:: yoffset

    :type: float
    :default: 0.0

    可视组件在垂直方向偏离的像素数。向下偏离时是正数。

.. transform-property:: xcenter

    :type: float
    :default: 0.0

    将xpos设置为指定的特性值(整个区域xpos最大值的一半)，将xanchor设置为0.5。

.. transform-property:: ycenter

    :type: float
    :default: 0.0

    将ypos设置为指定的特性值(整个区域ypos最大值的一半)，将yanchor设置为0.5。

.. transform-property:: rotate

    :type: float 或 None
    :default: None

    若值为None，不会进行旋转。否则，图像会按指定的角度顺时针旋转。根据下面会提到的rotate_pad的配置值，旋转可视组件会导致组件尺寸改变。xanchor和yanchor不为0.5的情况下，旋转整个可视组件会让组件相对整个界面的坐标发生变化。

.. transform-property:: rotate_pad

    :type: boolean
    :default: True

    若该值为True，一个可以旋转的可视组件就会使用原本的宽度和高度填充旋转矩形，并确保旋转时不会改变组件的尺寸。若该值为False，transform会给定某个能应用于可视组件的最小尺寸，更适合用于自动匹配的旋转。

.. transform-property:: transform_anchor

   :type: boolean
   :default: False

   若该值为True，锚点会定位在关联的子组件上，当子组件发生变换时拉伸并旋转。实际效果是，当子组件拉伸或旋转时，这项值可以指定子组件以指定的锚点拉伸或旋转。

.. transform-property:: zoom

    :type: float
    :default: 1.0

    该值根据系数对可视组件进行缩放。

.. transform-property:: xzoom

    :type: float
    :default: 1.0

    该值根据系数对可视组件在水平方向进行缩放。负值可以让图像水平翻转(即与原图像互为左右镜像)。

.. transform-property:: yzoom

   :type: float
   :default: 1.0

   该值根据系数对可视组件在垂直方向进行缩放。负值可以让图像垂直翻转(即与原图像互为上下镜像)。

.. transform-property:: nearest

    :type: boolean
    :default: None

    若该值为True，可视组件及其子组件会使用近邻取样(nearest-neighbor)过滤绘制。若该值为False，可视组件及其子组件使用双线性(bilinear)过滤绘制。若该值为None，绘制方式从父组件继承，或者采用 :var:`config.nearest_neighbor` 配置(默认值是false)。

.. transform-property:: alpha

    :type: float
    :default: 1.0

    该值控制可视组件的透明度。

    alpha变换(transform)会分别作用于每个图像所包含的子组件。在子组件存在重叠部门的情况，这可能会导致一些不期望出现的结果，比如透过衣服看到角色之类的。
    :func:`Flatten` 类可视组件可以解决这些问题。

.. transform-property:: additive

    :type: float
    :default: 0.0

    该值控制Ren'Py加性混合后的表现效果。该值为1.0时，Ren'Py使用ADD操作器(operator)绘制；该值为0.0时，Ren'Py使用OVER操作器(operator)绘制。

    加性混合会分别作用于transform的每一个子组件。

    完全的加性混合不会改变目标图像的alpha通道值，并且添加上去的图像可能不是可见的，前提是那些图像没有直接绘制在某个不透明的表面上。(某些复杂的操作，像 :func:`Flatten`， :func:`Frame` 和某些转场，使用加性混合可能会出现问题。)

    .. warning::

        加性混合只被基于硬件的渲染器支持，比如OpenGL和DirectX/ANGLE渲染器。软件渲染器无法正确绘制加性图像。

        图形系统启动后，如果加性混合可以被支持的话 ``renpy.get_renderer_info()["additive"]``
        的值会是true。


.. transform-property:: around

    :type: (position, position)
    :default: (0.0, 0.0)

    若该值非None，则指定了极坐标系的中心点坐标值，以整个区域的左上角为原点。在position模式下，设置的中心点可用于圆周运动。

.. transform-property:: alignaround

    :type: (float, float)
    :default: (0.0, 0.0)

    若该值非None，则指定了极坐标系的中心点坐标值，以整个区域的左上角为原点。在align模式下，设置的中心点可用于圆周运动。

.. transform-property:: angle

    :type: float

    获取极坐标系中角度的值。极坐标中心未设置的情况下不能获取。

.. transform-property:: radius

    :type: position

    获取极坐标系中半径的值。极坐标中心未设置的情况下不能获取。

.. transform-property:: crop

    :type: None 或 (int, int, int, int) 或 (float, float, float, float)
    :default: None

    若该值非None，会使用给定的矩形剪裁可视组件。指定的矩形是一个(x, y, width, height)形式的元组。如果 ``crop_relative`` 为True并且元组内元素的值是浮点数(float)，width和height用作比例值，与原图像的宽和高分别相乘输出结果。否则，数值代表像素数。

    如果各种corner特性与crop特性同时出现，crop的优先级高于各种corner特性。

.. transform-property:: crop_relative

    :type: boolean
    :default: False

    如果crop_relative为True，crop元组里的width和height用作分数，与原图像的宽和高分别相乘输出结果。

.. transform-property:: corner1

    :type: None 或 (int, int)
    :default: None

    若该值非None，给定了剪裁框的左上角坐标。crop优先级高于该项。

.. transform-property:: corner2

    :type: None 或 (int, int)
    :default: None

    若该值非None，给定了剪裁框的右下角坐标。crop优先级高于该项。

.. transform-property:: xysize

    :type: None 或 (position, position)
    :default: None

    若该值非None，将可视组件伸缩至给定的尺寸。

.. transform-property:: xsize

    :type: None 或 position
    :default: None

    若该值非None，可是组件会按照给定的宽度缩放。

    该值受到 :tpref:`fit` 影响。

.. transform-property:: ysize

    :type: None 或 position
    :default: None

    若该值非None，可是组件会按照给定的高度缩放。

    该值受到 :tpref:`fit` 影响。

.. transform-property:: fit

    :type: None 或 string
    :default: None

    若该值非None，会按下面表格的方式调整尺寸。表格中的“维度”视 ``xsize`` 和 ``ysize`` 不为空的情况而定。
   

    .. list-table::
       :widths: 15 85
       :header-rows: 1

       * - 值
         - 描述
       * - ``contain``
         - 在不超过任何维度尺寸的原则下近可能大。保持宽高比。
       * - ``cover``
         - 在不超过任何维持尺寸的原则下尽可能小。保持宽高比。
       * - None 或 ``fill``
         - 将可视组件拉伸/挤压，以匹配各维度指定大小。 
       * - ``scale-down``
         - 类似 ``contain``，但不会增加可视组件的尺寸。
       * - ``scale-up``
         - 类似 ``cover``，但不会增加可视组件的尺寸。

.. transform-property:: size

    :type: None 或 (int, int)
    :default: None

    若该值非None，将可视组件伸缩至给定的尺寸。

.. transform-property:: maxsize

    :type: None 或 (int, int)
    :default: None

    若该值非None，可以使可视组件在box当中以合适的尺寸放大或缩小显示，同时保持横纵比。（请注意，这意味着长或宽其中一个尺寸可能小于此box的尺寸。）

.. transform-property:: subpixel

    :type: boolean
    :default: False

    若该值为True，使用子像素(subpixel)坐标系统在界面上放置子物体。

    子像素(subpixel)位置会对绘入像素的色彩(包括不透明度)产生影响，但不会对像素原来的色彩产生影响。
    当子像素位置与运动图像一起出现时(常见情况)，图像应该在运动方向保留一点透明的边。

    举例来说，如果某个角色精灵(sprite)会水平移动，最好在左右两侧遇到透明的边界。
    避免出现角色边缘与背景颜色发生混合的问题。

.. transform-property:: delay

    :type: float
    :default: 0.0

    如果某个变换(transform)如同转场(transition)般使用，这个值定义了转场时间。

.. transform-property:: events

    :type: boolean
    :default: True

    若该值为True，事件消息会传给变换(transform)的子组件。若该值为False，事件消息会被屏蔽。(这个机制可以用在ATL变换中，放置事件消息达到某些old_widget。)

.. transform-property:: xpan

    :type: None 或 float
    :default: None

    若该值非None，其被解释为某个360度全景图中的经度。图像中央是0度，图像左端和右端分别是-180度和180度。

.. transform-property:: ypan

    :type: None 或 float
    :default: None

    若该值非None，其被解释为某个360度全景图中的纬度。图像中央是0度，图像顶部和底部分别是-180度和180度。

.. transform-property:: xtile

    :type: int
    :default: 1

    图像水平方向使用tile方式码放图像的次数。(如果给定了xpan的值则忽略本项。)

.. transform-property:: ytile

    :type: int
    :default: 1

    图像垂直方向使用tile方式码放图像的次数。(如果给定了ypan的值则忽略本项。)

.. transform-property:: matrixcolor

    :type: None 或 矩阵 或 MatrixColor对象
    :default: None

    若该值非None，该特性值用于将此变换下的所有子组件上色。详见 :ref:`matrixcolor` 。

.. transform-property:: blur

    :type: None 或 float
    :default: None

    使用 `blur` 像素数模糊图像的子组件， `blur` 数值不超过可视组件的边长。
    Ren'Py不同版本的模糊细节可能存在差异。模糊的结果可能存在瑕疵，尤其是模糊数值不断发生修改的情况下。

    使用该特性的前提是启用基于模型的渲染器，将 :var:`config.gl2` 设置为True。

此外，其他几组变换特性可以在文档其他地方找到：

3D舞台特性：
    :tpref:`perspective`、 :tpref:`matrixanchor`、 :tpref:`matrixtransform`、 :tpref:`zpos`、 :tpref:`zzoom`

基于模型渲染特性：
    :tpref:`blend`、 :tpref:`mesh`、 :tpref:`mesh_pad`、 :tpref:`shader`

GL特性：
    :ref:`GL特性 <gl-properties>`

uniforms：
    以 ``u_`` 开头的特性可以用于 :ref:`自定义着色器 <custom-shaders>` 中的uniform变量。

这些特性按照以下顺序应用：

#. tile
#. mesh, blur
#. crop, corner1, corner2
#. size, maxsize
#. zoom, xzoom, yzoom
#. pan
#. rotate
#. zpos
#. matrixtransform, matrixanchor
#. zzoom
#. perspective
#. nearest, blend, alpha, additive, shader.
#. matrixcolor
#. GL Properties, Uniforms
#. position properties

.. _circular-motion:

圆周运动
===============

当某个interpolation语句汇总包含关键词 ``clockwise`` 或 ``counterclockwise`` ，这个语句就会触发圆周运动。Ren'Py会比较起始坐标点并找出极坐标中心。Ren'Py接着会计算运动角度。如果还出现了circles分句，Ren'Py会确保旋转对应的圈数。

Ren'Py会合理运用angle和radius特性，触发圆周运动。如果transform处于align模式，设置angle和radius同时也会设置align特性。否则，就会设置pos特性。

.. _external-events:

外部事件消息
===============

下列事件是自动触发的：

``start``
    一种伪事件，进入 ``on`` 语句时触发，前提是没有更高优先级的事件出现。

``show``
    使用 ``show`` 或者 ``scene`` 语句显示transform，并且给定标签(tag)没有对应已显示的图像时触发。

``replace``
    使用 ``show`` 语句中的transform根据给定标签(tag)替换某个图像时触发。

``hide``
    使用 ``hide`` 语句或等效的python语句中的transform时触发。

    需要注意的是，transform被scene语句清除，或者退出其所在的上下文(比如退出游戏菜单)时，hide事件是不会触发的。

``replaced``
    transform被另一个transform替换时触发。原transform的图像实际上并不会隐藏或移除，直到整个ATL语句块(block)执行完。

``update``
    目前正在显示的界面发生更新，并且不是被另一个界面替换的情况时触发。随着这种情况很罕见却确实会出现，比如游戏加载资源时或者风格或者语言切换时。

``hover``, ``idle``, ``selected_hover``, ``selected_idle``
   当包含此transform的按钮或者被此transform包含的按钮，出现对应的状态名称时触发。
