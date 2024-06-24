.. _transitions:

===================
转场(transition)
===================

在Ren'Py中，转场(transition)可以用作  :ref:`with 语句
<with-statement>` 及其他语句的一部分，用于场景切换时提供各种效果。Ren'Py自带一些预定义的转场(transition)效果，可以在with语句中直接使用。Ren'Py中还包含transition类，可以用于创建新的transition对象。

.. _pre-defined-transitions:

预定义的转场(Pre-Defined Transitions)
========================================

预定义的转场(transition)可以直接使用在with语句中。举例：

::

    show bg washington
    with dissolve

.. var:: fade

    0.5秒时间画面逐渐暗淡至全黑，然后0.5秒时间画面从全黑逐渐变亮成新界面。一个 :func:`Fade()` 转场类的实例。

.. var:: dissolve

    0.5秒时间，使用溶解效果从旧界面切到新界面。一个 :func:`Dissolve()` 转场类的实例。

.. var:: pixellate

    0.5秒像素化旧场景，并0.5秒反向像素化至新场景。一个 :func:`Pixellate()` 转场类的实例。

.. var:: move

    0.5秒时间，将图像移动到新的位置。一个 :func:`MoveTransition()` 的转场实例。

    move转场，与ease转场类似，只能使用 :ref:`with语句 <with-statement>` 应用在单个图层或同时应用在所有图层。
    其不能在其他场景下生效，比如 :ref:`ATL <expression-atl-statement>`、:func:`ComposeTransition` 等。

.. var:: moveinright

    及： **moveinleft, moveintop, moveinbottom**

    从界面上对应的边界移入图像，用时0.5秒。

.. var:: moveoutright

    及： **moveoutleft, moveouttop, moveoutbottom**

    从界面上对应的边界移出图像，用时0.5秒。

.. var:: ease

    及： **easeinright, easeinleft, easeintop, easeinbottom, easeoutright, easeoutleft, easeouttop, easeoutbottom**

    类似于上面的move系列转场效果，差别在于ease系列基于余弦曲线放缓开始和结束的转场。

.. var:: zoomin

    镜头放大切入图像，耗时0.5秒。

.. var:: zoomout

    镜头缩小离开图像，耗时0.5秒。

.. var:: zoominout

    先镜头放大切入图像，然后镜头缩小离开图像，耗时0.5秒。

.. var:: vpunch

    这种转场效果，会垂直摇晃界面0.25秒。
    若要修改此转场和 :var:`hpunch`，可以使用 :ref:`atl-transitions`.

.. var:: hpunch

    这种转场效果，会水平摇晃界面0.25秒。

.. var:: blinds

    垂直遮蔽原界面，耗时1秒。一个 :func:`ImageDissolve()` 转场类的实例。

.. var:: squares

    以平面效果转场界面，耗时1秒。

.. var:: wipeleft

    及： **wiperight, wipeup, wipedown**

    以指定方向擦除原界面。 :func:`CropMove()` 转场类的实例。

.. var:: slideleft

    及： **slideright, slideup, slidedown**

    以指定方向滑入新场景。 :func:`CropMove()` 转场类的实例。

.. var:: slideawayleft

    及： **slideawayright, slideawayup, slideawaydown**

    以指定方向滑出旧场景。 :func:`CropMove()` 转场类的实例。

.. var:: pushright

    及： **pushleft, pushup, pushdown**

    新场景把旧场景从指定的边界推出。 :func:`PushMove()` 转场类的实例。

.. var:: irisin

    及： **irisout**

    使用一个矩形iris显示新界面，或者隐藏旧界面。 :func:`CropMove()` 转场类的实例。

.. _transition-classes:

转场(transition)类
==================

转场(transition)类是可以用于创建新转场效果的功能函数。这些函数是参数化的，允许创建一个系列的转场。

使用with语句就可以调用转场类。举例：

::

    # 一个持续时间10秒的溶解转场
    with Dissolve(10.0)

如果我们经常调用同一个转场效果，可以使用 :ref:`define语句 <define-statement>` 把转场效果声明为一个变量。

::

    define annoytheuser = Dissolve(1.0)

    label start:
        show bg washington
        with annoytheuser

time_warp参数可以使用 ``_warper`` 模块中内建warper类中对应的多个转场对象，
详见 :ref:`warpers <warpers>` 。

.. class:: AlphaDissolve(control, delay=0.0, alpha=False, reverse=False)

    返回一个转场(transition)效果，其使用一个控制组件(大多数情况下是某些动画)实现新旧界面的转场。transform表达式会进行计算。当transform完全不透明时新界面被启用，而transform完全透明时依然使用旧界面。

    `control`
        控制transform。

    `delay`
        转场效果使用时间。

    `reverse`
        若该值为True，alpha通道值反转。不透明区域来自旧图像，而透明区域来自新图像。

    `mipmap`
        如果溶解转场会将图片缩小至原尺寸的一半以下，可以将 :propref:`mipmap` 样式特性设置为True。
        生成mipmap会消耗更多GPU资源，但能减少显示瑕疵。详见 :propref:`mipmap` 。

.. class:: ComposeTransition(trans, before, after)

    返回由三种转场合成的一个转场效果。 `before` 和 `after` 转场会分别应用在旧场景和新场景，前提是这两个参数非None。被更新后的旧场景和新场景最后还会应用 `trans` 转场效果。

    ::

        # 旧场景图像从左侧移出，新场景图像从右侧移入，同时使用溶解效果。(这是一个系统消耗比较大的转场。)
        define moveinoutdissolve = ComposeTransition(dissolve, before=moveoutleft, after=moveinright)

.. class:: CropMove(time, mode='slideright', startcrop=(0.0, 0.0, 0.0, 1.0), startpos=(0.0, 0.0), endcrop=(0.0, 0.0, 1.0, 1.0), endpos=(0.0, 0.0), topnew=True)

    返回一个转场效果，其会剪裁一个场景并将其放置在界面中指定位置。其可以模板化处理一堆效果，这些效果的共通点是将界面分割成矩形条(slice)。

    `time`
        转场效果耗时。

    `mode`
        转场模式名。转场模式总共有3大类：wipes、slides、其他。也可以是“custom”，是一个用户自己定义的模式。

        在wipe模式下，原图像先保持不变，然后逐渐使用转场效果全部擦除。例如，在“wiperight”模式下，一个刷子会从左到右擦除原图像，即先擦除界面最左边的图像，接着擦除界面中间，最后擦除界面最右边。其他的wipe包括“wipeleft”、“wipedown”和“wipeup”。

        在slide模式下，图像会移动。在“slideright”模式下，图像的右边从界面的左边开始，平移至界面右边，完成整个转场过程。其他slide模式包括“slideleft”、“slidedown”和“slideup”。

        还有slideaway模式，这个模式下原图像在新图像上层，平移出界面。slideaway模式包括“slideawayright”、“slideawayleft”、“slideawayup”和“slideawaydown”。

        我们还支持矩形iris，包括“irisin”和“irisout”。

    下列参数值在模式为“custom”的情况下才会使用。位置信息与界面尺寸相关，剪裁大小与图像尺寸相关。一个(0.25, 0.0, 0.5, 1.0)的剪裁会使用某个图像的中间一小块。

    `startcrop`
        顶层图像的剪裁起始矩形。一个4元素的元组，包含x、y、width和height。

    `startpos`
        顶层图像绘制在界面上起始坐标。一个2元素的元组，包含x和y。

    `endcrop`
        顶层图像的剪裁结束矩形。一个4元素的元组，包含x、y、width和height。

    `endpos`
        顶层图像绘制在界面上结束坐标。一个2元素的元组，包含x和y。

    `topnew`
        若该值为True，被剪裁和移动的是新场景。若该值为False，被剪裁和移动的是旧场景。

    ::

        define wiperight = CropMove(1.0, "wiperight")
        define wipeleft = CropMove(1.0, "wipeleft")
        define wipeup = CropMove(1.0, "wipeup")
        define wipedown = CropMove(1.0, "wipedown")

        define slideright = CropMove(1.0, "slideright")
        define slideleft = CropMove(1.0, "slideleft")
        define slideup = CropMove(1.0, "slideup")
        define slidedown = CropMove(1.0, "slidedown")

        define slideawayright = CropMove(1.0, "slideawayright")
        define slideawayleft = CropMove(1.0, "slideawayleft")
        define slideawayup = CropMove(1.0, "slideawayup")
        define slideawaydown = CropMove(1.0, "slideawaydown")

        define irisout = CropMove(1.0, "irisout")
        define irisin = CropMove(1.0, "irisin")

.. class:: Dissolve(time, *, time_warp=None, mipmap=None)

    返回一个使用溶解效果切换新旧场景的转场效果。

    `time`
        溶解效果持续时间。

    `time_warp`
        一个 :ref:`调整时间线的功能函数 <warpers>`。若不为None，其应该是一个使用0.0至1.0之间的小数作为输入的函数，返回结果也是0.0至1.0之间。

    `mipmap`
        如果溶解转场会将图片缩小至原尺寸的一半以下，可以将 :propref:`mipmap` 样式特性设置为True。
        生成mipmap会消耗更多GPU资源，但能减少显示瑕疵。详见 :propref:`mipmap` 。

.. class:: Fade(out_time, hold_time, in_time, *, color='#000')

    返回一个转场效果，其使用入参 `out_time` 时间(单位为秒)，逐渐将整个界面填充为 `color` 指定的颜色，维持这个界面 `hold_time` 指定的时间(单位为秒)，最后使用入参 `in_time` 时间(单位为秒)逐渐切换为新界面。

    ::

        # 逐渐变黑并还原。
        define fade = Fade(0.5, 0.0, 0.5)

        # 保持全黑界面1秒。
        define fadehold = Fade(0.5, 1.0, 0.5)

        # 镜头闪光——快速且为纯白，然后恢复原界面。
        define flash = Fade(0.1, 0.0, 0.5, color="#fff")

.. class:: ImageDissolve(image, time, ramplen=8, *, reverse=False, time_warp=None, mipmap=None)

    返回一个转场效果，其使用溶解特效切换新旧界面，并利用某个图像控制溶解过程。这意味着纯白的像素首先被溶解，而纯黑的像素最后溶解。

    `image`
        使用的控制图像。其必须是一个图片文件或者图像控制器。控制图像需要与待溶解场景的尺寸一致。

    `time`
        溶解效果持续时间。

    `ramplen`
        色彩蔓延(ramp)步长。其必须是一个2的整次幂。默认值是8，当纯白像素全部溶解之后，下一步溶解的像素是在灰度上比纯白色低8度的颜色。

    `reverse`
        若该值为True，黑色像素反而先于白色像素溶解。

    `time_warp`
        一个 :ref:`调整时间线的功能函数 <warpers>`。若不为None，其应该是一个使用0.0至1.0之间的小数作为输入的函数，返回结果也是0.0至1.0之间。

    `mipmap`
        如果溶解转场会将图片缩小至原尺寸的一半以下，可以将 :propref:`mipmap` 样式特性设置为True。
        生成mipmap会消耗更多GPU资源，但能减少显示瑕疵。详见 :propref:`mipmap` 。

    ::

        define circirisout = ImageDissolve("circiris.png", 1.0)
        define circirisin = ImageDissolve("circiris.png", 1.0, reverse=True)
        define circiristbigramp = ImageDissolve("circiris.png", 1.0, ramplen=256)

    如果溶解转场会将图片缩小至原尺寸的一半以下，可以将 :propref:`mipmap` 样式特性设置为True。
    生成mipmap会消耗更多GPU资源，但能减少显示瑕疵。

.. class:: MoveTransition(delay, *, enter=None, leave=None, old=False, layers=['master'], time_warp=_warper.linear, enter_time_warp=_warper.linear, leave_time_warp=_warper.linear)

    使用这些转场时，图像会用新旧场景插值计算，因此移动场景切换会更顺滑。

    由于只有图层标签(layer tag)，MoveTransition只能使用 :ref:`with语句 <with-statement>` 应用在单个图层或同时应用在所有图层。
    其不能在其他场景下生效，比如 :ref:`ATL <expression-atl-statement>`、:func:`ComposeTransition` 等。
    在不同上下文(context)中无法使用MoveTransition，
    例如 :ref:`ATL <expression-atl-statement>`、:func:`ComposeTransition` 等其他转场。

    `delay`
        插入效果耗时。

    `old`
        若该值为True，转场过程过图像发生变化时，使用旧图像而不是新图像。
        否则，使用新图像。

    `layers`
        移动的图层(layer)列表。

    下面两个参数可以使用变换(transform)赋值，并且动效时间不应长于整个转场时间。

    `enter`
        若该值非空，图像所进入的场景会一同移动。 *enter* 的值应是一个应用在图像行的变换(transform)，该变换可以获取其起始坐标。

    `leave`
        若该值非空，图像所离开的场景会一同移动。 *leave* 的值应是一个应用在图像行的变换(transform)，该变换可以获取其结束坐标。

    下面三个参数可以使用 :ref:`调整时间线的功能函数 <warpers>` 赋值，一个使用0.0至1.0之间的小数作为输入的函数，返回结果也是0.0至1.0之间。

    `time_warp`
        应用于图像位移效果的时间warp函数。

    `enter_time_warp`
        应用于图像进入场景的时间warp函数。

    `leave_time_warp`
        应用于图像离开场景的时间warp函数。

    ::

        define longer_easein = MoveTransition(3.0, enter=offscreenright, enter_time_warp=_warper.easein)

    下列代码中，“a”会离开当前场景(用到 `leave` 和 `leave_time_warp`)，“b”会修改位置(用到 `time_warp`)，
    “c”会进入当前场景(用到 `enter` 和 `enter_time_warp`)。
    由于转场前后的tag相同，所以“d”不会离开场景并重新进入，而是只发生平移。

    ::

        define some_move_trans = MoveTransition(...)

        label start:
            show a
            show b at left
            show ugly_eileen as d at right
            e "This is a dialogue !"

            hide a
            show b at right
            show c
            show pretty_eileen as d at left
            with some_move_trans

    当组件“d”移动时，会根据 `old` 的取值决定显示 ugly_eileen 还是 pretty_eileen：
    如果 `old` 为默认值False，ugly_eileen会立刻变为pretty_eileen然后移动；
    如果 `old` 为True，ugly_eileen会先移动到目标位置再立刻变为pretty_eileen。

.. class:: MultipleTransition(args)

    返回一个转场效果，其是多个转场效果顺序显示之后的结果。

    `args`
        一个包含奇数个元素的 **列表**。列表中奇数序号的元素必须是场景，偶数序号的元素必须是转场效果。这里说的场景可以是如下类别之一：

        - 可视组件。
        - False值，表示使用旧场景。
        - True值，表示使用新场景。

        大多数情况下，第一个元素会是False而最后一个是True。

        注意，整个列表是一个参数，而不是 ``*args``。

    `args` 中的转场按顺序执行。对每一个转场效果而言，其前面的参数就是旧场景，其后面的参数就是新场景。举例：

    ::

        define logodissolve = MultipleTransition([
            False, Dissolve(0.5),
            "logo.jpg", Pause(1.0),
            "logo.jpg", dissolve,
            True])

    这个例子中，首先会使用溶解效果切换到logo.jpg文件，等待1秒钟后，再使用溶解效果切换至新场景。

.. class:: Pause(delay)

    返回一个转场效果，其会在 `delay` 秒后显示新的场景。这个转场效果可以用作MultipleTransition的一部分。

.. class:: Pixellate(time, steps)

    返回一个转场效果，其使用像素化切换新旧场景。

    `time`
        转场效果总耗时，单位为秒。

    `steps`
        在各个方向展开像素化使用的步数。每一步都会创建出上一步两倍宽度和高度的像素方块，所以5步像素化就能创建出32×32大小的像素方块。

.. class:: PushMove(time, mode="pushright")

    返回一个转场效果，其使用新场景把旧场景“推”出界面。

    `time`
        转场效果耗时。

    `mode`
        总共有4种模式：“pushright”、“pushleft”、“pushup”和“pushdown”，对应旧场景被“推”出界面的方向。

    ::

        define pushright = PushMove(1.0, "pushright")
        define pushleft = PushMove(1.0, "pushleft")
        define pushup = PushMove(1.0, "pushup")
        define pushdown = PushMove(1.0, "pushdown")

.. class:: Swing(delay=1.0, vertical=False, reverse=False, background="#000", flatten=True)

    一个转场效果。将旧场景绕某个轴旋转90度，此时画面是该场景一条边；切换为新场景并继续旋转90度。

    `delay`
        转场持续时间。

    `vertical`
        若为True，场景绕x轴旋转(像素在垂直方向移动)。若为False，场景绕y轴旋转(像素在水平方向移动)。

    `reverse`
        若为True，反向旋转。

    `background`
        场景旋转时，显示为背景的可视组件。

    `flatten`
        若为True，场景内元素将编排为屏幕尺寸相同的图像进行旋转。
        某些图像没有完整显示在屏幕中导致不希望出现的效果时，可以设置该参数。

.. _transition-families:

转场族群
===================

转场族群是可以定义一系列相关转场效果的函数。

.. function:: define.move_transitions(prefix, delay, time_warp=None, in_time_warp=None, out_time_warp=None, old=False, layers=[u'master'], **kwargs)

    该函数定义了 :class:`MoveTransition <MoveTransition>` 转场效果的族群，类似于 :var:`move` 和 :var:`ease` 转场。
    根据给定的入参 `prefix` ，其定义了以下转场效果：

    * *prefix* ——一个转场效果，其使用 `delay` 秒时间，将图像移动至新坐标。
    * *prefix*\ inleft， *prefix*\ inright， *prefix*\ intop， *prefix*\ inbottom —— 这些转场效果，使用 `delay` 秒时间，将图像移动至新坐标，并将新的图像从对应的界面边缘移入界面。
    * *prefix*\ outleft， *prefix*\ outright， *prefix*\ outtop， *prefix*\ outbottom —— 这些转场效果，使用 `delay` 秒时间，将图像移动至新坐标，并将新的需要隐藏的图像从对应的界面边缘移出界面。

    :class:`MoveTransition` 类的其他参数如下：

    `time_warp, in_time_warp, out_time_warp`
        :ref:`调整时间线的功能函数 <warpers>` 是根据输入的图像移动完成时间(取值范围为0.0值1.0)，返回一个图像直线运动的完成时间比例(取值范围为0.0值1.0)。

        该功能让图像运动速度复合缓动(ease)曲线，而不是让所有图像以一个统一恒定的速度移动。

        三个变量分别对应停留在界面的图像、新显示的图像和新隐藏的图像。

    `old`
        若该值为True，某标签(tag)对应的图像在转场过程中使用旧图像；否则使用新图像。

    `layers`
        应用转场效果的图层(layer)名。

    ::

        # 这条语句定义了所有以“move”开头的预定义转场效果的delay时间
        init python:
            define.move_transitions("move", 0.5)


.. _dict-transitions:

字典转场(Dict Transitions)
=============================

在很多Ren'Py用到转场的地方，可以用一个字典存放各图层和转场的映射关系。这种情况下，Ren'Py会给每个图层应用一个合适的转场。

当用到dict时，不会发生转场时通常发生的暂停。相反的是，dict语句立即返回字典，并且转场在下一次交互时开始执行。

这可以与main图层一起使用，以便在界面(screen)上显示对话时发生转场。举个例子，如果我们写成：

::

    define dis = { "master" : Dissolve(1.0) }

和：

::

    show eileen happy
    with dis

    e "Hello, world."

溶解效果将在文本显示的时候发生。

字典层转场不能在所有能用转场的地方使用，只有在能给一个层应用的转场时它才能使用。可以使用 ``with`` 语句和scene、show、hide语句的 ``with`` 子句。它也可以和 :func:`renpy.with_statement` ，
:func:`renpy.transition` ， :func:`Show` and :func:`Hide` 行为和一系列接受转场的config变量一起使用。 字典层*不会*在不能作用于层的功能上起作用，比如ATL，:func:`ComposeTransition`
和 :func:`MultipleTransition`。

这可能与导致转场发生的语句互动不佳，就像由 ``window auto`` 产生的转场。这通常可以通过适用于不同层次的第二个字典转场来解决。举例来说，如果你发现当对话窗口显示和隐藏时出现了奇怪的闪动，试着把 options.rpy改成：

::

    define config.window_show_transition = { "screens" : Dissolve(.25) }
    define config.window_hide_transition = { "screens" : Dissolve(.25) }

因为对话窗口整个都在界面(screen)层上所以可以修复这个问题。

.. _scene-show-hide-transition:

在scene、show和hide语句后自动应用转场
=================================================

Ren'Py可以在在scene、show和hide语句后自动显示某个转场。
该自动转场设置在 :var:`_scene_show_hide_transition` 项。

所有 ``scene``、``show`` 和 ``hide`` 语句都会应用此转场，除了下面几种情况：
* 后面带with从句
* ``window`` 语句之类，由 :ref:`dialogue-window-management` 控制转场
* 菜单上下文(context)中

例如：

::

    define _scene_show_hide_transition = Dissolve(0.25)

    label start:
        scene bg washington
        show eileen happy

        "由于对话框使用自己的转场，前面定义的溶解转场不会出现。"

        show lucy mad at right

        "前面定义的溶解转场会出现在这里。"

        hide lucy mad
        show eileen vhappy

        "这里会再次出现。"

.. _transition-see-also:

其他参考
========

:ref:`atl-transitions`、:ref:`使用Python的转场 <transitions-python>` ：
两部分分别阐述了如何使用ATL系统和Python创建转场。