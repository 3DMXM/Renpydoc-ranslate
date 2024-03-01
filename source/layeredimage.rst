.. _layered-images:

==============
层叠式图像
==============

当某个精灵(sprite)集的复杂度到达某个等级后，分别定义出每种可能的组合就会变得非常不便。
例如，某个角色有4套服装、4种发型和6种表情，就总共有96种组合方式。
针对每种可能的组合创建静态图像会占用很多磁盘空间和编程时间。

为了应对这种使用场景，Ren'Py提供了一种办法，可以定义多个图层(layer)组成的图像。
(此处的图层跟Ren'Py中其他地方的“图层”不太一样，更类似于Photoshop或者GIMP等绘图程序中图层的概念。)
有两种方法选择图层中需要显示的元素，一直是通过图像的 :ref:`属性 <concept-image>` ，另一种是根据条件实时计算。

使用 ``layeredimage`` 语句和一些指定格式的脚本可以定义层叠式图像。
:func:`LayeredImage` 对象是另一种 Python 形式的层叠式图像。它不是 :doc:`可视组件 <displayables>`，但可以用 ``image`` 语句声明，用法也与可视组件类似。

本页结尾包含了使用层叠式图像的建议和样例。

.. _defining-layered-images:

定义层叠式图像
===============

The language used to define layered images consists of only a few statements,
to introduce the layers. Here is an example which, while not making much
practical sense, is technically correct and outlines the layeredimage syntax
脚本语言需要引入若干图层，然后使用一些语句定义图层上要显示的图像。
这里是一个样例，没有什么高超的灵感和技巧，只是在层叠式图像上加上轮廓线。

::

    layeredimage augustina:
        zoom 1.4
        at recolor_transform

        always:
            "augustina_base"

        attribute base2 default

        group outfit:
            attribute dress default:
                "augustina_dress"
            attribute uniform

        group face auto:
            pos (100, 100)
            attribute neutral default

    label start:
        show augustina # 显示裙子和neutral状态表情
        aug "我喜欢这件裙子。"

        show augustina happy # 在auto组中自定生成定义
        aug "但我更喜欢……"

        show augustina uniform -happy # 用校服替代裙子，neutral替代happy表情
        aug "这件校服！"


这段脚本有点长，不过它很规整易读。下面我们将展示如何简化这段脚本。

首先， ``layeredimage`` 语句以精灵(sprite)的名字开头。这条语句属于Ren'Py脚本语言，运行在初始化阶段。

层叠式图像的语句块(block)可能包含always、group和if语句。 ``group`` 语句可以包含属性(attribute)。
``always`` 和 ``if`` 语句必须带可视组件(displayable)，而同个组内的attribute语句可以任何选择带一个。
以上所有语句都可以带特性(property)。

``always`` 语句定义的图层(layer)总是显示，就像是精灵(sprite)的背景。

``group`` 语句引入一组属性(attribute)，同一时间内只显示某一项属性(attribute)。
所以层叠式图像其实只显示角色的一套服装、一对眼睛、一对眉毛和一张嘴。指定的属性组特性(property)会传入对应的attribute，并让属性组自动定义各个属性。

``attribute`` 语句引入的图层，是仅在图像需要对应属性(attribute)时才会显示。例如，“augustina_outfit_dress”仅在出现“dress”属性时才会显示。
如果使用了关键词 ``default`` ，在没有其他有冲突的属性出现时，就会默认显示的属性；在这个样例中，只要不使用“wink”属性，就显示“augustina_eyes_open”属性的图像。

最后， ``if`` 语句添加了一个图层，该图层使用一条Python语句在不同的可视组件间选择显示的对象。Python语句总是重新计算，并显示第一个满足条件表达式为True的图像。

特性(property)由特性名称和一个简单表达式构成，可以传给每一个图层。一些特性(property)会改变某些语句的功能。
如果含有某一个或多个 :ref:`变换特性 <transform-properties>` 会创建一个 :func:`Transform` 对象并wrap出显示结果。
at后面的某个变换(transform)或者变换列表也会让可视组件产生变化。例如，这里的pos特性(property)创建了一个变换(transform)，移动角色“mouth”图像的位置。

最终图像的尺寸等于能包围所有图层的方框尺寸。所以最好直接让某一个图层就是最终图像的完整尺寸，这个尺寸能包含所有的图层。
第一个图层在最终图像最后面，而最后的图层在最终图像最前面——在这个样例中，眼镜的图层覆盖在所有其他图层上。
建议避免在包含的图像中使用变换特性(property)，比如 :propref:`xcenter` 和 :propref:`xalign`，
因为图像尺寸未知的情况下那些特性可能会出问题。

group和attribute语句在某个层叠式图像中可以出现多次，所有指定属性(attribute)的图像都会显示。

``if`` 语句是个例外，所有Python表达式都会在初始化阶段进行计算。

.. _using-an-layered-image:

使用层叠式图像
----------------------

要使用这个层叠式图像，而不是其他层叠式图像，变量evil必须给定一个值，比如：::

    default evil = True

这样，层叠式图像就可以像其他图像(image)一样显示了。几乎可以肯定，至少需要给定角色的一套服装——虽然Ren'Py不强制要求，图像还是需要显示一套的：::

    show augustina jeans

当精灵(sprite)显示时，额外属性(attribute)的要素只要不冲突就都会添加到图像上。
(使用Ren'Py时广泛存在的，匹配不到已定义图像的情况，基本不会发生在层叠式图像上。)
所以，

::

    show augustina wink

会激活与wink属性(attribute)关联的图层。我们可以可以关闭wink属性，使用：

::

    show augustina open

因为open状态的眼睛与wink状态的眼睛冲突。我们还可以直接移除wink属性，使用：

::

    show augustina -wink

这样也会显示open属性，因为它是默认项。

层叠式图像还可以使用在scene语句中。

.. _automatic-attributes:

自动化属性
--------------------

我们的第一个样例中有不少重复，很多属性(attribute)的名称已经在可视组件中定义过。
为了帮助创作者节约冗余的输入时间，Ren'Py可以根据图像名称、组名称和属性名称自动决定可视组件的名称。
使用下划线连接上述名称就能实现这一点。

这样做的时候，创作者还可以利用属性(attribute)的另一项功能特性——第一行可以添加任意特性(property)，并省略整个语句块(block)。

之前的样例可以这样写：

::

    layeredimage augustina:

        always:
            "augustina_base"

        group outfit:
            attribute dress
            attribute jeans

        group eyes:
            attribute open default
            attribute wink

        group eyebrows:
            attribute normal default
            attribute oneup

        group mouth:
            pos (100, 100)
            attribute smile default
            attribute happy

        if evil:
            "augustina_glasses_evil"
        else:
            "augustina_glasses"

这个样例跟之前那个是等价的(前提是使用的是相同名称的可视组件)。例如，在outfit组中的dress属性使用名为“augustina_outfit_dress”的可视组件。

还可以更进一步，让一个组内自动定义属性(attribute)。在定义组时使用关键词auto，就能让这个组自动搜索正则表达式匹配到的图像，并在属性不存在的情况下自动定义组内图像属性。

与 ``attribute`` 一样，特性(property)也可以放在组的第一行并省略语句块。always语句中的可视组件和特性(property)也可以采用同样的方式。

样例的最终格式如下：

::

    layeredimage augustina:

        always "augustina_base"

        group outfit auto

        group eyes auto:
            attribute open default

        group eyebrows auto:
            attribute normal default

        group mouth auto:
            pos (100, 100)
            attribute smile default

        if evil:
            "augustina_glasses_evil"
        else:
            "augustina_glasses"


这是定义同样的图像时，最精简的方法。当每个组中需要添加更多属性(attribute)时，自动定义功能节省的时间更多。
如果我们不需要默认属性，还可以减少几行脚本。那样，每个组都只需要一行。

在 ``always`` 和 ``if`` 语句中不能省略可视组件的名称，所以在这些地方使用的图像名称需要尽可能简短。合理的图片命名可以很轻松地定义出成千上万种图层的组合方式。

.. _statement-reference:

语句参考
---------

需要注意，当层叠式图像首次定义时，``if`` 语句中的所有条件表达式都在初始化阶段就会被计算。

.. _layeredimage-statement:

layeredimage语句
-----------------

``layeredimage`` 语句在Ren'Py用作某个层叠式图像定义的开头语句。
该语句是Ren'Py脚本语言的一部分，可以在 :ref:`init time <init-phase>` 阶段运行。
与 :ref:`atl-image-statement` 类似，layeredimage语句在开头定义图像名称并开启一个语句块，后面的内容则大相径庭。
图像名称中可以包含空格，类似于Ren'Py中的其他类型的图像名称。

定义layeredimage的语句块中可能包含下列语句，以及一些特性(property)。

`image_format`
    如果给定的图像是一个字符串，并且提供了image_format特性，就将 `image_format` 插入到图像名，根据得到的名称搜索对应的图片文件。
    例如，“sprites/eileen/{image}.png”会在sprites子目录下搜索所有png图片文件。
    (auto组不使用image_format特性，因为auto组自动搜索已定义的图像对象而不是图片文件。)

`format_function`
    这是一个函数，在初始化阶段执行，用于代替 `layeredimage.format_function` 函数，将图像信息格式化并传入某个可视组件。

`attribute_function`
    这是一个函数或可调用对象，用于调整最终显示的图像属性(attribute)。
    在图像上应用一些属性时，该函数会被调用。函数会返回对应图层调整后的属性的集合。
    该函数可以用于计算负责的属性依赖关系，或者随机选择属性。详见 :ref:`attribute-selection-process` 。


`at`
    应用于层叠式图像的一个变换(transform)或变换的列表。

:ref:`transform properties <transform-properties>`
    如果存在变换特性，都会用于构建一个应用于可视组件的 :func:`Transform` 。

`offer_screen`
    若为True，层叠式图像将尝试匹配整个界面，对其子组件调整位置和尺寸。
    若为False，层叠式图像将尝试在更小的包围矩形空间内放置各元素，每次显示的层叠式图像可能并不一样。

    若为None，即默认值，由配置项 :var:`config.layeredimage_offer_screen` 决定。该配置项的默认值是True。

.. _always:

always语句
-----------

``always`` 语句定义一个在层叠式图像中始终显示的图像，该图像不会与任何一个图像属性(attribute)做关联。
always语句必须提供一个可视组件，当然也可以使用特性(property)。
这两部分可以放在同一行，也可以放在一个语句块(block)中。

always语句使用下列特性：

`if_all`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都出现时，才显示图层(layer)。

`if_any`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只要有任意特定的属性出现时，就显示图层(layer)。

`if_not`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都不出现时，才显示图层(layer)。

:ref:`transform properties <transform-properties>`
    如果存在变换特性，都会用于构建一个应用于可视组件的 :func:`Transform()` 。

`at`
    应用于图层的一个变换(transform)或变换的列表。


.. _if:

if语句
------

``if`` 语句(或者更完整的if-elif-else语句)允许创作者设置一个或多个条件表达式。这些条件表达式会运行时进行计算。
每个条件表达式与某个可视组件关联，第一个结果为True的条件表达式对应的图像会被显示。如果没有条件表达式为True，``else`` 语句对应的图像就会显示。

一个稍微复杂的 ``if`` 语句样例如下：

::

    if glasses == "evil":
        "augustina_glasses_evil"
    elif glasses == "normal":
        "augustina_glasses"
    elif glasses == "funky":
        "augustina_glasses_clown"
    else:
        "augustina_nose_mark"

每个图层必须给定一个可视组件。if语句还可以使用下列特性(property)：

`if_all`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，条件表达式检查是否所有的命名属性(attribute)都出现了。

`if_any`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，条件表达式检查是否任意的命名属性(attribute)出现了。

`if_not`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，条件表达式检查是否所有的命名属性(attribute)都未出现。


:ref:`transform properties <transform-properties>`
    如果存在变换特性，都会用于构建一个应用于图层的 :func:`Transform()` 。

`at`
    应用于图层的一个变换(transform)或变换的列表。

当 ``layeredimage`` 语句运行时， ``if`` 语句就会转换为 :func:`ConditionSwitch` 。

.. var: layeredimage.predict_all = None

    Sets the value of `predict_all` for the ConditionSwitches produced
    by layeredimages' ``if`` statements.
    层叠式图像中的 ``if`` 语句生成的条件语句都会给据该配置项，把 `predict_all` 设置为对应的值。

``predict_all`` 不为True时，应该避免修改if语句的条件表达式。因为层叠式图像要么显示要么即将显示，修改if语句条件表达式会导致没有预加载的图像就被使用。
这种设计主要用于很少变化的角色自定义选项。

.. _attribute:

attribute语句
--------------

``attribute`` 语句添加了一个可视组件，当使用给定的属性(attribute)时显示对应的图像(image)。
比如，在前一个样例中，调用 ``show augustina dress`` 会导致“augustina_dress”作为整个“augustina”的一部分并显示。

attribute语句使用一个属性(attribute)名称。其也可以使用两个关键词。
``default`` 关键词表示，在没有明确使用同组其他属性的情况下作为默认的属性。
``null`` 关键词防止Ren'Py自动搜索对应属性的可视组件，
对某些有使用条件 `if_all`，`if_any`，`if_not`，`attribute_function`，:var:`config.adjust_attributes` 和 :var:`config.default_attributes` 的属性时很有用。

相同的属性名可以同时用在多个 ``attribute`` 分句中(``auto`` 组自动定义的属性会在后续另行说明)，
在满足条件时都显示相应的可视组件(`if_all`、`if_any` 和 `if_not` 特性可以调整最终结果)。

如果没有直接给定可视组件(displayable)，Ren'Py会根据层叠式图像名称、组(group)、组变种(group variant)和属性(attribute)，算出一个可视组件的名称。
详见 :ref:`pattern <layeredimage-pattern>` 章节。

attribute语句使用下列特性(property)：

`if_all`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都出现时，才显示图层(layer)。

`if_any`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只要有任意特定的属性出现时，就显示图层(layer)。

`if_not`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都不出现时，才显示图层(layer)。

:ref:`transform properties <transform-properties>`
    如果存在变换特性，都会用于构建一个应用于可视组件的 :func:`Transform()` 。

`at`
    应用于层叠式图像的一个变换(transform)或变换的列表。

`if_*` 从句会基于最终图像的属性列表进行尝试，具体方式详见 :ref:`这里 <concept-image>`，
但它 **不会修改** 属性列表。

::

    layeredimage eileen:
        attribute a
        attribute b default if_not "a"
        attribute c default if_not "b"

在上面的例子中，属性 ``b`` 和 ``c`` *总是* 属性列表的一部分(原因是他们的 ``default`` 从句)。
调用 ``show eileen a`` 时，属性 ``a`` 根据脚本中写的需求决定是否显示，而属性 ``b`` 不同，因为有 ``if_not`` 特性的约束。
但是，尽管对显示结果不起作用，属性 ``b`` 始终处于属性列表中，即意味着属性 ``c`` 始终对显示结果不起作用。

.. _group:

group语句
-----------

``group`` 语句可以将几种属性组成一个组(group)，同组内各属性互斥。
除非该组声明为 ``multiple``，否则同组内的属性 `a` 和 `b` 用在诸如 ``show eileen a b`` 之类地方会出现报错。
正确的用法是，只使用属性 `a` 自动隐藏 `b`，反之亦然。
另外，多个 ``attribute`` 从句传入同一个属性名是合法的。一般出现这种情况的原因是同一个属性包含多个精灵(sprite)，详见本节结尾内容。

``group`` 语句使用一个名称(name)。该名称并不常用，但可以用于生成组内属性的默认名称。
对 ``multiple`` 类型的组来说，名称则真的没什么用处。

这个名称后面可能跟着关键词 ``auto`` 。
如果在组内的任意属性后面的确存在auto，且定义了组内的任意属性后，Ren'Py会扫描自己的图像列表以匹配组的正则表达式(详见 :ref:`below <layeredimage-pattern>`)。
with the specificity that in that case, a multiple group's name *is* part if the
pattern, and that the ``format_function`` passed to the layeredimage is ignored.

找到的所有图像，如果匹配不到已定义的属性，就会自动在组内添加属性，就像使用 ``attribute`` 语句定义group一样。
详见 :ref:`layeredimage-examples` 章节的实际样例。

后面还可以跟关键词 ``multiple`` 。出现时该关键词时，可以同时选中某个组的多个成员。
这个功能可以用于某个自动定义多个属性的组，以便同时对组内成员同时设置相同的特性(property)或属性(attribute)，前提是各个属性间都不存在互斥关系。
但是与关键词 ``default`` 定义的属性会有冲突。
注意，``mutiple`` 类型的组与普通的组差别很大。很多对普通组来说都没有问题的特性，都不适用于 ``multiple`` 类型的组。

在以上这些可选的关键词后面，group语句第一行就可以声明相应的特性(property)，也能以包含特性和属性的语句块形式跟着group后面。

group语句可以使用 ``attribute`` 语句中设置的特性——即 ``if_any``、``at`` 等等。
应用到整个组的特性会分别应用到组内的各个属性(attribute)，但会被组内属性自带的特性所覆盖。
此外，有两个特性是专门用于组的：

`variant`
    这应该是一个字符串。如果存在这项特性，它会添加一个元素。
    该元素最终会成为自动生成图像名的一部分，以及搜索自动定义属性的正则表达式的一部分，前提是定义在 ``auto`` 组中。

`prefix`
    给定的prefix前缀会加一个下划线，并添加到手动或自动定义的属性名称前面。如果 *prefix* 为“leftarm”，遇到的属性名为“hip”，定义的最终属性名就是“leftarm_hip”，显示图像的完整脚本为 ``show eileen leftarm_hip``。

group语句使用的特性(property)与 ``attribute`` 语句相同。应用于组(group)的特性会传给组内的属性(attribute)，除非某项属性自身重写了同名的属性。

定义在同一个层叠式图像中一些同名的 ``group`` 语句块，会被看作同一个组的不同部分。例如：

::

    layeredimage eileen sitting:
        attribute base default
        group arms variant "behind":
            attribute on_hips
            attribute on_knees
            attribute mixed
        attribute table default
        group arms variant "infront":
            attribute on_table default
            attribute holding_margarita
            attribute mixed

在上面的例子中，``eileen_sitting_arms_behind_mixed.png`` 包含在桌子后面的左手，
``eileen_sitting_arms_infront_mixed.png`` 包含在桌子前面的右手。
当调用 ``show eileen sitting mixed`` 时，两个图像同时显示，分别在桌子前后。
例子中的 `on_hips` 属性与 `on_table` 属性互斥，因为它俩没有同一段代码块中声明，却属于同一个组。

.. _layeredimage-pattern:

范式和格式函数
================

不明确指定图像属性的范式，由下列部分构成：

* 层叠式图像名称，空格使用下划线替换。
* 组(group)名称，前提该组不是 ``multiple`` 类型。
* 变种(variant)名称。
* 属性(attribute)名称。

各部分都使用下划线连接。例如，我们有一个名为“augustina work”的图层图像，名为“eyes”的组，
那么根据范式 augustina_work_eyes\_\ `attribute` 匹配图像。 如果带一个 `blue` 的 `variant` ，就会根据范式 augustina_work_eyes_blue\_\ `attribute` 进行匹配。
在下例中：

::

    layeredimage augustina work:
        group eyes variant "blue":
            attribute closed

图像属性(attribute)链接的图像为 “augustina_work_eyes_blue_closed”。
处理时对应的图片文件名为 :file:`augustina_work_eyes_blue_closed.png`。
当然，这个例子中也可以使用 :ref:`image-statement` 显式定义。

如果想要一个 ``multiple`` 组的名称也包含在范式中，可以使用如下语法：

::

    group addons multiple variant "addons"

可以使用 `格式函数` 修改所有范式的结果：:func:`layeredimage.format_function` 就是一种格式函数的实现。
请参考入参列表，需要的情况下可以用自己实现的 `格式函数` 替换它。

.. function:: layeredimage.format_function(what, name, group, variant, attribute, image, image_format, **kwargs)

    调用该函数可以将各种属性和情况的信息串联起来，并返回一个可视组件名。可以被创作者定义的函数替换，但增加的其他未知入参会被忽略。

    `what`
        一个字符串，描述格式内容，可用于各类报错信息中。

    `name`
        层叠式图像的名称。

    `group`
        某个属性的组(group)。未指定或其属于某种情况的一部分时，可以为None。

    `variant`
        组(group)的变种入参，可以是None。

    `attribute`
        属性自身。

    `image`
        一个可视组件或一个字符串。

    `image_format`
        LayeredImage对象的 image_format 参数。

    如果 `image` 为None，那么 `name`、`group` (若不是None)、`variant` (若不是None)和 `attribute` 使用下划线连接得到的图像会创建为 `image`，并返回图像名称对应的字符串。

    如果 `images` 是一个字符串，并且 `image_format` 不是None，`image` 转为字符串格式并获取最终的可视组件。

    假设 `name` 的值是“eileen”，`group` 的值是“expression”，`attribute` 的值是“happy”，`image` 的结果就是“eileen_expression_happy”。
    假设 `image_format` 的值是“images/{image}.png”，最终Ren'Py找到的图片文件就是“images/eileen_expression_happy.png”。
    但要注意不带format入参时，上面两种方法找到的都是同一个图像。

.. _proxying-layered-images:

层叠式图像代理
===============

有时候，为了在多个地方使用同一个层叠式图像，需要给层叠式图像生成一个代理对象(proxy)。
这样设计的原因之一是，各处可能使用同一个精灵(sprite)的不同图像尺寸；另一个原因则是，可以使用层叠式图像作为对话框头像(side image)。

:func:`LayeredImagePorxy` 对象实现了这个功能，为层叠式图像创建出可以在各处使用的副本。例如：

::

    image dupe = LayeredImageProxy("augustina")

会创建一个可以独立显示的图像副本。创建时也可以使用变换作为入参，直接指定剪裁和位置信息用作头像：

::

    image side augustina = LayeredImageProxy("augustina", Transform(crop=(0, 0, 362, 362), xoffset=-80))

比较以下两种不同的图像定义：

::

    image sepia_augustina_one = Transform("augustina", matrixcolor=SepiaMatrix())
    image sepia_augustina_two = LayeredImageProxy("augustina", Transform(matrixcolor=SepiaMatrix()))

``sepia_augustina_one`` 是层叠式图像“augustina” *原生版本* 一个旧照片风格版本，也就是说不需要提供任何属性(attribute)就可以显示。
而 ``sepia_augustina_two`` 则跟“augustina”一样可以带入各种属性，并同时保持旧照片的风格。
实现方法如下：

::

    show augustina happy eyes_blue dress

然后：

::

    show sepia_augustina_one happy eyes_blue dress
    # 无效。因为Transform对象不接受属性(attribute)

    show sepia_augustina_two happy eyes_blue dress
    # 有效。显示“augustina happy eyes_blue dress”的旧照片风格。

.. class:: LayeredImageProxy(name, transform=None)

    该类是一个类图像对象，生成向某个层叠式图像传递属性的代理。

    `name`
        一个字符串，表示需要代理的层叠式图像名称。

    `transform`
        若给定，应是一个变换或变换列表，会应用到代理的图像上。

.. _attribute-selection-process:

选择显示属性
==============

有多个因素会影响 :ref:`show-statement` 最终显示结果。
为了明确说明各因素的作用顺序，本段内容详细说明了从 ``show`` 指令开始到屏幕最终显示的完整流程。

- ``show`` 语句根据后面跟随的图像标签(image tag)，初始化属性(attribute)的集合。
- 如果 :var:`config.adjust_attributes` 成功匹配到图像标签并调用了相关函数，函数将返回一个处理后的属性集合。
  此集合将替代上一步的属性集合。
- 如果配置项 :var:`config.default_attribute_callbacks` 中定义了回调函数，当该函数的触发条件达成时，
  调用函数并将执行结果的属性加入到上一步的集合中。

上述步骤并不仅限适用于层叠式图像，Ren'Py对所有需要显示的图像和层叠式图像都要经过前置处理。
因此，图像属性集使用下面的步骤必须能找到一个并且只有一个有明确定义的图像(或层叠式图像，或Live2D)。
详见 :ref:`show语句章节 <show-statement>`。

- show语句中包含的属性会与层叠式图像定义时的属性合并，通过上述前两步提出一些并保留剩下的。
  如果发现无法识别的属性则会报错。无报错的情况下，Ren'Py根据存在的属性与图像标签做匹配关联。
  这步计算会考察部分属性与图像标签的不兼容限制。某些实际的不兼容是由非multiple类型的组中的同名属性引起，使用 if_any/if_all/if_not clauses 分句就不会出现这种问题。
  这也是为什么明明在从句中没有某个属性，Ren'Py却认为该属性应该激活并显示出来的原因，往往在 if\_x 从句条件不满足的情况下容易出现类似问题。
  (译者注：这段原文使用了很多复杂长句，可能翻译有误。)
- 如果某个 ``attribute_function`` 函数应用到层叠式图像，将使用经过前述步骤筛选后的属性作为入参调用该函数。
  该函数可能会返回一个略有差别的属性集。
- 再来一次不兼容检查，此次是全量检查。
  这是最后一步处理，剩余的属性决定最终显示效果。

.. _advice:

几点建议
=========

**在图像名称中使用下划线。**

默认情况下，Ren'Py中的层叠式图像使用下划线作为图像名各段的分隔符。
可以在图像中临时使用空格，不过后面很可能会导致问题和故障。

Ren'Py的一条规则是，如果创作者想要显示一个图像，那个图像有一个同名图像正在显示，那么就显示那个同名图像。
这个规则也贯彻在层叠式图像中。创作者可以直接定义并显示图层，不过也会导致奇怪的问题，比如一双眼睛悬浮在空中。

每个图像使用的图像标签(tag)都与主图像不同的话，就不存在这个问题了。

**不需要剪裁图层。**

Ren'Py读取图像并加载到RAM之前会进行优化，将所有图像剪裁到非透明像素的包围框(bounding box)。
因此，在图像被正确预加载的前提下，创作者剪裁图像并不会提升性能或减少图像尺寸。

**层叠式图像不应使用运行过程中会发生变化的数据**

注意，定义层叠式图像之后，在 ``layeredimage`` 语句块中的所有表达式都会在初始化阶段计算，因此需要提前考虑各个 ``if`` 语句中的异常情况。
这与ATL的变换不同，也与 :var:`config.adjust_attributes`、:var:`config.default_attributes` 和 ``attribute_function`` 配置不同。
但与 ``format_function`` 类似，都只在层叠式图像定义后调用。

**选择合适的语法**

如果创作者想要一个总是可见的精灵(sprite)，可以使用 ``always`` 从句或 ``attribute x default`` 语法。
``always`` 语句要求创作者显式提供可视组件(使用 :ref:`范式 <layeredimage-pattern>` 自动生成的属性不行)，
而 ``attribute`` 语句会要求“x”对应的属性名在层叠式图像中总是处于激活状态。

如果创作者想要在使用 ``show`` 语句时向层叠式图像传入图像属性来决定具体显示的内容，
例如使用 ``show eileen happy`` 更换 ``show eileen jeans``，则要在 ``group`` 语句块中使用 ``attribute`` 语句(或在 ``auto`` 组中隐式)将两个标签设置为互斥关系。

如果创作者想要根据某个Python变量或条件表达式决定显示内容，则使用 ``if`` 语句。

如果创作者“即要又要”(比如：使用 ``show eileen ribbon`` 显示蓝色或红色缎带，缎带颜色由某个变量决定；是否显示缎带又由 ``ribbon`` 属性控制)，可以将各种属性组织为不同“版本”，然后使用 :var:`config.adjust_attributes` 配置的函数处理。

.. _layeredimage-examples:

样例
========

**范式和自动分组**

假设下列文件已经存在，并放置到 images/ 目录(或其子目录)，使用以下代码：

.. a code-block and not a ::, because it's not proper renpy syntax

.. code-block:: none

    francis_base.png
    francis_face_neutral.png
    francis_face_angry.png
    francis_face_happy.png
    francis_face_very_happy.png
    francis_face annoyed.png
    francis_supersad.png

::

    layeredimage francis:
        attribute base default
        group face auto
            attribute neutral default
        attribute supersad:
            Solid("#00c3", xysize=(100, 100))

层叠式图像 ``francis`` 会定义一个(默认的) ``base`` 属性(attribute)，并使用 :ref:`范式 <layeredimage-pattern>` 与(自动定义的)图像“francis_base”做关联：
使用下划线将图像名(“francis”)、组名称(此例中没有)、变种命中(此例中没有)和属性名按顺序连接构成图像名。

接着，包含“face”并且符合范式的属性都归入到 ``face`` 组，即 ``neutral`` 属性会与“francis_face_neutral”图像关联，“neutral”是该组中的一个属性。

在所有显式出现的属性都对照对应的图像后，``face`` 组就成了一个 ``auto`` 类型的组，所有存在的图像(无论是否自动定义)都会通过范式进行匹配搜索。
此例中，使用范式搜索后会找到3个图像：“francis_face_angry”、“francis_face_happy”和“francis_face_very_happy”。
分别对应 ``angry``、``happy`` 和 ``very_happy`` 三种属性。
但是不存在 ``anoyed`` 属性，因为“francis_face annoyed”中有一个空格，不符合使用下划线连接属性的范式。

最后定义了 ``supersad`` 属性，因为可视组件是显式声明的，不需要通过范式搜索。
roup, so they
end up not being used in the ``francis`` layeredimage.
图像“francis_supersad”和“francis_face annoyed”会使用Ren'Py原本的 :ref:`规则 <images-directory>` 根据图片文件名生成图像名，
并且无法匹配任何一个属性或auto组，因为无法用于 ``francis`` 层叠式图像。

可见使用范式关联图像与属性，然后使用auto组能有效减少代码量。
同一个层叠式图像值需要13行代码就可以定义完成。
这种语法可以有效应对sprite图集数量的几何式增长——比如此例中添加任何关于face属性的图片不需要修改任何代码。

**Dynamism in attributes**
**属性的动态机制**

下面的例子中，定义一些属性，会根据某些变量发生变化：

::

    layeredimage eileen:
        attribute base default
        group outfit auto
        group ribbon prefix "ribbon":
            attribute red
            attribute blue

    default eileen_ribbon_color = "red"

    init python:
        def eileen_adjuster(names):
            atts = set(names[1:])
            if "ribbon" in atts:
                atts.remove("ribbon")
                atts.add("ribbon_" + eileen_ribbon_color)
            return names[0], *atts

    define config.adjust_attributes["eileen"] = eileen_adjuster

