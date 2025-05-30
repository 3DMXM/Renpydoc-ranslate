.. _model-based-rendering:

基于模型的渲染器
=====================

尽管Ren'Py在视觉小说中主要使用二维矩形图形，但为了利用各类主流GPU的功能特性其实Ren'Py内置了一个基于模型的渲染器。
使用该渲染器可以实现很多视觉特效。

事先预警，该渲染器是Ren'Py最新添加的功能。很多情况下，不需要理解基于模型渲染器在后台的工作原理，就可以使用
新增的特性，比如 :tpref:`matrixcolor` 和Live2D的支持。Ren'Py后续也会添加类似的功能。
本页文档主要面向最前沿的创作者，以及尝试在Ren'Py中添加新功能的开发人员。

基于模型渲染器是Ren'Py中最新的功能特性，如果事先没有看过OpenGL、OpenGL ES、GLSL和GLSL ES手册的话，理解本页文档可能十分困难。
此外，不同图形处理单元驱动对输入模型数据的要求可能略有不同，需要事先检查硬件信息。

.. _modles-renders-and-drawing-oprations:

模型，渲染和绘图操作
---------------------

Ren'Py绘制到屏幕上的内容，本质上是一个模型。该模型包含以下内容：

* 由一个或多个三角形组成的网格(mesh)。
  一个三角形包含三个顶点(vertice)。
  每个顶点包含二维或三维空间中的位置信息，还可能包含其他信息，比如最常见的是纹理(texture)坐标。

* 0个或若干个纹理(texture)，最大数量受限于游戏实际运行平台的图形处理单元(GPU)。所有的图形处理单元都至少需要支持每个模型3个纹理。
  纹理是一个含有图像数据的矩形，可以直接或渲染加工后，加载进图形处理单元中。

* 着色器(shader)名称的一个列表。Ren'Py使用该列表创建着色器。着色器是在图形处理单元中运行的程序，用于渲染模型。
  着色器名称前缀为 “-” 表示禁用此着色器。

* uniform型变量值。uniform型变量保存添加到模型中的数据。比如，要使某个模型显示为某个纯色，指定的颜色就需要是一个uniform型。

* GL特性(property)。GL特性是控制渲染方式的标识型数据，比如模型的缩放模式以及颜色蒙版(mask)。

Ren'Py通常会在屏幕上同时绘制好几样东西，并创建一棵 :class:`Render` 对象树。
树上的Render对象的子对象可能是模型或其他Render对象。(后面会提到，Render对象也可以转为模型。)
一个Render对象包含：

* 子对象列表，包括每个子对象的二维偏移量。

* 一个  :class:`Matrix` 对象，用于描述各子对象变换到三维空间的方法。

* 模型绘制时需要用到的着色器名称、uniform变量和GL特性列表。

* 判断可绘制空间分割多边形是否更新的一些标识(flag)。

Ren'Py使用深度优先算法遍历Render对象树，遍历搜索到模型对象才绘制画面。
执行遍历时，Ren'Py会更新一个矩阵，该矩阵对模型的位置，分割多边形，着色器、uniform变量和GL特性列表进行转换。
当遍历的某一步中搜索到模型对象时，图形处理单元上对应的着色器程序将激活，并传入(矩阵内)所有信息，最后执行绘图操作。

.. _where-models-are-created:

模型对象在哪里创建的
------------------------

Ren'Py在常规操作中将自动创建模型对象。
理解模型创建细节的主要用处是，主动使用绘图操作生成模型对象以及直接在模型对象上的应用着色器。

图像和图像处理器(Image Manipulator)
    这两类创建的模型是由两个三角形组成的网格(mesh)，两个三角形正好覆盖原矩形图像。
    该网格包含纹理坐标。创建的模型使用 “renpy.texture” 着色器。

:func:`Solid`
    纯色可视组件创建的模型是由两个三角形组成的网格(mesh)，但没有纹理坐标。
    创建的模型使用 “renpy.solid” 着色器，该着色器使用的颜色信息存储在 ``u_renpy_solid_color`` uniform变量中。

:func:`Dissolve`, :func:`ImageDissolve`, :func:`AlphaDissolve`, :func:`Pixellate`, :func:`AlphaMask`, :func:`Flatten`
    以上这些变换和可视组件创建的模型对象可以根据实际需要包含对应的网格、着色器和uniform变量。

Live2D
    Live2D型可视组件在渲染时可能会创建多个模型对象，即每个图层一个模型对象。


:func:`Transform` 和 ATL
    Transform对象在 :tpref:`mesh` 为True或 :tpref:`blur` 特性时创建一个模型对象。
    模型创建后，Transform对象的所有子对象都将渲染为纹理，第一个纹理的网格作为整个模型的网格。

    并非所有的Transform都会创建模型对象。一些Transform值只是在渲染器中简单添加着色器和uniform变量(比如使用 :tpref:`blur` 和 :tpref:`alpha` 的Transform)。
    其他Transform只影响几何体(geometry)。

:class:`Render`
    当Transform对象的 ``mesh`` 属性(attribute)为True时，将创建模型对象。
    这种情况下，Render对象的所有子对象将被渲染为纹理，第一个纹理的网格作为整个模型的网格。

未来Ren'Py将添加更多创建模型的方法。

.. _shader-program-generation:

着色器程序概述
---------------

Ren'Py生成着色器程序的第一步是识别着色器名称列表。该列表包含 “renpy.geometry”，即从Render对象获取的着色器列表，以及模型对象绘制过程中用到的其他着色器。

接着所有着色器程序将被复制一份。以“-”开头的着色器将会从复制后的列表中删除，以及同名但开头不是“-”的着色器也删除。
(名为“-renpy.geometry”的着色器会导致自身和“renpy.geometry”都被删除)

接着，Ren'Py将根据列表中的着色器名，检索变量、函数、顶点着色器(vertex shade)和片元(fragment shader)列表，
并按优先级数值从小到大的顺序依次生成着色器源码。优先级数值定义在顶点着色器和片元着色器中。

Ren'Py会将使用过的所有着色器组合缓存在 game/cache/shaders.txt 文件中，并在启动时加载这个文件。
如果使用着色器方面有比较大改动，就需要编辑清空或删除这个文件。这样就可以重新生成有效数据。

.. _custom-shaders:

创建自定义着色器
----------------

通过调用 renpy.register_shader 函数可以基于GLSL规范创建新的着色器。

着色器名的格式必须是“命名空间.着色器名称”，比如“mygame.recolor”和“mylibrary.warp”。
Ren'Py已经占用了“renpy.”和“live2d.”两个命名空间，所有以下划线“_”开头的命名空间也是预留的不可使用。

.. function:: renpy.register_shader(name, **kwargs)

    该函数注册一个着色器名。其使用入参 `name` 和其他关键词参数：

    `name`
        指定着色器名称的字符串。以下划线或“renpy.”开头的名称已经被Ren'Py预留。


    `variables`
        着色器使用的各个变量。每行一个变量，存储类型(uniform、attribute或varying)后面跟变量类型、变量名称，结尾用分号。举例:
        ::

            variables='''
            uniform sampler2D tex0;
            attribute vec2 a_tex_coord;
            varying vec2 v_tex_coord;
            '''

    `vertex_functions`
        如果给定，该字符串会用作顶点着色器函数。

    `fragment_functions`
        如果给定，该字符串会用作片元着色器函数。

    着色器函数相关的两个关键词入参应该以 ``vertex_`` 或 ``fragment_`` 开头，结尾带一个整数表示优先级，比如“fragment_200”和“vertex_300”。
    这些优先级数值会决定着色器的应用方式，优先级数值低的函数会插入到优先级数值高的函数前面执行。

Ren'Py只支持以下变量类型：

* float (Python中的浮点数)
* vec2 (两个浮点数组成的向量)
* vec3 (三个浮点数组成的向量)
* vec4 (四个浮点数组成的向量)
* mat4 ( :class:`Matrix` 类)
* sampler2D (Ren'Py提供)

uniform变量开头必须为 u\_，attribute变量开头必须为 a\_，varying变量开头必须为 v\_。
以 u_renpy\_、 a_renpy 和 v_renpy 开头的变量都是Ren'Py预留变量名，不能用在自定义着色器中。

概览优先级的情况，优先级100设置几何体(geometry)，优先级200决定初始片元色彩(gl_FragColor)，更高数值优先级才能实际影响和改变片元色彩。

这里有一个自定义着色器样例，实现模型的色彩渐变：
::

    init python:

        renpy.register_shader("example.gradient", variables="""
            uniform vec4 u_gradient_left;
            uniform vec4 u_gradient_right;
            uniform vec2 u_model_size;
            varying float v_gradient_done;
            attribute vec4 a_position;
        """, vertex_300="""
            v_gradient_done = a_position.x / u_model_size.x;
        """, fragment_300="""
            gl_FragColor *= mix(u_gradient_left, u_gradient_right, v_gradient_done);
        """)

自定义着色器可以用作一个变换(transform)：
::

    transform gradient:
        shader "example.gradient"
        u_gradient_left (1.0, 0.0, 0.0, 1.0)
        u_gradient_right (0.0, 0.0, 1.0, 1.0)

    show eileen happy at gradient

还有一个变量可用于自定义着色器的debug：

.. var:: config.log_gl_shaders = False

    若该配置项为True，GLSL着色器程序的源代码会在启动阶段写入 log.txt 文件中。

.. _shader-local-variables:

着色器本地变量
---------------------------

着色器使用的本地变量可以用 ``u__``、``a__``、``v__`` 或 ``l__`` 作为前缀。
接着，所有的双下划线都会用着色名补充完整，着色器名中的“.”则会再替换为单下划线。
例如，着色器叫 ``example.gradient``，前缀 ``u__`` 会被替换为 ``u_example_gradient_``。

该功能的主要用于 :doc:`文本着色器 <textshaders>` ，大多数uniform变量都是着色器本地变量。
另外，着色器内部定义的变量都需要使用前缀 ``l__``。

.. _transforms-and-model-based-rendering:

Transform类和基于模型的渲染
---------------------------

基于模型的渲染功能在ATL和 :func:`Transform` 类中添加了下面两个特性：

.. transform-property:: mesh

    :type: None 或 True 或 元组
    :default: None

    若该值不是None，Transform对象将作为模型渲染。同时意味着：

    * 将创建一个网格。如果值是一个2元元组，将分别使用两个数值作为网格的x和y方向大小(任意方向至少为2)。如果值是True，根据子对象创建网格。
    * 该变换的子对象将渲染为纹理。
    * 渲染时将添加 renpy.texture 着色器。

.. transform-property:: mesh_pad

    :type: None 或 元组
    :default: None

    若该值不是None，其可能是2元或4元元组。
    如果mesh的值是True，mesh_pad表示网格纹理的四边留白大小。
    2元元组分别对应纹理的右侧和底部留白，4元元组分别对应纹理的左、顶、右、底留白。

    该特性可以与 pixel_perfect 一起使用，将文本渲染为网格。
    在Ren'Py中，文本渲染与屏幕分辨率有关，可能出现超出纹理无法覆盖网格的情况。
    添加一些留白会让纹理稍微大一点，可以完整显示所有像素。例如：

    ::

        transform adjust_text:
            mesh True
            mesh_pad (10, 0)
            gl_pixel_perfect True
            shader "shaders.adjust_text"

    可以确保传入着色器的纹理包含文本的所有像素。

.. transform-property:: shader

    :type: None 或 字符串 或 字符串列表
    :default: None

    若该值不是None，根据字符串或字符串列表将对应的着色器应用到Render对象(如果创建了模型对象)或在Render对象树上该Render对象分支后面的所有模型。

.. transform-property:: blend

    :type: None 或 str
    :default: None

    若该值不是None，其应该是一个字符串。根据该字符串在 :var:`config.gl_blend_func` 搜索对应的遮罩函数gl_blend_func特性后，用作图像遮罩模式。

    默认的遮罩模式包括“normal”(正常或覆盖)、“add”(相加)、“multiply”(相乘或正片叠底)、“min”(最小值)和“max”(最大值)。


以 u\_ 而非 u_renpy 开头的uniform型变量可以当作Transform的特性(property)来使用。
以 gl\_ 开头的GL特性(property)变量可以当作Transform的特性(property)来使用。
例如，想使用GL中的 color_mask 特性，在Transform中需要改为 gl_color_mask。

.. _blend-functions:

遮罩函数
---------------

.. var:: config.gl_blend_func = { ... }

    一个字典型数据，用作遮罩模式名与遮罩函数的映射关系。
    遮罩模式会赋值给 :ref:`gl_blend_func <gl-blend-func>` ，详见下表。

默认的遮罩模式有：

::

    gl_blend_func["normal"] = (GL_FUNC_ADD, GL_ONE, GL_ONE_MINUS_SRC_ALPHA, GL_FUNC_ADD, GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
    gl_blend_func["add"] = (GL_FUNC_ADD, GL_ONE, GL_ONE, GL_FUNC_ADD, GL_ZERO, GL_ONE)
    gl_blend_func["multiply"] = (GL_FUNC_ADD, GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA, GL_FUNC_ADD, GL_ZERO, GL_ONE)
    gl_blend_func["min"] = (GL_MIN, GL_ONE, GL_ONE, GL_MIN, GL_ONE, GL_ONE)
    gl_blend_func["max"] = (GL_MAX, GL_ONE, GL_ONE, GL_MAX, GL_ONE, GL_ONE)

由于Ren'Py会使用alpha预乘，导致某些像素的最终结果是半透明的。
在GPU中，颜色(r, g, b, a)会变成(r * a, g * a, b * a, a)，并传给遮罩函数。
这种机制可能会导致渲染出的颜色与绘图软件中的结果不一致。

.. _model-uniforms:

uniform和attribute变量
-----------------------

以下uniform型变量对所有模型都可直接使用。

``vec2 u_model_size``
    模型的宽度和高度。

.. _u-lod-bias:

``float u_lod_bias``
    纹理查找时细节等级(lod)的bias偏移。可以在一个变换对象中设置。
    :var:`config.gl` 配置项是其默认值，通常设置为-0.5。这样设置会让Ren'Py使用更高的采样级别，然后缩小。

``mat4 u_transform``
    此变换(transform)将项目虚拟像素转换为OpenGL的视口(viewport)。

``float u_time``
    该帧的时间。由于Epoch(译者注:1970年1月1日00:00:00 UTC)可能没有明确定义，所以最好把这个值看作是以秒为单位的数值，并按86400取模，每过一天都归零。

``vec4 u_random``
    4个介于0.0到1.0之间的随机数。每帧生成的随机数都不同(尽管可能比较相近)。

``vec4 u_viewport``
    该项指定当前绘制的视口(viewport)。
    u_viewport.xy表示从视口左下角为原点的坐标。
    u_viewport.pq表示视口的宽度和高度。

``vec2 u_virtual_size``

    游戏的虚拟分辨率(:var:`config.screen_width` ， :var:`config.screen_height`)。
    从gl_Position转化为虚拟坐标可以使用如下代码：

    .. code-block:: glsl

        v_position = u_virtual_size * vec2(gl_Position.x * .5 + .5, -gl_Position.y * .5 + .5)

``vec2 u_drawable_size``
    窗口的可绘制区域尺寸，单位是像素，一般等于游戏运行时的分辨率。
    例如1280×720分辨率的游戏拉伸到1920×1080运行，那么此项的值就是(1920, 1080)。

``sampler2D tex0``, ``sampler2D tex1``, ``sampler2D tex2``
    如果纹理可用，对应的sampler2D类型数据可以存入这些变量。

``vec2 res0``, ``vec2 res1``, ``vec2 res2``
    如果纹理可用，纹理的尺寸信息将存入这些变量。当纹理是从磁盘加载时，这些数值就是图片文件的尺寸。
    在渲染为纹理后，这些数值是实际可绘制像素的最小外接矩形的尺寸。

以下attribute型变量对所有模型都可直接使用。

``vec4 a_position``
    待渲染顶点位置信息。该值表示虚拟像素，以纹理左上角为原点。

如果纹理可用，还有下面的attribute型变量：

``vec2 a_tex_coord``
    顶点相对纹理内部的坐标。

.. _gl-properties:

GL特性(property)
-----------------

GL特性会更改OpenGL或基于模型渲染器的全局状态。
这些特性可以与Transform对象一起使用，或者 :func:`Render.add_property` 函数一起使用。

.. _gl-blend-func:

``gl_blend_func``
    该特性应是一个6元元组，用作一个方程的计算。此方程会根据遮罩像素、被遮罩像素等信息算出最终结果。
    分别用作功能调节像素、原像素、遮罩像素和功能条件像素相关参数。

    一个例子是(`rgb_equation`, `src_rgb`, `dst_rgb`, `alpha_equation`, `src_alpha`, `dst_alpha`)。
    调用方式如下：

    ::

        glBlendEquationSeparate(rgb_equation, alpha_equation)
        glBlendFuncSeparate(src_rgb, dst_rgb, src_alpha, dst_alpha)

    这些函数的功能请参考OpenGL文档。
    OpenGL常量可以从renpy.uguu中引入：

    ::

        init python:
            from renpy.uguu import GL_ONE, GL_ONE_MINUS_SRC_ALPHA

    更通用的建议方式是使用 :tpref:`blend` 变换特性。

``gl_color_mask``
    该特性应是一个布尔型4元元组，分别对应像素中的4个通道(红、绿、蓝和alpha)。只有当元组中对应通道的元素值为True时，绘图操作才会实际绘制像素的颜色值。

``gl_depth``
    若为True，将会清理深度缓存，然后启用该可视组件和其子组件的深度渲染。

    注意，绘制任意像素甚至是透明像素，都会更新深度缓存。因此，对包含半透明像素的图片使用该特性可能会导致无法预料的问题。
    (替代方案为，``show`` 语句中使用 ``zorder`` 和 ``behind`` 从句。)

``gl_pixel_perfect``
    只有创建网格时该特性才会生效。若该值是True，Ren'Py会把网格的第一个顶点与屏幕某个像素对齐。
    该特性常用于文本内容的衔接，确保文字的清晰度。

``gl_drawable_resolution``
    若为True或未设置，纹理将以游戏窗口的相同分辨率渲染。若为False，纹理将以可视组件的虚拟分辨率渲染。

``gl_anisotropic``
    该特性决定了，应到网格上的纹理是否创建各向异性(anisotropy)。
    各向异性是一种功能特性，能让纹理在X和Y方向的缩放系数不同时，采样出多个纹理元素(texel)。

    该项默认为True。Ren'Py将其设置为False，为了避免对其他效果产生影响，比如Pixellate(像素化)转场。

``gl_mipmap``
    该项决定纹理是否提供了网格用于创建mipmap。默认值为True.

``gl_texture_wrap``
    该项决定了将纹理映射到网格的方式。其值应该是一个2元元组，
    第一个元素用于设置GL_TEXTURE_WRAP_S，第二个元素用于设置GL_TEXTURE_WRAP_T，
    这两项通常用作纹理的X和Y轴映射方式。

    这些OpenGL常量应从renpy.uguu中引入：

    ::

        init python:
            from renpy.uguu import GL_CLAMP_TO_EDGE, GL_MIRRORED_REPEAT, GL_REPEAT

    该项可以针对不同纹理设置不同的值。`gl_texture_wrap_tex0` 控制第一纹理，`gl_texture_wrap_tex1` 控制第二纹理，
    `gl_texture_wrap_tex2` 控制第三纹理，`gl_texture_wrap_tex3` 控制第四纹理。在Transform对象中只能使用这4个默认纹理。
    如果需要同时使用更多纹理则可以使用Render.add_property添加“texture_wrap_tex4”或者“texture_wrap_myuniform”等。

.. _model-displayable:

模型可视组件
-----------------

模型可视组件(model displayable)就像是使用基于模型渲染器创建并使用模型的一个工厂。

.. class:: Model(size=None)

    该类是一种可视组件，让Ren'Py使用基于模型渲染器创建一个2D或3D模型，并根据指定渲染器绘制模型，
    或放入指定的Transform(或Displayable)对象中。

    `size`
        若非None，该参数应是一个分辨便是宽度和高度的二元元组，用于模型的尺寸。
        若没有指定，模型的尺寸将与其占用的区域一致。合适的参数也将影响模型使用到纹理的大小。

    如果没有调用 mesh 方法，且存在至少一个纹理，Ren'Py将根据加载纹理时的方式设置网格的 a_postion 和 a_tex_coord 值。
    否则，将只设置网格的a_postion。
    All methods on this calls return the displayable the method is called
    on, making it possible to chain calls.(译者注：看不懂这句写的是什么鸡掰意思……)

    .. method:: grid_mesh(width, height)

        生成一个width×height的空间点网格，将所有点在水平和垂直方向上距离最近的其他点连接生成矩形，然后将矩形沿对角线切割生成三角形网格。

        `width`, `height`
            水平和垂直方向上点的数量，都必须是不小于2的整数。

    .. method:: texture(displayable, focus=False, main=False, fit=False)

        通过指定可视组件，为该模型添加纹理。
        第一张纹理会成为 ``tex0``，第二张纹理则是 ``tex1`` ，以此类推。

        `focus`
            若为True，获得焦点事件将传给可视组件。
            默认作为入参的可视组件坐标以1:1映射到纹理。

        `main`
            若为True，作为入参的可视组件将作为模型的主要子组件，可以被可视组件检测器探知。

        `fit`
            若为True，根据可视组件的尺寸创建模型。
            只有在单一纹理的情况下才可以设置为True。

    .. method:: child(displayable, fit=False)

        该方法与texture方法相同，除了 `focus` 和 `main` 参数已被设置为True。

    .. method:: shader(shader)

        为模型添加着色器(shader)。

        `shader`
            表示着色器名称的字符串，并将应用到模型上。

    .. method:: uniform(name, value)

        设置着色器中用到的各uniform型变量的值。

        `name`
            一个字符串，表示uniform型变量的名称，前缀是“u\_”。

        `value`
            uniform型变量的值。可以是浮点型数值，2元、3元、4元数组，或者矩阵。

    .. method:: properties(name, value)

        设置GL特性(property)的值。

        `name`
            一个字符串，表示GL特性的名称，前缀是“gl\_”。

        `value`
            GL特性的值。

.. _model-displayable-examples:

模型可视组件样例
^^^^^^^^^^^^^^^^^^^^^^^^^^

模型可视组件可用在ATL变换中间，并使用内置着色器(shader)创建溶解(dissolve)变换效果。

::

    transform dt(delay=1.0, new_widget=None, old_widget=None):
        delay delay
        Model().texture(old_widget).child(new_widget)
        shader [ 'renpy.dissolve' ]

        u_renpy_dissolve 0.0
        linear delay u_renpy_dissolve 1.0

.. _animated-shaders:

带动画的着色器
----------------

当着色器依靠 ``u_time`` 来实现动画是，就要特别注意了。
Ren'Py并没有固定的刷新率，就算满屏的各个着色器都在每帧显示不同内容，
如果没有可视组件申请重绘，依然可能会把刷新率降低到5fps。

当在ATL变换中使用带动画的着色器时，可能会出现卡顿。
但同时屏幕上的其他动画却运行顺畅，原因可能就是使用着色器的变换没有申请重绘。
为了解决此类问题，可以写一个空的ATL循环，强制重绘：

::

    transform fancy_shader:
        shader 'my_fancy_shader'
        pause 0
        repeat

``pause 0`` 会尽可能快地循环绘制。创作者可以修改 ``pause`` 时间，来设置自己需要的最小刷新率，比如 ``pause 1.0/30``。

Shader Parts
------------

Ren'Py使用的着色器请详见 :doc:`shader_parts`。

.. _model-default-shader-parts:

默认着色器名称
---------------

renpy.geometry (priority 100)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform mat4 u_transform;
    attribute vec4 a_position;

顶点着色器：
::

    gl_Position = u_transform * a_position;

renpy.blur (priority 200)
^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform sampler2D tex0;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;
    uniform float u_renpy_blur_log2;

顶点着色器：
::

    v_tex_coord = a_tex_coord;

片元着色器：
::

    gl_FragColor = vec4(0.);
    float renpy_blur_norm = 0.;

    for (float i = 0.; i < u_renpy_blur_log2 + 5.; i += 1.) {
        float renpy_blur_weight = exp(-0.5 * pow(u_renpy_blur_log2 - i, 2.));
        gl_FragColor += renpy_blur_weight * texture2D(tex0, v_tex_coord.xy, i);
        renpy_blur_norm += renpy_blur_weight;
    }

    gl_FragColor /= renpy_blur_norm;

renpy.dissolve (priority 200)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform float u_lod_bias;
    uniform sampler2D tex0;
    uniform sampler2D tex1;
    uniform float u_renpy_dissolve;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器：
::

    v_tex_coord = a_tex_coord;

片元着色器：
::

    vec4 color0 = texture2D(tex0, v_tex_coord.st, u_lod_bias);
    vec4 color1 = texture2D(tex1, v_tex_coord.st, u_lod_bias);

    gl_FragColor = mix(color0, color1, u_renpy_dissolve);

renpy.imagedissolve (priority 200)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

顶点着色器：
::

    v_tex_coord = a_tex_coord;

片元着色器：
::

    vec4 color0 = texture2D(tex0, v_tex_coord.st, u_lod_bias);
    vec4 color1 = texture2D(tex1, v_tex_coord.st, u_lod_bias);
    vec4 color2 = texture2D(tex2, v_tex_coord.st, u_lod_bias);

    float a = clamp((color0.a + u_renpy_dissolve_offset) * u_renpy_dissolve_multiplier, 0.0, 1.0);
    gl_FragColor = mix(color1, color2, a);

renpy.solid (priority 200)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform vec4 u_renpy_solid_color;

片元着色器：
::

    gl_FragColor = u_renpy_solid_color;

renpy.texture (priority 200)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform float u_lod_bias;
    uniform sampler2D tex0;
    attribute vec2 a_tex_coord;
    varying vec2 v_tex_coord;

顶点着色器：
::

    v_tex_coord = a_tex_coord;

片元着色器：
::

    gl_FragColor = texture2D(tex0, v_tex_coord.xy, u_lod_bias);

renpy.matrixcolor (priority 400)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform mat4 u_renpy_matrixcolor;

片元着色器：
::

    gl_FragColor = u_renpy_matrixcolor * gl_FragColor;

renpy.alpha (priority 500)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

变量列表：
::

    uniform float u_renpy_alpha;
    uniform float u_renpy_over;

片元着色器：
::

    gl_FragColor = gl_FragColor * vec4(u_renpy_alpha, u_renpy_alpha, u_renpy_alpha, u_renpy_alpha * u_renpy_over);
