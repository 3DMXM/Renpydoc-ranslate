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

若该项是多帧动画，则固定以20fps帧率播放。Ren'Py会在图片或偏移值变化后同步修改光标。

下表列举了光标可能处于的各种状态，以及相应使用场景：

.. list-table::
 :header-rows: 1

 * - 状态关键词
   - 使用场景

 * - ``default``
   - 所有场景的缺省项。该项必须赋值，在没有明确指定场景关键词时都将使用该项。

 * - ``say``
   - 用户处于“say”界面时使用该项。

 * - ``with``
   - 转场时使用该项。

 * - ``menu``
   - 用户处于菜单(例如分支选项菜单)时将使用该项。

 * - ``prompt``
   - 提示用户进行输入时使用该项。

 * - ``imagemap``
   - 在imagemap组件上使用。

 * - ``button``
   - 用户鼠标悬停在某个button或imagebutton组件上时使用该项。

 * - ``pause``
   - 暂停或调用renpy.pause()函数时，使用该项。

 * - ``mainmenu``
   - 主菜单。

 * - ``gamemenu``
   - 游戏菜单(gamemenu界面)。

每个状态关键词都附带一个可选的 ``pressed_`` 前缀，表述鼠标左键按下之后切换光标图案。
例如，``pressed_button`` 会在用户点击某个按钮之后改变光标。
若要定义默认情况下按下鼠标左键时的光标样式，可以直接使用 ``pressed_default`` 关键词。
只要没有其他 ``pressed_`` 的状态关键词，就都会应用该默认光标。

样例：

::

    define config.mouse = { }
    define config.mouse['default'] = [ ( "gui/arrow.png", 0, 0) ]
    define config.mouse['pressed_default'] = [ ( "gui/arrow_pressed.png", 0, 0) ]
    define config.mouse['button'] = [ ( "gui/arrow_button.png", 0, 0) ]
    define config.mouse['pressed_button'] = [ ( "gui/arrow_button_pressed.png", 0, 0) ]
    define config.mouse['menu'] = [ ( "gui/arrow_menu.png", 0, 0) ] # 用户处于菜单界面时，使用该光标
    # 由于没有“pressed_menu”光标，将使用默认的“pressed_default”光标

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

.. class:: MouseDisplayable(cursor, x, y)

    用作替换鼠标光标的可视组件。当用户在屏幕内移动鼠标时，该可视组件将跟随鼠标一起移动。

    `cursor`
        用作绘制光标的可视组件

    `x, y`
        热区(hotspot)坐标，以鼠标左上角的为原点，虚拟像素数。

    .. method:: add(self, name, cursor, x, y)

        该方法能添加一个光标，根据鼠标状态 `name` 显示对应的光标。
        该方法返回的是MouseDisplayable对象，因此可以连续调用添加多个不同状态的光标。

        (译者注：MouseDisplayable(cursor, x, y).add(name1, cursor1, x1, y1).add(name2, cursor2, x2, y2).add(name3, cursor3, x3, y3)……)

.. _using-mouse-cursors:

使用鼠标光标
------------

使用鼠标光标的通常方法是，对界面内某个可以获得焦点的组件(按钮或者条)使用 ``mouse`` 特性，指定光标名称。
例如：

::

    screen test():
        textbutton "鼠标测试" actiuon NullAction() mouse "spin"

还可以使用 :var:`default_mouse` 设置全局鼠标光标：

::

    $ default_mouse = "spin"