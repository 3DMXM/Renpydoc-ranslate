.. _matrix:

Matrix
======

.. class:: Matrix(//)

    该类是一种4×4矩阵，在Ren'Py的很多地方都有用到。

    用作坐标变换时，矩阵的16个元素是：
    ::

        xdx, xdy, xdz, xdw,
        ydx, ydy, ydz, ydw,
        zdx, zdy, zdz, zdw,
        wdx, wdy, wdz, wdw

    在计算公式 x' = xdx * x + xdy * y + xdz * z + xdw * w 中，x是原x轴坐标值，x'是变换值。其他的y、z和w值类似。
    常见的情况是w的值为1，在一个矩阵中就可以实现坐标的位移、旋转和缩放的组合变换。

    When used to transform colors, the 16 elements of this matrix are
    用作色彩变换时，矩阵的16个元素是：
    ::

        rdr, rdg, rdb, rda,
        gdr, gdg, gdg, gda,
        bdr, bdg, bdb, bda,
        adr, adg, adb, ada,

    分别对用红绿蓝和alpha通道。

    使用Python乘法运算符可以实现矩阵对象相乘，并实现多个矩阵的功能。矩阵相乘时，矩阵的顺序会影响最终效果。
    假设 `v` 是一个待变换的坐标或色彩：
    ::

        (step2 * step1) * v

    等效于：
    ::

        step2 * (step1 * v)

    `//`
        该值是一个4或9或16个数值的列表，用作矩阵对象的初始值。如果列表内元素数量不满16个，从矩阵左上角填充。没有指定的zdz和wdw，值默认为1.0。
        例如：
        ::

            Matrix([ 1, 2, 3, 4 ])

        最终生成的矩阵为：
        ::

            1.0, 2.0, 0.0, 0.0,
            3.0, 4.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0,