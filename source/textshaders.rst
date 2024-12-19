.. _text-shaders:

============
文本着色器
============

Ren'Py中包含一个文本着色器(text shader)系统，可以控制文本的显示效果。
启用文本着色器系统后，会使用两个三角面片 :doc:`model` 来渲染每一个Unicode字符。
创作者自定义或Ren'Py内置的着色器程序都可以通过这种方式应用在模型上，并控制文本显示效果。

文本着色器的文档有三块内容：

#. 如何使用文本着色器
#. Ren'Py内置哪些文本着色器
#. 如何创建新的文本着色器

需要注意，文本着色器系统本身不复杂，游戏创作者可以很容易掌握。
但制作符合自己要求的文本着色器需要很多基础知识，比如GLSL(OpenGL Shading Language)和 :doc:`model` 等。
其中大部分基础知识都与Ren'Py的功能特性无关。

.. _using-text-shaders:

使用文本着色器
===================

总共有三种方法可以使用文本着色器：

**默认文本着色器** 第一种方法，使用 :var:`config.default_textshader` 设置默认的文本着色器。

::

    define config.default_textshader = "wave:10"

这样设置后，指定的文本着色器将用于所有文本，除了某些额外指定了文本着色器的内容。
该设置项还可以合并多个文本着色器，其中大部分都是默认着色器。

默认文本着色器需要小心慢速文本的情况，并且不应产生副作用。

**样式** 第二种方法，使用样式特性 :propref:`textshader`。可以直接指定样式特性，也可以使用Ren'Py提供的多种样式设置方式。

::

    style default:
        textshader "dissolve"

    define goldfinger = Character("金手指", what_textshader="linetexture:gold.png")

    screen purchase():
        vbox:
            text "购买DLC内容！" textshader "wave"
            textbutton "立刻购买":
                text_textshader "wave" action iap.Purchase("dlc")

**文本标签** 第三种方法，使用 :tt:`对应的文本标签 <shader>` 修改部分文本的显示效果。

::

    "这是什么？  {shader=zoom}突然出现{/shader} 的一封信？"

**注意** 一个文本段落要么都使用文本着色器，要么都不使用，不能混着用。
例如，应该通过设置 :var:`config.default_textshader` 或样式特性 :propref:`textshader`，再使用文本标签显示效果。

.. _specifying-text-shaders:

指定文本着色器
-----------------------

在脚本中可以使用字符串来指定文本着色器：

::

    "dissolve"
    "jitter:u__jitter=1.0, 3.0"
    "texture:gold.png"

字符串的第一部分，即第一个冒号前的内容，表示文本着色器的名称。
字符串的其他部分，对应传给着色器的一些uniform变量，使用冒号分隔。
(uniform变量是着色器程序的控制变量。)

uniform变量可以使用等号(=)赋值。也可以省略uniform变量名，按顺序依次对所有uniform变量赋值。(Ren'Py 7不支持省略uniform变量名。)
所有内置变量名均以 u\_ 开头，处于简洁也可以省略这个 u\_ 。

uniform变量的值可能是以下类型：

* 至少1个至多4个的数字，使用逗号分隔。分别用于float、vec2、vec3和vec4类型的变量。
* 以#开头，表示颜色。(例如，#f00和#ff0000都表示红色。)该值会创建一个颜色对应的vec4向量。颜色会预乘上alpha通道的值。
* 一个 :doc:`可视组件 <displayables>`，会用做一张纹理。纹理会创建一个sampler2D对象，并用于纹理采样。

uniform值不能使用表达式或从某个变量读取，但可以使用文本内插创建一个字符串并计算出某个文本着色器的标签或参数。

最后，文本着色器可以使用 | 符号联用。例如：

::

    "jitter:1.0, 3.0|wave"

上面这句脚本会在文本中同时应用jitter和wave两个着色器，前提是两个着色器互相兼容，并且没有同名的uniform变量
(或具有同名且同类型的uniform变量，能够互相兼容，取值固定使用着色器列表中最后一个同名uniform变量的值)。

除非文本着色器显式将 `include_default` 设置为False，通过样式或文本标签应用文本着色器时都将联用默认的文本着色器。

.. _text-shader-callback:

文本着色器回调
---------------------

配置项 :var:`config.textshader_callbacks` 可以设置回调函数，在启用某个文本着色器之后就会调用设置的回调函数。
该功能可以基于个人设置(preference)定制文本着色器。

::


    default persistent.dissolve_text = True

    init python:
        def get_default_textshader():
            if persistent.dissolve_text:
                return "dissolve"
            else:
                return "typewriter"

    define config.default_textshader = "default"
    define config.textshader_callbacks["default"] = get_default_textshader

.. _built-in-text-shaders:

内建的文本着色器
=====================

以下是Ren'Py内建的文本着色器：

.. function:: dissolve

    dissolve文本着色器可以将文本以溶解(dissolve)形式缓慢显示出来。dissolve指定范围的字符，按顺序依次显示，直到显示完最后一个字符。

    `u__duration = 10.0`
        过渡效果持续时间。若设为0，立刻显示没有过渡效果。

.. function:: flip

    flip文本着色器会将文本在水平方向上翻转。开头的字符先翻转，最后的字符最后翻转。

    `u__duration = 10.0`
        过渡效果持续时间。若设为0，立刻翻转没有过渡效果。

.. function:: jitter

    jitter文本着色器会让文本抖动，即根据文本原显示位置添加一个随机偏移量，且每帧的位置偏移量都重新计算。

    `u__jitter=(3.0, 3.0)`
        抖动幅度，单位为像素。

.. function:: linetexture

    将文本与某个纹理相乘，各行单独计算。用到的纹理在水平方向会与文本左端对齐。
    纹理的中心点在垂直方向上会与文本底部对齐，这也意味着纹理下半部分几乎就看不到了。

    `u__texture = ...`
        与文本相乘使用的纹理。

    `u__scale = (1.0, 1.0)`
        纹理的缩放系数。例如(1.0, 0.5)可以让纹理变为原本的一半高度。

.. function:: offset

    offset文本着色器可以让文本位置偏移一个固定的值。

    `u__offset = (0.0, 0.0)`
        文本偏移量，单位为像素。

.. function:: slowalpha

    slowalpha着色器用于配合另一个慢速文本着色器，比如typewriter或dissolve。
    它可以让未被其他文本着色器生效的文本内容以一个半透明的状态显示而不是完全不可见，即参数u__alpha的值。

    `u__alpha = 0.2`
        其他文本着色器还未生效部分的文本不透明度。

.. function:: texture

    texture文本着色器会将多行文本与某个纹理的颜色相乘。
    它不对轮廓线(outline)和偏移(offset)生效。用到的纹理将与整段文本的左上角对齐。

    `u__texture = ...`
        与文本相乘使用的纹理。

.. function:: typewriter

    typewriter文本着色器配合低速文本，可以让字符逐个出现，模仿人类打字员的行为。

    使用该着色器后，默认文本着色器将不生效。

.. function:: wave

    wave文本着色器可以让文本向波浪一样上下弹跳。

    `u__amplitude = 5.0`
        文本的上下位移幅度，单位为像素。

    `u__frequency = 2.0`
        移动频率，表示每秒完成整个弹跳的次数。

    `u__wavelength = 20.0`
        整个波长范围涉及的字符数。

.. function:: zoom

    zoom文本着色器可以让低速文本从某个初始大小逐步放大到完整尺寸。初始大小的值由参数u__zoom决定，默认为0.0。

    `u__zoom = 0.0`
        字符显示时的初始大小。

    `u__duration = 10.0`
        过渡效果持续时间。若设为0，立刻变大没有过渡效果。

    使用该着色器后，默认文本着色器将不生效。

.. _creating-text-shaders:

创建文本着色器
=====================

文本着色器是运行在GPU上的GLSL程序。可以使用 renpy.register_text_shader 函数注册文本着色器。

.. function:: renpy.register_textshader(name, shaders=(), extra_slow_time=0.0, extra_slow_duration=0.0, redraw=None, redraw_when_slow=0.0, include_default=True, adjust_function=None, doc=None, **kwargs)

    该函数会创建一个文本着色器，并注册着色器名 `name` 。

    该函数使用下列入参：

    `name`
        文本着色器名。同时也会注册一个名为 `name` 的着色器程序。

    `shaders`
        应用到文本的着色器程序。该项可以是一个字符串，字符串列表或字符串元组。
        该项中包含的着色器程序必须是通过 :func:`renpy.register_shader` 或本函数注册过的着色器。
        如果着色器名前带一个‘-’，表示从着色器列表中移除对应的着色器程序。
        (例如，“-textshader.typewriter”表示移除typerwriter着色器。)

        注意，通过该函数注册的着色器名自动添加了前缀“textshader.”，在作为参数时需要传入完整的着色器名。

    `extra_slow_time`
        添加一个额外的时间。Ren'Py计算当前字符的效果时间时将加上该时间。
        某些着色器做字符过渡效果时间不足时，该参数就可以用上。

    `extra_slow_duration`
        该参数也是一个时间值，会除以同时生效字符总数然后再加到 `extra_slow_time` 上。

    `redraw`
        所有低速文本显示并且经过 `extra_slow_time` 时间后，再次重新绘制的时间间隔，单位为秒。

    `redraw_when_slow`
        文本已绘制并且显示低速文本时，再次重新绘制的时间间隔，单位为秒。

    `include_default`
        若为True，将会联用 :var:`config.default_textshader` 中的着色器。

    `adjust_function`
        该参数是一个函数，通过某个对象调用。传给文本着色器的uniform变量会先使用该函数处理。
        该函数可以设置来源对象的 `extra_slow_time`、`extra_slow_duration`、
        `redraw` 和 `redraw_when_slow` 这4个字段。

    `doc`
        包含文档信息的一个字符串。该参数为Ren'Py的文档系统所设计。

    以 ``u_`` 开头的关键字入参会传给着色器作为uniform变量，以 ``#`` 开头的字符串会识别为某种颜色。
    大多数uniform变量都应该以 ``u__`` 开头，使用 :ref:`着色器本地变量 <shader-local-variables>` 防止与其他着色器发生变量名冲突。

    名为 `variables` 的关键字入参和所有以 `fragment_`、`vertex_` 开头的关键字入参都会传给 :func:`renpy.register_shader` 函数，
    并注册对应的着色器。

.. _variables-in-text-shaders:

文本着色器中的变量
-------------------------

除了创作者自己设计文本着色器时指定的uniform变量(通常以 ``u__`` 开头)，Ren'Py还使下列变量可以直接在文本着色器中使用。
若要在文本着色器中使用某个变量，需要将变量名通过 `variables` 参数传入 renpy.register_text_shader 函数。

除此之外，针对模型还可以使用 :ref:`uniform和attribute变量 <model-uniforms>`，
常用的包括 `a_position`、`a_tex_coord`、`u_time` 和 `u_random`。

.. _uniforms:

uniform变量
^^^^^^^^^^^

``float u_text_depth``
    从最顶层算起，文本的深度(depth)。最顶层的文本深度为0.0，第一层轮廓线或投影的深度为1.0，第二层罗廓线或投影的深度为2.0，以此类推。

``float u_text_main``
    若该变量值为1.0，则对应文本为主要文本。若该变量值为0.0，则对应文本为主要文本的轮廓线或投影。

``float u_text_max_depth``
    u_text_depth的最大值，表示能绘制的轮廓线和投影总数量。
    当u_text_depth等于u_text_max_depth时，意味着当前文本是最后一层轮廓线或投影，该功能在绘制背景时可能有用。

``vec2 u_text_offset``
    文本相对字符中心点的偏移量。按照先在x轴方向偏移再y轴方向偏移的顺序计算，单位为像素。

``float u_text_outline``
    文本轮廓线宽度。轮廓线只考虑能绘制的像素点。该变量表示从文本外缘到轮廓线外援的距离，单位为像素。

``float u_text_slow_duration``
    使用低速文本时，单个字符的效果时间。设置为0.0表示不显示低速文本。

``float u_text_slow_time``
    低速文本效果的时间戳，从效果生效开始计算，单位为秒。仅当低速文本效果结束时该值才会增加，并输出最大值。
    如果用户点击并结束了低速文本，也会输出最大值。其应只能用于低速文本。

``float u_text_to_drawable``
    虚拟像素向可绘制像素的转换比例。

``float u_text_to_virtual``
    可绘制像素向虚拟像素的转换比例。

``sampler2D tex0``
    在当前深度(depth)包含渲染文本的对应纹理。

``vec2 res0``
    tex0的分辨率，以可绘制像素计。

.. _attributes:

attribute变量
^^^^^^^^^^^^^

绘制文本时，每个字形(glyph)都有自身对应的顶点(vertex)。多个字形可能会有一些顶点的坐标是相同的，但依然会看作不同顶点传入着色器。

(译者注：baseline、ascent和descent是字母型文字才需要考虑的东西，纯中文用户完全不用管。)

``float a_text_ascent``
    当前字形的字体在基线以上的ascent高度，以可绘制像素计。

``vec2 a_text_center``
    字形基线的中心坐标，以可绘制像素计。该坐标并不是三角形中心，由基线与字符中心的距离决定。

``float a_text_descent``
    The descent of the current glyph below the baseline, in drawable pixels.
    当前字形的字体在基线以下的descent高度，以可绘制像素计。

``float a_text_index``
    正在绘制字形的索引号。顶点索引从0开始，依次递增。

``vec2 a_text_min_time``
    所有字形的任意顶点需要显示的最小时间。从左往右显示时，即最左端顶点的显示时间。
    若要让文本立刻显示，但 ``u_text_slow_duration`` 的值又不是0.0，该项应设置为-3600.0。

``vec2 a_text_max_time``
    所有字形的任意顶点需要显示的最大时间。从左往右显示时，即最右端顶点的显示时间。
    若要让文本立刻显示，但 ``u_text_slow_duration`` 的值又不是0.0，该项应设置为-3600.0。

``float a_text_time``
    对应顶点的显示时间。
    若要让文本立刻显示，但 ``u_text_slow_duration`` 的值又不是0.0，该项应设置为-3600.0。

``vec4 a_text_pos_rect``
    整个字形的包围框，以可绘制像素计。该变量是一个vec4类型，分别表示包围狂的x、y、宽度和高度，以可绘制像素计。
    可以通过除以 ``res0`` 来获得纹理坐标值。

.. _pseudo-glyphs:

伪字形
-------------

Ren'Py绘制带轮廓线的文本时，会创建覆盖文本开头和结尾的伪字形(pseudo-glyph)。
如果遇到空行，则会创建覆盖整行的伪字形。
这些伪字形用于计算轮廓线超出文字顶部和底部的区域。

.. _text-shaders-example:

样例
-------

这是一个文本着色器样例，能让文本显示后转动。

::

    init python:

        def adjust_extra_slow_time(ts, u__delay, **kwargs):
            """
            调整文本着色器的额外显示时间，以支持旋转文本着色器。
            """
            ts.extra_slow_time = u__delay

        renpy.register_textshader(
            "spin",
            adjust_function = adjust_extra_slow_time,

            variables = """
            uniform float u__delay;
            uniform float u__offset;
            uniform float u_text_slow_time;
            attribute vec2 a_text_center;
            attribute float a_text_min_time;
            """,

            vertex_50 = """
            float l__angle = clamp((u_text_slow_time - a_text_min_time) / u__delay, 0.0, 1.0) * 2.0 * 3.1415926536;
            float l__sin = sin(l__angle);
            float l__cos = cos(l__angle);

            gl_Position.y -= u__offset;
            gl_Position.xy -= a_text_center;
            gl_Position = vec4(
                gl_Position.x * l__cos - gl_Position.y * l__sin,
                gl_Position.x * l__sin + gl_Position.y * l__cos,
                gl_Position.z,
                gl_Position.w
                );
            gl_Position.xy += a_text_center;
            gl_Position.y += u__offset;
            """,

            u__delay = 1.0,
            u__offset = 0,
        )

之后就可以在如下脚本中使用：

::

    define config.default_textshader = "typewriter"

    label start:

        "这是一个 {shader=spin:0.5:-5}旋转{/shader} 文本着色器测试。"