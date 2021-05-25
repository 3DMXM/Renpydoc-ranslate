.. _matrixcolor:

Matrixcolor
===========

Ren'Py可以使用变换特性 :tpref:`matrixcolor` 对图像染色。该特性使用一个 :class:`Matrix` 类或者 ColorMatrix对象作为参数。

.. _premultiplied-alpha-color:

alpha预乘
-------------

Ren'Py加载图片后，会先解压，然后将图片复制到电脑或移动设备的图形处理单元(GPU)中。
复制过程中，4种色彩通道(红、绿、蓝和alpha即不透明度)的值都会进行归一化处理，使之介于0.0与1.0之间。
在GPU系统中，1.0表示最大色彩值或完全不透明，0.0表示最小色彩值或完全透明。

Ren'Py处理的工作不仅限于此。色彩通道数值归一化完成后，红绿蓝通道的数值会分别与alpha通道的数值相乘。
也就是说，一个纯白像素的数值会是(1.0, 1.0, 1.0, 1.0)，一个50%不透明度红色像素的数值会是(0.5, 0.0, 0.0, 0.5)，一个透明的像素数值会是(0.0, 0.0, 0.0, 0.0)。

alpha预乘系统，使Ren'Py在缩放图片时不会出现亮度降低的问题。
因为缩放图片常常类似于计算两个像素色彩平均值。
假设不使用alpha预乘，我们需要处理两个像素，一个纯白像素和一个透明纯黑像素——即(1.0, 1.0, 1.0, 1.0)和(0.0, 0.0, 0.0, 0.0)。
两个像素的彩色平均值为(0.5, 0.5, 0.5, 0.5)。但这不是我们需要的，纯白像素和透明纯黑像素之间应该插入一个50透明度的白色，而不是50%透明度的灰色。

以这种方式存储色彩信息后，Ren'Py就可以在屏幕上绘制正确的结果，而不会在缩放图像时产生问题。

.. _using-a-matrix-to-change-colors:

使用矩阵修改色彩
-----------------

用于修改色彩的 :class:`Matrix` 对象由16个数字组成，可以写成一个4×4的阵列形式。
这里我们将每个数字使用一个字母代替：
::

    define mymatrix = Matrix([ a, b, c, d,
                               e, f, g, h,
                               i, j, k, l,
                               m, n, o, p, ])

注意这里的字母只是代替数值，实际使用时这些都必须是真实的数值，可以直接写死或者通过计算获得。

这些数值将分别作用于原图像色彩的RGBA通道，并生成新的色彩，具体算法如下：
::

    R' = R * a + G * b + B * c + A * d
    G' = R * e + G * f + B * g + A * h
    B' = R * i + G * j + B * k + A * l
    A' = R * m + G * n + B * o + A * p

看起来有些复杂吧。还有一个十分简单的解析方式——第一行数值用于生成新的红色通道，第二行用于生成新的绿色通道，以此类推。
如果我们想要一个交换红色与绿色的矩阵，可以这样实现：
::

    transform swap_red_and green:
        matrixcolor Matrix([ 0.0, 1.0, 0.0, 0.0,
                             1.0, 0.0, 0.0, 0.0,
                             0.0, 0.0, 1.0, 0.0,
                             0.0, 0.0, 0.0, 1.0, ])

这只是一个简单的样例，此外有一大堆色彩理论可以使用这种方式进行表示。
矩阵可以组合使用，使用时符合矩阵乘法法则，各矩阵从右往左依次相乘。

.. _colormatrix:

ColorMatrix类
--------------

因为矩阵对象只是用于静态色彩修改，对动画无能为力。
所以能够同时具有矩阵的功能并能接受参数输入将会非常实用。

ColorMatrix类是一个基类，可以扩展为很多用于创建色彩矩阵的衍生类。
Ren'Py会调用ColorMatrix类的实例，并返回色彩矩阵。ColorMatrix对象已很好地集成在ATL中，可以直接实现动画。
::

    transform red_blue_tint:
        matrixcolor TintMatrix("#f00")
        linear 3.0 matrixcolor TintMatrix("#00f")
        linear 3.0 matrixcolor TintMatrix("#f00")
        repeat

ColorMatrix类可以被子类继承，需要重写 ``__call__`` 方法。
该方法有以下要求：

* 用作插值计算的旧对象。该对象可以来自任何类，在没有旧对象时可以是None。
* 一个介于0.0和1.0之间的数值，用作插值计算的比例。0.0表示完全使用旧对象，1.0表示完全使用新对象。

该方法返回值必须是一个  :class:`Matrix` 。

下面是Ren'Py中TintMatrix类的实现，它是一个典型的ColorMatrix派生类：
::

    class TintMatrix(ColorMatrix):
        def __init__(self, color):

            # Store the color given as a parameter.
            self.color = Color(color)

        def __call__(self, other, done):

            if type(other) is not type(self):

                # 没有原来的颜色，我们从self.color获取自身rgba数值
                r, g, b = self.color.rgb
                a = self.color.alpha

            else:

                # 否则，我们从self.color和other.color分别获取rgba并进行计算结果
                oldr, oldg, oldb = other.color.rgb
                olda = other.color.alpha
                r, g, b = self.color.rgb
                a = self.color.alpha

                r = oldr + (r - oldr) * done
                g = oldg + (g - oldg) * done
                b = oldb + (b - oldb) * done
                a = olda + (a - olda) * done

            # alpha预乘
            r *= a
            g *= a
            b *= a

            # 返回一个矩阵对象
            return Matrix([ r, 0, 0, 0,
                            0, g, 0, 0,
                            0, 0, b, 0,
                            0, 0, 0, a ])

.. _built-in-colormatrix-subclasses:

内建的ColorMatrix派生类
-------------------------------

下面列出了Ren'Py内建的ColorMatrix派生类。

.. class:: BrightnessMatrix(value=1.0)

    在 :tpref:`matrixcolor` 特性中使用，用于提高图像亮度的ColorMatrix派生类，不修改alpha通道数值。

    `value`
        表示亮度提高的数量。该值应该介于-1到1之间。-1表示最暗，1表示最亮。

.. class:: ColorizeMatrix(black_color, white_color)

    在 :tpref:`matrixcolor` 特性中使用，对黑白色可视组件染色的ColorMatrix派生类。它会根据像素彩色中的黑色或白色数值用作插值比例进行插值计算。

    不对alpha通道进行操作。

    使用该类时最好使用黑白图片(或者使用 :func:`SaturationMatrix` 将饱和度降为0后的图像)，不然可能会产生奇怪的结果。

    `black_color`, `white_color`
        分别对应黑色和白色重映射后的两种颜色。

        (译者注：colorize又称“形色化”，本质上是一种色彩RGB值的重映射算法。比如入参 `black_color` 设置为红色#ff0000，`white_color` 设置为蓝色#0000ff，黑白图片染色之后原来纯黑的部分将变成红色，原来纯白的部分将变成蓝色，原来灰色的部分将变为红蓝混合。原文档中这段的描述过于纠结插值算法，没有直译。)

.. class:: HueMatrix(value=1.0)

    在 :tpref:`matrixcolor` 特性中使用，旋转 `value` 度色相值的ColorMatrix派生类。`value` 可以是任意数值，可正可负。360度表示色相正好旋转一圈。
    不对alpha通道进行操作。

.. class:: IdentityMatrix()

    在 :tpref:`matrixcolor` 特性中使用，使图像恢复原色彩和alpha值。

    `value`
        忽略。

.. class:: InvertMatrix(value=1.0)

    在 :tpref:`matrixcolor` 特性中使用，反转各色彩通道值的ColorMatrix派生类。不对alpha通道进行操作。

    `value`
        反转比例。0.0表示完全不反转，1.0表示完全反转。常用于动画。

.. class:: OpacityMatrix(value=1.0)

    在 :tpref:`matrixcolor` 特性中使用，修改图像透明度，而不修改颜色通道值的ColorMatrix派生类。

    `value`
        该值介于0.0与1.0之间，直接与原alpha通道数值相乘。

.. class:: SaturationMatrix(value, desat=(0.2126, 0.7152, 0.0722))

    在 :tpref:`matrixcolor` 特性中使用，修改图像饱和度，而不修改alpha通道值的ColorMatrix派生类。

    `value`
        对比度调整数值，1.0表示原图像，0.0表示变成黑白灰的图像。

    `desat`
        该值是一个3元元组，三个数值分别控制红绿蓝通道从0饱和度置换为原饱和度图像的曲线斜率。
        默认的常量数值是基于NTSC电视信号系统中流明度(luminance)定义。由于人眼对绿色最敏感，所以降低饱和度时相比其他两种颜色要多保留一些。

.. class:: SepiaMatrix(tint=u'#ffeec2', desat=(0.2126, 0.7152, 0.0722))

    在 :tpref:`matrixcolor` 特性中使用，将某个可视组件改为老照片(sepia-tone)风格的ColorMatrix派生类。等效于：
    ::

        TintMatrix(tint) * SaturationMatrix(0.0, desat)

.. class:: TintMatrix(color)

    在 :tpref:`matrixcolor` 特性中使用，添加图像色调而不修改alpha通道值的ColorMatrix派生类。

    `color`
        用作添加色调的颜色。该值会作为入参传入 :func:`Color`，可以是Color函数支持的任意类型。

