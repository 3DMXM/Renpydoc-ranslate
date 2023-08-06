.. _live2d:

Live2D Cubism
=============

`Live2D Cubism <https://www.live2d.com/en/>`_ 是一种使用2D图片制作动画的系统，可以用在视觉小说的角色精灵中。
这些2D图片会绘制在几个不同的图层中——例如，瞳孔和眼睛反光一个图层，眼白一个图层，眉毛一个图层等。

Live2D软件允许创作者将这些图层与网格(mesh)模型关联，并根据参数对网格变形。
Live2D软件允许创作者创建动作文件决定随时间变化的参数，以及表情文件控制角色表情变化。

集成在Ren'Py中的Live2D系统可以使用对应的文件并显示文件内定义的动画。Ren'Py会根据具体参数值处理动作和表情。
这些参数实际上会传给原生的Cubism SDK，Ren'Py得到的返回值是一个待显示的网格(mesh)列表。
Ren'Py渲染这些网格之后，就实现了屏幕上的Live2D角色。

Ren'Py同时支持Cubism 3和Cubism 4格式的Live2D动画，即这两种格式的表情与动作播放。 

.. warning::

    x86_64的安卓平台不支持Live2D，因为对应平台缺乏某个动态连接库(DLL)。这也表示在安卓模拟器和ChromeOS上运行可能会有问题。

    Web平台也不支持Live2D。

    在iOS平台安装Live2D时，需要手工将静态库复制到自己的iOS项目中。

.. _installing-live2d:

安装Live2D
-----------

使用Live2D之前，你需要下载和安装原声的Cubism SDK，下载链接为 `Live2D 页面 <https://www.live2d.com/zh-CHS/download/cubism-sdk/download-native/>`_ 。
请注意，如果你的商业项目年收入达到了某个下限，将需要购买一个Live2D使用许可证。

下载完Live2D后，把CubismSdkForNative-4-r.1.zip文件放入Ren'Py的SDK目录中，接着可以在Ren'Py启动器中安装。
在启动器中进入“设置”项，选择“操作”标签下的“安装库”，点击“安装 Live2D Cubism SDK for Native”。等待一段时间后，Live2D就安装成功了。

.. _opt-in-to-gl2:

启用GL2选项
-------------

如果需要使用Live2D，需要启用基于模型的渲染器。在游戏项目的任意脚本中添加一行：
::

    define config.gl2 = True

.. _defining-animations:

定义动画
---------

使用Live2D可是组件与image语句可以定义Live2D动画：

.. function:: Live2D(filename, zoom=None, top=0.0, base=1.0, height=1.0, alias={}, loop=False, fade=None, seamless=None, attribute_function=None, attribute_filter=None, update_function=None, **properties)

    该可是组件会播放一段Live2D动画。

    `filename`
        该值应该是一个 model3.json 或 .exp3.json 文件，文件内定义了Live2D动画参数。例如，“Resources/Hiyori/Hiyori.model3.json”。

    `zoom`
        若该值非None，应用一个缩放系数。对 `top` 和 `base` 生效。

    `top`
        图像的顶部，用于指定图像大小。该值是一个表示比例的小数，0.0表示图像最上方，1.0表示图像最下方。

    `base`
        图像的底部，用于指定图像大小。该值是一个表示比例的小数，0.0表示图像最上方，1.0表示图像最下方。
        该值也会用来作为默认锚点在y轴方向的值(yanchor)。

    `height`
        图像最终缩放高度。该值是表示整个屏幕高度比例的小数。

    `loop`
        若为True则循环播放最后一个动作。否则不循环。

    `alias`
        一个字典型数据，用来存储对应动作或表情的别名。

    `fade`
        True if motion fading should be enabled, False if motion fading
        should not be enabled, and None to use the value of :var:`_live2d_fade`.
        若为True则启用动作淡入淡出，若为False则不启用。若为None则使用配置项  :var:`_live2d_fade` 的值。

    `nonexclusive`
        若该值非None，必须是一个非排他性表情名称的列表。
        表情默认是排他性的，即每次只能显示一个表情。若表情加入非排他性列表中，则可以同时显示多个非排他性表情，并附加在某个排他性表情上。

    `seamless`
        该值决定是否启用无缝循环。无缝循环可以避免单一动作循环时也出现淡入淡出。
        该值为True表示始终启用无缝循环，False表示禁用无缝循环，也可以是一个循环动作的集合。

    `default_fade`
        默认的动作或表情淡出时间，单位为秒。所有Live2D动作的默认值为1.0，也可能出现不希望出现淡出的情况。
        可以先把该值设置为0.0，根据实际需要显式赋值。

    `attribute_function`
        若该值非None，应该是一个函数，入参是一个属性(attribute)元组，返回值是另一个属性元组。
        该函数可用于更换显示内容的属性——前提是显示的图像中未使用该属性。
        需要确保该值至少对应给定表情的某一个属性。

    `attribute_filter`
        若该值非None，应该是一个函数，入参是一个属性(attribute)元组，返回值是另一个属性元组。
        该函数通常用于滤除可能冲突的非排他性属性。属性会按最近使用时间排序，从近到远。
        当属性发生冲突时，将采用最近使用过的属性。

    `update_function`
        若该值非None，应该是一个函数，当前动作和表情修改参数并渲染成动画后，将调用该函数。
        调用该函数时需要有两个入参：

        * Live2D对象。
        * 显示时间，单位为秒。

        该函数用于动态修改参数，方法是使用Live2D对象中的 `blend_parameter` 方法。
        该函数应该返回一个数值，单位为秒，表示可以再次调用前的时间间隔；也可以返回None，表示下次交互行为发生时再次调用。
        当可视组件重新渲染时，也可能调用该函数。
        

    `attribute_function` 与 `attribute_filter` 间的差别是：前者用于用新属性替换原来的某个属性；后者用来解决属性冲突，确保一组属性中存在唯一真正可用。

    只有 `filename` 是固定位置参数，其他参数都是关键词参数。

    相同 `filename` 的Live2D对象拥有相同的 `alias`、`fade`、`nonexclusive`、`seamless`、`default_fade`、`attribute_function`、 `attribute_filter` 
    和 `update_function` 值。因此只要指定第一个指定使用 `filename` 的Live2D对象的这系列参数即可。

    .. method:: blend_parameter(name, blend, value, weight=1.0)

        该方法会以参数 `value` 值使用遮罩模式(blend)。在 `update_function` 以外无效果。

        `name`
            此模型需要修改的参数名称。

        `blend`
            遮罩模式，应该是“Add”、“Multiplay”或“Overwrite”之一。

        `value`
            使用遮罩时的不透明度数值。

        `weight`
            介于0.0到1.0之间的浮点数，表示使用遮罩后的新值所占权重。

    .. method:: blend_opacity(name, blend, value, weight=1.0)

        该方法会以参数 `value` 值使用遮罩模式(blend)。在 `update_function` 以外无效果。

        `name`
            此模型需要修改的参数名称。

        `blend`
            遮罩模式，应该是“Add”、“Multiplay”或“Overwrite”之一。

        `value`
            使用遮罩时的不透明度数值。

        `weight`
            介于0.0到1.0之间的浮点数，表示使用遮罩后的新值所占权重。

通过一个配置项可用于帮助debug源自 .model3.json 文件的动画和表情问题：

.. var:: config.log_live2d_loading = False

    若为True，启动时将会动作和表情记录到加载目录中的log.txt文件中。

Live2D可视组件应使用image语句声明：

::

    image hiyori = Live2D("Resources/Hiyori", base=.6)

声明时也可以定义属性(attribute)。在使用相同角色定义不同的缩放时，这非常有用。

::

    image hiyori close = Live2D("Resources/Hiyori", base=.6)
    image hiyori far = Live2D("Resources/Hiyori", base=.9)

请注意，调用 Live2D()时，用户的硬件设备可能会不支持初始化Live2D，整个项目可能卡在加载阶段。
类型的情况也会发生在Web平台的版本上。
创建的游戏应该可以在不支持Live2D的情况下运行，比如使用跳转或替代方案：

::

    init python:
        def MyLive2D(*args, fallback=Placeholder(text="不支持Live2D"), **kwargs):
            if renpy.has_live2d():
                 return Live2D(*args, **kwargs)
            else:
                 return fallback

    image kobayashi = MyLive2D(...)
    image eileen moving = MyLive2D(..., fallback="eileen happy")

.. _using-animations:

使用动画
----------------

显示Live2D图像的通用方法是使用show语句。在show语句后面添加属性(attribute)即可播放对应的表情和动作。

样例如下：
::

    show natori exp_00 mtn_01
    show hiyori m10
    show hiyori m10 m01

这里使用的是Cubism SDK中示例角色的动作名。Ren'Py会从Live2D文件中提取动作和表情的名称，强制转换为小写字母。
model3.json文件名相同如果动作或表情名称的前缀与对应的model3.json文件名相同，这个前缀和紧跟着的下划线会删除，剩下的部分作为属性。
(例如，“Hiyori_Motion01”处理后的属性是“motion01”。)

排他性表情最多只有一种，非排他性表情和动作可以有任意种。
同时指定多个动作时，所有动作按顺序播放，如果loop参数为True则循环最后一个动作。
这样就可以播放完任意表情后，接着播放一个默认待机动画。
同时指定多个动作时，同属性名的动作只能出现一次，除非使用的是同一个动作的多个不同别名。

There are two special attributes ``null`` and ``still``. The null attribute
means that no exclusive expression file should be applied, giving the character's
default expression. The ``still`` motion stops all motion.
还有两个特殊的属性： ``null`` 和 ``still`` 。
``null`` 属性表示不使用任何排他性表情文件，给定角色的默认表情。
``still`` 则会停止所有动作。

非排他性表情将始终存在，除非显式移除：
::

    show hiyori -wave

.. _scaling:

缩放
-------

许多Live2D模型制作时使用了超高的分辨率，直接使用会查出屏幕显示范围。为了适配这种情况，Ren'Py中有两种方法缩小Live2D模型。

第一种方式是使用 `zoom` 参数。这可以直接设置一个模型的缩放值。使用 `zoom` 参数后，其他缩放相关的参数都会忽略。

另一种方法是，使用 `top`、`base` 和 `height` 参数。前两个参数指定了图像显示范围的上下限(与Ren'Py中的其他地方相同，0.0表示顶部，1.0表示底部)。
使用这些参数后，会发生两件事：

* 图片缩放后，显示区域介于 `top` and `base` 之间，`height` 表示屏幕高度的一个比例。
* 锚点会调整，使 `base` 正好位于屏幕底部。

When figuring out how to scale a Live2D animation, what I do first is adjust the `base` parameter until the right part of the animation is lined
up with the bottom of the screen. Then:
关于如何缩放Live2D动画的问题，我做的第一件事是调整 `base` 参数，使动画的底部能够在屏幕上显示出来。然后再根据情况：

* 如果图像太大，降低 `height` 的值，知道获取合适的尺寸。
* 如果图像太小，增加 `top` 的值，以减少图像上端与屏幕之间的空白空间。

.. _motion-fading:

动作平滑过渡
-------------

Ren'Py支持Live2D动作平滑过渡。一般来说，当Ren'Py中切换动画时使用硬切换——当前动作停止，新动作再开始。如果使用转场(transition)，画面上同时出现两个动画。

Live2D支持另一种模式，通过在不同参数之间计算插值，可以实现新旧动画间的平滑过渡。
设想某个角色将自己的胳膊移动到某个位置，计算新旧动画之间位置的插值后用于过渡，而不是使用dissolve方式切换。

动作平滑过渡使用 `fade` 参数进行控制。若该值为True，启用动作平滑过渡；相反则使用硬切换。
若该值为None，根据 ``_live2d_fade`` 配置项的值决定是否启用：


.. var:: _live2d_fade = True

    若为True，Live2D动画启用动作平滑过渡。若为False，动画间硬切换。

.. _aliasing:

设置别名
--------

`alias` 参数允许创作者为动作设置别名。例如：
::

    image hiyori = Live2D("Resources/Hiyori", base=.6, aliases={"idle" : "m01"})

设置别名后可以这样使用：
::

    show hiyori idle

想过与这句相同：
::

    show hiyori m01

.. _loop-and-image-prediction:

循环与图片预加载
--------------------

当 `loop` 参数设置为True时，Ren'Py将循环播放Live2D的最后一个动画。
需要播放某个循环动画是，很重要的一点是，添加一个0.2秒的暂停时间。
这能给Ren'Py一些时间执行消耗较大的图片预加载。(图片预加载和读取发生在不同时间情况，这也可以不是必要的。)

.. _live2d-functions:

相关函数
---------

.. function:: renpy.has_live2d()

    当前平台支持Live2D时返回True，否则返回False。