.. _layered-images:

层叠式图像
==============

当某个精灵(sprite)集的复杂度到达某个等级后，分别定义出每种可能的组合就会变得非常不便。
例如，某个精灵有4套服装、4种发型和6种表情，就总共有96种组合方式。
针对每种可能的组合创建静态图像会占用很多磁盘空间和编程时间。

为了应对这种使用场景，Ren'Py提供了一种办法，可以定义多个图层(layer)组成的图像。
(此处的图层跟Ren'Py中其他地方的“图层”不太一样，更类似于Photoshop或者GIMP等绘图程序中图层的概念。)
图层可以无条件显示，也可以通过图像属性(attribute)或者实时计算的条件表达式选择是否显示。

为了让定义层叠式图像更加方便，Ren'Py提供了 ``layeredimage`` 语句。以layeredimage开头的语句表示，允许传作者使用特定域的语言定义一个层叠式图像。
还有 :func:`LayeredImage` 对象，虽然它不是一般的图像(image)对象，但可以使用image语句声明，也可以和一般图像一样使用。

.. _defining-layered-images:

定义层叠式图像
-----------------------

层叠式图像的特定域脚本语言由几种语句组成。其中一种语句就是一个引入图像的普通脚本语言语句，跟在它后面的语句则引入图层和图层组。

为了介绍这种特殊的语言，这里的例子是一个使用了多种功能特性(feature)的层叠式图像，所有的隐式项全都使用显式标明。 

::

    layeredimage augustina:

        always:
            "augustina_base"

        group outfit:

            attribute dress:
                "augustina_outfit_dress"

            attribute jeans:
                "augustina_outfit_jeans"

        group eyes:

            attribute open default:
                "augustina_eyes_open"
                default True

            attribute wink:
                "augustina_eyes_wink"

        group eyebrows:

            attribute normal default:
                "augustina_eyebrows_normal"

            attribute oneup:
                "augustina_eyebrows_oneup"

        group mouth:

            pos (100, 100)

            attribute smile default:
                "augustina_mouth_smile"

            attribute happy:
                "augustina_mouth_happy"

        if evil:
            "augustina_glasses_evil"
        else:
            "augustina_glasses"


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
^^^^^^^^^^^^^^^^^

``layeredimage`` 语句在Ren'Py用作某个层叠式图像定义的开头语句。layeredimage语句开始处是图像名称，后面的语句块内包含attribute、group和if语句。

层叠式图像使用下列特性(property)：

`image_format`
    如果给定的图像是一个字符串，并且提供了image_format特性，就将 *image_format* 插入到图像名，根据得到的名称找对应的图片文件例如，“sprites/eileen/{image}.png”会在sprites子目录下搜索所有png图片文件。(auto组不使用image_format特性，因为auto组自动搜索图像(image)而不是图片文件。)

`format_function`
    这是一个函数，用于代替 `layeredimage.format_function` 函数，将图像信息格式化并传入某个可视组件。

:ref:`transform properties <transform-properties>`
    如果存在变换特性，都会用于构建一个应用于可视组件的 :func:`Transform` 。

`at`
    应用于层叠式图像的一个变换(transform)或变换的列表。

`offer_screen`
    若为True，层叠式图像将尝试匹配整个界面，对其子组件调整位置和尺寸。
    若为False，层叠式图像将尝试在更小的包围矩形空间内放置各元素，每次显示的层叠式图像可能并不一样。
    
    若为None，即默认值，由配置项 :var:`config.layeredimage_offer_screen` 决定。该配置项的默认值是True。

.. _attribute:

Attribute语句
^^^^^^^^^^^^^^

``attribute`` 语句添加了一个图层(layer)，当使用给定的属性(attribute)时显示对应的图像(image)。同一个属性可以用在多个图层中，并响应这个属性一齐显示(if_also和if_not特性可以更改这点)。

attribute语句使用一个属性(attribute)名称。其可以使用两个关键词。 ``default`` 关键词表示，在没有同组冲突属性出现的情况下作为默认的属性。 ``null`` 关键词防止Ren'Py自动搜索对应属性的可视组件，对某些有使用条件 `if_all`， `if_any`， 或 `if_not` 的属性时很有用。

如果没有直接给出可视组件(displayable)，Ren'Py会根据层叠式图像名称、组(group)、组变种(group variant)和属性(attribute)，
用下划线连接碧昂将空格也替换为下划线，算出一个可视组件的名称。
所以如果我们有一个名为“augustina”的图像，组名“eyes”，属性名“closed”，那么最终使用的图像名为“augustina_eyes_closed”。
(层叠式图像的格式化函数就负责处理这个工作，默认的格式化函数是 :func:`layeredimage.format_function`。)

如果某个属性(attribute)不在某个组(group)里，就会使用相同的属性名放入那个组中，但那个组并不会用于计算可视组件的名称。(Ren'Py会搜索“image_attribute”，而不是“image_attribute_attribute”。)

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
但它 **不会 *修改* 属性列表**。

::

    layeredimage eileen:
        attribute a
        attribute b default if_not "a"
        attribute c default if_not "b"

在上面的例子中，属性 ``b`` 和 ``c`` *总是* 属性列表的一部分(原因是他们的 ``default`` 从句)。
调用 ``show eileen a`` 时，属性 ``a`` 根据脚本中写的需求决定是否显示，而属性 ``b`` 不同，因为有 ``if_not`` 特性的约束。
但是，尽管对显示结果不起作用，属性 ``b`` 始终处于属性列表中，即意味着属性 ``c`` 始终对显示结果不起作用。

.. _group:

Group语句
^^^^^^^^^^

如果某个组中出现了一个属性，除非该组是 ``multiple``，组中在出现其他属性都将报错。
(不过一个组中可以包含同样的属性多次。)

``group`` 语句使用一个名称(name)。该名称并不常用，但可以用于生成组内属性的默认名称。
``multiplay`` 组的名称则真的没什么用处。

这个名称后面可能跟着关键词 ``auto`` 。如果在组内的任意属性后面的确存在auto，Ren'Py会扫描自己的图像列表以匹配组的正则表达式(详见下面内容)。找到的所有图像，如果匹配不到已定义的属性，就会自动在组内添加属性，就像使用attribute语句定义属性一样。

后面还可以跟关键词 ``multiple`` 。出现时，可以同时选中某个组的多个成员。这个功能可以用于某个自动定义多个属性的组，以便同时对组内成员同时设置相同的特性(property)或属性(attribute)。但是与关键词 ``default`` 定义的属性会有冲突。

特性(property)可以定义在组的第一行，后面带一个语句块，包含特性(property)和属性(attribute)。

有两个特性是专门用于组的：

`variant`
    这应该是一个字符串。如果存在这项特性，它会添加一个元素。
    该元素最终会成为自动生成图像名的一部分，以及搜索自动定义属性的正则表达式的一部分，前提是定义在 ``auto`` 组中。

`prefix`
    给定的prefix前缀会加根下划线，并添加到手动或自动定义的属性名称前面。如果 *prefix* 为“leftarm”，遇到的属性名为“hip”，定义的最终属性名就是“leftarm_hip”。

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

**正则表达式** 使用的图像正则表达式由下列部分构成：

* 图像名称，空格使用下划线替换。
* 组(group)名称，若组不是 ``multiple`` 。
* 变种(variant)名称。
* 属性(attribute)名称。

全部使用下划线组成。例如，我们有一个名为“augustina work”的图层图像，名为“eyes”的组，就会根据正则表达式 augustina_work_eyes_`attribute` 匹配图像。 如果带一个 `blue` 的 `variant` ，就会根据正则表达式 augustina_work_eyes_blue_`attribute` 进行匹配。

.. _always:

Always语句
^^^^^^^^^^^

``always`` 语句定义一个保持显示的图层。always语句必须提供一个可视组件，当然也可以使用特性(property)。
这两部分可以放在同一行，也可以放在一个语句块(block)中。

always语句使用下列特性：

`if_all`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都出现时，才显示图层(layer)。

`if_any`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只要有任意特定的属性出现时，就显示图层(layer)。

`if_not`
    属性(attribute)名称的字符串或字符串列表。如果出现了这项特性，只有所有特定的属性都不出现时，才显示图层(layer)。

:ref:`transform properties <transform-properties>`
    如果存在变换特性，都会用于构建一个应用于图层的 :func:`Transform()` 。

`at`
    应用于图层的一个变换(transform)或变换的列表。

.. _if:

If语句
^^^^^^

``if`` 语句(或者更完整的if-elif-else语句)允许创作者设置一个或多个条件表达式。这些条件表达式会运行时进行计算。
每个条件表达式与某个图层(layer)关联，第一个结果为True的条件表达式对应的图像会被显示。如果没有条件表达式为True，else语句对应的图像就会显示。

一个稍微复杂的 ``if`` 语句样例如下：

::

    if glasses == "evil":
        "augustina_glasses_evil"
    elif glasses == "normal":
        "augustina_glasses"
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

当 ``layeredimage`` 语句运行时， ``if`` 语句就会转换为 :func:`ConditionSwitch()` 。

.. var: layeredimage.predict_all = None

    层叠式图像中的if语句生成的条件语句都 会给据该配置项，把 `predict_all` 设置为对应的值。

``predict_all`` 不为True时，应该避免修改if语句的条件表达式。因为层叠式图像要么显示要么即将显示，修改if语句条件表达式会导致没有预加载的图像就被使用。
这种设计主要用于很少变化的角色自定义选项。

.. _poses:

姿势
-----

一个角色对应的精灵(sprite)可能有多个姿势，不同姿势的所有内容——至少有趣的所有内容——都是不同的。
例如，如果某个角色有站立和坐着两种姿势，所有的图像部件就都在不同的位置。

在那种情况下，可以根据同一个图像标签(tag)定义多个层叠式图像。  ``layeredimage`` 语句可以允许创作者包含属性(attribute)作为图像名称的一部分。所以我们可以这样：

::

    layeredimage augustina sitting:
        ...

    layeredimage augustina standing:
        ...

使用层叠式图像合成一个对话框头像(side image)特别好用。不同角色的对话框头像不会与其他角色的有任何关系。 

::

    layeredimage side eileen:
        ...

    layeredimage side lucy:
        ...

.. _advice:

几个建议
---------

**在图像名称中使用下划线。**
默认情况下，Ren'Py中的层叠式图像使用下划线作为图像名各段的分隔符。
可以在图像中临时使用空格，不过后面很可能会导致问题和故障。

Ren'Py的一条规则是，如果创作者想要显示一个图像，那个图像有一个同名图像正在显示，那么就显示那个同名图像。
这个规则也贯彻在层叠式图像中。创作者可以直接定义并显示图层，不过也会导致奇怪的问题，比如一双眼睛悬浮在空中。

每个图像使用的图像标签(tag)都与主图像不同的话，就不存在这个问题了。

**不需要剪裁图层。**
Ren'Py读取图像并加载到RAM之前会进行优化，将所有图像剪裁到非透明像素的包围框(bounding box)。
因此，在图像被正确预加载的前提下，创作者剪裁图像并不会提升性能或减少图像尺寸。

.. _layeredimage-python:

Python
------

当然， ``layeredimage`` 语句有一个Python等效语句。group语句则没有——group应用 ``attribute`` 的值，而auto功能可以通过 :func:`renpy.list_images()` 来实现。

.. function:: Attribute(group, attribute, image=None, default=False, **kwargs)

  这个函数用于由某个属性(attribute)控制展现层叠式图像中的某个图层(layer)。单个的属性可以控制多个图层，在这种情况下那个属性的图层会同时响应并显示。

  **group**
    一个字符串，表示属性控制的组名称。可以是None，表示由属性名创建同名的组。

  **attribute**
    一个字符串，表示属性的名称。

  **image**
    如果不是None，这项应该是受属性控制显示的可视组件。

  **default**
    如果是True，并且组内其他属性没有设置为默认属性，就使用 *attribute* 作为默认属性。

  还有下面几个关键词入参：

  **at**
    应用于图像的一个变换(transform)或者变换列表。

  **if_all**
    一项属性(attribute)或属性列表。只有所有属性都显示时，对应的可视组件才会显示。

  **if_any**
    一项属性(attribute)或属性列表。只要不是空列表，任意属性显示时，对应的可视组件都会显示。

  **if_not**
    一项属性(attribute)或属性列表。所有属性都不显示的情况下，可视组件才显示。

    其他关键词入参都可以集成为变换(transform)的特性(property)。如果出现了这样的关键词入参，就会创建一个变换用于warp图像。
    (例如，pos=(100, 200)可以用于让图像在水平方向偏移100像素、在垂直方向偏移200像素。)

    如果 *image* 参数省略或者为None，并且 :func:`LayeredImage()` 传入了 *image_format* 参数，image_format就用于生成图像文件名。

    .. function:: Condition(condition, image, **kwargs)

    这个函数用于由某个条件表达式控制展现层叠式图像中的某个图层(layer)。当条件表达式为True时，显示图层。否则不显示。

    **condition**
      这是一个字符串，表示Python条件表达式，决定是否显示图层。

    **image**
      若不是None，这是一个可视组件，条件表达式condition为True时显示。

    **if_all**
      一项属性或属性列表。只有所有属性都显示时，才计算条件表达式的值。

    **if_any**
      一项属性或属性列表。只要列表不是空列表，任意属性显示时都计算条件表达式的值。

    **if_not**
      一项属性或属性列表。只有所有属性都不显示时，才计算条件表达式的值。

    **at**
      应用于图像的一个变换(transform)或者变换列表。

    其他关键词入参都可以集成为变换(transform)的特性(property)。如果出现了这样的关键词入参，就会创建一个变换用于warp图像。
    (例如，pos=(100, 200)可以用于让图像在水平方向偏移100像素、在垂直方向偏移200像素。)

    .. function:: LayeredImage(attributes, at=[], name=None, image_format=None, format_function=None, attribute_function=None, **kwargs)

    这是一个类图像对象，如果显示某个合适的属性(attribute)的集合，使用集合中那些属性对应的可视组件合成一个可视组件并显示。

    **attribute**
      这必须是一个Attribute对象列表。每个Attribute对象影响一个可视组件作为最终图像的一部分是否显示。列表中的元素是从后往前顺序排列，第一个元素距离观察者(viewer)最远，最后一个元素距离最近。

    **at**
      一个变换(transform)或变换列表，应用于可视组件。

    **name**
      属性名称。这项用作图像组成名称的一部分。

    **image_format**
      如果给定的图像是一个字符串，并且出现了image_format，就在图像名中插入image_format，用作图片文件。例如，“sprites/eileen/{image}.png”会搜索sprites子目录下的图像。
      (这项不用在auto组中，auto组只搜索图像而不搜索图片文件。)

    **format_function**
      一个函数，用于代替 *layeredimage.format_function* 函数，将图像信息格式化并传入某个可视组件。

    **attribute_function**
      如果不是None，这个函数使用应用于图像的属性(attribute)集作为参数，并返回选择的图层所使用的属性集。
      在属性自身被选中后，决定显示图层时，调用这个函数。它可以用于表示属性或随机选择的属性间复杂的依赖关系。

    额外的关键词入参会传入一个固定布局(Fixed)，这个固定布局用于防止图层。除非显示重写，固定布局的xfit和yfit都设置为True，表示所有图层图像显示时固定布局会收缩为最小尺寸。

    层叠式图像不是可视组件(displayable)，能使用的范围比可视组件小。这是因为很多地方需要提供一个图像名(通常包含image属性)。
    比如，层叠式图像可以使用scene和show语句显示，也可以通过图像名字符串当作一个可视组件使用。

    :func:`layeredimage.format_function` 函数用作将属性(attribute)和可视组件格式化为图片文件。创作者可以查看这个函数的结构和使用的入参，在需要的情况下可以使用自己的 *format_function* 函数替换它。

    .. function:: layeredimage.format_function(what, name, group, variant, attribute, image, image_format, **kwargs)

    调用这个函数可以将属性(attribute)或条件表达式的信息格式化并传入可视组件中。创作者可以用自定义函数替换这个函数，不过新的函数会忽略未知的关键词入参。

    **what**
      一个字符串，表示格式化内容的描述信息，常用于创建更详尽的错误信息。

    **name**
      图像属性(attribute)名称。

    **group**
      属性的组(group)名，如果不支持组或者其是条件表达式的一部分则为None。

    **variant**
      组(group)内的variant入参，如果没有则为None。

    **attribute**
      属性(attribute)本身。

    **image**
      一个可视组件或者字符串。

    **image_format**
      LayeredImage函数的image_format入参。

    如果 ``image`` 的值是None，那么就用下划线连接 ``name`` 、 ``group`` (如果非None)、 ``variant`` (如果非None)和 ``attribute`` ，组合并创建出 *image* 。这个创建的 *image* 是一个字符串。

    如果 *image* 是一个字符串，并且 *image_format* 不是None， *image* 引用的对象经过函数格式化，得到最终使用的可视组件。

    所以，如果 *name* 是“eileen”， *group* 是“expression”， *attribute* 是“happy”， *image* 就被设置为“eileen_expression_happy”。
    如果 *image_format* 是“mages/{image}.png”，Ren'Py找到的最终图像就是“images/eileen_expression_happy.png”。
    但是注意，Ren'Py还会找到不带format入参的同名图像。

.. _proxying-layered-images:

层叠式图像生成代理对象
-----------------------

有时候，为了在多个地方使用同一个层叠式图像，需要给层叠式图像生成一个代理对象(proxy)。这样设计的原因之一是，各处可能使用同一个精灵(sprite)的不同图像尺寸；另一个原因则是，可以使用层叠式图像作为对话框头像(side image)。

:func:`LayeredImagePorxy` 对象实现了这个功能，为层叠式图像创建出可以在各处使用的副本。

举例：

::

    image dupe = LayeredImageProxy("augustina")

这行脚本创建了一个可以独立显示的图像副本。这个副本能搭配上某个变换(transform)入参，并用于设定对话框头像(side image)的位置，像这样：

::

    image side augustina = LayeredImageProxy("augustina", Transform(crop=(0, 0, 362, 362), xoffset=-80))

.. function:: LayeredImageProxy(name, transform=None)

  这是一个类图像对象。可以将某个层叠式图像的属性(attribute)传给另一个层叠式图像。

  `name`
    一个字符串，表示需要生成代理对象的层叠式图像名。

  `transform`
    若给定了这个入参，表示生成代理对象后，会应用于图像上的某个变换(transform)或变换列表。

.. _selection-attributes-to-display:

选择显示属性
----------------

有多个因素都会影响 ``show`` 的最终显示结果。
为了明确说明各因素的作用顺序，本段内容详细说明了从 ``show`` 指令开始到屏幕最终显示的完整流程。

- ``show`` 语句根据后面跟随的图像标签(image tag)，初始化属性(attribute)的集合。
- 如果 :var:`config.adjust_attributes` 成功匹配到图像标签并调用了相关函数，函数将返回一个处理后的属性集合。
  此集合将替代上一步的属性集合。
- 如果配置项 :var:`config.default_attribute_callbacks` 中定义了回调函数，当该函数的触发条件达成时，
  调用函数并将执行结果的属性加入到上一步的集合中。
- 前面两个步骤不对层叠式图像产生效果。Ren'Py在此步骤决定显示普通图像还是层叠式图像。
  使用之前获得的图像属性集，根据 :ref:`show语句<show-statement>` 中描述的逻辑，必须指向唯一的图像(或层叠式图像、Live2D)
- 接着，丢弃属性集合中的之前显示的同名属性，保留其他属性，将属性名与层叠式图像定义中的属性合并。
  此时可能会检测到无法识别的属性并报错。如果没有报错，合并后的属性作为图像标签(tag)。
  这步计算将会使用某些不兼容的约束条件，但不是所有约束。
  相同“非multiple”组中的属性不兼容检查将在此时处理，但 if_any/if_all/if_not 从句部分则不做检查。
  也就是说，明明某些属性在 if\x 从句中不满足判断前提，但如果不再次显式调用整个show语句的话，
  依然会被Ren'Py认为该属性值需要显示。
- 如果层叠式图像指定了一个 attribute_function，将使用经过上述几步处理后的属性集合。
  返回值是另一个略有不同的属性集合。
- 再来一次不兼容检查，此次是全量检查。
  这是最后一步处理，剩余的属性决定最终显示效果。
