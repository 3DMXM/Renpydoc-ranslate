.. _color-class:

Color类
===========

Ren'Py有一个Color类，可以用于各色彩空间之间的转换，或者进行各种调色操作。Color对象不能改变，可以用在任何色彩元组出现的地方。

色彩元组处于下列三种色彩空间之一：

* RGB - 红(Red)、绿(Green)、蓝(Blue)
* HLS - 色相(Hue)、亮度(Lightness)、饱和度(Saturation)
* HSV - 色相(Hue)、饱和度(Saturation)、明度(Value)

下面的例子中，不同的色彩空间的计算方式，表示了同一种亮绿色：::

    # 标准Ren'Py色彩。
    Color("#0f0")
    Color("#00ff00")
    Color((0, 255, 0, 255))

    # 从其他色彩空间转换
    Color(hls=(.333, 0.5, 1.0))
    Color(hsv=(.333, 1.0, 1.0))

    # 将红色通过某个方法转为绿色，并返回一个新的色彩。
    Color("#f00").rotate_hue(.333)


.. class:: Color(color=None, hls=None, hsv=None, rgb=None, alpha=1.0)

  Color类用于表现和操作色彩以及各个色彩空间之间转换。它也使用一个alpha值表现透明度。

  创建一个Color对象时，至少需要提供一个 *color* 、 *hls* 、 *hsv* 或 *rgb* 入参。(如果每一项入参都是None，那么返回None。)

  .. attribute:: color

    Ren'Py能理解的标准格式色彩之一。标准格式色彩包括：

    - 一个Color对象。
    - 一个(r, g, b)或(r, g, b, a)元组，每一项数值都位于0到255的闭区间。
    - 十六进制色彩字符串，格式为"#rgb"、"#rgba"、"#rrggbb"或"#rrggbbaa"。

  .. attribute:: hls

    HLS色彩空间的某个色彩。这是一个三元元组，每个元素的值位于0.0到1.0的闭区间。

  .. attribute:: hsv

    HSV色彩空间的某个色彩。这是一个三元元组，每个元素的值位于0.0到1.0的闭区间。

  .. attribute:: rgb

    RGB色彩空间的某个色彩。这是一个三元元组，每个元素的值位于0.0到1.0的闭区间。

  如果提供的色彩不包含alpha值，就需要使用 *alpha* 。 *alpha* 的值必须位于0.0到1.0的闭区间。

  Color对象可以当作一个4元元组使用，各个元素分别为红、绿、蓝和alpha。被当作元组使用时，元组内每个元素的值位于0到255的闭区间。

  Color对象支持+、-和*操作符，分别表示加法、减法和乘法。
  有时候对色彩的这些操作会导致色彩中某个元素的值超过支持的范围。
  这样的色彩不能被直接传给Ren'Py的其他部分。
  (可以调用normalize方法将元素值限制在合适的范围内，并返回一个新的色彩。)

  .. method:: hls

    将色彩以HLS色彩空间三元元组形式返回。每个元素的值位于0.0到1.0的闭区间。

  .. method:: hsv

    将色彩以HSV色彩空间三元元组形式返回。每个元素的值位于0.0到1.0的闭区间。

  .. method:: rgb

    将色彩以RGB色彩空间三元元组形式返回。每个元素的值位于0.0到1.0的闭区间。

  .. method:: alpha

    将色彩的alpha(透明度)值返回。alpha的值位于0.0到1.0的闭区间，0.0表示完全透明，1.0表示完全不透明。

  .. method:: hexcode

    返回一个字符串，字符串为#rrggbbaa或#rrggbb格式的十六进制颜色代码。

    Color对象有下列方法。由于Color对象本身不能改变，这些方法会返回一个新的Color对象。

  .. method:: interpolate(other, fraction)

    该Color对象和RGB色彩空间中的 *other* 间的插值(interpolate)，将结果返回为一个新的Color对象。如果 *fraction* 的值是0.0，结果为原Color对象；如果 *fraction* 的值是1.0，结果与 *other* 相同。

  .. method:: interpolate_hls(other, fraction)

    该Color对象和HLS色彩空间中的 *other* 间的插值(interpolate)，将结果返回为一个新的Color对象。如果 *fraction* 的值是0.0，结果为原Color对象；如果 *fraction* 的值是1.0，结果与 *other* 相同。

    *other* 可以是一个字符串、Color对象或HLS元组。

  .. method:: interpolate_hsv(other, fraction)

    该Color对象和HLV色彩空间中的 *other* 间的插值(interpolate)，将结果返回为一个新的Color对象。如果 *fraction* 的值是0.0，结果为原Color对象；如果 *fraction* 的值是1.0，结果与 *other* 相同。

    *other* 可以是一个字符串、Color对象或HSV元组。

  .. method:: multiply_hls_saturation(saturation)

    把该Color对象的饱和度乘以 *saturation* ，将结果返回为一个新的Color对象。在这HLS色彩空间内完成。

  .. method:: multiply_hsv_saturation(saturation)

    把该Color对象的饱和度乘以 *saturation* ，将结果返回为一个新的Color对象。在这HSV色彩空间内完成。

  .. method:: multiply_value(value)

    把该Color对象的明度乘以 *value* ，将结果返回为一个新的Color对象。在这HSV色彩空间内完成。

  .. method:: normalize(self)

    返回了这个Color对象的归一化版本，所有色彩值都位于0到255的闭合区间。

  .. method:: opacity(opacity)

    把该Color对象的alpha值乘以 *opacity* ，将结果返回为一个新的Color对象。

  .. method:: replace_hls_saturation(saturation)

    把该Color对象的饱和度替换为 *saturation* ，将结果返回为一个新的Color对象。在这HLS色彩空间内完成。

  .. method:: replace_hsv_saturation(saturation)

    把该Color对象的饱和度替换为 *saturation* ，将结果返回为一个新的Color对象。在这HSV色彩空间内完成。

  .. method:: replace_hue(hue)

    把该Color对象的色相替换为位于0.0到1.0闭区间内的 *hue* ，将结果返回为一个新的Color对象。

  .. method:: replace_lightness(lightness)

    把该Color对象的亮度替换为 *lightneww* ，将结果返回为一个新的Color对象。在这HLS色彩空间内完成。

  .. method:: replace_opacity(opacity)

    把该Color对象的饱和度替换为 *saturation* ，将结果返回为一个新的Color对象。

  .. method:: replace_value(value)

    把该Color对象的明度替换为 *value* ，将结果返回为一个新的Color对象。在这HSV色彩空间内完成。

  .. method:: rotate_hue(rotation)

    使用 *rotation* 调整该Color对象的色相，将结果返回为一个新的Color对象。 *rotation* 是色相环旋转角度。色相环旋转一周360度。

  .. method:: shade(fraction)

    将该Color对象与黑色混合，创建色彩的低调(shade)。 *fraction* 是新色彩相对原色彩的比值。如果 *fraction* 为1.0，色彩不发生变化；如果为0.0，返回黑色。

    alpha值不会被这个方法改变。

  .. method:: tint(fraction)

    将该Color对象与白色混合，创建色彩的高调(tint)。*fraction* 是新色彩相对原色彩的比值。如果 *fraction* 为1.0，色彩不发生变化；如果为0.0，返回白色。

    alpha值不会被这个方法改变。
