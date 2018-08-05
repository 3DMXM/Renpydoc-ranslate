.. _drag-and-drop:

拖放组件
=============

Ren'Py含有一些拖放组件，这些组件允许使用鼠标在界面上任意移动。关于拖拽功能的使用有以下要点：

* 存储窗口坐标，允许用户重新调整窗口坐标。
* 能把卡牌在界面上随意拖拽的卡牌游戏。(例如，solitaire纸牌)
* 背包系统。
* 拖拽记录系统。

拖放组件提供不仅限于自身的拖放功能。这里主要涉及两个类。Drag类提供让一些东西能够在界面上拖动的功能，让其他可拖动组件掉落在自己上面的功能，或者两者兼有。DragGroup类提供了Drag的群组功能——当拖放发生时，作为同一个DragGroup内的一部分，组内所有Drag对象都需要做出响应。

拖放系统可以通过 :ref:`Screen Language <screens>` 使用，或者直接用作可视组件。当你创建Drag对象后不再需要引用这些对象，最好使用界面语言。典型的情况是，可拖拽组件显示了一个用于放置在界面里的窗口。如果你在创建Drag对象后还需要引用，通常更好的做法是直接创建Darg对象并把它们添加到一个DragGroup对象中。

.. _drag-drop-displayables:

可视组件
------------

.. class:: Drag(d=None, drag_name=None, draggable=True, droppable=True, drag_raise=True, dragged=None, dropped=None, drag_handle=(0.0, 0.0, 1.0, 1.0), drag_joined=..., clicked=None, hovered=None, unhovered=None, mouse_drop=False, **properties)

  一个可视组件，提供了一个对象，可以在其有效区域内使用鼠标拖拽。一个Drag对象还有供其他Drag对象可以掉落在上面的区域。

  一个Drag对象可以在父对象(parent)内部随意移动。通常，Drag的父对象是一个 :func:`Fixed()` 或 :class:`DragGroup` 。

  一个Drag对象有一个子组件。子组件的状态反映出拖放操作的状态：

  - ``selected_hover`` - 当其被拖拽时。
  - ``selected_idle`` - 当其被放下时。
  - ``hover`` - 鼠标已点击而拖拽未发生时。
  - ``idle`` - 其他情况。

  拖拽句柄(handle)是一个子组件内的矩形。当鼠标进到拖拽句柄里的非透明像素上方时，就允许发生拖拽或点击。

  一个新创建的可拖拽组件会被添加到默认的DragGroup中。一个可拖拽组件只能在一个DragGroup里。一旦被添加到另一个组中，就会自动被上一个组移除。

  当某个Drag对象首次渲染时，如果从其所在的DragGroup中无法获得坐标，就使用标准布局算法计算出它的左上角坐标。

  `d`
    若存在，这就是Drag对象的子组件。如果不是None，Drag对象就使用子组件的样式。

  `drag_name`
    若非None，表示可拖拽组件的名称。也可以用作可拖拽对象的名称特性(property)。如果有或曾经有一个可拖拽组件，名称相同，也在DragGroup当中，它将取代原来的可拖拽对象的起始位置。

  `draggable`
    若为True，Drag对象可以使用鼠标拖拽。

  `droppable`
    若为True，其他Drag对象可以放在该Drag对象上。

  `drag_raise`
    若为True，该Drag对象被拖拽是会升到最高层。如果其与其他Drag对象连在一起，相连的Drag对象都会升到最高层。

  `dragged`
    一个回调函数(或回调函数列表)，当Drag对象被拖拽时被调用。调用时使用两个入参。第一个参数是被拖拽的Drag对象列表。第二个参数是某个可以掉落其上的Drag对象，或者None表示不会落下。如果回调函数返回一个非None，这个值也会作为此次交互动作的返回结果。

  `dropped`
    一个回调函数(或回调函数列表)，当Drag对象落下时被调用。调用时使用两个入参。第一个参数表示掉落在哪个Drag对象上。第二个参数是一个被拖拽的Drag对象列表。如果回调函数返回一个非None，这个值也会作为此次交互动作的返回结果。

    当dragged和dropped回调函数被同一个事件消息触发，那么仅在dragged回调函数返回None的情况dropped回调函数才会被调用。

  `clicked`
    不使用入参的回调函数，当Drag对象仅仅被点击而没有移动的情况下调用。droppalbe也可以得到焦点并被点击。如果回调函数返回一个非None，这个值也会作为此次交互动作的返回结果。

  `drag_handle`
    一个(x, y, width, height)形式的元组，给定了子组件拖拽句柄的坐标信息。在这个元组中，整数被看作像素数的值，浮点数被看作子组件尺寸的比例分数。

  `drag_joined`
    使用当前Drag对象作为入参的回调函数。一般返回一个[ (drag, x, y) ]格式的元组列表，表示可拖拽组件连在一起组层一个单元。 *x* 和 *y* 是各个拖拽组件之间的偏移量，与Drag左上角的坐标无关。

  `drag_offscreen`
    若为True，draggable可以移出屏幕。这样设置有潜在风险，使用drag_joined或可以改变尺寸的Drag对象，一旦被拖离出屏幕，就没有办法把它们弄回来了。

  `mouse_drop`
    若为True，Drag对象会掉落在光标下第一层的droppable上。若为False，也是默认值，Drag对象掉落在overlap最大度数的droppab上。

  除了 *d* ，所有的参数都在Drag对象的字段(field)中。除此之外，在Drag对象被渲染后，下列域里的值也变成可用状态：

  `x, y`
    Drag对象相对于自身父组件的坐标，单位为像素。

  `w, h`
    Drag对象子组件的宽度和高度，单位为像素。

  .. method:: bottom(self)

    降低该可视组件的高度，降到其所在drag_group的底层。

  .. method:: set_child(d)

    将该Drag对象的子组件设为d。

  .. method:: snap(x, y, delay=0)

    修改Drag对象的坐标。如果Drag对象没有显示，坐标的改变瞬时完成。否则，坐标的改变会耗时 *dalay* 秒，生成线性移动的动画。

  .. method:: top(self)

    升高该可视组件的高度，升到其所在drag_group的顶层。

.. class:: DragGroup(*children, **properties)

  表示一个Drag对象组。某个Drag对象受限于整个DragGroup。掉落只在同一个组内的Drag对象间发生。组内的Drag对象可以会被抬升高度。

  DragGroup的布局类似 :func:`Fixed()` 。

  DragGroup构造函数的所有固定位置参数都是需要添加到DragGroup的Drag对象。

  .. method:: add(child)

    添加Drag对象作为DragGroup的子组件(child)。

  .. method:: get_child_by_name(name)

    返回该DragGroup中名为 *name* 的第一个子组件。

  .. method:: remove(child)

    移除该DragGroup中的子组件child。

.. _examples:

样例
--------

这个样例中，在say界面允许用户拖拽窗口并选择放在界面的任意位置。

::

    screen say:

        drag:
            drag_name "say"
            yalign 1.0
            drag_handle (0, 0, 1.0, 30)

            xalign 0.5

            window id "window":
                # 确保窗口尺寸小于整个界面。
                xmaximum 600

                has vbox

                if who:
                    text who id "who"

                text what id "what"

这是一个稍微复杂的样例，展示了如何拖拽功能如何用在游戏流程中，还有如何使用拖拽功能将一个角色移动到某个位置：

::

    init python:

        def detective_dragged(drags, drop):

            if not drop:
                return

            store.detective = drags[0].drag_name
            store.city = drop.drag_name

            return True

    screen send_detective_screen:

        # 作为背景的地图。
        add "europe.jpg"

        # DragGroup确保每个侦探可以拖拽到每个城市。
        draggroup:

            # 侦探们
            drag:
                drag_name "Ivy"
                child "ivy.png"
                droppable False
                dragged detective_dragged
                xpos 100 ypos 100
            drag:
                drag_name "Zack"
                child "zack.png"
                droppable False
                dragged detective_dragged
                xpos 150 ypos 100

            # 可选的城市。
            drag:
                drag_name "London"
                child "london.png"
                draggable False
                xpos 450 ypos 140
            drag:
                drag_name "Paris"
                draggable False
                child "paris.png"
                xpos 500 ypos 280

    label send_detective:
        "我们需要调查！应该派谁去哪里？"

        call screen send_detective_screen

        "好的，我们派 [detective] 去 [city]。"

更复杂的系统需要使用更重要的编程技巧才能搞定。 `Ren'Py cardgame framework <http://www.renpy.org/wiki/renpy/Frameworks#Cardgame>`_
是一个在复杂系统如何使用拖放功能和制作卡牌游戏两方面都很有用的例子。
