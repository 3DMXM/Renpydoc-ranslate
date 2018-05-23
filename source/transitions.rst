.. _transitions:

===========
转场(transition)
===========

在Ren'Py中，转场(transition)可以用作  :ref:`with 语句
<with-statement>`及其他语句的一部分，用于场景切换时提供各种效果。Ren'Py自带一写预定义的转场(transition)效果，可以在with语句中直接使用。Ren'Py中还包含transition类，可以用于创建新的transition对象。

预定义的转场（Pre-Defined Transitions）
=======================

预定义的转场(transition)可以直接使用在with语句中。举例：::

    show bg washington
    with dissolve

.. var:: fade

    0.5秒时间画面逐渐暗淡至全黑，然后0.5秒时间画面从全黑逐渐变亮成新界面。一个 :func:`Fade()` 转场类的实例。

.. var:: dissolve

    0.5秒时间，使用溶解效果从旧界面切到新界面。一个 :func:`Dissolve()` 转场类的实例。

.. var:: pixellate

    0.5秒像素化旧场景，并0.5秒反向像素化至新场景。一个 :func:`Pixellate()` 转场类的实例。

.. var:: move

    通过在图像上移动位置切换场景。一个 :func:`MoveTransition()` 的转场实例。

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

    及： **pushleft, pushtop, pushbottom**

    新场景把旧场景从指定的边界推出。 :func:`PushMove()` 转场类的实例。

.. var:: irisin

    及： **irisout**

    使用一个矩形iris显示新界面，或者隐藏旧界面。 :func:`CropMove()` 转场类的实例。

转场(transition)类
==================

转场(transition)类是可以用于创建新转场效果的功能函数。这些函数是参数化的，允许创建一个系列的转场。

使用with语句就可以调用转场类。举例：::

    # 一个持续时间10秒的溶解转场
    with Dissolve(10.0)

如果我们经常调用同一个转场效果，可以使用 :ref:`define语句 <define-statement>` 把转场效果声明为一个变量。::

    define annoytheuser = Dissolve(1.0)

    label start:
         show bg washington
         with annoytheuser


         .. function:: AlphaDissolve(control, delay=0.0, alpha=False, reverse=False)

           返回一个转场(transition)效果，其使用一个控制组件(大多数情况下是某些动画)实现新旧界面的转场。transform表达式会进行计算。当transform完全不透明时新界面被启用，而transform完全透明时依然使用旧界面。

           **control**

             控制transform。

           **delay**

             转场效果使用时间。

           **alpha**

             若该值为真(true)，图像会与其后面的图像混合。若该值为假(false)，图像完全不透明，并会覆盖在后面的图像上。

           **reverse**

             若该值为真(true)，alpha通道值反转。不透明区域来自旧图像，而透明区域来自新图像。

         .. function:: ComposeTransition(trans, before, after)

           返回由三种转场合成的一个转场效果。 *before* 和 *after* 转场会分别应用在旧场景和新场景，前提是这两个参数非空。被更新后的旧场景和新场景最后还会应用 *trans* 转场效果。

           ::

               # 旧场景图像从左侧移出，新场景图像从右侧移入，同时使用溶解效果。(这是一个系统消耗比较大的转场。)
               define moveinoutdissolve = ComposeTransition(dissolve, before=moveoutleft, after=moveinright)

         .. function:: CropMove(time, mode="slideright", startcrop=(0.0, 0.0, 0.0, 1.0), startpos=(0.0, 0.0), endcrop=(0.0, 0.0, 1.0, 1.0), endpos=(0.0, 0.0), topnew=True)

           返回一个转场效果，其会剪裁一个场景并将其放置在界面中指定位置。其可以模板化处理一堆效果，这些效果的共通点是将界面分割成矩形条(slice)。

           **time**

             转场效果耗时。

           **mode**

             转场模式名。转场模式总共有3大类：wipes、slides、其他。也可以是“custom”，是一个用户自己定义的模式。

             在wipe模式下，原图像先保持不变，然后逐渐使用转场效果全部擦除。例如，在“wiperight”模式下，一个刷子会从左到右擦除原图像，即先擦除界面最左边的图像，接着擦除界面中间，最后擦除界面最右边。其他的wipe包括“wipeleft”、“wipedown”和“wipeup”。

             在slide模式下，图像会移动。在“slideright”模式下，图像的右边从界面的左边开始，平移至界面右边，完成整个转场过程。其他slide模式包括“slideleft”、“slidedown”和“slideup”。

             还有slideaway模式，这个模式下原图像在新图像上层，平移出界面。slideaway模式包括“slideawayright”、“slideawayleft”、“slideawayup”和“slideawaydown”。

             我们还支持矩形iris，包括“irisin”和“irisout”。

           下列参数值在模式为“custom”的情况下才会使用。位置信息与界面尺寸相关，剪裁大小与图像尺寸相关。一个(0.25, 0.0, 0.5, 1.0)的剪裁会使用某个图像的中间一小块。

           **startcrop**

             顶层图像的剪裁起始矩形。一个4元素的元组，包含x、y、width和height。

           **startpos**

             顶层图像绘制在界面上起始坐标。一个2元素的元组，包含x和y。

           **endcrop**

             顶层图像的剪裁结束矩形。一个4元素的元组，包含x、y、width和height。

           **endpos**

             顶层图像绘制在界面上结束坐标。一个2元素的元组，包含x和y。

           **topnew**

             若该值为真(true)，被剪裁和移动的是新场景。若该值为假(false)，被剪裁和移动的是旧场景。

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

         .. function:: Dissolve(time, alpha=False, time_warp=None)

           返回一个使用溶解效果切换新旧场景的转场效果。

           **time**

             溶解效果持续时间。

           **alpha**

             若该值为真(true)，溶解效果会使用alpha通道。若该值为假(false)，直接替换原界面，这样效率比较高。

           **time_warp**

             一个调整时间线的功能函数。若不为空值(None)，其应该是一个使用0.0至1.0之间的小数作为输入的函数，返回结果也是0.0至1.0之间。

         .. function:: Fade(out_time, hold_time, in_time, color="#000")

           返回一个转场效果，其使用 *out_time* 入参时间(单位为秒)，逐渐将整个界面填充为 *color* 指定的颜色，维持这个界面 *hold_time* 指定的时间(单位为秒)，最后使用 *in_time* 入参时间(单位为秒)逐渐切换为新界面。

           ::

               # 逐渐变黑并还原。
               define fade = Fade(0.5, 0.0, 0.5)

               # 保持全黑界面1秒。
               define fadehold = Fade(0.5, 1.0, 0.5)

               # 镜头闪光——快速且为纯白，然后返回原界面。
               define flash = Fade(0.1, 0.0, 0.5, color="#fff")

         .. function:: ImageDissolve(image, time, ramplen=8, reverse=False, alpha=True, time_warp=None)

           返回一个转场效果，其使用溶解特效切换新旧界面，并利用某个图像控制溶解过程。这意味着纯白的像素首先被溶解，而纯黑的像素最后溶解。

           **image**

             使用的控制图像。其必须是一个图片文件或者图像控制器。控制图像需要与待溶解场景的尺寸一致。

           **time**

             溶解效果持续时间。

           **ramplen**

             色彩蔓延(ramp)步长。其必须是一个2的整次幂。默认值是8，当纯白像素全部溶解之后，下一步溶解的像素是在灰度上比纯白色低8度的颜色。

           **reverse**

             若该值为真(true)，黑色像素反而先于白色像素溶解。

           **alpha**

             若该值为真(true)，溶解效果会使用alpha通道。若该值为假(false)，直接替换原界面，这样效率比较高。

           **time_warp**

             一个调整时间线的功能函数。若不为空值(None)，其应该是一个使用0.0至1.0之间的小数作为输入的函数，返回结果也是0.0至1.0之间。

           ::

               define circirisout = ImageDissolve("circiris.png", 1.0)
               define circirisin = ImageDissolve("circiris.png", 1.0, reverse=True)
               define circiristbigramp = ImageDissolve("circiris.png", 1.0, ramplen=256)

         .. function:: MoveTransition(delay, enter=None, leave=None, old=False, layers=['master'], time_warp=None, enter_time_warp=None, leave_time_warp=None)

           返回一个转场效果，其插入了新旧界面中图像(使用相同的图像标签tag)的坐标。

           **delay**

             插入效果耗时。

           **enter**

             若该值非空，图像所进入的场景会一同移动。 *enter* 的值应是一个应用在图像行的变换(transform)，该变换可以获取其起始坐标。

           **leave**

             若该值非空，图像所离开的场景会一同移动。 *leave* 的值应是一个应用在图像行的变换(transform)，该变换可以获取其结束坐标。

           **old**

             若该值为真(true)，旧图像会被使用而不是新图像。

           **layers**

             移动的图层(layer)列表。

           **time_warp**

             应用于插入效果的时间warp函数。其是一个使用0.0至1.0之间的小数作为输入的函数，返回结果也是0.0至1.0之间。

           **enter_time_warp**

             应用于图像进入场景的时间warp函数。

           **leave_time_warp**

             应用于图像离开场景的时间warp函数。

         .. function:: MultipleTransition(args)

           返回一个转场效果，其是多个转场效果顺序显示之后的集。

           **args**

             一个包含奇数个物件的列表。列表中奇数序号的物件必须是场景，偶数序号的物件必须是转场效果。这里说的场景可以是如下类别之一：

             - 可视组件。
             - false值，表示使用旧场景。
             - true值，表示使用新场景。

             大多数情况下，第一个入参会是false而最后一个是true。

           *args* 中的转场按顺序执行。对每一个转场效果而言，其前面的参数就是旧场景，其后面的参数就是新场景。举例：

           ::

               define logodissolve = MultipleTransition([
                   False, Dissolve(0.5),
                   "logo.jpg", Pause(1.0),
                   "logo.jpg", dissolve,
                   True])

           这个例子中，首先会使用溶解效果切换到logo.jpg文件，等待1秒钟后，再使用溶解效果切换至新场景。

         .. function:: Pause(delay)

           返回一个转场效果，其会在 *delay* 秒后显示新的场景。这个转场效果可以用作MultipleTransition的一部分。

         .. function:: Pixellate(time, steps)

           返回一个转场效果，其使用像素化切换新旧场景。

           **time**

             转场效果总耗时，单位为秒。

           **steps**

             在各个方向展开像素化使用的步数。每一步都会创建出上一步两倍宽度和高度的像素方块，所以5步像素化就能创建出32×32大小的像素方块。

         .. function:: PushMove(time, mode="pushright")

           返回一个转场效果，其使用新场景把旧场景“推”出界面。

           **time**

             转场效果耗时。

           **mode**

             总共有4种模式：“pushright”、“pushleft”、“pushup”和“pushdown”，对应旧场景被“推”出界面的方向。

           ::

               define pushright = PushMove(1.0, "pushright")
               define pushleft = PushMove(1.0, "pushleft")
               define pushup = PushMove(1.0, "pushup")
               define pushdown = PushMove(1.0, "pushdown")

转场族群
===================

转场族群是可以定义一系列相关转场效果的函数。

.. function:: define.move_transitions(prefix, delay, time_warp=None, in_time_warp=None, out_time_warp=None, old=False, layers=[u'master'], **kwargs)

  该函数定义了move转场效果的族群，类似于move和ease转场。根据给定的入参 *prefix* ，其定义了以下转场效果：

  - *prefix* ——一个转场效果，其使用 *delay* 秒时间，将图像移动至新坐标。
  - *prefixinleft* ， *prefixinright* ，*prefixintop* ，*prefixinbottom* —— 这些转场效果，使用 *delay* 秒时间，将图像移动至新坐标，并将新的图像从对应的界面边缘移入界面。
  - *prefixoutleft* ， *prefixoutright* ，*prefixouttop* ，*prefixoutbottom* —— 这些转场效果，使用 *delay* 秒时间，将图像移动至新坐标，并将新的需要隐藏的图像从对应的界面边缘移出界面。

  **time_warp, in_time_warp, out_time_warp**

    时间扭曲功能是根据输入的图像移动完成时间(取值范围为0.0值1.0)，返回一个图像直线运动的完成时间比例(取值范围为0.0值1.0)。

    该功能让图像运动速度复合缓动(ease)曲线，而不是让所有图像以一个统一恒定的速度移动。

    三个变量分别对应停留在界面的图像、新显示的图像和新隐藏的图像。

  **old**

    若该值为真(true)，转场效果作用于旧的可视组件，而不是新的那些。

  **layers**

    应用转场效果的图层(layer)名。

  ::

      # 这条语句定义了所有以“move”开头的预定义转场效果的delay时间
      init python:
          define.move_transitions("move", 0.5)


.. _dict-transitions:

字典转场（Dict Transitions）
================

在很多Ren'Py用到转场的地方啊，可以用一个字典对应很多层名来应用到多层的转场。这种情况下，Ren'Py给每一层运用一个合适的转场。

当用到dict时，不会发生转场时通常发生的暂停。相反的是，dict语句立即返回字典，并且转场在下一次交互时开始执行。

这可以与主层一起使用，以便在界面(screen)上显示对话时发生转场。举个例子，如果我们写成::

    define dis = { "master" : Dissolve(1.0) }

和::

    show eileen happy
    with dis

    e "Hello, world."

溶解效果将在文本显示的时候发生。

字典层转场不能在所有能用转场的地方使用，只有在能给一个层应用的转场时它才能使用。可以使用``with``语句和scene、show、hide语句的``with``子句。它也可以和 :func:`renpy.with_statement` ，
:func:`renpy.transition` ， :func:`Show` and :func:`Hide` 动作和一系列接受转场的config变量一起使用。 字典层*不会*在不能作用于层的功能上起作用，比如ATL，:func:`ComposeTransition`
和 :func:`MultipleTransition`。

这可能与导致转场发生的语句互动不佳，就像由``window auto``产生的转场。这通常可以通过适用于不同层次的第二个字典转场来解决。举例来说，如果你发现当对话窗口显示和隐藏时出现了奇怪的闪动，试着把 options.rpy改成：::

    define config.window_show_transition = { "screens" : Dissolve(.25) }
    define config.window_hide_transition = { "screens" : Dissolve(.25) }

因为对话窗口整个都在界面(screen)层上所以可以修复这个问题。
