.. _displaying-images:

=================
显示图像
=================

若要定义出视觉小说的重点，通过其名字就能得到，重点是“视觉”。Ren'Py中，提供了4种语句用于控制图像显示，并提供了一种模式用于控制图像显示顺序。这些特性可以使视觉小说和叙事性游戏中，合理展示图像变得十分方便。

与图像相关的4种语句分别是：

* ``image`` - 定义一个新的图像(image)。
* ``show`` - 在图层上(layer)显示一个图像。
* ``scene`` -清空图层(layer)，并可选是否在那个图层上显示一个图像。
* ``hide`` - 将图层(layer)上的某个图像移除。

图像的突然变化显得很突兀，Ren'Py提供了 ``with`` 语句，可以在场景切换时提供各种效果。

本页中出现的大多数语句都会使用 :ref:`lint` 检查，但他们的等效Python语句则不会检查。

.. _concepts:

一些概念
========

.. _concept-image:

图像(image)
------------

图像(image)是可以使用show语句显示在界面上的一类东西的统称。图像(image)由一个名称和一个可视组件构成。当某个图像展示在某个图层上时，也表示那个图像关联的可视组件显示在图层上。

一个 :dfn:`图像名称` 可能包含一个或更多字段，由空格分隔。图像名称的第一个字段称作 :dfn:`图像标签(tag)`。 后面的字段被称作 :dfn:`图像属性(attribute)`。

举例来说，假设图像名称为 ``mary beach night happy`` 。图像标签就是 ``mary`` ，而图像属性(attribute)就是 ``beach`` 、 ``night`` 和 ``happy`` 。

可视组件是可以展现在界面上的一类东西的统称。最常用来展现的是静态图像，只需要以字符串形式给定图片文件名称就可以使用了。在上面的样例中，我们可以使用 ``"mary_beach_night_happy.png"`` 这样的文件名
除了静态图片之外，图像(image)可以使用 :doc:`Ren'Py支持的所有可视组件 <displayables>` 。 用于显示图像的语句也可以用来显示动画、纯色和其他可视组件。

.. _layer:

图层(layer)
------------

图层是一个可以显示在界面上的可视组件列表。Ren'Py支持多图层，包括使用自定义图层。图层(layer)的顺序在游戏内设置(被
:var:`config.layers` 变量控制)， 而图层内可视组件的顺序由scene和show语句的顺序及语句中的特性(property)共同决定。

以下图层由Ren'Py内部定义：

master
     该图层是在scene、show和hide语句中默认使用的图层。master图层主要用于背景和角色精灵(sprite)。

transient
     UI函数使用的默认图层。在每次互动结束后，该图层都会被清空。

screens
     该图层用于界面系统。

overlay
     当UI函数被覆盖(overlay)函数调用时，默认使用的图层。当一个互动行为重新启动时，该图层会被清空。

若需要定义新的图层，可以调用 :func:`renpy.add_layer` 函数，并设置图层相关 :doc:`配置项 <config>`。
使用 :ref:`camera statement <camera>`，时，一个图层可以同时应该多个变换。

.. _defining-images:

定义图像(image)
===============

有两种定义图像(image)的方式。你可以将图片文件放在images目录里，或者使用image语句定义一个图像(image)。图像的定义格式比较简单，只要放入目录中的图片文件命名符合转换规则，就能直接转换为图像并使用，还允许使用非图像文件定义图像。

使用image语句的优先级高于通过image目录定义的图像。

.. _image-directory:
.. _images-directory:

images目录
----------------

图像目录名为“images”，放置在game目录下。当一个扩展名为.jpg、.jpeg、.jxl、.png或.webp的文件被放入这个目录时，文件的扩展名会被忽略，文件名的其余部分强制转为小写，最终生成的文件名会被用作图像(image)的名称，前提是那个名称没有在之前其他地方被显示定义过。

这种设计会处理所有images目录下的子目录。例如，以下所有文件都会被定义为图像(image) ``eileen happy`` ：

::

    game/images/eileen happy.png
    game/images/Eileen Happy.jpg
    game/images/eileen/eileen happy.png

如果指定图片名后没有在game目录中找到，则会再次在images目录搜索。

.. _oversampling:

过采样
--------

默认情况下，图片的尺寸决定了实际显示时的大小。
比如，一个1920×1080像素的图片，使用 :func:`gui.init` 运行在1920×1080分辨率下时，将填满整个屏幕。

启用过采样之后，图片显示时的尺寸会比实际的要小。
例如，原图片为3480×2160像素，过采样系数为2。
那么两个轴向的尺寸都会减半，最终图像将显示为1920×1080。

在图片需要缩放同时要求细节时，过采样技术十分有用。
当使用更高细节的图形重制游戏时，过采样可以用来解决 :var:`config.physical_width` 和 :var:`config.physical_height` 与素材间的矛盾。

图片名出去扩展名，以一个 ‘@’ 符号加数字形式结尾时，将自动启用过采样。
例如，“eileen happy@2.png”表示2倍过采样，“eileen happy@3x.png”表示3倍过采样。
使用 :func:`Image` 函数时指定关键字参数 `oversample` 的值也可以启用过采样。

.. _image-statement:

image语句
---------------

image语句用于定义图像(image)。一条image语句由以下部分组成：以关键词 ``image`` 开头的一条逻辑行，后接一个图像名，一个等号(``=``)和一个可视组件。举例： ::

    image eileen happy = "eileen_happy.png"
    image black = "#000"
    image bg tiled = Tile("tile.jpg")

    image eileen happy question = VBox(
        "question.png",
        "eileen_happy.png",
        )

如果某个图片文件并不直接放在game目录下，创作者需要给出文件路径。例如，对图片game/eileen/happy.png，需要这样写： ::

    image eileen happy = "eileen/happy.png"

image语句在初始化阶段就运行，在开始标签(label)运行或者初始菜单展现之前。就算image语句不放在初始化语句块(block)中，它们依然会获得初始化语句块同样的优先级级别500。

其他信息可以参考 :ref:`ATL的image语句变种 <atl-image-statement>` 。

.. _show-statement:

show语句
==============

show语句用于在某个图层(layer)上显示一个图像(image)。一条show语句由以下部分组成：以关键词 ``show`` 开头的一条逻辑行，后接一个图像名，以及0个或多个特性(property)。

如果show语句被给定了某个已存在的图像(image)的准确名称，对应的图像就会被显示。如果给定图像名不存在，Ren'Py就会尝试寻找符合以下条件的图像：

* 在show语句中拥有相同特定标签(tag)。
* 在show语句中拥有给定的所有属性(attribute)。
* 若拥有相同标签(tag)的某个图像正被显示，与那个图像共享最大数量的属性(attribute)。

若没有任何一个符合条件的图像(image)被找到，就会发生异常。

若带有相同图像标签(tag)的图像已经在图层上显示了，新的图像就会替换原来的图像。否则，该图像会覆盖在同一图层所有其他图像之上。(对设计者来说)图像的相互覆盖顺序可以通过调整zorder和behind特性(property)。

show语句不会触发互动行为。由于图像实际上已经向用户展示，后面必须执行一个能够触发互动行为的(say、menu、pause或with)语句。

show语句可以使用以下特性(property)：

``as``
    as特性(property)使用一个名称。当某个图像被显示时，as特性(property)的名称被用作该图像的标签(tag)的别名。这种设计可以让同样的图像在界面上出现两次。

``at``
    at特性(property)使用一个或多个英文逗号分隔的简单表达式。每一个简单表达式必须能换算成一个变换(transform)。变换(transform)被以从左到右的顺序应用到图像上。

    如果没有给定at分句的情况下，Ren'Py会保持之前任何已经存在并应用到图像上使用ATL或 :class:`Transform` 创建的变换(transform)。如果没有指定变换(transform)，图像会使用默认 :var:`default`
    变换(transform)显示。

    使用标签(tag)进行变换特性的修改和替换的内容，详见 :ref:`变换替换 <replacing-transforms>` 章节。

``behind``
    behind特性(property)使用一列英文逗号分隔的变量名。每个变量名都代表一个图像标签(tag)。分句开头变量名指代的图像，显示在带有指定标签(tag)的所有图像之后。

``onlayer``
    onlayer特性(property)使用一个变量名。在变量名对应的图层(layer)上显示图像。

``zorder``
    zorder特性(property)使用一个整数值。该整数指定了同一个图层(layer)内各个图像在z轴上的位置。数值越大，图像距离用户越近。zorder主要不是用于Ren'Py游戏中，而对从其他引擎移植过来的视觉小说可能有用。
    zorder还有个用处，可以将某些始终要显示在最上层的图像的zorder设置得很大，避免了设置图层的麻烦。

假设我们定义了如下的图像：

::

    image mary night happy = "mary_night_happy.png"
    image mary night sad = "mary_night_sad.png"
    image moon = "moon.png"

show语句样例如下：

::

    # 最基础的显示
    show mary night sad

    # 由于‘mary night sad’已经显示了，下个语句等价于：
    # show mary night happy
    show mary happy

    # 在界面右边显示图像
    show mary night happy at right

    # 同样的图像显示两次
    show mary night sad as mary2 at left

    # 在两个图像后面显示图像
    show moon behind mary, mary2

    # 在用户自定义的图层上显示图像
    show moon onlayer user_layer

.. _attributes-management:

属性(attribute)管理
---------------------

综上所述，属性可以设置、添加和替换。

还可以使用减号移除：

::

     # 显示正常的苏珊
     show susan

     # 显示高兴的苏珊
     show susan happy

     # 再次显示正常的苏珊
     show susan -happy

.. _show-expression:

show expression
---------------

show语句的一个变种，使用关键词 ``expression`` 代替图像名，后面跟一个简单表达式。表达式必须能解析为一个可视组件，而该可视组件会在图层上显示。若要隐藏该可视组件，必须使用as语句指定一个图像标签(tag)。

举例::

    show expression "moon.png" as moon

.. _show-layer:

show layer
------------

``show layer`` 语句将跟后面的 :ref:`camera 语句 <camera>` 一起讨论。

.. _scene-statement:

scene语句
===============

scene语句会移除图层(layer)上所有的可视组件，并在该图层上显示一个图像。场景语句开头是关键词 ``scene`` ，后面跟一个图像名，最后可能有若干个特性(property)。scene语句中，图像的显示方式和特性的使用效果与show语句一致。

scene语句经常用于，在背景图层上显示一个图像。例如::

    scene bg beach

**scene表达式。**
与show语句类似，场景语句也能使用表达式代替图像名。

**清空图层。**
如果图像名为空，scene语句会清空图层上所有可视组件，并且不会显示任何东西。

.. _hide-statement:

hide语句
==============

hide语句将一个图像从图层中移除。该语句以关键词 ``hide`` 开头，后跟一个图像名，再后面可能包含一个特性(property)。hide语句从图片名中获取图片标签(tag)，并将图层上该标签(tag)所对应的所有图像都移除。

hide语句很少用到。如果一个精灵(sprite)表示一个角色，那么只有当角色离开场景时hide语句才会被用到。当角色改变表情时，使用show语句更好，因为显示语句会自动替换带有同名标签(tag)的角色图片。

hide语句拥有以下特性(property):

``onlayer``
    该特性拥有一个变量名。隐藏该变量名对应图层(layer)上的图像(iamge)。

举例::

    e "我要离开这里。"

    hide eileen

下面这段是反例，请勿模仿这种写法::

    hide eileen
    show eileen happy

正确的写法是::

    show eileen happy


.. _with-statement:

with语句
==============

with语句用于在场景切换时应用转场(transition)效果，使得图像的出现和隐去不显得突兀。with语句以关键词 ``with`` 开头，后跟一个简单表达式，该简单表达式可以转换为一个转场(transition)对象或者特殊值  ``None`` 。

转场(transition)效果会被应用于某次互动行为后上一个界面所有内容的消隐，跟show和hide语句执行后新界面的展现之间。

with语句会触发等待一个互动行为。该互动行为存在期间由用户控制，用户可以通过互动更快结束这个过程。

所有可用的转场(transition)效果列表，详见 :doc:`转场 <transitions>`。

with语句的样例::

    show bg washington
    with dissolve

    show eileen happy at left
    show lucy mad at right
    with dissolve

这段脚本触发了两段过渡(transitions)效果。第一个with语句使用 ``dissolve`` 效果将界面场景切换至背景“washington”。( ``dissolve`` 默认为历时0.5秒的溶解效果。)

第二个with语句在Eileen和Lucy出场之后使用了转场(transition)效果。这条语句使得原本只包含背景画面的场景切换到包含三个图像的场景——新登场的两个角色图像一齐使用溶解效果出现。

.. _with-none:

With None
---------

在上述的例子中，使用了两次dissolve效果。但如果我们希望背景即刻出现，而角色登场使用dissolve效果的话，应该怎样做？在第一个with语句中只是不带任何值的话，3个图像依然会使用dissolve效果显示——我们需要一种方式声明背景需要立刻出现。

with语句使用特殊值 ``None`` ，就可以满足我们的要求。 ``with None`` 语句会简单地触发一个互动行为，不改变用户所看到的画面。当下一个转场(transition)发生时，这种效果会从with None语句定义的语句块开始直到互动行为完成。

例如，这段脚本::

    show bg washington
    with None

    show eileen happy at left
    show lucy mad at right
    with dissolve

只有一个转场(transition)效果发生，发生在只有背景“washington”到背景加两个角色的场景。

.. _with-clause-of-scene-show-and-hide-statements:

scene、show和hide语句中的with分句
-----------------------------------------------

scene、show和hide语句可以带一个with分句，该分句使得图片的显示和隐藏可以直接关联一个转场(transition)效果。with分句跟在其他语句的同一个逻辑行结尾，以关键词 ``with`` 开头，后接一个简单表达式。

with分句等效于在原有语句前面先加了一行 ``with None`` 语句，附加分句的过渡效果相当于原有语句后加了一行with语句 :ref:`with 语句 <with-statement>`。举例：::

    show eileen happy at left with dissolve
    show lucy mad at right with dissolve

等效于::

    with None
    show eileen happy at left
    with dissolve

    with None
    show lucy mad at right
    with dissolve

.. _camera-and-show-layer-statements:

camera和show layer语句
================================

``camera`` 语句允许我们将某个变换(transform)或者ATL变换(transform)应用于整个图层(layer)，比如“master”图层上。语法如下：

::

    camera at flip

或：

::

    camera:
        xalign 0.5 yalign 0.5 rotate 180

若要停用图层上的格式，则使用：

::

    camera

camera语句可以选择指定图层名称，图层名放在 ``camera`` 和 ``at`` 或 ``:`` 之间：

::

    camera mylayer at flip

``show layer`` 语句相当于一个旧版本的 ``camera`` 语句，有一些区别，也依然可以使用。

::

    show layer master:
        blur 10

两者的区别是：

* 使用 ``show layer`` 应用的变换会在下一个 ``scene`` 语句后清除，而 ``camera`` 语句则需要显式清除。

* ``show layer`` 语句需要指定图层名称，而 ``camera`` 默认应用到master图层。


.. _hide-and-show-window:

hide和show窗口
====================

当某个角色不处于发言状态时，window语句用于控制窗口显示。(例如，在过渡效果或者暂停状态下。)window show语句显示窗口，而window hide语句隐藏窗口。

转场(transition)效果是可选的，若指定了过渡效果，就会应用在窗口的显示和隐藏。若没有指定，默认使用 :var:`config.window_show_transition` 和
:var:`config.window_hide_transition` 的值。指定None则不使用任何过渡效果。

窗口自身可以通过调用 :var:`config.empty_window` 显示。 窗口默认旁白说了一句话，内容为空字符串。::

    ###
        show bg washington
        show eileen happy
        with dissolve

        window show dissolve

        "我可以说话……"

        show eileen happy at right
        with move

        "……和移动，在窗口显示的情况下。"

        window hide dissolve

.. _image-functions:

图像(image)函数
===============

.. function:: renpy.add_layer(layer, above=None, below=None, menu_clear=True, sticky=None)

    界面中添加一个新的图层。如果已存在同名图层，则该函数没有任何效果。

    *behind* 或 *above* 参数至少一项不能为None。

    `layer`
        一个字符串，指定待添加图层的名称。

    `above`
        若不是None，应该是一个字符串，表示待添加的新图层需要在对应图层的上层。

    `below`
        若不是None，应该是一个字符串，表示待添加的新图层需要在对应图层的下层。

    `menu_clear`
        若为True，进入游戏菜单上下文时该图层将清空，离开游戏菜单上下文时恢复图层显示内容。

    `sticky`
        若为True，所有实用tag标签在该图层显示的内容都可将该图层设置为默认图层，直到该图层隐藏。
        若为None，仅当其他粘滞图层存在时，该图层才会替换其他粘滞图层并成为新的粘滞图层。

.. function:: renpy.can_show(name, layer=None, tag=None)

    该函数判断入参 *name* 代表的图像是否能显示。函数把入参 *name* 看做一个图像标签(tag)和属性(attribute)。该函数依据目前正显示在 *图层* 上的所有 *tag* 来尝试确认唯一的图像。若存在唯一可显示图像，则以元组形式返回图像名。否则返回None。

    `tag`
        图像标签(tag)属性。若为空，默认使用入参name的第一个组件。

    `layer`
        需要确认的图层(layer)名。若为空，则默认使用 *tag* 所在图层。

.. function:: renpy.change_zorder(layer, tag, zorder)

    修改图层 *layer* 上标签为 *tag* 图像的zorder值。

.. function:: renpy.check_image_attributes(tag, attributes)

    根据给定的tag和attributes检查是否存在唯一图像。若存在，按顺序返回图像属性(attribute)。否则返回None。

.. function:: renpy.clear_attributes(tag, layer=None)

    清楚带有 `tag` 标签的图像属性(attribute)。
    如果tag不带任何图像属性，则无事发生。

    `layer`
        待检查的图层。若为None，则使用 `tag` 对应的默认图层。

.. function:: renpy.copy_images(old, new)

    复制图像，并更换新图像的前缀名。样例：

    ::

        renpy.copy_images("eileen", "eileen2")

    将复制所有以“eileen”开头的图像并创建以“eileen2”开头的新图像。若“eileen happy”存在，则创建“eileen2 happy”。

    `old`
        原图片名的字符串，图片名各部分以空格分隔。

    `new`
        新图片名的字符串，图片名各部分以空格分隔。

.. function:: renpy.flush_cache_file(fn)

    该函数会将所以引用文件 *fn* 的图像缓存都清空。
    需要Ren'Py强制更新图像文件时可以调用该函数。

.. function:: renpy.get_attributes(tag, layer=None)

    根据入参图片标签 *tag* ，返回对应图像属性(attribute)的元组。若图像整在显示，则返回None。

    `layer`
        待检图层(layer)。若为空，使用 *tag* 所在的默认图层。

.. function:: renpy.get_available_image_tags()

    返回一个列表，包含所有已定义的图像标签。

.. renpy.get_hidden_tags(layer='master')

    返回指定图层上，当前处于隐藏状态却依然有相关属性信息的图像标签的集合。

.. renpy.get_image_bounds(tag, width=None, height=None, layer=None)

    如果带有指定 *tag* 的图像显示在图层 *lay* 上，则返回图像的包围盒。
    如果符合条件的图像不存在，则返回None。

    包围盒是一个 (x, y, width, height) 形式的元组。
    每个元素都表示像素数量，有可能是浮点值。

    `width, height`
        包含目标图像的矩形区域的宽度和高度。
        若为None，则默认值分别是界面的宽度和高度。

    `layer`
        若为None，使用tag对应的默认图层。

.. function:: renpy.get_ordered_image_attributes(tag, attributes=(), sort=None)

    返回图像标签(tag)列表，按照对用户来说合理的方式排序。

    `attributes`
        若该值不为空，只寻找与给定属性(attribute)兼容的结果。(兼容的意思是，各类属性在同一时间里能找到对应唯一图像。)

    `sort`
        若不为None，返回的属性(attribute)列表就是排序后的。该单入参函数应当用作中断器(tiebreaker)。
        详见 `这篇教程 <https://docs.python.org/3/howto/sorting.html#key-functions>`_ 。

.. function:: renpy.get_placement(d)

    该函数获取到可视组件d的位置。返回的位置信息可信度很低，因为可视组件在渲染后可能被改变了，也可能可视组件在首次渲染之前根本不存在。

    该函数返回的对象包含以下字段(field)，每一个都对应一项样式特性(property)：

    **- pos**
    **- xpos**
    **- ypos**
    **- anchor**
    **- xanchor**
    **- yanchor**
    **- offset**
    **- xoffset**
    **- yoffset**
    **- subpixel**

.. function:: renpy.get_registered_image(name)

    如果有 :ref:`已注册 <defining-images>` 的同名图像则返回图像对象。
    否则返回None。

.. function:: renpy.get_say_image_tag()

    返回当前发言角色对应的图像标签(tag)(角色获得的图像入参)。如果当前没有角色发言或当前发言角色没有对应的图像标签(tag)则返回None。

.. function:: renpy.get_showing_tags(layer='master')

    返回入参 *layer* 图层上显示的所有图像标签(tag)的集。

.. function:: renpy.get_zorder_list(layer)

    返回图层 *layer* 的(tag, zorder)列表。

.. function:: renpy.has_image(name, exact=False)

    若入参name为名的图像存在返回真(true)，若不存在返回假(false)。

    `name`
        一个图像名的字符串，或者图像名各组件的元组。

    `exact`
        只有跟name全匹配的图像名存在时才返回真(true)——部分匹配则返回假(false)。

.. function:: renpy.mark_image_seen(name)

    将对应名称的图像在当前用户系统上标记为显示过。

.. function:: renpy.mark_image_unseen(name)

    将对应名称的图像在当前用户系统上标记为未显示过。

.. function:: renpy.seen_image(name)

    若名为name的图像在用户系统中至少被看到过一次，就返回真(true)。图像被看到的定义是，其在show、scene语句或者renpy.show()函数中出现过。(注意这里的“被看到”并不意味着真的被用户看见过，比如show语句后面马上跟一个hide语句的情况也属于“被看到”过。)

.. function:: renpy.showing(name, layer='master')

    若与name同名标签的图像整在图层  *layer* 上显示，则返回真(true)。

    `image`
        可能是一个给定图像名的字符串，或者给定图像名各组件的元组。还可以只是给定图像标签(tag)的字符串。

    `layer`
        待检图层(layer)。若为None，使用 *tag* 所在默认图层。

.. function:: renpy.start_predict(*args)

    该函数接受一个或多个可视组件作为入参。该函数触发Ren'Py在每次交互行为中预加载入参中的可视组件，直到使用 func:`renpy.stop_predict()` 移除预加载的那些可视组件。
    如果可视组件名称字符串一个包含1个或多个 \\* 字符，则视为一个通配表达式。
    如果字符串中至少存在一个英文句号 . ，表达式将对整个文件名进行匹配，否则将不匹配文件扩展名。
    例如：

    ::

        $ renpy.start_predict("eileen *")

    预加载所有名为eileen的所有图片。而：

    ::

        $ renpy.start_predict("images/concert*.*")

    匹配images目录下所有以concert开头的文件。

.. function:: renpy.stop_predict(*args)

    该函数接受一个或多个可视组件作为入参。该函数触发Ren'Py停止在每次互动行为中预加载入参中的可视组件。

.. _di-see-also:

其他参考
========

:doc:`statement_equivalents` ：关于如何在Python中使用本章节提到的大部分功能。

:doc:`displayables` ：其他可显示对象，不限于基本的图片。