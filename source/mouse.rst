.. _custom-mouse-cursors:

定制鼠标光标
-------------

Ren'Py有两套系统可实现定制鼠标光标。
一种是利用硬件鼠标光标，另一种是在Ren'Py中绘制一个可视组件当作鼠标光标。

硬件鼠标光标有两个优点：

* 非常快。
* 消耗低。使Ren'Py有更多时间执行其他工作。

同时也有两个限制：

* 光标只能是小尺寸。至少一个32×32像素的，常用的大尺寸也不过64×64像素.
* 光标只能使用图像文件序列。

使用Ren'Py绘制一个可视组件用作光标可是跳出这些限制。
光标可以是Ren'Py能绘制的任何东西。当计算机启用图像三重缓存时，Ren'Py绘制光标可能会出现明显的延迟，而硬件光标不会。

.. _hardware-mouse-cursor:

硬件鼠标光标
---------------------

硬件鼠标光标由配置项 :var:`config.mouse` 控制。
该配置项是一个字典型数据，将鼠标名称映射为一个序列帧列表。
每个序列帧都是一个三元元组，依次表示图片文件名、图片内部的X和Y轴偏移量。

例如：

::

    define config.mouse = { }
    define config.mouse['default'] = [ ( "gui/arrow.png", 0, 0) ]
    define config.mouse['spin' ] = [
        ( "gui/spin0.png", 7, 7 ),
        ( "gui/spin1.png", 7, 7 ),
        ( "gui/spin2.png", 7, 7 ),
        ( "gui/spin3.png", 7, 7 ),
        ( "gui/spin4.png", 7, 7 ),
        ( "gui/spin5.png", 7, 7 ),
        ( "gui/spin6.png", 7, 7 ),
        ( "gui/spin7.png", 7, 7 ),
    ]

若动画由多帧组成，帧率为20fps。Ren'Py只能修改光标的图片或偏移量。

.. _displayable-mouse-cursor:

可视组件鼠标光标
------------------------

可视组件光标使用配置项 :var:`config.mouse_displayable` 的值，以及MouseDisplayable类型的可视组件。
下面是一个样例：

::

    image mouse spin:
        "gui/spin0.png"
        rotate 0.0
        linear 1.0 rotate 360.0

        # 暂停，等待图像预加载
        pause 1.0

        repeat

    define config.mouse_displayable = MouseDisplayable(
        "gui/arrow.png", 0, 0).add("spin", "mouse spin", 9.9, 9.9)

.. function:: MouseDisplayable(cursor, x, y)

    用作替换鼠标光标的可视组件。当用户在屏幕内移动鼠标时，该可视组件将跟随鼠标一起移动。

    `cursor`
        用作绘制光标的可视组件

    `x, y`
        热区(hotspot)坐标，以鼠标左上角的为原点，虚拟像素数。

.. _using-mouse-cursors:

使用鼠标光标
------------

使用鼠标光标的通常方法是，对界面内某个可以获得焦点的组件(按钮或者条)使用 ``mouse`` 特性，指定光标名称。
例如：

::

    screen test():
        textbutton "鼠标测试" actiuon NullAction mouse "spin"

还可以使用 :var:`default_mouse` 设置全局鼠标光标：

::

    $ default_mouse = "spin"