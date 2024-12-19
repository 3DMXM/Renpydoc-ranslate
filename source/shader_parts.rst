.. _default-shader-parts:

默认着色器名称
==============

着色器可以被 :doc:`model` 和 :doc:`textshaders` 使用。
此页文档包含了着色器优先级索引，以及每个默认着色器代码。

.. _vertex-part-priorities:

顶点着色器优先级
----------------------

Ren'Py使用顶点着色器的优先级如下：

* 优先级 0 设置gl_Position。
* 优先级 10 在后续调整前设置gl_Postion的虚拟坐标或可绘制区域的坐标。
* 优先级 20-80 调整gl_Postion的虚拟坐标或可绘制区域的坐标。
* 优先级 90 在调整后设置gl_Postion的虚拟坐标或可绘制区域的坐标。
* 优先级 100 将gl_Position转换为视口坐标。
* 优先级 200 存储各种变量信息，不能修改gl_Position。

按顺序列出：

0. :ref:`renpy.geometry <shader-renpy-geometry>`
10. :ref:`textshader.linetexture <shader-textshader-linetexture>`
10. :ref:`textshader.texture <shader-textshader-texture>`
20. :ref:`textshader.flip <shader-textshader-flip>`
25. :ref:`textshader.zoom <shader-textshader-zoom>`
30. :ref:`textshader.jitter <shader-textshader-jitter>`
35. :ref:`textshader.offset <shader-textshader-offset>`
40. :ref:`textshader.wave <shader-textshader-wave>`
100. :ref:`renpy.geometry <shader-renpy-geometry>`
200. :ref:`renpy.alpha_mask <shader-renpy-alpha-mask>`
200. :ref:`renpy.blur <shader-renpy-blur >`
200. :ref:`renpy.dissolve <shader-renpy-dissolve>`
200. :ref:`renpy.imagedissolve <shader-renpy-imagedissolve>`
200. :ref:`renpy.mask <shader-renpy-mask>`
200. :ref:`renpy.texture <shader-renpy-texture>`
200. :ref:`textshader.dissolve <shader-textshader-dissolve>`
200. :ref:`textshader.typewriter <shader-textshader-typewriter>`

.. _fragment-part-priorities:

片元着色器优先级
------------------------

Ren'Py使用片元着色器的优先级如下

* 优先级 200 决定一个初始颜色并存储在gl_FragColor中。
* 优先级 300 与另一张纹理中的颜色相乘。
* 优先级 325 在文本着色器调整前存储alpha值。
* 优先级 350 应用文本着色器调整alpha值。
* 优先级 375 可以回撤文本着色器的效果。
* 优先级 400 调整颜色，应用变换和基于可视组件级别的更改。
* 优先级 500 调整alpha通道，应用变换和基于可视组件级别的更改。

按顺序列出：

200. :ref:`renpy.blur <shader-renpy-blur>`
200. :ref:`renpy.dissolve <shader-renpy-dissolve>`
200. :ref:`renpy.imagedissolve <shader-renpy-imagedissolve>`
200. :ref:`renpy.mask <shader-renpy-mask>`
200. :ref:`renpy.solid <shader-renpy-solid>`
200. :ref:`renpy.texture <shader-renpy-texture>`
300. :ref:`textshader.linetexture <shader-textshader-linetexture>`
300. :ref:`textshader.texture <shader-textshader-texture>`
325. :ref:`textshader.slowalpha <shader-textshader-slowalpha>`
350. :ref:`textshader.dissolve <shader-textshader-dissolve>`
350. :ref:`textshader.typewriter <shader-textshader-typewriter>`
375. :ref:`textshader.slowalpha <shader-textshader-slowalpha>`
400. :ref:`renpy.matrixcolor <shader-renpy-matrixcolor>`
500. :ref:`renpy.alpha <shader-renpy-alpha>`
500. :ref:`renpy.alpha_mask <shader-renpy-alpha-mask>`

.. _shader-renpy-alpha:

renpy.alpha
-----------

变量列表：

::

    uniform float u_renpy_alpha;
    uniform float u_renpy_over;

片元着色器(优先级500)：

::

    gl_FragColor = gl_FragColor * vec4(u_renpy_alpha, u_renpy_alpha, u_renpy_alpha, u_renpy_alpha * u_renpy_over);

.. _shader-renpy-alpha_mask:

renpy.alpha_mask
-----------------

变量列表：

::

    uniform sampler2D tex0;
    uniform sampler2D tex1;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器(优先级200)：

::

    v_tex_coord = a_tex_coord;

片元着色器(优先级500)：

::

    vec4 src  = texture2D(tex0, v_tex_coord.xy);
    vec4 mask = texture2D(tex1, v_tex_coord.xy);

    gl_FragColor = vec4(src.r * mask.r, src.g * mask.r, src.b * mask.r, mask.r);

.. _shader-renpy-blur:

renpy.blur
----------

变量列表：

::

    uniform sampler2D tex0;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;
    uniform float u_renpy_blur_log2;

顶点着色器(优先级200)：

::

    v_tex_coord = a_tex_coord;

片元着色器(优先级200)：

::

    gl_FragColor = vec4(0.);
    float renpy_blur_norm = 0.;

    for (float i = -5.; i < 1.; i += 1.)
    {
        float renpy_blur_weight = exp(-0.5 * pow(u_renpy_blur_log2 - i, 2.));
        renpy_blur_norm += renpy_blur_weight;
    }

    gl_FragColor += renpy_blur_norm * texture2D(tex0, v_tex_coord.xy, 0.);

    for (float i = 1.; i < 14.; i += 1.)
    {

        if (i >= u_renpy_blur_log2 + 5.)
        {
            break;
        }

        float renpy_blur_weight = exp(-0.5 * pow(u_renpy_blur_log2 - i, 2.));
        gl_FragColor += renpy_blur_weight * texture2D(tex0, v_tex_coord.xy, i);
        renpy_blur_norm += renpy_blur_weight;
    }

    if (renpy_blur_norm > 0.0)
    {
        gl_FragColor /= renpy_blur_norm;
    }
    else
    {
        gl_FragColor = texture2D(tex0, v_tex_coord.xy, 0.0);
    }

.. _shader-renpy-dissolve:

renpy.dissolve
--------------

变量列表：

::

    uniform float u_lod_bias;
    uniform sampler2D tex0;
    uniform sampler2D tex1;
    uniform float u_renpy_dissolve;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器(优先级200)：

::

    v_tex_coord = a_tex_coord;

片元着色器(优先级200)：

::

    vec4 color0 = texture2D(tex0, v_tex_coord.st, u_lod_bias);
    vec4 color1 = texture2D(tex1, v_tex_coord.st, u_lod_bias);

    gl_FragColor = mix(color0, color1, u_renpy_dissolve);

.. _shader-renpy-geometry:

renpy.geometry
--------------

变量列表：

::

    uniform mat4 u_transform;
    attribute vec4 a_position;

顶点着色器(优先级0)：

::

    gl_Position = a_position;

顶点着色器(优先级100)：

::

    gl_Position = u_transform * gl_Position;

.. _shader-renpy-imagedissolve:

renpy.imagedissolve
-------------------

变量列表：

::

    uniform float u_lod_bias;
    uniform sampler2D tex0;
    uniform sampler2D tex1;
    uniform sampler2D tex2;
    uniform float u_renpy_dissolve_offset;
    uniform float u_renpy_dissolve_multiplier;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器(优先级200)：

::

    v_tex_coord = a_tex_coord;

片元着色器(优先级200)：

::

    vec4 color0 = texture2D(tex0, v_tex_coord.st, u_lod_bias);
    vec4 color1 = texture2D(tex1, v_tex_coord.st, u_lod_bias);
    vec4 color2 = texture2D(tex2, v_tex_coord.st, u_lod_bias);

    float a = clamp((color0.a + u_renpy_dissolve_offset) * u_renpy_dissolve_multiplier, 0.0, 1.0);
    gl_FragColor = mix(color1, color2, a);

.. _shader-renpy-mask:

renpy.mask
----------

变量列表：

::

    uniform float u_lod_bias;
    uniform sampler2D tex0;
    uniform sampler2D tex1;
    uniform float u_renpy_mask_multiplier;
    uniform float u_renpy_mask_offset;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器(优先级200)：

::

    v_tex_coord = a_tex_coord;

片元着色器(优先级200)：

::

    vec4 src = texture2D(tex0, v_tex_coord.st, u_lod_bias);
    vec4 mask = texture2D(tex1, v_tex_coord.st, u_lod_bias);

    gl_FragColor = src * (mask.a * u_renpy_mask_multiplier + u_renpy_mask_offset);

.. _shader-renpy-matrixcolor:

renpy.matrixcolor
-----------------

变量列表：

::

    uniform mat4 u_renpy_matrixcolor;

片元着色器(优先级400)：

::

    gl_FragColor = u_renpy_matrixcolor * gl_FragColor;

.. _shader-renpy-solid:

renpy.solid
-----------

变量列表：

::

    uniform vec4 u_renpy_solid_color;

片元着色器(优先级200)：

::

    gl_FragColor = u_renpy_solid_color;

.. _shader-renpy-texture:

renpy.texture
-------------

变量列表：

::

    uniform float u_lod_bias;
    uniform sampler2D tex0;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器(优先级200)：

::

    v_tex_coord = a_tex_coord;

片元着色器(优先级200)：
::

    gl_FragColor = texture2D(tex0, v_tex_coord.xy, u_lod_bias);

.. _shader-textshader.dissolve:

textshader.dissolve
-------------------

变量列表：

::

    uniform float u_textshader_dissolve_duration;
    uniform float u_text_slow_duration;
    uniform float u_text_slow_time;
    attribute float a_text_time;
    varying float v_text_time;

顶点着色器(优先级 200)：

::
    v_text_time = a_text_time;

片元着色器(优先级 350)：

::
    float l_textshader_dissolve_duration = u_textshader_dissolve_duration * u_text_slow_duration;
    float l_textshader_dissolve_done;
    if (l_textshader_dissolve_duration > 0.0) {
        l_textshader_dissolve_done = clamp((u_text_slow_time - v_text_time) / l_textshader_dissolve_duration, 0.0, 1.0);
    } else {
        l_textshader_dissolve_done = v_text_time <= u_text_slow_time ? 1.0 : 0.0;
    }
    gl_FragColor = gl_FragColor * l_textshader_dissolve_done;

.. _shader-textshader.flip:

textshader.flip
---------------

变量列表：

::

    uniform float u_textshader_flip_duration;
    uniform float u_text_slow_duration;
    uniform float u_text_slow_time;
    attribute vec2 a_text_center;
    attribute float a_text_min_time;

顶点着色器(优先级 20):

::

    float l_textshader_flip_duration = u_textshader_flip_duration * u_text_slow_duration;
    float l_textshader_flip_done;

    if (l_textshader_flip_duration > 0.0) {
        l_textshader_flip_done = clamp((u_text_slow_time - a_text_min_time) / l_textshader_flip_duration, 0.0, 1.0);
    } else {
        l_textshader_flip_done = a_text_min_time <= u_text_slow_time ? 1.0 : 0.0;
    }

    gl_Position.x = mix(a_text_center.x - (gl_Position.x - a_text_center.x), gl_Position.x, l_textshader_flip_done);

.. _shader-textshader.jitter:

textshader.jitter
-----------------

变量列表：

::

    uniform vec2 u_textshader_jitter_jitter;
    uniform vec4 u_random;
    uniform float u_text_to_drawable;

顶点着色器(优先级 30):

::

    vec2 l_textshader_jitter_jitter = u_textshader_jitter_jitter * u_text_to_drawable;
    gl_Position.xy += l_textshader_jitter_jitter * u_random.xy - l_textshader_jitter_jitter / 2.0;

.. _shader-textshader.linetexture:

textshader.linetexture
----------------------

变量列表：

::

    uniform sampler2D u_textshader_linetexture_texture;
    uniform vec2 u_textshader_linetexture_scale;
    uniform vec2 u_textshader_linetexture_texture_res;

    uniform float u_text_to_virtual;
    uniform float u_text_main;

    attribute vec2 a_text_center;
    varying vec2 v_textshader_linetexture_coord;

顶点着色器(优先级 10):

::

    v_textshader_linetexture_coord = vec2( gl_Position.x, (gl_Position.y - a_text_center.y)) / u_textshader_linetexture_scale * u_text_to_virtual / u_textshader_linetexture_texture_res;
    v_textshader_linetexture_coord.y += 0.5;

片元着色器(优先级 300):

::

    if (u_text_main == 1.0) {
        gl_FragColor = texture2D(u_textshader_linetexture_texture, v_textshader_linetexture_coord) * gl_FragColor;
    }

.. _shader-textshader.offset:

textshader.offset
-----------------

变量列表：

::
    uniform vec2 u_textshader_offset_offset;
    uniform float u_text_to_drawable;

顶点着色器(优先级 35):

::

    gl_Position.xy += u_textshader_offset_offset * u_text_to_drawable;

.. _shader-textshader.slowalpha:

textshader.slowalpha
--------------------

变量列表：

::
    uniform float u_textshader_slowalpha_alpha

片元着色器(优先级 325):

::

    vec4 l_textshader_slowalpha_color = gl_FragColor;

片元着色器(优先级 375):

::

    gl_FragColor = mix(gl_FragColor, l_textshader_slowalpha_color, u_textshader_slowalpha_alpha);

.. _shader-textshader.texture:

textshader.texture
------------------

变量列表：

::

    uniform sampler2D u_textshader_texture_texture;
    uniform vec2 u_textshader_texture_texture_res;

    uniform float u_text_to_virtual;
    uniform float u_text_main;
    varying vec2 v_textshader_texture_coord;

顶点着色器(优先级 10):

::

    v_textshader_texture_coord = u_text_to_virtual * gl_Position.xy / u_textshader_texture_texture_res;

片元着色器(优先级 300):

::

    if (u_text_main == 1.0) {
        gl_FragColor = texture2D(u_textshader_texture_texture, v_textshader_texture_coord) * gl_FragColor;
    }

.. _shader-textshader.typewriter:

textshader.typewriter
---------------------

变量列表：

::

    uniform float u_text_slow_time;
    attribute float a_text_min_time;
    varying float v_text_min_time;

顶点着色器(优先级 200):

::

    v_text_min_time = a_text_min_time;

片元着色器(优先级 350):

::

    float l_textshader_typewriter_done = v_text_min_time <= u_text_slow_time ? 1.0 : 0.0;
    gl_FragColor = gl_FragColor * l_textshader_typewriter_done;

.. _shader-textshader.wave:

textshader.wave
---------------

变量列表：

::

    uniform float u_textshader_wave_amplitude;
    uniform float u_textshader_wave_frequency
    uniform float u_textshader_wave_wavelength;

    uniform float u_time;
    uniform float u_text_to_drawable;
    attribute float a_text_index;

顶点着色器(优先级 40):

::

    gl_Position.y += cos(2.0 * 3.14159265359 * (a_text_index / u_textshader_wave_wavelength + u_time * u_textshader_wave_frequency)) * u_textshader_wave_amplitude * u_text_to_drawable;

.. _shader-textshader.zoom:

textshader.zoom
---------------

变量列表：

::

    uniform float u_textshader_zoom_zoom;
    uniform float u_textshader_zoom_duration;
    uniform float u_text_slow_duration;
    uniform float u_text_slow_time;
    attribute vec2 a_text_center;
    attribute float a_text_min_time;

顶点着色器(优先级 25):

::

    float l_textshader_zoom_duration = u_textshader_zoom_duration * u_text_slow_duration;

    if (l_textshader_zoom_duration > 0.0) {
        float l_textshader_zoom_done = clamp((u_text_slow_time - a_text_min_time) / l_textshader_zoom_duration, 0.0, 1.0);
        gl_Position.xy = mix(a_text_center + (gl_Position.xy - a_text_center) * u_textshader_zoom_zoom, gl_Position.xy, l_textshader_zoom_done);
    }
