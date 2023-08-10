.. _transforms:

==========
变换
==========

变换(transform)可以从一个可视组件套用到另一个可视组件。内建的变换(transform)常用于控制界面上某个对象的位置，而用户自定义的变换(transform)可以出发更复杂的效果，比如运动、缩放和旋转。

变换(transform)可以通过在scene和show语句后使用at分句实现。下面样例中将eileen happy这个可视组件应用了“right”变换(transform)。::

    show eileen happy at right

可以同时应用多个变换(transform)，不同变换(transform)之间用英文逗号分隔。这些变换(transform)从左到右依次应用，所以遇到不同变换有冲突的情况下最后面的变换(transform)最优先表现。::

    show eileen happy at halfsize, right

每个可视组件总是有一个相关联的变换(transform)。如果没有指定变换(transform)，将使用主(prior)变换。修改变换(transform)时，未定义的值会直接使用主变换的对应值，或者如果没有主变换的话从 `default` 配置获取。

.. _default-transforms:

默认变换
==================

Ren'Py附带了一些默认定义好的变换(transform)。这些变换(transform)定义了界面上的位置信息。这里有一个默认变换下图像位置的描述： ::

                +-----------------------------------------------------------+
                |topleft, reset               top                   topright|
                |                                                           |
                |                                                           |
                |                                                           |
                |                                                           |
                |                          truecenter                       |
                |                                                           |
                |                                                           |
                |                                                           |
                |                                                           |
   offscreenleft|left                   center, default                right|offscreenright
                +-----------------------------------------------------------+

offscreenleft和offscreenright变换位置会图片显示在界面之外。这两个变换(transform)可以用于将物体移除界面(记得之后隐藏这些物体，并确认他们不在消耗系统资源)。

这些变换(transform)的详细信息如下：

.. var:: center

    水平居中，并与界面底部对齐。

.. var:: default

    水平居中，并与界面底部对齐。default可以通过 :var:`config.default_transform` 重定义，这样show和scene语句显示的图片默认位置也会改变

.. var:: left

    与界面左下角对齐。

.. var:: offscreenleft

    将可视组件置于界面左外侧，与界面底部对齐。

.. var:: offscreenright

    将可视组件置于界面右外侧，与界面底部对齐。

.. var:: reset

    重置变换(transform)。将可视组件放置在界面左上角，并清除一切缩放、宣传等附加效果。

.. var:: right

    与界面右下角对齐。

.. var:: top

    水平居中，与界面顶部对齐。

.. var:: topleft

    与界面左上角对齐。

.. var:: topright

    与界面右上角对齐。

.. var:: truecenter

    水平和垂直都居中。

.. _creator-defined-transforms:

创作者定义的变换
==========================

创作者可以使用 :doc:`ATL语言 <atl>` 和 :class:`Transform` 的函数自定义变换。
