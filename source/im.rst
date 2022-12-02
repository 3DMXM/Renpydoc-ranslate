:orphan:

.. _image-manipulator:

图像处理器
==================

图像处理器(Image Manipulator)本身是一个可视组件。它会接受一个图像或者另一个图像处理器对象，对原有对象进行某些处理。图像处理器只接受图像或其他图像处理器作为输入。

任何能放可视组件的地方也可以放图像处理器，但反过来不一定可行。 :func:`Image` 对象是一种图像处理器，所以任何需要使用图像处理器的地方都可以使用image对象。

图像处理的应用具有重大意义。过去的一些图像处理器由于各种的问题不应再使用。
除了使用 :func:`im.Data` 的情况，可视组件 :func:`Transform` 提供了很多类似的功能，并同时修复了过去的问题，尽管使用这些需要启用gl2配置项。


.. function:: im.AlphaMask(base, mask, **properties)

    使用两个图像处理器 *base* 和 *mask* 作为入参，创建一个图像处理器。其使用 *mask* 的红色通道值替换了 *base* 的alpha通道值。

    该函数用于向某个图像提供alpha通道值，来源是另一个图像。比如某个jpeg图片提供色彩数据，使用另一个jpeg图片提供alpha值。在某些情况下，两张jpeg图片的文件大小可能比一张png图文文件还要小。

    需要注意，该函数与 :func:`AlphaMask()` 使用不同的入参，AlphaMask()使用的是mask参数的alpha通道值。

.. function:: im.Blur(im, xrad, yrad=None, **properties)

    可以将图像 `im` 模糊化的图像处理器。使用 `xrad` 和可选的 `yrad` 表示模糊区域的椭圆中心区域。

    如果 `yrad` 的值是None，就与 `xrad` 的值相同，也就意味着中心区域是个圆形。

    ::

        image logo blurred = im.Blur("logo.png", 1.5)

.. function:: im.Crop(im, rect)

    该图像处理器实现了图像剪裁功能。对原图像 *im* ，剪裁其在 *rect* 范围内的图像。 *rect* 参数是一个(x, y, width, height)形式的元组。

    ::

        image logo crop = im.Crop("logo.png", (0, 0, 100, 307))

.. function:: im.Data(data, filename, **properties)

    这个图像处理器从二进制文件加载图像。

    `data`
      由byte组成的字符串，表示标准文件格式下的压缩图片数据。

    `filename`
      与图像关联的 *filename* 文件名。这项用于向Ren'Py提供数据格式的提示。(图像并不是从磁盘加载的。)

.. function:: im.FactorScale(im, width, height=None, bilinear=True, **properties)

    该图像处理器实现图像(或图像处理器) *im* 的按比例缩放。缩放后的图像宽高比不变。如果 *height* 入参为空，默认与 *width* 值相同。

    如果 *bilinear* 为True，缩放时使用双线性插值算法。否则，缩放时使用最近邻插值算法。

    ::

        image logo doubled = im.FactorScale("logo.png", 1.5)

.. function:: im.Flip(im, horizontal=False, vertical=False, **properties)

    该图像处理器实现图像(或图像处理器) *im* 在垂直或水平方向的翻转。 *vertical* 和 *horizontal* 参数控制具体的翻转方向。

    ::

        image eileen flip = im.Flip("eileen_happy.png", vertical=True)

.. function:: im.Grayscale(im, **properties)

    该图像处理器创建了一个 *im* 的灰度版本(即色彩饱和度为0)。

.. function:: im.Sepia(im, **properties)

    该图像处理器创建了一个 *im* 的旧化版本(即老照片样式)。

.. function:: im.Tile(im, size=None, **properties)

    在 *size* 范围内以tile形式码放 *im* 。

    `size`
      如果不为None，该值是一个(width, height)元组。如果为空，默认值为(config.screen_width, config.screen_height)，即整个界面的尺寸。

    The same effect can now be achieved using the :func:`Tile`
    displayable, with ``Tile(im, size=size)``.
    可以使用 :func:`Tile` 组件时指定 ``Tile(im, size=size)`` 实现同样效果。

.. _im-matrixcolor:

im.MatrixColor
--------------

im.MatrixColor图像处理器是使用一个矩阵控制图像色彩变换的图像处理器。使用的矩阵可以是一个im.matrix对象，使用一个支持矩阵乘法的5×5矩阵进行编码，通过一系列函数返回编码结果。im.matrix对象可以多重相乘并同时生效。例如：

::

    image city blue = im.MatrixColor(
        "city.jpg",
        im.matrix.desaturate() * im.matrix.tint(0.9, 0.9, 1.0))

样例中，先将图像黑白化，然后提高图像中蓝色的纯度(实际降低了红色和绿色的纯度)。如果处理过程环节中的图片不需要存储，多个矩阵的使用是非常高效的，无论是在处理时间和缓存空间要求方面，都比单独使用两个im.MatrixColor矩阵好。

图像处理器 im.MatrixColor 的功能已经被Transform类和ATL中transform的matrixcolor特性替代了。
每次生成 `im.matrix` 都会将赋值给一个新的 `Matrix` 对象，详见 :doc:`matrixcolor <matrixcolor>` 。

.. warning::

    Matrix对象的乘法规则与 im.Matrixcolor 相反。为了获得相同的效果， ``im.a*im.b*im.c`` 要改成 ``C*B*A`` 。

.. function:: im.MatrixColor(im, matrix, **properties)

    使用 *matrix* 线性化转换图像处理器 *im* 。

    *matrix* 是一个列表元组或者 :func:`im.matrix` 对象，包含20或者25个元素。如果对象中包含25个元素，第20个元素之后的会被忽略。

    假设原图像的色彩值有4项，分别为R、G、B和A，值的范围为0.0至1.0；转换后的色彩值为R'、G'、B'和A'，值的范围为0.0至1.0；色彩转换矩阵的各项值如下：

    ::

        [ a, b, c, d, e,
          f, g, h, i, j,
          k, l, m, n, o,
          p, q, r, s, t ]

    转换后的颜色可以使用如下方程计算：

    ::

        R' = (a * R) + (b * G) + (c * B) + (d * A) + e
        G' = (f * R) + (g * G) + (h * B) + (i * A) + j
        B' = (k * R) + (l * G) + (m * B) + (n * A) + o
        A' = (p * R) + (q * G) + (r * B) + (s * A) + t

    转换后图像的各项颜色值会被限制在区间[0.0, 1.0]里。

.. function:: im.matrix()

    从 *matrix* 参数构造一个im.matrix对象。im.matrix对象支持矩阵乘法、标量乘法(scalar multiplication)、点位(element-wise)加法和点位(element-wise)减法。进行这些运算时，使用标准的数学符号(分别使用\*、\*、+和-)。两种乘法的使用取决于两个因子：如果两个im.matrix相乘就使用矩阵乘法，如果有一个因子不是矩阵则使用标量乘法。

    *matrix* 是一个列表元组或者im.matrix对象，包含20或者25个元素。如果对象中包含20个元素，后面会加(0, 0, 0, 0, 1)填充成5×5矩阵，为了符合乘法运算的需求。

.. function:: im.matrix.brightness(b)

    返回一个im.matrix矩阵对象，可用于转换某个图像的明度。

    `b`
      图像明度的变化值。该值是一个介于-1和1之间的数值。-1表示最低明度，1表示最高明度。

    等效于 :tpref:`matrixcolor` 变换特性BrightnessMatrix(b)。

.. function:: im.matrix.colorize(black_color, white_color)

    为黑白图像添加色调分离效果的im.matrix矩阵。 *black_color* 和 *white_color* 是Ren'Py中的样式色彩，所以可以表示为一个色彩字符串或者0-255范围内色彩值组成的元组。

    ::

        # 这个矩阵能使图像黑色变为红色，而白色变为蓝色。
        image logo colored = im.MatrixColor(
            "bwlogo.png",
            im.matrix.colorize("#f00", "#00f"))

    等效于 :tpref:`matrixcolor` 变换特性ColorizeMatrix(black_color, white_color)。

.. function:: im.matrix.contrast(c)

    返回一个im.matrix矩阵对象，可用于转换某个图像的对比度。 *c* 应是一个大于0.0的值，其值介于0.0和1.0之间时降低对比度，其值大于1.0时增加对比度。

    等效于 :tpref:`matrixcolor` 变换特性ContrastMatrix(c)。

.. function:: im.matrix.desaturate()

    返回一个im.matrix矩阵对象，可以将某个图像转为黑白(变成灰度图像)。等效于调用im.matrix.saturation(0)。

    等效于 :tpref:`matrixcolor` 变换特性SaturationMatrix(0)。

.. function:: im.matrix.hue(h)

    返回一个im.matrix矩阵对象，用于调整色相，保持亮度的情况下转动色相环 *h* 度。

    等效于 :tpref:`matrixcolor` 变换特性HueMatrix(h)。

.. function:: im.matrix.identity()

    返回一个标识符矩阵，标识某些色彩或者alpha值不会改变。

    等效于 :tpref:`matrixcolor` 变换特性IdentityMatrix()。

.. function:: im.matrix.invert()

    返回一个im.matrix矩阵对象，在不改变alpha通道的情况下，反转图像的红、绿、蓝三色值。

    等效于 :tpref:`matrixcolor` 变换特性InvertMatrix(1.0)。

.. function:: im.matrix.opacity(o)

    返回一个im.matrix矩阵对象，改变图像的透明度。 *o* 为0.0表示完全透明，为1.0表示完全不透明。

    等效于 :tpref:`matrixcolor` 变换特性OpacityMatrix(o)。

.. function:: im.matrix.saturation(level, desat=(0.2126, 0.7152, 0.0722))

    返回一个im.matrix矩阵对象，改变图像的饱和度。这种改变与alpha通道无关。

    `level`
      处理后图像的色彩饱和度相对值。1.0表示原图色彩饱和度，0.0表示灰度图。

    `desat`
      这是一个3元素元组，每个元素对应红、绿、蓝三个通道的饱和度相对值。默认值基于NTSC色彩空间亮度通道的值。由于人眼对绿色最敏感，所以绿色通道保留的信息通常比其他两个通道多。

    等效于 :tpref:`matrixcolor` 变换特性SaturationMatrix(value, desat)。

.. function:: im.matrix.tint(r, g, b)

    返回一个im.matrix矩阵对象，图像增亮，但不改变alpha通道。 *r* 、 *g* 和 *b* 是介于0跟1之间的数值，各个通道原值与入参的乘积就是最终图像的值。(例如，若 *r* 是0.5，原图像红色通道的值是100，转换后的图像红色通道值就是50。)

    等效于 :tpref:`matrixcolor` 变换特性TintMatrix(Color((r, g, b)))。