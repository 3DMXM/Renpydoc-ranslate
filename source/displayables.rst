.. _displayables:

可视组件
============

可视组件是一类可以向用户显示的对象。Ren'Py可视组件具有多种用途。

* 使用image语句声明一个图像名。
* 使用screen language add语句添加至界面(screen)。
* 声明某个配置变量。
* 声明某个样式特性。

当Ren'Py函数或者变量需要一个可视组件时，总共可用的东西有5种：

* 典型的可视组件(displayable)对象，通过调用本章后面提到的某些函数创建。
* 一个带英文冒号 ``:`` 的字符串。很少使用，详见下面 :ref:`可视组件前缀 <displayable-prefixes>` 部分。
* 一个带英文句号(.)的字符串。该字符串在传入 :func:`Image` 函数后被作为一个文件名处理。
* 一种颜色。可能是十六进制表示的颜色字符串格式——比如 “#rgb”、“#rgba”、“#rrggbb”或“#rrggbbaa”，可能是一个 :class:`Color`，也可能是一个(r, g, b, a)格式的元组，元组中每个元素的值都位于0到255的闭区间内。颜色会被传入 :func:`Solid` 函数。
* 一个图像名。所有字符串拼接后，引用某个使用image语句定义的图像。图像名可以由image语句定义，或者从 :ref:`images目录 <images-directory>` 中自动定义。
* 一个列表。如果提供的是一个列表，列表中的物件(item)会按后面描述的方式展开，并逐个检查是否能匹配到某个文件名或图像名。如果匹配成功，列表物件展开会停止，匹配到的内容会按照刚才提到的几种方式处理。

字符串中允许存在一个或多个用方括号包含的带替换内容，比如“eileen [mood]”和“eileen_[outfit]_[mood].png”这样形式的。一旦出现了类似的字符串，引擎就会创建出动态图像。动态图像在每次互动行为(比如say语句和菜单)开始阶段，具有
:ref:`文本内插 <text-interpolation>` 的行为表现。最终生成的字符串会按照上文提到的规则处理。

如果某个字符串含有一个子字符串 "[prefix\_"] ，就会使用当前可视组件关联样式的前缀替换该子字符串。

.. _images:

图像
------

最常见的可视组件是通过加载硬盘上的一个文件并显示的图像(image)。由于图像是如此常用，所以每当某个上下文中某字符串给出了一个文件名，并需要将这个文件用作可视组件时，引擎就会自动创建一个图像(image)对象。唯一需要直接使用图像(image)对象的情况是，你想创建一个带样式特性的图像。

.. function:: Image(filename, *, optimize_bounds=True, oversample=1, dpi=96, **properties)

    从文件中加载一个图像。 `filename` 是一个字符串，表示加载的文件名。

    `filename`
        应该是一个图片文件名，包括扩展名。


    `optimize_bounds`
        若为True，图片在一个不透明像素构成的包围框(bounding box)内的部分才会加载到显存中。
        (只有将图片作为着色器输入时，才可能需要将该项设置为False。)

    `oversample`
        若该参数大于1，表示图像需要过采样(oversample)，实际像素数比逻辑尺寸大。
        例如分辨率为2048×2048，过采样率为2的图片文件，在各种布局计算时都当作1024×1024大小的图片。

    `dpi`
        SVG图片的DPI。默认值为96。增大该参数可以把SVG图片渲染得更大，反之则渲染得更小。

::

    # 这两行等价。
    image logo = "logo.png"
    image logo = Image("logo.png")

    # 使用Image()允许我们指定一个默认位置截取某个图像的一部分。
    image logo right = Image("logo.png", xalign=1.0)

以下四种是推荐使用的图片文件格式：

* AVIF
* Webp
* Png
* Jpg

推荐的矢量图文件格式：

* SVG

没有动画的Gif文件和Bmp文件也是支持的，但已经不推荐用在本世代游戏中。

从硬盘加载文件，解码图像并将图像绘制到屏幕上，这一系列工作耗时比较长。因此加载过程需要几十甚至上百毫秒的话，就无法提供一个可接受的帧率，并会让用户觉得恼怒。

因为图像是一个固定尺寸，在大多数情况下都不会更改图像的可视区域，所以可以在图像真正使用之前提前加载，并放入内存的图片缓存中。图片解码并放入缓存之后，就可以很高效地绘制在屏幕上了。

Ren'Py会预测未来使用的图像，加载文件后先放入图像缓存备用。当图像缓存空间不足时，Ren'Py会先删除不会再被使用到的那些图像。

默认情况下，Ren'Py会预先缓存相当于8个界面大小的图像数据。(如果你的界面分辨率是800×600，那一个界面大小相当于一张800×600的图像，两张400×600的图像，以此类推。)这个值可以通过 :var:config.image_cache_size 配置项修改。

尽管精确的数值取决于规则细节，并且也存在一些明确的标准。一个最基础的规则是，图像缓存中的每一个像素，都占用4个字长的主内存和4个字长的显存。

.. _svg-images:

SVG图片
----------

Ren'Py支持SVG 1.0标准的图片，使用的是NanoSVG库。一些 **不支持** 的功能特性如下：

* 文本类元素直接忽略。如果文本已转换为路径(path)，则可以渲染出来。
* 内嵌的位图(bitmap)直接忽略。
* 内置脚本直接忽略。
* 动画直接忽略。

NanoSVG库支持的功能特性详见 `这里 <https://core.tcl-lang.org/tips/doc/trunk/tip/507.md>`_ 。

推荐将所有SVG图片中无法渲染的内容都转换为路径(path)。

Ren'Py渲染SVG图片时假设虚拟界面的分辨率为96dpi.
如果窗口拉大或缩小，SVG图片将等比缩放，:ref:`过采样 <oversampling>` 会用于确保图片能以正确的虚拟尺寸渲染。

SVG图片在缩放后依然能保持锐度。

.. _image-like-displayables:

类图像的可视组件
-----------------------

我们将这些可视组件称作“类图像”，是因为他们占用界面中的一块矩形区域但不会对输入做任何反应。
有别于通常的图像，这些“类图像”可以调整尺寸填充某个区域(Frame、Tile、Solid)，或者允许用户指定尺寸(Composite、Crop、Null)。这些“类图像”不是图像处理器(Image Manipulator)。

类图像可视组件使用 :ref:`position-style-properties`。

.. function:: AlphaMask(child, mask, **properties)

    可视组件使用入参 *child* 作为自身的颜色，其alpha通道值使用 *child* 的alpha通道值与 *mask* 的乘积。因此，该可视组件具有 *child* 同样的颜色，当 *child* 或 *mask* 之一是透明的情况下该组件也是透明，当 *child* 和 *mask* 都不透明的情况下该组件才不透明。

    *child* 和 *mask* 可以是任意可视组件。AlphaMask的尺寸是 *child* 和 *mask* 的重叠区域尺寸。

    需要注意，该函数与im.AlphaMask()使用不同的入参，im.AlphaMask()还使用入参mask的颜色通道。

.. function:: Borders(left, top, right, bottom, pad_left=0, pad_top=0, pad_right=0, pad_bottom=0)

    border对象提供边界(border)尺寸和码放(tile)给 :func:`Frame()` 对象。其也可以提供填充( :func:`padding` )信息，用于带填充特性的窗口(window)或者框架(frame)。

    `left top right bottom`
        这些参数提供的某个框架(frame)需要使用的插入尺寸，以及各条边的填充(padding)边界。这些值应该是0或者正整数。

    `pad_left pad_top pad_right pad_bottom`
        这些参数会添加到各条边填充(padding)的值，可以是正整数或负整数。(例如，如果 *left* 是5， *pad_left* 是-3，那么最终的填充(padding)值就是2。)

    填充(padding)信息是一个字段(field)：

    .. attribute:: padding

        这是一个4元素的元组，包含了矩形4条边的填充(padding)信息。

.. function:: Composite(size, *args, **properties)

    这个函数使用其他可视组件合成并创建一个新的可视组件。新可视组件的尺寸由 *size* 决定。 *size* 是一个(width, height)形式的元组，两个元素分别表示宽度和高度。

    保留的固定位置参数用于放置LiveComposite中的图像。保留的固定位置参数应该是由两个数据构成的组。组中的第一个元素是一个(x, y)形式的元组；第二个元素是合成用的可视组件，使用前一个元素表示的位置进行合成。

    可视组件的合成顺序为从后往前。

    ::

        image eileen composite = Composite(
            (300, 600),
            (0, 0), "body.png",
            (0, 0), "clothes.png",
            (50, 50), "expression.png")

.. function:: Crop(rect, child, **properties)

    这个函数使用 *rect* 剪裁 *child* 并创建一个新的可视组件。 *rect* 是一个(x, y, width, height)形式的元组。

    ::

        image eileen cropped = Crop((0, 0, 300, 300), "eileen happy")

.. function:: DynamicImage(name)

    动态图像是一种可视组件，这个组件包含文本内插(text interpolation)字符串。那些待内插的文本内容补完后就能生成一个新的可视组件对象。每一项互动行为开始后都会执行文本内插补完字符串。

.. function:: Flatten(child, **properties)

    该对象将可能由多个纹理组成的入参 *child* ，压成单个纹理。

    某些操作，比如变换特性alpha，会应用到最终构成可视组件的每一个纹理上。最终的可视组件会剔除错误结果，比如界面上的纹理有重叠。Flatten对象根据多个纹理创建单个纹理的时，能避免这些问题。

    Flatten是一个性能消耗高昂的操作，应该在必要的情况下才使用。

.. function:: Frame(image, left=0, top=0, right=None, bottom=None, tile=False, **properties)

    Frame是一个可视组件，可以调整图像尺寸使其匹配某个可用区域，同时也保存其边界(border)的宽度和高度。Frame通常用于窗口(window)或按钮(button)的背景。

    .. figure:: frame_example.png

        使用框架(frame)将图像增大为原尺寸的两倍。

    `image`
        一个可以被框架(frame)调整尺寸的图像处理器。

    `left`
        左边框的边界(border)尺寸。此入参也可以是一个 :func:`Border()` 对象，这种情况下其他几个参数也都被这个Border对象一块代替。

    `top`
        上边框的边界(border)尺寸。

    `right`
        右边框的边界(border)尺寸。如果为None，则默认与  *left* 一样。

    `bottom`
        下边框的边界(border)尺寸。如果为None，则默认与  *top* 一样。

    `tile`
        若该值为True，使用码放(tile)形式重新调整图像区域尺寸，否则使用缩放(scale)形式。

    ::

        # 文本窗口过小时重新调整背景尺寸
        init python:
            style.window.background = Frame("frame.png", 10, 10)

.. function:: Null(width=0, height=0, **properties)

    在界面上创建一个空框(box)的可视组件。框的尺寸由 *width* 和 *height* 控制。这个对象用在某个可视组件需要一个子组件且找不到合适的子组件时，或者在box里充当空白。

    ::

        image logo spaced = HBox("logo.png", Null(width=100), "logo.png")

.. function:: Solid(color, **properties)

    将声明的颜色 *color* 填满自身所有区域的可视组件。

    ::

        image white = Solid("#fff")

.. function:: Tile(child, style='tile', **properties)

    将 *child* 以码放形式填充整个可视组件区域。

    ::

        image bg tile = Tile("bg.png")

.. _gui-text-displayables:

文本组件
-----------------

参见 :ref:`text-displayables` 。

.. _dynamic-displayables:

动态可视组件
--------------------

动态可视组件会基于游戏状态显示一个子组件。

需要注意，动态可视组件总是显示它们的当前状态。因此，动态可视组件参与转场(transition)。(准确的说，转场过程中动态可视组件总是显示同样的东西。)

根据设计，动态可视组件用于从定义到离开界面都很少改变的要素(比如自定义角色系统)，而不是用于经常变化的内容，比如角色表情。

.. function:: ConditionSwitch(*args, predict_all=None, **properties)

    基于Python条件表达式，改变自身显示内容的可视组件。固定位置入参应该是一组两个值的形式，每组分别包含：

    - 包含Python表达式语句的字符串。
    - 当条件表达式为True时显示的组件。

    第一条为True的条件表达式会显示自己的可视组件，所以需要保证至少一个条件表达式永远为True。

    这里使用的条件表达式不应该有明显的副作用。

    `predict_all`
        若为True，当显示可视组件时，所有可能的可视组件都会提前缓存。若为False，只加载当前条件表达式的可视组件。若为None，使用 :func:`config.conditionswitch_predict_all` 的配置。

    ::

        image jill = ConditionSwitch(
            "jill_beers > 4", "jill_drunk.png",
            "True", "jill_sober.png")

.. class:: DynamicDisplayable(function, *args, **kwargs)

    基于某个Python函数可以改变自身子组件的可视组件，作用范围贯穿于某次互动行为。
    此类对象不能使用任何特性，因为其布局是由子组件的特性所决定。

    `function`
        该入参是一个函数，调用时可使用以下参数：

        * 可视组件的显示时间。
        * 具有相同标签(tag)的任意可视组件的显示时间。
        * 任何固定位置的或关键字入参用于DynamicDisplayable类对象。

        并返回一个(d, redraw)元组。这个元组中：

        * `d` 是需要显示的可视组件。
        * `redraw` 是再次调用该函数的间隔等待时间，如果是空值(None)的话就不会再次调用函数直到下次互动行为。

        每次互动后，`function` 函数都会被调用。

    有一个特殊情况，`function` 可能是一个Python字符串并可以等效为一个可视组件。在那种情况下，每个互动行为中function都只能运行一次。

    ::

        # 显示一个从5到0的倒计时，每十分之一秒更新直到计时结束。
        init python:

            def show_countdown(st, at):
                if st > 5.0:
                    return Text("0.0"), None
                else:
                    d = Text("{:.1f}".format(5.0 - st))
                    return d, 0.1

        image countdown = DynamicDisplayable(show_countdown)

.. function:: ShowingSwitch(*args, predict_all=None, **properties)

    基于目前界面上正在显示图像，能更改自身显示内容的可视组件。固定位置入参应该是一组两个值的形式，每组分别包含：

    - 一个指定图像名的字符串，或者用None表示默认图像。
    - 在条件表达式为True时使用的可视组件。

    默认图像需要提前指定。

    `predict_all`
        若为True，当显示可视组件时，所有可能的可视组件都会提前缓存。若为False，只加载当前条件表达式的可视组件。若为None，使用 :func:`config.conditionswitch_predict_all` 的配置。

    ShowingSwitch的一个用途是，根据角色感情更改角色边栏头像。例如：

    ::

        define e = Character("Eileen",
            show_side_image=ShowingSwitch(
                "eileen happy", Image("eileen_happy_side.png", xalign=1.0, yalign=1.0),
                "eileen vhappy", Image("eileen_vhappy_side.png", xalign=1.0, yalign=1.0),
                None, Image("eileen_happy_default.png", xalign=1.0, yalign=1.0),
                )
            )

.. _layer-displayables:

图层可视组件
------------------

图层可视组件会基于游戏的某些状态值在某个图层上显示内容。
图层可视组件设计为与 :var:`config.detached_layers` 协同使用。

图层可视组件与动态可视组件类似，图层显示的内容由当前状态值决定。
因此，图层可视组件不受转场效果的影响。除非某个转场指定目标就是图层可视组件对应的图层。

.. class:: Layer(layer, **properties)

    该类可以让某个图层像可视组件一样覆盖在其他图层上。设计为与独立图层(detached layer)协同使用。
    
    不能把图层覆盖在自身上。
    
    `layer`
        需要显示的图层。

    `clipping`
        若为False，图层内容可以超过自身范围的部分依然显示。否则超出范围的部分将被剪裁。

        配置项config.layer_clipping的值会覆盖此参数的值。

::

    # 定义一个新的名为broadcast的独立图层
    define config.detached_layers += [ "broadcast" ]

    # 定义一个新的名为tv的图层可视组件，用于显示图层broadcast的内容
    image tv = Window(Layer("broadcast"), background='#000', padding=(10, 10))

    image living_room = Placeholder('bg', text='living_room')
    image studio = Solid('7c7')
    image eileen = Placeholder('girl')

    label example:
        pause

        # 设置broadcast图层的场景
        scene studio onlayer broadcast
        with None

        # 开启新场景living_room
        scene living_room

        # 在屏幕右下角显示图层可视组件tv
        show tv:
          align (.75, .75) zoom .3

        # 在broadcast图层显示Eileen
        show eileen onlayer broadcast

        # 以dissolve转场进入living room场景，同时Eillen从画面右侧进入。
        with {'master': dissolve, 'broadcast': moveinright}
        pause


.. _applying-transforms-to-displayables:

应用于可视组件的变换(transform)
-----------------------------------

At函数使用某个可视组件和若干个 :ref:`变换(transform) <transforms>` 产生一个新的可视组件。

.. function:: At(d, *args)

    对给定的源可视组件 *d* ，将 *args* 中所有变换(transform)都应用于该组件。所有变换(transform)参数的应用顺序是从左到右，所以最外层的变换(transform)效果是最右边的入参。

    ::

        transform birds_transform:
            xpos -200
            linear 10 xpos 800
            pause 20
            repeat

        image birds = At("birds.png", birds_transform)

.. _layout-boxes-and-grids:

布局框和坐标系
----------------------

布局框是在界面上设置其子组件布局的可视组件。其可以使用水平布局或者垂直布局，也可以使用标准位置算法设置布局。

框式可视组件可以使用任意数量的固定位置参数和关键词参数。固定位置参数会被以子组件的形式加入框体中。关键词参数则是应用于框体的各种样式特性。

框体使用 :ref:`position-style-properties` 和 :ref:`box-style-properties`。

.. function:: Fixed(*args, **properties)

    充满整个界面的框体。该框体成员的布局顺序从后往前，使用自身的位置特性控制显示位置。

.. function:: HBox(*args, **properties)

    框体内成员布局顺序从左到右。

.. function:: VBox(*args, **properties)

    框体内成员布局顺序从上到下。

::

    # 显示两个logo，分别位于左边和右边。
    image logo hbox = HBox("logo.png", "logo.png")

    # 显示两个logo, 一个在另一个上方。
    image logo vbox = VBox("logo.png", "logo.png")

    # 显示两个logo。
    # 由于默认情况下，其他位置显示的图像与界面左上方显示的一致，
    # 我们需要使用其他图片替换那些不需要logo的地方。
    image logo fixed = Fixed(
        Image("logo.png", xalign=0.0, yalign=0.0),
        Image("logo.png", xalign=1.0, yalign=1.0))


坐标布局会在界面上建立一个坐标系，并显示其子组件。其使用
:ref:`position-style-properties` 和 :propref:`spacing` 样式特性。

.. function:: Grid(*args, **properties)

    在一个坐标系中布局可视组件。前两个固定位置参数分别对应坐标中的列号和行号。固定位置参数的 *columns \* rows* 给定了坐标系中所能容纳的可视组件总数。

.. _effects:

特效
-------

这些可视组件通常用于创建某种视觉特效。

.. function:: AlphaBlend(control, old, new, alpha=False)

    这种过渡(transition)效果用于从一个可视组件(大多数使用某种动画变化)过渡到另一个。当变换(transform)完全不透明时，新的可视组件会被启用；当变化完全透明时，旧的可视组件会被启用。

    `alpha`
        若该值为True，前后图像会相互混合。若该值为False，也就是默认值，前面的图像会显示半透明，覆盖在后面的图像上。

.. _image-manipulators:

图像处理器
------------------

:doc:`图像处理器 <im>` 本身是一个可视组件。它会接受一个图像或者另一个图像处理器对象，对原有对象进行某些处理。图像处理器只接受图像或其他图像处理器作为输入。

任何能放可视组件的地方也可以放图像处理器，但反过来不一定可行。 :func:`Image` 对象是一种图像处理器，所以任何需要使用图像处理器的地方都可以使用image对象。

图像处理的应用具有重大意义。过去的一些图像处理器由于各种的问题不应再使用。
除了使用 :func:`im.Data` 的情况，可视组件 :func:`Transform` 提供了很多类似的功能，并同时修复了过去的问题。

图像处理器的详情请参见 :doc:`图像处理器 <im>` 。

.. _placeholders:

占位组件
------------

占位组件(placeholder)用于正确显示背景图或者角色图像。在开发者模式下，使用某个未定义的图像时，占位组件会被自动使用。如果你觉得默认的显示有问题，也可以手动指定占位组件的使用。

::

    # 默认情况下，会使用girl占位组件。
    image sue = Placeholder("boy")

    label start:
         show sue angry
         "苏" "你还好吗？现在，受死吧！"

.. function:: Placeholder(base=None, full=False, flip=None, text=None, **properties)

    该可视组件可以用于显示一个占位角色或背景。

    `base`
        显示图像的类型。应该是以下类型之一：

        'bg'
            显示一个背景占位组件。这个组件会以浅灰填满整个界面，并在界面上方显示图像名。

        'boy'
            显示一个“记为男性”的占位组件，胸口位置显示图片名。

        'girl'
            显示一个“记为女性”的占位组件，胸口位置显示图片名。

        None
            尝试自动确认图像用途。如果图像名以“bg”、“cg”或者“event”开头，则取值'bg'。

            否则，使用'girl'占位组件。

    `full`
        若该值为True，使用全身像的精灵(sprite)。否则，使用3/4像的精灵(sprite)。

    `flip`
        若该值为True，精灵(sprite)会水平翻转。

    `text`
         若指定了该项，显示占位符时会使用此项文本。若没有指定，则会使用对应占位符自带的文本。

.. _displayable-prefixes:

可视组件前缀
--------------------

可视组件可以使制作者定义他们自己的可视组件，并且涉及到所有Ren'Py可以用到可视组件的地方。
一个带前缀的可视组件名是一个带有英文冒号的字符串。前缀在冒号左边，参数在冒号右边。
:var:`config.displayable_prefix` 变量将前缀对应到一个函数。函数接受此参数，并返回一个可视组件或None。

比如说，这个例子创建一个big前缀，返回一个原来两倍大的图像。

::

    init -10 python:
        def embiggen(s):
            return Transform(s, zoom=2)

        config.displayable_prefix["big"] = embiggen

``init -10`` 确保前缀在任何图像使用它之前被定义。
然后前缀可以用来定义图像：

::

    image eileen big = "big:eileen happy"

或者其他需要显示可视组件的地方。

.. _displayable-see-also:

其他参考
--------

:doc:`displaying_images` ：这页介绍了如果制作以上可视组件并在界面上显示。
