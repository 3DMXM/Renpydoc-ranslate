.. _sprites:

精灵(sprite)
=============

为了满足同时显示大量图像的需求，Ren'Py支持精灵(sprite)系统。这个系统允许用户创建精灵，每个精灵包含一个可视组件。精灵可以拥有自身的界面坐标和垂直顺序改变。

如果不在乎系统性能的话，精灵系统的概念类似于 :func:`Fixed` 与 :func:`Transform` 的结合。 精灵的运行速度比变换(transform)快，但是扩展性比较低。精灵系统最大的性能提升方法是，每一帧中每个可视组件只渲染一次。精灵的限制是只能修改自身的xoffset和yoffset值，而不像变换(transform)有许多特性(property)可以修改。

使用那个精灵系统之前，需要先创建一个SpriteManager对象，然后调用它的create方法创建新的粒子(particle)。根据需要，更新每个精灵的xoffset、yoffset和zorder域，就能让精灵在界面内移动。通过把 `update` 和 `event` 入参应用于SpriteManager，创作者能根据时间调整精灵，并对用户输入做出响应。

.. _sprite-classes:

Sprite类
--------------

.. class:: Sprite

  这表示一个被SpriteManager类管理下的精灵(sprite)。其包含的字段(field)控制精灵在界面的位置。精灵不能直接创建，而是调用 :meth:`SpriteManager.create()` 。

  Sprite对象的字段(field)如下：

  `x, y`
    精灵左上角为原点的x和y轴坐标值，与SpriteManager相关。

  `zorder`
    一个整数值，控制SpriteManager中所有精灵叠放顺序。这个数值越大，对应精灵距离观看者(viewer)越近。

  `events`
    若为True，事件消息会传给子组件。若为False，也是默认值，子组件忽略所有事件消息(并屏蔽事件消息以免浪费时间处理)。

  Sprite对象含有如下的方法：

  .. method:: destroy(self)

    销毁该精灵，防止其再次显示，并从SpriteManager中移除。

  .. method:: set_child(d)

    将可视组件与精灵 *d* 关联。

.. class:: SpriteManager(update=None, event=None, predict=None, ignore_time=False, **properties)

  这是个管理一组精灵的可视组件，并尽可能快地把所有精灵显示出来。

  `update`
    若非None，每次SpriteManager渲染某个精灵都会调用的函数。调用时带一个入参，值是从SpriteManager第一次显示后的时间长度，单位为秒。返回值一般是该函数再次被调用以及SpriteManager再次被渲染的时间间隔，单位为秒。

  `event`
    若非None，当某个事件发生时会调用的函数。其使用以下事件消息作为入参：

    * 某个pygame事件对象。
    * 事件的x坐标调整。
    * 事件的y坐标调整。
    * 从SpriteManager第一次显示开始计算的时间。

    如果该函数返回了一个非空值，互动结束时将这个值返回。

  `predict`
    若非None，该函数返回一个可视组件列表。These displayables are predicted when the sprite manager is.

  `ignore_time`
    若为True，渲染可视组件时忽略的时间。当SpriteManager使用了一些数量不大的图像，并且这些图像不会变化时，才应该使用这项值。使用这项值的可视组件数量不能多，因为使用后的可视组件在SpriteManager对象的整个生命周期内，会一直保留在内存中。

  在首次渲染后(在 *update* 函数调用前)，SpriteManager如有下列字段(field)：

  `width, height`
    SpriteManager的宽度和高度，单位为像素。


  SpriteManager包含下列方法：

  .. method:: create(d)

    为可视组件 *d* 创建一个新的精灵(Sprite)，并添加到该SpriteManager中。

  .. method:: redraw(delay=0)

    在 *delay* 秒后重绘该SpriteManager。

.. function:: SnowBlossom(d, count=10, border=50, xspeed=(20, 50), yspeed=(100, 200), start=0, fast=False, horizontal=False)

  雪花(snowblossom)效果可以让某个精灵(sprite)的多个实例在界面中上下左右移动。当某个精灵离开界面时，其会返回起始点。

  `d`
    用作精灵的可视组件。

  `border`
    界面边界(border)的尺寸。精灵会被看作处于界面内，除非它越出了边界。需要确保精灵不会突然消失。

  `xspeed, yspeed`
    精灵移动速度，分别对应水平和垂直方向。这可以是一个数值或者两个数值的元组。在后面那种情况，每个粒子(particle)的速度可以声明为两个值之间的随机数。速度可以是整数或负数，只要保证后面的数值比前面的大。

  `start`
    每添加一个粒子(particle)，延迟的时间，单位为秒。这项值允许粒子从界面顶部出发，跟“wave”效果不同。

  `fast`
    若为True，粒子从界面中心出发，而不是界面四边。

  `horizontal`
    若为True，粒子在界面的左右两边出现，而不是上下两边。

.. _sprite-examples:

Sprite样例
---------------

SnowBlosson类是在界面内放置掉落物体的易用办法。

::

    image snow = SnowBlossom("snow.png", count=100)


这个样例展示了如何使用一个SpriteManager创建复杂行为。在这个例子中，总共显示了400个粒子，并让粒子避开鼠标。

::

    init python:
        import math

        def repulsor_update(st):

            # 如果我们不知道鼠标在哪里，先放弃获取鼠标信息
            if repulsor_pos is None:
                return .01

            px, py = repulsor_pos

            # 使用for循环检测每一个精灵……
            for i in repulsor_sprites:

                # 计算从精灵到鼠标的向量
                vx = i.x - px
                vy = i.y - py

                # 计算向量长度，将向量归一化。
                vl = math.hypot(vx, vy)
                if vl >= 150:
                    continue

                # 计算需要移动的距离
                distance = 3.0 * (150 - vl) / 150

                # 移动
                i.x += distance * vx / vl
                i.y += distance * vy / vl

                # 确保停留在界面上。
                if i.x < 2:
                    i.x = 2

                if i.x > repulsor.width - 2:
                    i.x = repulsor.width - 2

                if i.y < 2:
                    i.y = 2

                if i.y > repulsor.height - 2:
                    i.y = repulsor.height - 2

            return .01

        # 收到事件消息时，记录鼠标的坐标。
        def repulsor_event(ev, x, y, st):
            store.repulsor_pos = (x, y)


    label repulsor_demo:

        python:
            # 创建一个SpriteManager。
            repulsor = SpriteManager(update=repulsor_update, event=repulsor_event)
            repulsor_sprites = [ ]
            repulsor_pos = None

            # 确保只有一个可视组件smile。
            smile = Image("smile.png")

            # 添加400个精灵。
            for i in range(400):
                repulsor_sprites.append(repulsor.create(smile))

            # 放置这400个精灵。
            for i in repulsor_sprites:
                i.x = renpy.random.randint(2, 798)
                i.y = renpy.random.randint(2, 598)

            del smile
            del i

        # 把repulsor添加到界面。
        show expression repulsor as repulsor

        "..."

        hide repulsor

        # 清理。
        python:
            del repulsor
            del repulsor_sprites
            del repulsor_pos
