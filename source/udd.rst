.. _creator-defined-displayables:

============================
创作者定义的可视组件
============================

最复杂也最强大，能够定制Ren'Py表现效果的方式，就是使用创作者定义的可视组件。
一个创作者定义的可视组件允许使用任何pygame事件消息。
其可以渲染其他可视组件，并将其他可视组件放置在界面的任何位置。
这可是突破Ren'Py提供的工具限制，适合创建一些2D的迷你游戏。
(但请参考 :ref:`sprites <sprites>` 章节内容，那里相似地描述了生成同样物体的高阶方法。)

创作者定义的可视组件完全使用Python代码编写，
我们鼓励创作者在创建自己的可视组件之前具有一定程度的Python面向对象编程技能。

.. _udd-example:

样例
=======

这是一个创作者定义可视组件的样例。
这个可视组件能根据子组件中心与鼠标指针的距离修改子组件的alpha值。

::

    init python:

        import math

        class Appearing(renpy.Displayable):

            def __init__(self, child, opaque_distance, transparent_distance, **kwargs):

                # 向renpy.Displayable构造器传入额外的特性(property)。
                super(Appearing, self).__init__(**kwargs)

                # 子组件。
                self.child = renpy.displayable(child)

                # 子组件完全不透明和完全透明的距离。
                # 前者必须小于后者。
                self.opaque_distance = opaque_distance
                self.transparent_distance = transparent_distance

                # 子组件的alpha通道值。
                self.alpha = 0.0

                # 子组件的宽度和高度。
                self.width = 0
                self.height = 0

            def render(self, width, height, st, at):

                # 创建一个变换(transform)，调整子组件的alpha通道值。
                t = Transform(child=self.child, alpha=self.alpha)

                # 创建一个子组件的渲染器。
                child_render = renpy.render(t, width, height, st, at)

                # 或者子组件尺寸。
                self.width, self.height = child_render.get_size()

                # 创建返回的渲染器。
                render = renpy.Render(self.width, self.height)

                # 以blit方式将子组件的渲染器信息复制我们的渲染器。
                render.blit(child_render, (0, 0))

                # 返回渲染器。
                return render

            def event(self, ev, x, y, st):

                # 继续按从可视组件中心到鼠标指针的距离。
                # 鼠标指针位置为x和y，表示指针图案左上角为原点的坐标。
                distance = math.hypot(x - (self.width / 2), y - (self.height / 2))

                # 根据距离，计算alpha值。
                if distance <= self.opaque_distance:
                    alpha = 1.0
                elif distance >= self.transparent_distance:
                    alpha = 0.0
                else:
                    alpha = 1.0 - 1.0 * (distance - self.opaque_distance) / (self.transparent_distance - self.opaque_distance)

                # 如果alpha值发生变化，触发redraw事件。
                if alpha != self.alpha:
                    self.alpha = alpha
                    renpy.redraw(self, 0)

                # 将事件传给各子组件。
                return self.child.event(ev, x, y, st)

            def visit(self):
                return [ self.child ]

使用创作者定义的可视组件时，我们可以创建对应的实例，并将实例添加至界面。

::

    screen alpha_magic:
        add Appearing("logo.png", 100, 200):
            xalign 0.5
            yalign 0.5

    label start:
        show screen alpha_magic

        "Can you find the logo?"

        return

.. _renpy-displayable:

renpy.Displayable
=================

创作者定义的可视组件是通过renpy.Displayable类的子类创建的。创作者定义的可视组件必须重写render方法，也可以重写其他方法。

一个可视组件对象必须是可以被pickle的，这意味着其不含有不能被pickle的对象特性(reference)。特别需要注意的是，Render对象不能存储在创作者定义的可视组件中。

由于需要重写Displayable类的很多方法，我们将这些方法都放在 `self` 参数中。

.. class:: renpy.Displayable

    创作者定义可视组件的基类。

    .. method:: __init__(**properties):

        子类可能重写这个构造器，并添加新的参数。如果的确出现了新参数，需要把所有未知的关键词入参都传入到renpy.Displayable构造器，这样调用：

        ::

            super(MyDisplayable, self).__init__(**properties)

    .. method:: render(self, width, height, st, at)

        子类必须重新这个方法，并返回一个 :class:`renpy.Render`
        对象。渲染器对象决定了在界面的所有显示效果。

        `width`, `height`
            这个可视组件的有效区域范围，单位为像素。

        `st`
            一个浮点数，表示显示时间轴，单位为秒。可视组件在界面上首次显示的时间点，是显示时间轴的起始点。

        `at`
            一个浮点数，动画时间轴，单位为秒。带有同样标签(tag)的图像显示而不是隐藏的时间点，是动画时间轴的起始点。(当可视组件不使用标签显示，就与显示显示时间轴相同。)

        可视组件首次显示时会调用render方法。在 :func:`renpy.redraw`
        函数调用这个对象时，对象会再次调用render方法。

    .. method:: event(self, ev, x, y, st)

        将一个pygame事件消息传入创作者定义可视组件就会调用event方法。如果event方法返回一个非None的值，这个也会作为交互动作的结果并返回。

        event方法也存在于其他可视组件，允许创作者定义可视组件将事件消息传给其他可视组件。

        `ev`
            一个 `event 对象 <http://www.pygame.org/docs/ref/event.html>`_

        `x`, `y`
            事件的x和y坐标值，以可视组件左上角为原点。这些信息会用在特性(preference)中定位pygame事件对象中的信息。

        `st`
            一个浮点数，显示时间轴，单位为秒。

        每次交互动作的开头都会生成一个事件消息，
        :func:`renpy.timeout` 函数可以用于触发另一个事件消息。

    .. method:: per_interact(self)

        每次交互动作的开头都会调用这个方法。这个函数可以用于触发一次重新绘制，以及回滚过程中对象需要部分重新绘制的情况。

    .. method:: visit(self)

        如果可视组件有子可视组件，就需要重写这个方法返回一个子可视组件的列表。这个方法确保那些可视组件的per_interact方法都被调用，并能预加载使用的图像。

renpy.Render
============

创作者定义的可视组件与renpy.Render对象一起运行。
调用某个可视组件的 :func:`renpy.render` 函数，可以返回一个Render对象。
一个创作者定义的可视组件应该调用 :class:`renpy.Render` 的render方法创建一个Render对象。

由于Render对象不能派生子类，我们省略了显式 `self` 参数。

.. class:: renpy.Render(width, height)

    创建一个新的Render对象。

    `width`, `height`
        Render对象的宽度和高度，单位为像素。

    .. method:: blit(source, pos, main=True)

        在这个Render对象中绘制另一个Render对象。

        `source`
            待绘制的Render对象。

        `pos`
            绘制的位置。是一个(x, y)元组，表示从目标Render对象左上角为原点的坐标。

        `main`
            唯一的关键词参数。若为True， `source` will 会在样式检查器中显示。

    .. method:: place(d, x=0, y=0, width=None, height=None, st=None, at=None, render=None, main=True)

        渲染 `d` 并将其放入由 `x`、 `y`、
        `width` 和 `height` 定义的矩形中，使用Ren'Py标准位置算法。

        `x`, `y`, `width`, `height`
            放入的矩形区域。如果 `width` 或 `height` 为None，就分别使用Render对象的宽或者高。

        `st`, `at`
            传入Render对象的两个时间。若为None，默认使用render方法调用这个方法时传入的时间。

        `render`
            若不是None，这项代替 `d` 成为渲染对象。

        `main`
            同 .blit()。

    .. method:: canvas()

       返回一个canvas对象。canvas对象有对应
       `pygame.draw <http://www.pygame.org/docs/ref/draw.html>`_
       函数的方法，第一个参数(surface)省略。

       canvas对象也有一个get_surface()方法，能返回使用canvas的paygame Surface对象。

    .. method:: get_size()

        R返回一个(width, height)元组，表示Render对象的尺寸。

    .. method:: subsurface(rect)

        返回一个Render对象，原Render对象的剪裁。

        `rect`
            一个 (x, y, width, height) 元组。

    .. method:: zoom(xzoom, yzoom)

        设置该可视组件子组件在水平和垂直方向上的缩放(zoom)等级。只有子组件会被缩放——宽度、高度和blit坐标都不会缩放。

    下列属性和方法只在启用基于模型的渲染器后才能使用：

    .. attribute:: mesh

        This field enables model-based rendering for this Render. If true:
        该字段对此Render对象启用基于模型的渲染器。

        若为True：

        * 此可视组件的所有子组件都会渲染为纹理(texture)。
        * 此可视组件关联的第一个子组件的尺寸作为网格(mesh)的尺寸。
        * 使用此Render对象创建网格、着色器、uniform变量和GL属性。

        创建的网格模型将在单次绘制操作中完成。

    .. method:: add_shader(shader)

        该方法使此Render对象或其子对象使用名为 `shader` 的着色器进行绘制。
        着色器名应是一个字符串。如果着色器名以“-”开头，表示不使用此着色器。

    .. method:: add_uniform(name, value)

        此Render对象或其子对象绘制时，将名为 `name` 的uniform变量赋值为 `value` 。

    .. method:: add_property(name, value)

        此Render对象或其子对象绘制时，将名为 `name` 的GL属性变量赋值为 `value` 。

.. _utility-functions:

功能函数
=================

这些函数管理渲染过程。

.. function:: renpy.displayable(d, scope=None)

    这个函数使用入参 *d* ，*d* 可能是一个可视组件对象或字符串。如果是一个字符串，使用常用的规则将其转换为一个可视组件。

.. function:: renpy.end_interaction(value)

    若 *value* 不是None，立刻结束当前交互动作，并让交互动作返回 *value* 。若 *value* 是None，不做任何事。

    在创作者定义的可视组件内部的渲染器和事件消息处理方法中可以调用这个函数。

.. function:: renpy.load_image(im) link

    使用图像缓存加载图像操作器(manipulator) *im* ，返回一个纹理(texture)。

.. function:: renpy.load_surface(im)

    使用图像缓存加载图像操作器(manipulator) *im* ，返回一个pygame Surface对象。

.. function:: renpy.map_event(ev, keysym)

    如果pygame事件 *ev* 匹配 *keysym* 就返回True。

    `keysym`

        下列情况之一：

        - 在 :func:`config.keymap` 中配置的键盘绑定名称。
        - 在 :ref:`定制化快捷键 <keymap>` 章节中描述的keysym对象。
        - 包含一个或多个keysym的列表。

.. function:: renpy.render(d, width, height, st, at)

    渲染一个可视组件，并返回一个renpy.Render对象。

    `d`
        待渲染的可视组件。

    `width, height`
        可视组件渲染区域的宽度和高度。

    `st, at`
        显示和动画时间轴。

    这个对象返回的渲染器可以缓存，一旦恢复一次后就不该再修改渲染器。

.. function:: renpy.timeout(seconds)

    经过 *seconds* 秒后生成一个事件消息。这个函数确保了创作者定义可视组件的事件处理方法被调用到。

.. function:: renpy.redraw(d, when)

    经过 *when* 秒之后重新绘制可视组件 *d* 。
