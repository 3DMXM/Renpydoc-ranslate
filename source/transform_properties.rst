.. _transform-properties:

====================
变换特性
====================

变换特性(transform property)可以被 :doc:`transforms` 使用，影响可视组件的绘制。
变换特性常用于 :ref:`ATL <atl>` 和 :class:`Transform` 类中。

.. _list-of-transform-properties:

transform特性列表
============================

transform存在以下特性(property)。

当给定的数据类型当作一个坐标 :term:`position` 时，其可能是一个整型、 :term:`absolute <position>` 类型或者浮点型。
如果是一个浮点型，其可以用作某块区域(用作坐标 :propref:`pos` )或者可视组件(用作锚点 :propref:`anchor` )的比例值。

需要注意的是，并非所有特性都是完全独立的。例如， :propref:`xalign` 和 :propref:`xpos` 都会更新同一批底层数据。
在parallel语句中，对相同的数据，最多只允许一个语句块进行调整。
(这些可能都是在同一个语句块中。)angle和radius特性同时设置水平和垂直坐标。

.. _positioning:

坐标
--------

.. transform-property:: pos

    :type: (position, position)
    :default: (0, 0)

    相对坐标，以整个区域左上角为原点。

.. transform-property:: xpos

    :type: position
    :default: 0

    水平坐标，以整个区域的最左端为坐标零点。

.. transform-property:: ypos

    :type: position
    :default: 0

    垂直坐标，以整个区域的最上端为坐标零点。

.. transform-property:: anchor

    :type: (position, position)
    :default: (0, 0)

    锚点坐标，以可视组件左上角为原点。

.. transform-property:: xanchor

    :type: position
    :default: 0

    锚点的水平坐标，以可视组件最左端为坐标零点。

.. transform-property:: yanchor

    :type: position
    :default: 0

    锚点的垂直位置，以可视组件最上端为坐标零点。

.. transform-property:: align

    :type: (float, float)
    :default: (0.0, 0.0)

    将pos和anchor设置为相同的值。

.. transform-property:: xalign

    :type: float
    :default: 0.0

    将xpos和xanchor设置为相同的值。

.. transform-property:: yalign

    :type: float
    :default: 0.0

    将ypos和yanchor设置为相同的值。

.. transform-property:: offset

    :type: (absolute, absolute)
    :default: (0, 0)

    可视组件在两个方向偏离的像素数。向右和向下偏离时是正数。

.. transform-property:: xoffset

    :type: absolute
    :default: 0

    可视组件在水平方向偏离的像素数。向右偏离时是正数。

.. transform-property:: yoffset

    :type: absolute
    :default: 0

    可视组件在垂直方向偏离的像素数。向下偏离时是正数。

.. transform-property:: xycenter

    :type: (position, position)
    :default: (0.0, 0.0)

    等效于将pos的值设置为该特性的值，并同时将archor设置为(0.5, 0.5)。

.. transform-property:: xcenter

    :type: position
    :default: 0.0

    等效于将pos的值设置为该特性的值，并同时将xanchor设置为0.5。

.. transform-property:: ycenter

    :type: position
    :default: 0.0

    等效于将pos的值设置为该特性的值，并同时将yanchor设置为0.5。

.. transform-property:: subpixel

    :type: boolean
    :default: False

    若为True，子组件将根据子像素(subpixel)确定位置。

    子像素位置还影响写入最终像素的颜色(包括不透明度)，但具体写入哪个像素依然是不变的。
    如果子像素位置还会发生移动(很常见的情况)，移动方向上的即将进入的界面图像应该包含带透明度混合的边界。

    例如，某个角色立绘在水平方向移动，最好在左右两侧设置半透明的边界。
    对于实际大小超过整个可视区域的背景图就没必要使用该特性，反正边界部分是看不到的。
    
    (译者注：subpixel往往跟MSAA相关。具体内容请借助搜索引擎学习。)

.. _rotation:

旋转
--------

.. transform-property:: rotate

    :type: float or None
    :default: None

    若值为None，不会进行旋转。否则，图像会按指定的角度顺时针旋转。
    根据下面会提到的rotate_pad的配置值，旋转可视组件会导致组件尺寸改变。
    xanchor和yanchor不为0.5的情况下，旋转整个可视组件会让组件相对整个界面的坐标发生变化。

.. transform-property:: rotate_pad

    :type: boolean
    :default: True

    若该值为True，一个可以旋转的可视组件就会使用原本的宽度和高度填充旋转矩形，并确保旋转时不会改变组件的尺寸。
    若该值为False，transform会给定某个能应用于可视组件的最小尺寸，更适合用于自动匹配的旋转。

.. transform-property:: transform_anchor

   :type: boolean
   :default: False

   若该值为True，锚点会定位在关联的子组件上，当子组件发生变换时拉伸并旋转。
    实际效果是，当子组件拉伸或旋转时，这项值可以指定子组件以指定的锚点拉伸或旋转。

.. _zoom-and-flip:

缩放与翻转
-------------

.. transform-property:: zoom

    :type: float
    :default: 1.0

    该值根据系数对可视组件进行缩放。

.. transform-property:: xzoom

    :type: float
    :default: 1.0

    该值根据系数对可视组件在水平方向进行缩放。负值可以让图像水平翻转(即与原图像互为左右镜像)。

.. transform-property:: yzoom

   :type: float
   :default: 1.0

   该值根据系数对可视组件在垂直方向进行缩放。负值可以让图像垂直翻转(即与原图像互为上下镜像)。

.. _pixel-effects:

像素效果
----------

.. transform-property:: nearest

    :type: boolean
    :default: None

    若该值为True，可视组件及其子组件会使用近邻取样(nearest-neighbor)过滤绘制。
    若该值为False，可视组件及其子组件使用双线性(bilinear)过滤绘制。
    若该值为None，绘制方式从父组件继承，或者采用 :var:`config.nearest_neighbor` 配置(默认值是False)。

.. transform-property:: alpha

    :type: float
    :default: 1.0

    该值控制可视组件的不透明度。

    alpha变换(transform)会分别作用于每个图像所包含的子组件。
    在子组件存在重叠部门的情况，这可能会导致一些不期望出现的结果，比如透过衣服看到角色之类的。
    :func:`Flatten` 类可视组件可以解决这些问题。

.. transform-property:: additive

    :type: float
    :default: 0.0

    该值控制Ren'Py加性混合后的表现效果。该值为1.0时，Ren'Py使用ADD操作器(operator)绘制；该值为0.0时，Ren'Py使用OVER操作器(operator)绘制。

    加性混合会分别作用于transform的每一个子组件。

    完全的加性混合不会改变目标图像的alpha通道值，并且添加上去的图像可能不是可见的，
    前提是那些图像没有直接绘制在某个不透明的表面上。
    (某些复杂的操作，像 :func:`Flatten`， :func:`Frame` 和某些转场，使用加性混合可能会出现问题。)

.. transform-property:: matrixcolor

    :type: None 或 矩阵 或 MatrixColor对象
    :default: None

    若非None，该特性值将应用到所有子组件并重新计算颜色。只有使用MatrixColor并且满足结构性相似的前提下，才能进行插值计算。
    详见 :doc:`matrixcolor` 。

.. transform-property:: blur

    :type: None 或 float
    :default: None

    使用 `blur` 像素数模糊图像的子组件， `blur` 数值不超过可视组件的边长。
    Ren'Py不同版本的模糊细节可能存在差异。模糊的结果可能存在瑕疵，尤其是模糊数值不断发生修改的情况下。

.. _polay-positioning:

极坐标
-----------------

.. transform-property:: around

    :type: (position, position)
    :default: (0.0, 0.0)

    该特性指定了一个起点坐标，以整个区域左上角做原点。(根据 :tpref:`angle` 和 :tpref:`radius` 计算出的)极向量范围内的区域将被绘制。
    以上两者共同决定了 :tpref:`pos` 的值。

.. transform-property:: angle

    :type: float

    该特性给出极坐标系下某个坐标的角度信息。角度的单位是度(degree)，0度时在屏幕正上方，90度时在屏幕右方。

    Ren'Py会将角度的值控制在0到360度的区间内，有0度不包含360度。
    当数值超过这个区间范围时，Ren'Py使用前会处理成等效角度。(角度值设置为-10度，等效于将角度设置为350度。)

.. transform-property:: radius

    :type: position

    极坐标系下坐标的半径。
    
    如果值是浮点数，会被自动缩小到刚好能适用于宽度和高度的某个值。

.. _polar-positioning-of-the-anchor:

极坐标系的锚点
-------------------------------

.. note::

    使用极坐标系时同时也启用了锚点。通常最简单的处理就是将 :tpref:`anchor` 设置为(0.5, 0.5)，即可视组件的中心。

.. transform-property:: anchoraround

    :type: (position, position)
    
    该特性指定了一个起点坐标，以整个区域左上角做原点。(根据 :tpref:`anchorangle` 和 :tpref:`anchorradius` 计算出的)极向量范围内的区域将被绘制。
    以上两者共同决定了 :tpref:`anchor` 的值。

.. transform-property:: anchorangle

    :type: (float)

    极坐标系下锚点坐标的角度。角度的单位是度(degree)，0度表示正上方，90度表示右方。

    Ren'Py会将角度的值控制在0到360度的区间内，有0度不包含360度。
    当数值超过这个区间范围时，Ren'Py使用前会处理成等效角度。(角度值设置为-10度，等效于将角度设置为350度。)

.. transform-property:: anchorradius

    :type: (position)

    极坐标系下锚点坐标的半径。
    若该值是浮点数，将乘以可视组件的宽和高，计算得到结果。如果可视组件的高和宽不相等，计算结果不是absolute类型，最终会沿椭圆旋转。
    因此，推荐将该特性设置为 ``int`` 或 ``absolute`` 类型的值。

.. _cropping-and-resizing:

剪裁与重新调整尺寸
---------------------

.. transform-property:: crop

    :type: None 或 (position, position, position, position)
    :default: None

    若该值非None，会使用给定的矩形剪裁可视组件。指定的矩形是一个(x, y, width, height)形式的元组。

    如果各种corner特性与crop特性同时出现，crop的优先级高于各种corner特性。

.. transform-property:: corner1

    :type: None 或 (position, position)
    :default: None

    若该值非None，指定剪裁框的左上角坐标。剪裁时优先使用各corner特性值。
    若crop_relative为启用状态，且该值为浮点型与子组件的尺寸相关。

.. transform-property:: corner2

    :type: None 或 (position, position)
    :default: None

    若该值非None，指定剪裁框的右下角坐标。剪裁时优先使用各corner特性值。
    若crop_relative为启用状态，且该值为浮点型与子组件的尺寸相关。

.. transform-property:: xysize

    :type: None 或 (position, position)
    :default: None

    若该值非None，将可视组件伸缩至给定的尺寸。等效于，将入参元组的第一元素赋值给 :tpref:`xsize`，将入参元祖的第二元素赋值给 :tpref:`ysize`。

    该值受到 :tpref:`fit` 影响。

.. transform-property:: xsize

    :type: None 或 position
    :default: None

    若该值非None，可是组件会按照给定的宽度缩放。

    该值受到 :tpref:`fit` 影响。

.. transform-property:: ysize

    :type: None 或 position
    :default: None

    若该值非None，可是组件会按照给定的高度缩放。

    该值受到 :tpref:`fit` 影响。

.. transform-property:: fit

    :type: None 或 string
    :default: None

    若该值非None，会按下面表格的方式调整尺寸。表格中的“维度”分别为：

    * 若 :tpref:`xsize` 和 :tpref:`ysize` 都不为None，这两项都会用作维度。
    * 若 :tpref:`xsize` 和 :tpref:`ysize` 只有其中一项不是None，则两个维度都使用非None项的值。
    * 若 :tpref:`xsize` 和 :tpref:`ysize` 都为None，且fit项不是None，则根据Transform中的宽度和高度作为两个维度的值。

    若fit、xsize和ysize都是None，则该特性不生效。

    .. list-table::
       :widths: 15 85
       :header-rows: 1

       * - 值
         - 描述
       * - ``contain``
         - 在不超过任何维度尺寸的原则下近可能大。保持宽高比。
       * - ``cover``
         - 在不超过任何维持尺寸的原则下尽可能小。保持宽高比。
       * - None 或 ``fill``
         - 将可视组件拉伸/挤压，以匹配各维度指定大小。 
       * - ``scale-down``
         - 类似 ``contain``，但不会增加可视组件的尺寸。
       * - ``scale-up``
         - 类似 ``cover``，但不会增加可视组件的尺寸。

.. _panning-and-tiling:

全景图和平铺
------------------

.. transform-property:: xpan

    :type: None 或 float
    :default: None

    若该值非None，其被看作某个360度全景图中的经度。图像中央是0度，图像左端和右端分别是-180度和180度。

.. transform-property:: ypan

    :type: None 或 float
    :default: None

    若该值非None，其被看作某个360度全景图中的纬度。图像中央是0度，图像顶部和底部分别是-180度和180度。

.. transform-property:: xtile

    :type: int
    :default: 1

    图像水平方向使用图像平铺的次数。

.. transform-property:: ytile

    :type: int
    :default: 1

    图像垂直方向使用图像平铺的次数。

.. _atl-transition:

转场
----

详见 :ref:`atl-transitions` 。

.. transform-property:: delay

    :type: float
    :default: 0.0

    如果该变换(transform)用作转场(transition)，这个值定义了转场时间。

.. transform-property:: events

    :type: boolean
    :default: True

    若该值为True，事件消息会传给该变换(transform)的子组件。若该值为False，事件消息会被屏蔽。
    (这个机制可以用在ATL变换中，放置事件消息达到某些old_widget。)

.. _other:

其他
----

.. transform-property:: fps

    :type: float or None
    :default: None

    若非None，该特性会更该其所在变换的最小时间颗粒。
    例如某个变换的fps为10，那么变换的时间最小值至少为0.1秒。
    该特性可以用于模拟低刷新率。

.. transform-property:: show_cancels_hide

    :type: boolean
    :default: True

    通常，某个同名或带同名标签(tag)的可视组件或界面，从隐藏状态转为显示状态时，将移除组件或界面的隐藏属性，变换中hide部分的效果将取消。
    如果该特性为False，则不会中断和取消hide变换，而是会将hide变换的效果处理完。

此外，其他几组变换特性可以在文档其他地方找到：

3D舞台特性：
    :tpref:`perspective`、:tpref:`point_to`、:tpref:`orientation`、:tpref:`xrotate`、:tpref:`yrotate`、:tpref:`zrotate`、:tpref:`matrixanchor`、:tpref:`matrixtransform`、:tpref:`zpos`、:tpref:`zzoom`

基于模型渲染特性：
    :tpref:`blend`、 :tpref:`mesh`、 :tpref:`mesh_pad`、 :tpref:`shader`

GL特性：
    :ref:`GL特性 <gl-properties>`

uniforms：
    以 ``u_`` 开头的特性可以用于 :ref:`自定义着色器 <custom-shaders>` 中的uniform变量。

.. _property-order:

特性生效顺序
------------

这些特性按照以下顺序生效：

#. fps
#. mesh, blur
#. tile
#. pan
#. crop, corner1, corner2
#. xysize, size, maxsize
#. zoom, xzoom, yzoom
#. point_to
#. orientation
#. xrotate, yrotate, zrotate
#. rotate
#. zpos
#. matrixtransform, matrixanchor
#. zzoom
#. perspective
#. nearest, blend, alpha, additive, shader
#. matrixcolor
#. GL Properties, Uniforms
#. position properties
#. show_cancels_hide

.. _deprecated-transform-properties:

过期的变换特性
================

.. warning::

    下列特性不应再使用近期开发的游戏中，可能会与其他功能特性发生冲突。
    暂时保留这些特性是考虑到兼容性。

.. transform-property:: alignaround

    :type: (float, float)

    将 :tpref:`anchor`、 :tpref:`around` 和 :tpref:`anchoraround` 设置为相同的值。

.. transform-property:: crop_relative

    :type: boolean
    :default: True

    若为False，:tpref:`crop` 的值将作为像素数的值，而不再是原图像的宽度或高度的比例。

    如果计算结果是某个绝对数值像素数，应该将 :func:`absolute` 实例应用到 :tpref:`crop` 特性，而不使用crop_relative特性。
    必要时，不确定类型的数值可以传给 :func:`absolute` 函数处理。

.. transform-property:: size

    :type: None or (int, int)
    :default: None

    :tpref:`xysize` 的一个旧版本，将浮点值作为像素数的值进行插值操作。

.. transform-property:: maxsize

    :type: None or (int, int)
    :default: None

    若该值非None，可以使可视组件在box当中以合适的尺寸放大或缩小显示，同时保持横纵比。（请注意，这意味着长或宽其中一个尺寸可能小于此box的尺寸。）

    若要实现同样结果，可以将 :tpref:`xysize` 设定为同样的值，并把 :tpref:`fit` 设置为“contain”。
