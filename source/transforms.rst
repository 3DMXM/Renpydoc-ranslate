.. _transforms:

==========
变换
==========

变换(transform)可以按顺序依次使用，将一个 :doc:`可视组件 <displayables>` 变为另一个可视组件。
总共有多种类型的变换，也有多种方式创建变换。
内建的变换常用于控制界面上某个对象的位置，而用户自定义的变换可以触发更复杂的效果，比如移动、缩放和旋转，甚至复杂的色彩效果。

在scene和 :ref:`show <show-statement>` 语句后使用at分句就能应用各种变换。
下面样例中对图像 ``eileen happy`` 应用了 ``right`` 变换。::

    show eileen happy at right

可以同时应用多个变换，不同变换之间用英文逗号分隔。这些变换从左到右依次应用。

::

    show eileen happy at halfsize, right

.. 每个可视组件总是有一个相关联的变换(transform)。如果没有指定变换(transform)，将使用主(prior)变换。修改变换(transform)时，未定义的值会直接使用主变换的对应值，或者如果没有主变换的话从 `default` 配置获取。

.. _applying-transforms-to-displayables-in-python:

在Python中对可视组件应用变换
=============================

若要在Python中对可视组件 ``d`` 引用变换 ``t`` 有好几种方法：

#. 最为通用也最推荐的方法是，使用 ``At(d, t)`` (下面有样例)。这种方法适用于所有变换。

#. ``d(child=t)`` 适用于所有 :ref:`ATL变换 <atl>`。

#. ``t(d)`` 适用于 :ref:`Python变换 <transforms-python>`，以及不需要坐标作为参数的ATL变换。

.. function:: At(d, *args)

    对指定的源可视组件 `d` ，将 `args` 中所有变换应用于该组件。变换的应用顺序是从左到右，所以最外层的变换效果是最右边的入参。

    ::

        transform birds_transform:
            xpos -200
            linear 10 xpos 800
            pause 20
            repeat

        image birds = At("birds.png", birds_transform)

.. note::
    如果某些变换没有传入需要的参数，变换结果可能会导致无法正常显示。
    这种情况下需要检查使用 :ref:`transform-statement` 定义的变换到底需要什么参数。

.. note::
    变换结果可能还是一个变换，可以进一步应用于另一个可视组件(及其子组件)；
    这种情况下ATL变换依然可以如其他变换一样使用，不影响其子组件。


.. _built-in-transforms:

内建变换
==================

Ren'Py附带了一些默认定义好的变换。这些变换定义了界面上的位置信息。这里有一个默认变换下图像位置的描述：

.. code-block:: none

                 +-----------------------------------------------------------+
                 |topleft, reset               top                   topright|
                 |                                                           |
                 |                                                           |
                 |                                                           |
                 |                                                           |
                 |                          truecenter                       |
                 |                                                           |
                 |                                                           |
                 |                                                           |
                 |                                                           |
    offscreenleft|left                   center, default                right|offscreenright
                 +-----------------------------------------------------------+

:var:`offscreenleft` 和 :var:`offscreenright` 变换会让图像显示在界面之外。这两个变换可以用于将物体从界面移除(记得之后隐藏这些物体，并确认他们不再消耗系统资源)。

这些变换(transform)的详细信息如下：

.. var:: center

    水平居中，并与界面底部对齐。

.. var:: default

    水平居中，并与界面底部对齐。default可以通过 :var:`config.default_transform` 重定义，这样show和scene语句显示的图片默认位置也会改变

.. var:: left

    与界面左下角对齐。

.. var:: offscreenleft

    将可视组件置于界面左外侧，与界面底部对齐。

.. var:: offscreenright

    将可视组件置于界面右外侧，与界面底部对齐。

.. var:: reset

    重置变换。将可视组件放置在界面左上角，并清除一切缩放、旋转及其他效果。

.. var:: right

    与界面右下角对齐。

.. var:: top

    水平居中，与界面顶部对齐。

.. var:: topleft

    与界面左上角对齐。

.. var:: topright

    与界面右上角对齐。

.. var:: truecenter

    水平和垂直都居中。

.. _atl:

动画和变换语言
================

动画和变换语言(简称ATL)提供了一种高级方式，便于创建动画、界面内移动可视组件、设置组件位置、应用各种变换(等。
ATL语言可以根据时间变化实现效果，也可以根据事件类消息做出响应。

在Python中，与ATL变换等效的是 :func:`Transform`
类组件。目前没有办法通过编程创建一个ATL变换效果。

可以使用 :ref:`transform-statement` 创建ATL变换对象。创建结果可用作可视组件(可能没有能被看到的子组件所以透明)。
ATL变换对象可以使用 :ref:`sl-add` 传入某个界面，或者使用 :ref:`show-expression-statement` 或 :func:`renpy.show` 函数直接显示。

.. _ren-py-script-statements:

Ren'Py脚本语句
----------------

ATL可以包含在Ren'Py脚本语句中。

.. _transform-statement:

transform语句
~~~~~~~~~~~~~~

``transform`` 语句创建了一个变换(transform)效果，可以在某个at分句中使用。transform语句的语法如下：

.. productionlist:: script
    atl_transform : "transform" `qualname` ( "(" `parameters` ")" )? ":"
                  :    `atl_block`

transform语句必须在 :ref:`初始化阶段 <init-phase>` 运行。
定义transform可能需要一个参数列表，使用方式与Python函数类型。
有一些类型参数暂时禁止使用，未来可能会开放：

#. 只有固定位置参数
#. 没有默认值的关键词参数
#. 可变的固定位置参数(``*args``)
#. 可变的关键词参数(``**kwargs``)

只有所有参数都赋值之后，创建的Transfor对象才能用作变换。

*请参考：* :ref:`atl-partial`

`qualname` 必须是一个使用英文标点“.”分割的Python标识符。使用ATL创建的transform与 `qualname` 绑定，
如果存在 :ref:`store <named-stores>` 则保存在对应存储空间中。

::

    transform left_to_right:
        xalign 0.
        linear 2 xalign 1.
        repeat

    transform ariana.left:
        xalign .3

    transform animated_ariana_disp:
        "ariana"
        pause 1.
        "ariana_reverse"
        pause 1.
        repeat

创建出的对象既是变换也是可视组件，但不支持 ``image`` 语句。
因为它以变量(或常量)形式创建，与命名空间 :ref:`images <defining-images>` 中的对象不同。

.. _atl-image-statement:

带ATL语句块的image语句
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


使用ATL的另一种方法是，在 :ref:`images <image-statement>` 语句中包含ATL语句块。这将某个图像与给定的transform绑定。由于没有办法向该transform传入参数，所以只在transform自身定义了某个动画的情况下才有用。
带ATL语句块的image语句语法如下：

.. productionlist:: script
    atl_image : "image" `image_name` ":"
              :    `atl_block`

::

    image animated_ariana_img:
        "ariana"
        pause 1.
        "ariana_reverse"
        pause 1.
        repeat

.. _scene-and-show-statements-with-atl-block:

带ATL语句块的scene和show语句
------------------------------

最后一种使用ATL的方法是，包含在 ``scene`` 或者 :ref:`show <show-statement>` 语句中。这种方法可以通过ATL改变图像。

.. productionlist:: script
    atl_scene : `stmt_scene` ":"
              :     `atl_block`
    atl_show  : `stmt_show` ":"
              :     `atl_block`

::

    show eileen happy:
        xalign 1.

    scene bg washington:
        zoom 2.

.. _atl-syntax-and-semantics:

ATL语法和语义
---------------

ATL语句可能是单行的，也可能是多行组成的语句块(block)。
除了后面会提到的少数例外，ATL语句块中的语句按从上到下的顺序执行。


如果某个ATL语句需要计算某个表达式，那么对应的整个变换首次执行时(例如使用 ``show`` 语句或将该变换显示为某个界面的一部分时)将计算该表达式，
而不是执行某部分ATL语句时才计算。

..

    一个ATL语句块(block)由一个或多个逻辑行组成，使用相同的缩进量。每个ATL语句块中的逻辑行都必须包含一条或多条ATL语句。

    总共有两种ATL语句：简单ATL语句和复杂ATL语句。简单语句不使用ATL语句块。单条逻辑行就可能包含一条或多条ATL语句，使用英文逗号分隔。复杂语句会包含语句块(block)。复杂语句的第一行会以英文冒号( ``":"`` )结尾：

    默认情况下，语句块(block)里会从第一条语句开始顺序执行所有语句。当整个语句块达到结尾时执行就会被终止。time语句会改变这种执行逻辑，详见后面的段落。

    当语句块(block)中所有语句都终止时，语句块的执行也就被终止了。

    如果ATL语句需要某个表达式赋值，只能在transform初次加入场景列表时进行赋值。(比如使用 ``show`` 语句或者某个界面显示展示部分变换时。)

下面列出各种ATL语句。

.. _inline-contains-atl-statement:

单行contains语句
~~~~~~~~~~~~~~~~~~~~~~~~~

单行contains语句可以计算一个简单表达式，并得到一个 :doc:`可视组件 <displayables>` 。

.. productionlist:: atl
    atl_contains : "contains" `expression`

此语句会把当前ATL变换的某个子组件设置(或替换)成表达式计算结果，用作动画。

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

与变换表达式语句相比，:ref:`displayable-atl-statement` 定义更明晰，但其可以使用 
:doc:`transition <transitions>` 来替换子组件。
contains语句适合用在某个ATL语句块中容纳另一个变换效果，而不是单纯复用某个变换的代码块。

.. _number-statement:

数值语句
~~~~~~~~~~~~~~~~

数值语句由一个简单表达式构成，该表达式可以计算出一个整数或一个浮点数。
其是“pause”的一个简略版。

.. productionlist:: atl
    atl_number : "pause"? `simple_expression`

数值语句用于指定一个固定秒数的暂停。

::

    image atl example:
        # 显示logo_base.png。
        contains "logo_base.png"

        # 暂停1.0秒。
        pause 1.0

        # 显示logo_bw.png，使用dissolve转场。
        "logo_bw.png" with Dissolve(0.5, alpha=True)

        # 暂停3秒。
        3

        repeat

.. _properties-statement:

特性值语句
~~~~~~~~~~~~~~~~~~~~

该语句可以将一个或多个变换特性设置为某个新的值。

.. productionlist:: atl
    atl_properties : `atl_property`+

.. productionlist:: atl
    atl_property : `transform_property` `simple_expression`

特性值语句先指定一些特性名称，并对每项特性都设置一个值。
:ref:`transform-properties` 中的变换特性列表详细说明了每个特性的含义及使用的值类型。

::

    transform rightoid:
        xalign .9

    transform ariana.left:
        xanchor .3 xpos 100

.. _interpolation-statement:

插值语句
~~~~~~~~~~

插值语句主要用于获取平滑的动画效果。

.. productionlist:: atl
    atl_interp : ((`warper` `simple_expression`) | ("warp" `simple_expression` `simple_expression`)) (`atl_interp_target`+ | (":"
               :    `atl_interp_target`+ ))

.. productionlist:: atl
    atl_interp_target : (`atl_property`+ ("knot" `simple_expression`)* )
                      : | `atl_transform_expression`
                      : | "clockwise"
                      : | "counterclockwise"
                      : | ("circles" `simple_expression`)

下面是一些插值语句的样例：

::

    show logo base:
        # 在界面右上角显示logo。
        xalign 1.0 yalign 0.0

        # 耗时1秒，将logo移动到最左侧。
        linear 1.0 xalign 0.0

        # 耗时1秒，将logo移动到界面正中心。移动时的使用ease缓动函数。
        ease 1.0 truecenter

        # 设置旋转锚点。
        anchor (0.5, 0.5)

        # 耗时2秒，让logo按顺时针方向做圆周旋转，最终到达界面正上方。
        linear 2.0 yalign 0.0 clockwise circles 3

        # 让logo按照指定样条的路径，在界面中移动。
        linear 2.0 align (0.5, 1.0) knot (0.0, .33) knot (1.0, .66)

        # 同时修改xalign和yalign的值。
        linear 2.0 xalign 1.0 yalign 1.0

        # 与上一步相同，但使用语句块形式。
        linear 2.0:
            xalign 1.0
            yalign 1.0

插值语句的第一部分用于选择time-warp函数。即，将线性时间转为非线性时间，关于warper的信息详见 :ref:`warpers` 。
可以使用在ATL注册的warp类函数名，或者使用关键词“warp”开头的某个表达式代表的函数。
无论使用的是哪种函数，后面跟着的数字表示总体消耗时间，单位为秒。

::

    transform builtin_warper:
        xpos 0
        ease 5 xpos 520

    init python:
        def my_warper(t):
            return t**4.4

    define my_warpers = [my_warper]

    transform accessed_as_function:
        xpos 0
        warp my_warpers[0] 5 xpos 520
        warp my_warper 3 xpos 100

整个插值语句的持续时长由给定的时间决定，至少为1帧。

指定的 :doc:`transform_properties` 会逐渐逼近终值，并在插值语句结尾达到该终值。
具体的细节有以下几种：

* 如果终值后面还跟着一个或多个节点(knot)，表示运动路径是样条。
  初始值和终值分别是样条的起点与终点，knot则是样条的控制节点。
  四次曲线只使用一个knot，贝塞尔曲线使用两个knot，Carmull-Rom曲线则使用三个或更多knot。
  前两种情况中，knot都是单纯的控制节点。
  而Catmull-Rom曲线中，只有首尾两个knot是控制节点(通常不在曲线上)，其他knot则都在曲线路径上。

* 如果插值语句中包含一个“clockwise”或“counterclockwise”从句，表示使用圆周运动。
  Ren'Py处理圆周运动时，首先比较起点与终点位置(通常使用 :tpref:`pos`、:tpref:`align`、:tpref:`angle` 和 :tpref:`radius` 设置)，
  然后找到极坐标原点(通常使用 :tpref:`around` 设置)。接着计算指定方向需要旋转的角度值，单位为度。
  如果出现了“circle”从句，Ren'Py则会加上对应数量的整圈。

* 其他情况下，会对起点和重点的坐标进行线性插值。

如果某个 :ref:`transform-expression-atl-statement` 中只有一条特性(property)语句，也可以进行插值计算。
起始值就是ATL变换中对应特性的值，跟直接设置起点的值效果相同。

warper后面可以跟一个英文冒号(:)。这种情况下，warper后可能会有一个或多个如上阐述的从句。
这样做可以让ATL可以同时对多个特性进行插值。

.. _pass-statement:

pass语句
~~~~~~~~~

.. productionlist:: atl
    atl_pass : "pass"

``pass`` 语句是一个简单语句，不会触发任何效果：一种 no-op 。
pass语句可以用于分隔其他语句。比如出现两套choice语句的时候，如果不用pass语句，选项会混在一起。
pass语句还可以用在一些语法层面需要出现语句块，但创作者只想要空着的地方，比如某些选项语句后面必须写点什么。

(译者注：pass就是脚本中的占位符。空着不写会报错，写个pass就能运行了。)

.. _repeat-statement:

repeat语句
~~~~~~~~~~~

``repeat`` 语句是一种简单语句。脚本执行到repeat时会跳转到包含repeat的语句块的开头，并重新开始执行。

.. productionlist:: atl
    atl_repeat : "repeat" (`simple_expression`)?

如果repeat中出现了一个表达式，该表达式可以计算出一个整数。这个整数就是整个语句块(block)重复执行的次数。
(``repeat 2`` 表示语句块最多会执行2次，``repeat 1`` 则不会有重复执行的效果。)
repeat语句必须是一个语句块(block)的最后一个语句：

::

    show logo base:
        xalign 0.0
        linear 1.0 xalign 1.0
        linear 1.0 xalign 0.0
        repeat
.. _block-statement:

block语句
~~~~~~~~~~~~

``block`` 语句包含ATL语句块(block)。

.. productionlist:: atl
    atl_block_stmt : "block" ":"
                   :      `atl_block`

block语句用于对需要重复运行的语句分组：

::

    label logo base:
        alpha 0.0 xalign 0.0 yalign 0.0
        linear 1.0 alpha 1.0

        block:
            linear 1.0 xalign 1.0
            linear 1.0 xalign 0.0
            repeat

.. _parallel-statement:

parallel语句
~~~~~~~~~~~~~

``parallel`` 语句用于定义一个可以并行执行的ATL语句块的集。

.. productionlist:: atl
    atl_parallel : ("parallel" ":"
                 :    `atl_block`)+

parallel语句会将语句块(block)中连续出现的多个parallel项都放入一个并行集之中。当整个语句块中所有语句都执行完后，parallel语句才会终止。

语句块中的所有并行语句都应各自独立，并使用不同的 :doc:`transform_properties`。当两个并行分支修改了同一项特性(property)，会产生无法预料的结果。

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

.. _choice-statement:

choice语句
~~~~~~~~~~~~

``choice`` 语句定义了一个所有可选项的集合。Ren'Py会根据玩家的选择，执行对应选项相关的ATL语句块(block)，之后跳转到choice语句块结束处。

.. productionlist:: atl
   atl_choice : ("choice" (`simple_expression`)? ":"
              :     `atl_block`)+

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

在choice语句块内部使用 ``pass`` 语句可以生成一个空的choice语句块。

.. _animation-statement:

animation语句
~~~~~~~~~~~~~~~

使用 ``animation`` 语句时，必须将其放在整个ATL语句块的开头，告诉Ren'Py该语句块要使用动画时间轴。

.. productionlist:: atl
    atl_animation : "animation"

与普通的显示时间轴相比，在带有相同标签(tag)的图像(image)或界面(screen)开始显示的那一刻，animation时间轴就将进行计时并被所有相同标签(tag)的图像和界面共享。
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

.. _on-statement:

on语句
~~~~~~~~

``on`` 语句会定义一个事件处理器(handler)。

.. productionlist:: atl
   atl_on : "on" `name` [ "," `name` ] * ":"
          :      `atl_block`

``on`` 语句会将语句块(block)中连续出现的多个on项都放入一个事件集之中。on语句可以只处理某一个事件名，或者使用逗号分隔的事件名列表。

on语句用于处理各种事件(event)。当某个事件被处理后，其他的事件处理就会停止，并且会立即进入新事件的处理流程。当某个事件处理器没有新的待处理事件，就会产生 ``default`` 事件(已经处理 ``default`` 事件的情况除外)。

on语句的执行不会自然终止。(但是其可以被time语句，或者关联的事件处理器终止。)

生成任意事件的方法详见event语句部分，以及 :ref:`external-atl-events` 中的原生事件列表。


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

.. _transform-expression-atl-statement:

变换表达式语句
~~~~~~~~~~~~~~~~~

变换表达式语句可以包含另一个ATL变换，并用作自身ATL语句块的一部分。

.. productionlist:: atl
    atl_transform_expression : `simple_expression`

这种语句只有在ATL变换自身 **没有** 子组件时才有效。否则，同样的语句会被当作 :ref:`displayable-atl-statement` 处理。
变换表达式语句中的内容会替换变换名，并执行对应的变换。

::

    transform move_right:
        linear 1.0 xalign 1.0

    image atl example:
        # 显示logo_base.png
        "logo_base.png"

        # 运行变换move_right
        move_right

.. _displayable-atl-statement:

可视组件语句
~~~~~~~~~~~~~~~~~~~~~

可视组件语句通常是一个简单的Python表达式，可以计算出一个 :doc:`可视组件 <displayables>` 对象。
可视组件语句后面也可能会有一个从句，即另一个简单表达式。

.. productionlist:: atl
    atl_displayable : `simple_expression` ("with" `simple_expression`)?

该语句用于设置或替换某个变换的子组件。

如果后面有 ``with`` 从句，后面的第二个表达式计算结果会用作 :doc:`转场 <transitions>` 效果，并用于新旧两个子组件的切换过程。
需要注意的是，并非所有转场都能正常使用。具体参考 :ref:`dict-transitions` 、 :var:`move- <move>` 和:var:`ease- <ease>` 。

::

    image atl example:
        # 显示logo_base.png。
        "logo_base.png"

        # 暂停1.0秒。
        1.0

        # 显示logo_bw.png，使用dissolve转场效果。
        "logo_bw.png" with Dissolve(0.5, alpha=True)

.. warning::

    如果传入无子组件的变换对象，可能会让整个变换变成透明且无效。
    传入无子组件的ATL变换可能会被当作 :ref:`transform-expression-atl-statement`，产生与预期不同的效果。

如果表达式计算出的ATL变换 **包含** 子组件，那么整个ATL语句块会等到所有子组件内的ATL代码都执行完之后再继续向下执行。

.. _contains-block-statement:

contains语句块
~~~~~~~~~~~~~~~~~~~~~~~~

contains语句块，类似于 :ref:`单行contains语句 <inline-contains-atl-statement>`，可以设置变换的子组件，但方式不同。

.. productionlist:: atl
    atl_counts : "contains" ":"
               :    `atl_block`

一个或多个contains语句块会被分组，并放在一个 :func:`Fixed` 组件中，设置为该变换的子组件。

每个语句块都必须定义一个可用的可视组件，否则会报错。
所有contains语句会立刻并行执行，并不会等待所有子组件内的代码都执行完毕才执行下一条contains。

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
~~~~~~~~~~~~~

``function`` 语句允许ATL使用Python代码。

.. productionlist:: atl
    atl_function : "function" `simple_expression`

这些函数与 :func:`Transform` 具有相同的入参和返回结果：

* 第一个入参是一个transform对象。可以设置该对象的 :doc:`transform_properties`。

* 第二个入参是显示时间轴，表示函数开始执行到现在经过的秒数。

* 第三个入参是动画时间轴，表示具有相同标签(tag)的对象在整个界面上已存在的秒数。

* 如果函数返回一个数值，其会在数值对应的时间(秒)后再次被调用。(0秒表示尽可能快地调用该函数。)如果函数返回None，主控流程会跳到下一个ATL语句。

除了修改第一个入参中的Transform对象之外，该函数不应产生副作用。
并可以在任意时间传入任意值并调用，能配合预加载功能。

注意，``function`` 不是一个变换特性，并且其跟 :func:`Transform` 的 `function` 参数也不完全一致。

::

    init python:
        def slide_vibrate(trans, st, at, /):
            if st > 1.0:
                trans.xalign = 1.0
                trans.yoffset = 0
                return None
            else:
                trans.xalign = st
                trans.yoffset = random.randrange(-10, 11)
                return 0

    label start:
        show logo base:
            function slide_vibrate
            pause 1.0
            repeat


.. _time-statement:

time语句
~~~~~~~~~~~~

``time`` 语句是一种控制语句。

.. productionlist:: atl
    atl_time : "time" `simple_expression`

其包含一个简单表达式，可以算出一个时间点，单位为秒。这个时间点表示其所在语句块(block)从开始执行到time语句结束的总时长。
当time语句中给定的“time”结束后，后面的语句才会开始执行。在上一个语句还在执行的情况下，这种控制转换依然会执行，也能强行终止任意优先级的语句。

time语句隐含了一个pause语句，表示暂停无限长时间。这表示如果主控流程不能抵达time语句处，它就会保持等待直到time语句获取流程控制权。

当一个语句块中存在多个time语句时，它们各自的结束时间点必须按顺序严格递增。

::

    image backgrounds:
        "bg band"
        xoffset 0
        block:
            linear 1 xoffset 10
            linear 1 xoffset 0
            repeat # 主控流程永远无法主动退出循环

        time 2.0
        xoffset 0
        "bg whitehouse"

        time 4.0
        "bg washington"

.. _event-statement:

event语句
~~~~~~~~~~

``event`` 语句是一个简单语句，其会使用给定的名称产生一个事件(event)。

.. productionlist:: atl
    atl_event : "event" `name`

当在某个语句块(block)运行过程中出现某个事件(event)时，语句块会检查自身是否存在对应事件名的处理器(handler)。如果处理器存在，主控流程会切换到对应的事件处理器。否则，事件会广播至所有事件处理器。

.. _external-atl-events:

外部事件
-------------

下列事件会在ATL变换中自动触发：

``start``
    一种伪事件，进入 ``on`` 语句时触发，前提是没有更高优先级的事件出现。

``show``
    使用 ``show`` 或者 ``scene`` 语句显示transform，并且给定标签(tag)没有对应已显示的图像时触发。

``replace``
    使用 ``show`` 语句中的transform根据给定标签(tag)替换某个图像时触发。

``hide``
    使用 ``hide`` 语句或等效的python语句中的transform时触发。

    需要注意的是，transform被 :ref:`scene-statement` 清除，或者退出其所在的 :ref:`context` 时，hide事件是不会触发的。

``replaced``
    transform被另一个transform替换时触发。原transform的图像实际上并不会隐藏或移除，直到整个ATL语句块(block)执行完。

``hover``、``idle``、``selected_hover``、``selected_idle``、``insensitive``、``selected_insensitive``
   当包含此transform的按钮或者被此transform包含的按钮，出现对应的状态名称时触发。

.. _atl-partial:

ATL的柯里化和部分入参传递
---------------------------------------

使用 :ref:`transform-statement` 定义的ATL变换可以设置多种不同的入参列表。
如同调用函数一样调用ATL变换时，返回结果依然是一个transform，入参则可以改变原transform中同名参数的值。

例如：

::

    transform screamer(child, screamee, wait_time=2, flash_time=.1):
        child
        pause wait_time
        screamee
        pause flash_time
        child

    # 这样写不会报错(类似于引用Python函数返回结果)。
    define shorter_screamer = screamer(wait_time=1)

    define eileen_excited_screamer = screamer(screamee="eileen excited", flash_time=.2)

    label start:
        show hhannahh happy at screamer(screamee="hhannahh surprised", wait_time=1.5)
        "这是一种方法。"

        show eileen vhappy at eileen_excited_screamer
        "这是另一种方法。"

        show patricia sad at eileen_excited_screamer(screamee="patricia wow")
        "并且你也可以这样做。"

需要注意，变换 ``shorter_screamer`` 虽然源自 ``screamer``，但不能直接像 ``show eileen at screamer`` 这样直接用。
因为其 ``screamee`` 参数未赋值。

还要注意，类似脚本标签(label)和界面(screen)定义，使用 :ref:`transform-statement` 定义的transform的入参默认值，
是在transform *被调用* 时才计算的，而不是 *被定义* 时就计算好的。

总之，transform只有在调用另一个变换(例如上例中的 ``shorter_screamer`` 或部分入参传递)时，才会计算所有入参的默认值。
无论默认值来自原始的transform(比如 ``shorter_screamer`` 的 `flash_time` 参数或部分入参传递的 `wait_time` 参数)，
还是来自更早执行的脚本中的调用(比如 `shorter_screamer`` 中的 `wait_time` 参数或部分入参传递的 `screamee` 和`flash_time` 参数)。

.. _atl-child-param:

特殊child参数
-----------------------

如果某个ATL变换有一个入参名为“child”，并且该入参获得了一个值，那么将 **无视该入参值的类型和赋值方式** ，
该变换的子组件将被设置为child参数的值。
(无视入参值类型和赋值方式是指，不需要考虑参数是固定位置入参是还是关键词入参，也不需要考虑该参数有默认值还是要求必须重新赋值。)

需要注意，child入参的默认值不会生效，还是需要从外部传入一个新的值。

另外，ATL变换用作一个transform时，默认不会将 ``child=`` 作为关键词参数传递并设置目标的child，除非目标有个同名的child入参。

例如，下面的脚本能在child与另一个可视组件之间来回切换：

::

    transform lucy_jump_scare(child):
        # child的值会隐式设置为transform的子组件。
        pause 5

        # “jump scare”式惊吓。
        "lucy mad"
        pause .2

        # 再显示原来的子组件。
        child

还可以在 ``contains`` 语句块中放置原来的子组件：

::

    transform marquee(width, height=1.0, duration=2.0, child=None):
        xcenter 0.5
        ycenter 0.5

        crop (0, 0, 0.5, 500)

        contains:
            child
            xanchor 0.0 xpos 1.0
            linear duration xanchor 1.0 xpos 0.0

`old_widget` 和 `new_widget` 两个“关键词限定”入参(即不能用于固定位置入参)在 :ref:`atl-transitions` 中有特殊用法。

.. _warpers:

warpers
=======

warper是一类函数，其可以改变插值语句中用到的时间值。他们将时间t转换为t'，t和t'都是浮点数，t会将给定的时间值归一化为0.0到1.0。
(如果该语句给定的原时长是0，那运行时t就是1.0。)
t'的初始取值范围也是0.0到1.0，不过可以超出这个范围。
以下warper都是默认定义好的。

``pause``
    暂停，然后跳变成新值。如果 ``t == 1.0``，则 ``t' = 1.0``；否则 ``t' = 0.0``。

``linear``
    线性插值。``t' = t``

``ease``
    开头慢，中间加速，之后又减速。``t' = .5 - math.cos(math.pi * t) / 2.0``

``easein``
    开头快，然后减速。``t' = math.cos((1.0 - t) * math.pi / 2.0``

``easeout``
    开头慢，然后加速。``t' = 1.0 - math.cos(t * math.pi / 2.0)``

除此之外，Robert Penner的easing函数都是支持的。为了避免与上面的几个函数名重复，有些函数名字修改过。这些标准函数的图像可以在这个网站上查看 http://www.easings.net/

===============     ===================
Ren'Py 函数名       easings.net 函数名
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

可以通过只读模块 ``_warper`` 访问这些warper效果。该模块包含了上述所有函数。
在Ren'Py内置效果中使用时间warp函数很有用，比如可以这样用：

::

    with Dissolve(1, time_warp=_warper.easein_quad)

我们可以在一个 ``python early`` 语句块中，使用 ``renpy.atl_warper`` 装饰器定义新的warper函数。定义warper函数文件需要在使用那个函数的其他任何文件之前被处理。定义的代码如下：

::

    python early hide:

        @renpy.atl_warper
        def linear(t):
            return t


.. _replacing-transforms:

替换变换
====================

某个ATL变换、内建变换或使用 :class:`Transform` 定义的变换对象被同类变换替换时，
同名特性的值会从前一个变换继承到新的变换。不同类型的变换无法继承。

如果 :ref:`show语句 <show-statement>` 中的at关键字后列出了多个变换待替换，则新变换列表从后往前依次替换，直到新替换变换列表全部换完。例如：

::

    show eileen happy at a, b, c
    "我们稍等一下。"
    show eileen happy at d, e

``e`` 变换替换了 ``c``， ``d`` 变换替换了 ``b``，而没有变换会替换 ``a``。

替换时，旧变换的特性值由新变换继承。如果旧变换正处于动画中，则新变换继承的可能是中间的某个值。例如：

::

    transform bounce:
        linear 3.0 xalign 1.0
        linear 3.0 xalign 0.0
        repeat

    transform headright:
        linear 15 xalign 1.0

    label example:
        show eileen happy at bounce
        pause
        show eileen happy at headright
        pause

这个例子中，图像会左右弹跳，直到用户点击鼠标。
当用户点击鼠标后， ``bounce`` 中的 ``xalign`` 特性值将被 ``headright`` 继承。
精灵在x轴方向坐标移动的初始值，即是用户点击鼠标时的值。

位置相关特性(包括 :tpref:`xpos`、:tpref:`ypos`、:tpref:`xanchor` 和 :tpref:`yanchor`，以及等效的:tpref:`xalign`、:tpref:`radius` 和 :tpref:`angle`))继承时有一项特殊规则：
子组件设置的值会覆盖父组件的值。这样设计是考虑到可视组件往往只有一项位置信息，需要优先保证设置的值不受影响。
对位置特性的设置有多种方式，例如，:tpref:`xalign` 会同时设置xpos和xanchor。

最后，如果某个 ``show`` 语句不包含 ``at`` 从句，则不需要搞特性值继承问题。若要重置所有变换特性，可以先隐藏再显示对应的可视组件。
若要中断动画效果，可以这样：

::

    show eileen happy at some_animation
    "Wow, so this is what antigravity feels like !"

    show eileen:
        pass
    "But I'm happy when it settles down."

.. _the-transform-class:

Transform类
============

ATL变换在Python中等效于一个Transform对象。

.. class:: Transform(child=None, function=None, **properties)

    创建一个Transform对象，并将各种操作应用到其子组件，操作包括：剪裁、旋转、缩放和alpha混合等。
    一个Transform对象的字段一一对应 :ref:`变换特性 <transform-properties>` ，并都将应用到子组件。

    `child`
        应用变换的子组件。

    .. function:: function(trans: Transform, st: float, at: float, /) -> int|None

        若不是None，这是渲染变换效果时调用的函数。调用这个函数时使用3个固定位置入参：

        * Transform对象。
        * 显示时间轴，单位为秒。
        * 动画时间轴，单位为秒。

        函数会返回一个延迟时间，单位为秒。在运行延迟时间之后这个函数会被再次调用。如果延迟时间是None，则会在下次互动之后立刻调用。

        该函数除了修改第一个入参的变换对象之外不应有其他副作用，并且要求可以在任何时间点使用任何值调用以配合预加载。

    其他关键词入参都会作为对应变换特性的值。
    绘制变换效果时，对应的变换特性都会根据入参设置值，但在变换对象创建后不再更改。
    使用 ``function`` 参数传入的函数或调用 :meth:`update` 方法，可以改变对应的变换特性。
    
    其他参数被视为设置变换特性的值。

    .. attribute:: hide_request

        当function函数被调用时，这项会被设置为True，标识变换效果被隐藏。

    .. attribute:: hide_response

        如果hide_request为True，这项会被设置为False，防止变换效果被隐藏。

    .. method:: set_child(child)

        使用一个新的 `child` 调用这个方法，`child` 成为变换的子组件。

    .. method:: update()

        当变换特性(property)字段在 `function` 参数指定的回调方法之外被更新时，这个方法会被调用，确保修改生效。

.. _callables-as-transforms:

可调用对象用作变换
=======================

Finally, simple Python callables can be used as transforms. These callables
should take a single :doc:`displayable <displayables>` as an argument, and
return a new Displayable. For example
最后，Python中的可调用对象可以用作变换。这些可调用对象必须能使用 :doc:`可视组件 <displayables>` 作为入参，
并且能返回一个新的可视组件。例如：

::

    init python:

        # 这是一个使用right和left两个默认变换的自定义变换。
        def right_or_left(d):
            if switch:
                return At(d, right)
            else:
                return At(d, left)

某些内建对象可以也符合入参为可视组件并返回可视组件的要求，例如 :func:`Flatten`，也可以直接用作变换。
