.. _full-changelog:

=====================
变更日志(Ren'Py 7.x-)
=====================

.. _renpy-7.4.6:

7.4.6
=====

.. _7-4-6-camera-statement:

camera语句
----------------

新增了 ``camera`` 语句，用在3D舞台系统中。
这个语句与 ``show layer`` 语句相似，但 ``camera`` 语句不需要指定图层名，也不会在使用 ``scene`` 语句后清除效果。

可以直接这样写

::

    camera:
        perspective True

就能启用3D舞台系统。

除此之外， ``show layer`` 语句和 ``scene`` 语句在7.4.4及更早版本中的效果发生了反转。
``scene`` 语句将清除 ``show layer`` 语句带来的变换效果。

.. _7-4-6--model-displayable:

模型可视组件
-----------------

新增类 :class:`Model` 是一种使用基于模型渲染器并用于创建模型的可视组件。
现在可以使用该类创建多纹理的2D模型，并可以自定义变换(transform)，并像内建的各种变换一样使用。

目前这个组件还不支持3D，不过未来可期。

.. _7-4-6-other-improvements:

其他提升
------------------

Atom文本编辑器升级，对应的renpy语法高亮插件也需要同步升级，可以将Ren'Py近几个版本中新增的关键字也高亮显示。

使用游戏控制器时，将立刻隐藏鼠标光标。

.. _7-4-6-fixes:

修复项
--------

每夜版中在iOS平台编译过程中产生的错误已修复，不过那个错误没有出现在Ren'Py正式版中。

Ren'Py应用程序窗口失焦后，模态(modal)界面无法拦截时间事件的问题，已经修复。

blur着色器的迭代次数做了限制，确保Ren'Py与大多数使用webgl的设备兼容。

在勾选“强制重新编译”选项时，Ren'Py生成最终文件时将重新编译 renpy/ 目录下的所有Python文件。
这样可以确保某些原因修改过的文件都能重新编译，但并不是指创作者电脑上Ren'Py所在的整个目录。

使用animation时间轴时，ATL将跳到可视组件显示内容的第一帧。

回滚之后，Ren'Py的暂停设置了超时。

.. _renpy-7.4.5:

7.4.5
=====

.. _model-based-renderer-7-4-5:

基于模型的渲染器
--------------------

从Ren'Py 7.4.5开始，基于模型的渲染器将作为游戏的默认渲染器。
如果要禁用此渲染器，请将 :var:`config.gl2` 设置为False。

启用基于模型的渲染器后，Ren'Py可以支持“3D舞台”。
3D舞台在显示图像时增加了第三个维度，当可视组件缩放、移动、旋转等变化时显示3D透视效果。
更多信息详见 :ref:`3D Stage <3dstage>`。

为了3D舞台的使用便利性考虑，使用 ``show layer`` 或 :func:`renpy.layer_at_list` 应用到整个图层的变换(transform)后，``scene`` 语句不再清空该图层的变换(transform)。

启用基于模型的渲染器后，可以使用新增的 :func:`Swing` 转场效果。
该转场能让场景在3D空间里的垂直或水平轴向旋转，并实现场景切换。

新增的 :tpref:`blend` 变换特性可用来指定遮罩函数。
遮罩函数控制如何将新的像素与原有像素混合。除了Ren'Py原有的“normal”和“add”遮罩函数，这次新增了“multiply”、“min”和“max”函数。

.. _mouse:

鼠标
-----

一直以来积攒了一些对硬件鼠标支持的修改和提升，现在正式在文档中发布了GPU中受限尺寸硬件鼠标的支持。

新增配置项 :var:`config.mouse_displayable` 和可视组件 :func:`MouseDisplayable`，可用软件鼠标替换硬件鼠标，类似于Ren'Py 7.3或更早之前的方案。

.. _features-7-4-5:

功能特性
--------

新增函数 :func:`renpy.screenshot_to_bytes`，可以截屏并把图像存入一个二进制对象，该二进制对象可以传给 :func:`im.Data`。
二进制对象很大，可以将它存储在常用或永久存档中。

新增的 :func:`renpy.music.get_loop` 函数会返回某音频通道上的一个循环播放音频文件列表。
可以用来控制循环播放的顺序等。

:func:`renpy.input` 函数和input可视组件可以使用新增的 `mask` 参数。
该参数是一个字符串，用来遮挡向用户展示的字符内容。常用于隐藏密码文本。

启动器新增了一个黑暗主题。

新增的 :var:`config.adjust_attributes` 配置项，可以实现图像属性(attribute)替换。
比如，可以将原本的 ``eileen happy`` 替换为 ``eileen happy_eyes happy_mouth``。
层叠式图像(LayeredImage)也可以契合该功能。

从命令行运行lint工具时，选项 ``--error-code`` 可以在lint运行失败时让Ren'Py返回错误代码。

图层转场可以在某个互动行为结尾持续。

Ren'Py避免在回滚中暂停，总是尝试在某个需要互动的语句处结束回滚。

播放音频时，现在可以同步两个音频通道上不同音频文件的时间轴。

.. _android-7-4-5:

安卓
-------

发布安卓版本的几个必要的包(package)已经包含在Ren'Py中。
这样就修复了由于Bintray关闭导致新安装的Ren'Py 7.4.4无法成功发布安卓版本。

Ren'Py在安卓上显示preslash界面的方式变更。
preslash现在使用Java bootstrap显示，在OpenGL图层顶部的一个新图层中。
相对于Ren'Py 7.4中使用SDL的2D渲染器，这是一个新的渲染机制。
这个改动将提高安卓设备的兼容性，并避免启动阶段的黑屏。

此次改动的另一部分是，Ren'Py缩放preslpash图片的方式也改变了。Ren'Py会将presplash图像在整个可用区域内使用scale-to-fit方式进行缩放。

某些安卓设备上模糊效果无法正确显示的一个问题已修复。

在安卓设备上播放某些稀有视频、音频格式时出现的一个问题已修复。

安卓方面的修复会要求创作者重新生成安卓项目，遇到安卓在配置时的问题

.. _other-platform-7-4-5:

其他平台
---------------

Web平台beta版更新。

iOS 14.5.1及更高版本上的移动版Safari浏览器的一次回退，使Ren'Py无法在该平台运行。
由于该问题是由移动版Safari引起的，没有解决方案，只会向用户显示一调提示信息让他们联系苹果公司。
此次回退也影响了其他在iOS平台的浏览器，比如移动版Safari封装外壳的Chrome和Firefox浏览器。

iOS版本生成问题修复。

macOS平台对Steam的支持已修复。

macOS应用程序的签名和认证已修复。

.. _other-fixes-7-4-5:

其他修复项
-----------

默认的level-of-detail bias设置为-0.5，可以通过配置项 :var:`config.gl_lod_bias` 修改。
这个值在Ren'Py中对缩小有用，对放大没用。不过在放大图像时可能会产生锯齿。

此外还有一些Ren'Py针对模态界面的提升。

.. _renpy-7.4.4:

7.4.4
=====

old-game目录
----------------------

为帮助创作者实现游戏多个发布版本(比如早期公测或Patreon平台版本)，Ren'Py新增了old-game目录，会将前一个版本game目录的部分内容复制到old-game中。
Ren'Py会使用目录中的.rpyc文件。由于.rpyc文件在加载游戏时需要使用，所以也可以用于帮助多人开发游戏遇到的加载问题。

更多信息，详见 :ref:`文档 <old-game>` 。

.. _fixes-7.4.4:

修复
-----

使用手势或控制器导致程序异常退出的一个问题已修复。

发布web版本时windows版本程序异常退出的问题已修复。

成就系统的后端持久化数据，可以清空进度。

Live2D可以重置不透明度等参数。

加载时，Ren'Py不再改变窗口最大化尺寸。

.. _other-7.4.4:

其他
-----

新增了一项GL特性 ``blend_func`` ，需要启用基于模型的渲染器。
该特性可以自己定义GL遮罩函数，使Ren'Py开始支持各种遮罩模式。

Live2D可以支持additive(叠加)和multiply(相乘或正片叠底)遮罩模式。

使用default或define定义 ``renpy`` 命名空间的变量时将报错。


之前有一些 ref:`Preference对象 <preference-variables>` 的方法在文档中遗漏，已补充在文档中。
这些方法可以获取或设置当前音量值和静音状态。

.. _renpy-7.4.3:

7.4.3
=====

Windows
-------

重写了修改图标的代码，生成的可执行程序只能包含软件和图标，不再含有任何冗余数据。
这样应该能够避免某些杀毒软件的拦截。

当前版本Ren'Py已经接入Windows平台的通用C运行时(Runtime)库。
这样可能会提升Windows Vista某些补丁版本的运行效率。同时也使得Ren'Py更符合现代软件安全要求，避免某些杀毒按软件的拦截。

当前版本Ren'Py禁用了Nvidia显卡的线程优化(Threaded Optimization)功能。
N卡的线程优化功能在Ren'Py上表现很糟糕，会在某些不希望暂停的地方突然暂停。
这样也可能修复音频播放出现断裂的问题。

在OpenGL不可用而DirectX可用的情况下，Ren'Py将自动使用ANGLE库，通过DirectX模拟OpenGL ES。
该功能在Ren'Py 7.4版本中还不能正常工作。当Ren'Py尝试各种不同的视觉系统时，窗口将出现闪烁。

.. _7-4-3-android:

安卓
-------

当安卓修改某个渲染上下文(context)时，“非基于模型”渲染器可以正确分配纹理。
解决了以前随机发生的画面撕裂问题，尤其是使用Dissolves效果时出现的问题。

这解决了以往的一个问题，即在游戏还没有完全启动时用户就切换应用，导致启动异常。
现在当Ren'Py发现程序启动时没有获取焦点时，将在用户切回游戏时保存并退出，然后再重新启动。

总体来说，安卓设备的兼容性都得到了提升。

.. _7-4-3-features:

新增特性
--------

新增配置项  :var:`config.main_menu_music_fadein`，
用以控制主菜单音乐的淡入方式。

新增的 :func:`renpy.get_zorder_list` 和 :func:`renpy.change_zorder` 函数允许图像或界面显示中设置zorder的值。

window和frame组件可以使用样式特性 :propref:`modal` 。
这两种组件中modal特性的语法和功能，与界面的 model 特性类似，但仅限于限制鼠标在这两种组件范围内的作用。
主要用于确保玩家不能点击到window背后的某些按钮，而那些按钮并没有被禁用。

可视组件 :func:`Live2D` 现在可以使用参数 `update_function` ，
使用该参数能直接修改对应的其他参数。

当前版本Ren'Py支持显示emoji表情和基本多文种平面(Basic Multilingual Plane，简称BMP)以外的字符，前提是使用的字体文件支持那些字符。
目前使用字体渲染系统显示emoji表情，所以只有黑白单色符号。

:class:`FontGroup` 类用于某个字体内部的字符重映射(remap)。

使用在 :func:`AlphaMask` 中用作遮罩(mask)的可视组件可以获得焦点，并允许应用新的效果(effect)。

玩家可以选择忽略不能加载的图片文件。

新增的 :func:`renpy.get_sdl_dll` 和 :func:`renpy.get_sdl_window_pointer` 函数可以使用ctype函数库直接访问SDL的DLL文件。
现在可以实现SDL中的各种功能，但Ren'Py本身并不提供现成的DLL文件。

使用 :func:`renpy.transition` 或带 ``with`` 从句的语句，其转场效果可以被鼠标点击终结，即直接跳到转场结束的画面。

:func:`renpy.translate_string` 函数正式记入文档中，其提供将某个字符串翻译为指定语言的功能。

可以创建一个 ``hide_windows`` 脚本标签(label)，提供定制鼠标中间或键盘H键隐藏对话窗口的方法。

新增的特性，比如 :tpref:`mesh_pad` 变换特性和 ``gl_pixel_perfect`` gl特性，用于文本上应用着色器后实现完美的像素渲染效果。


前缀为 ``show_`` 的特性可以用于函数 :func:`renpy.input` 的参数，并最终传入 ``input`` 界面。

:class:`Color` 类新增了一个rgba特性，其返回一个rgba元组。

.. _7-4-3-old-features:

旧特性
--------

在Ren'Py 7.4中引入的 :var:`default_mouse` 配置项允许不修改 :var:`config.mouse` 的情况下实现修改鼠标光标。但实时修改该配置项的方法不存在。

.. _7-4-3-other-fixes:

其他修复内容
-------------

多个modal界面存在时的处理异常问题已经修复。

lint在Windows平台上运行时生成的文件将使用Windows风格的换行符。

Windows平台的SDL错误信息将使用系统编码方式进行解码，使其更易读。

Python中unicode引号字符的问题已经修复。

变换特性 :tpref:`blur` 的值介于0与1之间时，已可以正常工作。

文本标签 {done} 已做预编译。

对GL加载失败的情况，Ren'Py回滚到了更早版本的库以实现更好的处理。

为macOS生成的app需要启用HighDPI模式。

.. _7-4-3-translations:

多语言支持
------------

Ren'Py文档已同时翻译为简体中文和繁体中文，由被诅咒的章鱼和逆转咸鱼提供。

法语内容更新。

.. _renpy-7.4.2:

7.4.2
=====

.. _7-4-2-fixed-and-changes:

修复与变更
-----------------

新增的配置项 :var:`config.context_fadeout_music` 和 :var:`config.context_fadein_music`
可以实现游戏加载或其他运行环境变化时的音乐淡入淡出效果。

Ren'Py根据文件扩展名(.motion3.json 和 .exp3.json)搜索Live2D动作和表情文件，而不再使用目录名称。

新增的 :var:`build.include_i686` 配置项判断32位版本的Ren'Py是否打包生成。不包含32位版本的程序不仅可以减少下载数据，还能避免某些杀毒软件的过度反应。

新增的 :var:`build.change_icon_i686` 配置项将阻止i686版本的图标变更。这个改动可以避免杀毒软件的错误检测。

当游戏运行时，Ren'Py不再禁用屏幕保护或系统休眠功能。

maxOS上一个全屏禁用调整窗口大小后无法恢复窗口的问题，已经修复。

树梅派上播放webp图片导致死机的问题已经修复。

此版本修复了生成发布过程中会丢失文件的一个错误：

* say.vbs文件丢失，在Windows平台的自动语音功能无法正常工作。
* 用于支持ANGLE的一些文件丢失，导致DirectX渲染时无法正常工作。

.. _7.4.2-android:

安卓
-------

在三星的设备上发现一个问题，是启用放大快捷键时，可能游戏会无法响应。
我正在出补丁修复，但不想因此延后这个版本的更新。

macOS上的JVM检测机制很健壮，不太会被浏览器插件拒绝。

当前版本Ren'Py推荐使用AdoptOpenJDK作为JVM的基础。


.. _renpy-7.4.1:

7.4.1
=====

.. _7-4-1-pause-statement-changes:

pause语句变更
--------------

``pause`` 语句的语法变更，正确用法为：

::

    pause 1.0

等效于：

::

    $ renpy.pause(1.0)

不再是：

::

    with Pause(1.0)

这表示需要真正暂停的功能特性都可以用pause语句实现。

modal型界面不再能阻止 ``pause`` 或 :func:`renpy.pause()` 的暂停效果。
这表示pause语句可以对显示在其上层的界面也有效果。

.. _7-4-1-say-statement-id-clause:

say语句带id的从句
-----------------------

say语句可以增加一种 ``id`` 从句，允许创作者指定原say语句id。
这用在需要多语言支持的项目有用，比如原版语言中修复了一个拼写错误，不再需要更新所有其他语言文件。


使用该功能特性是，只要在say语句后面添加 ``id``，并拼上语句的id号。

::

    e "This used to have a typo." id start_61b861a2

.. _7-4-1-live2d:

Live2D
------

Live2D添加了一个 `default_fade` 参数，可以修改动作和表情开始与结束时的默认平滑过渡时间。

一个Live2D的明显元组错误已经修复。

.. _7-4-1-controller-blocklist:

控制器黑名单
--------------------

The Nintendo Switch Pro Controller, when connected to a computer by
USB, requires an initialization sequence to be sent to cause it to
act as a Joystick, and not return incorrect data.
任天堂Switch Pro手柄使用USB连接上电脑后，会申请一个初始序列号之后才能作为游戏设备使用。

Ren'Py 7.4.0版本尝试发送这个序列号，但这样做需要直接接入USB总线，在某些电脑上可能会导致死机或长时间暂停。
我们认为，这种做法很容易导致Ren'Py的其他兼容问题。

结果是，我们把任天堂Switch Pro手柄加入了控制器黑名单中，不能在Ren'Py中使用。

.. _7-4-1-macos:

macOS
-----

现在macOS的最低支持版本是10.10(Yosemite).
Ren'Py 7.4无法在这个版本号运行，所以这是对该版本支持的恢复。

macOS 11.0(Big Sur)上无法选择项目目录的问题已经修复。

Pyobjus已经内置在macOS版本Ren'Py中。这个库可以使用Cocoa的API。

.. _7-4-1-android:

安卓
-------

有一些报告发现，Ren'Py 7.4.1预发布版本在某些老旧的安卓设备上无法正常工作，比如三星Galaxy S5。
我们正尝试着一个设备复现此类问题，必要的时候再发布一个新版本。

.. _7-4-1-translation:

多语言支持
------------

更新了西班牙语。

.. _7-4-1-other-fixes:

其他修复
-----------

某些支持SSE3的电脑使用Ren'Py播放某些分辨率视频时导致的死机问题已经修复。

跟之前版本的Ren'Py一样，视频播放时可以利用CPU多核进行解码。

Windows平台不使用100%DPI时，Ren'Py窗口变大的问题已经修复。

选用不支持的渲染器时，Ren'Py不再会给性能告警，比如要求GL2渲染器时使用GL或者ALGLE渲染器的情况。

某些情况下say语句中属性(attribute)无法生效的问题已经修复。

非默认UTF-8编码文件的电脑，使用MultiPersistent保存文件不生效的问题已经修复。

``rpy python 3`` 标识混合编译的性能提升。

三重引号字符串(比如用在gui.about里的)使用出错的问题已经修复。

重新加载时，Ren'Py将重新检测自身所在路径。

Ren'Py会根据渲染器动态加载所有功能，并在不生效的情况下尝试其他渲染器。

某个语句后加载的计时器(timer)，会在回滚后精确复位。如果计时已经结束，即使游戏回滚到计时器生成之前的地方，依然会保持计时结束状态。

Ren'Py允许游戏运行时截屏。

动态变量在回滚后无法维持动态的问题已经修复。

给定尺寸后，hbox和vbox可视组件会以Ren'Py 7.4相同方式放置所有子组件。

新增的 :propref:`mipmap` 样式特性可以用在 :func:`Dissolve`，:func:`ImageDissolve` 和 :func:`AlphaDissolve` 转场效果中，
以及 :func:`AlphaMask`，:func:`Movie` 和 :func:`Text` 可视组件中，还有所有文本。
该特性控制以上提及内容生成的纹理是否生成mipmap。不生成mipmap可以提升速度较慢电脑的渲染性能，缺点是缩小图片时会有显示瑕疵。
没有指定值的情况下，该特性分别根据配置项 :var:`config.mipmap_dissolves`，:var:`config.mipmap_movies` 和 :var:`config.mipmap_text` 取值。

自动语音配置项的版本切换功能体验提升。

Lint检查工具再次由于多语言问题爆了。


.. _renpy-7.4.0:

7.4
====


.. _model-based-renderer:

基于模型的渲染器(renderer)
---------------------------

新版本包含一个全新的“基于模型的渲染器(model-based renderer)”，主要处理将文本和图片绘制到显示器上，作为Ren'Py 6.10时添加的原生OpenGL渲染器的补充(实际是替换)。
该渲染器能够更好利用当前主流GPU(无论集显还是独显)提升性能和效果。
该渲染器支持的设备包括，支持OpenGL 2.2、DirectX 9.0c或11的电脑，支持OpenGL ES 3的移动设备和嵌入式系统。

基于模型的渲染器最大的改变在于，Ren'Py将不再受限于在二维平面上绘制矩形图像，Ren'Py可以将图像转为三维空间内的三角形网格(mesh)。
已经存在和使用的矩形精灵对象(sprite)也将使用同样的显示方式，Ren'Py将其转换为非矩形的网格，实际上就是全三维的几何体(geometry)。

除了网格几何体，基于模型的渲染器还支持着色器(shader)，除了Ren'Py自带的着色器，还允许创作者在游戏中自定义着色器。
着色器(shader)是指运行在GPU上的小段程序，用来处理几何体与像素数据，以此实现各种类型的图像效果。

基于模型的渲染器实现了更快的纹理(texture)加载系统，把一些系统消耗加大的纹理加载和alpha遮罩(premultiplication)工作，从CPU转到GPU处理。

基于模型的渲染器还会为加载进GPU的纹理创建mipmap。mipmap是指纹理的一系列分割采样后的缩微版本，存储在GPU中。通过创建和使用mipmp，现版本Ren'Py将图片尺寸缩小到原来的50%，且不产生混频失真(aliasing artifact)。
该功能在4K显示器使用1080P或更低分辨率时能有明显效果。

在当前版本中，基于模型的渲染器是可选的配置项，通过变量 :var:`config.gl2` 控制是否使用。当我们对新渲染器基类足够经验之后，可能会作为为类Ren'Py的默认渲染器。

.. _renpy-7.4.0-live2d:

Live2D
------

基于模型的渲染器带来的新特性之一，就是支持使用Live2D技术支持的精灵图像(sprite)。
Ren'Py要求创作者自行下载Live2D Cubism的包，同时创作者在发行游戏前需要同意Live2D技术的使用条款。

Ren'Py支持Live2D模型的显示，可以任意改变模型的表情并将多个动作组合成队列(queue)。该功能集成在Ren'Py的图像属性(image attribute)中。
当图像属性改变时，Ren'Py还支持动作切换的渐变(fade)效果。

.. _matrixcolor-and-blur:

matrixcolor和blur
-----------------

基于模型的渲染器带来了变换(transform)方面的新功能，比如matrixcolor和blur。

当前版本的变换(包括ATL中的变换)新增了一个 :tpref:`matrixcolor` 特性(property)。
该特性是一个矩阵(matrix)或实时创建矩阵的对象，用于对变换的子组件进行染色。

之前版本的Ren'Py中包含名为 func:`im.MatrixColor` 的图像处理器，而新的matrixcolor特性的性能更好。
图像处理器往往需要几分之一秒进行运算，在实时演算中显得太慢，并且尽显对单一图像处理。新的变换特性速度很快，可以用在需要演算的每一帧，并且可以应用在所有可视组件。
现在可以使用变换的matrixcolor用于某个图层(layer)，将整个图层染色——不再需要单独的纯色图就可以将游戏画面改为老旧照片的棕黄色(sepia)或者黑白两色。

图像处理器中的MatrixColor跟新增的matrixcolor特性有些许差别，新增的matrixcolor使用4×4矩阵并对alpha通道预乘(premultiply)，所以它使用的矩阵与图像控制器不同。
此外，使用新的matrixcolor特性时需要使用一些新的 :ref:`ColorMatrix <colormatrix>` 对象。

另一个新增的变换特性是  :tpref:`blur` ，可以根据给定的像素数对可视组件的子组件模糊处理。

.. _python-2-python-3-compatibility-mode:

Python2/Python3兼容模式
------------------------

因为Ren'Py还不完全在Python3环境内支持，该版本的Ren'Py包含了一些功能特性允许创作者的脚本同时在Python2和Python3环境下运行。

首先，Ren'Py现在使用 `未来计划 <https://python-future.org/>`_ 提供标准库的兼容性。
目前可以在模块(module)已经改名的情况下使用import引用Python3的模块。

某个开头为 ``rpy python 3`` 的.rpyc 文件将会以Python3兼容模式编译。该特性导致了两项变化：

* Ren'Py编译文件时将尝试匹配Python3语法规则，包括除法规则的改变。在Python3中，``1/2`` 等于0.5而不是0。
  由于这项改变会影响可视组件的位置，写成 ``1//2`` 可以保持原来的语法规则。
* Ren'Py会改变字典(dict)类型的行为表现，直接在 .rpy 文件中调用 ``items``、 ``keys`` 和 ``values`` 方法时，
  将返回视图(view)类型，而不是原来的列表(list)类型。这项改变匹配Python3中对应方法的语法规则，但在面对数据保存或回滚时，
  必须将返回结果显式转化为列表类型再使用。

.. _upgraded-libraries-and-platform-support:

升级了库与平台支持
--------------------

Ren'Py 7.4的生成系统(build system)统一为redone，不再使用多系统单独生成的方式(除了webasm)。
此次生成系统的变更同时将所有Ren'Py用到的库都升级为更新的版本。

因此，Ren'Py官方支持的平台列表有明显变化。这里是最新的支持列表：

.. list-table::
    :header-rows: 1

    * - 平台
      - CPU
      - 备注
    * - Linux
      - x86_64
      - 最低版本要求Ubuntu 16.04
    * - Linux
      - i686
      - 最低版本要求Ubuntu 16.04
    * - Linux
      - i686
      - 最低版本要求Ubuntu 16.04
    * - Linux
      - armv7l
      - 使用Raspian Buster的树梅派
    * - Windows
      - x86_64
      - 64位或更新版本的Windows Vista。
    * - Windows
      - i686
      - 最低版本要求Windows Vista.
    * - macOS
      - x86_64
      - macOS 10.10+
    * - Android
      - armv7a
      - Android 4.4 KitKat
    * - Android
      - arm64
      - Android 5.0 Lollipop
    * - Android
      - x86_64
      - Android 5.0 Lollipop
    * - iOS
      - arm64
      - 所有64位iOS设备，iOS 11.0+
    * - iOS
      - x86_64
      - 所有64位iOS模拟器，iOS 11.0+
    * - Web
      - webasm
      - 主流web浏览器

最大的新增平台是64位版本Windows，这意味着Ren'Py可以在所有主流64位桌面和移动平台运行。
如果需要的话，新增的 :var:`renpy.bits` 配置项可用于确认运行平台是32位还是64位(例如，将 :var:`config.image_cache_size_mb` 设置为合适的值)。

当前版本不再支持32位使用armv71处理器的iOS设备。这些设备甚至不再被苹果支持，并且也不支持Ren'Py要求的OpenGL ES版本。

.. _renpy-7-4-0-web:

Web
---

多亏了新的编译技术，现在Ren'Py在浏览器上的运行速度显著提升了。

为web平台构建的游戏可以在游戏运行时从服务器下载图像和音频文件。
当图像或音频预加载时，游戏就会开始下载。这项技术可以减少游戏开始运行前的初始化时间和内存占用。

在触屏设备的web浏览器上运行游戏时，Ren'Py会显示一个触控键盘，弥补WebAssembly游戏键盘输入方面的缺陷。

加载过程中可以使用WebP格式显示splash界面，包括带动画的WebP。

提供了更多Python模块(module)，使Python环境更贴近原生的Ren'Py端口。

提升了对iOS浏览器的支持。

.. _renpy-7-4-0-steam:

Steam
------

可以在Ren'Py启动器安装Steam平台的支持。方法是启动器中选择在“设置”->“安装库”->“安装Steam支持包”。

新增的配置项 :var:`config.steam_appid` 会为创作者自动创建名为 steam_appid.txt 的文件。
在项目中应用时，需要使用 ``define`` 语句赋值或在python early 语句块中赋值。

.. _renpy-7-4-0-translations:

多语言支持
----------

简体中文、日语和汉语的多语言支持更新，现在使用了统一的字体(译者注：SourceHanSans，也就是思源黑体)。

教程项目中新增了简体中文，由Neoteus提供。

(译者：我不吐槽这事……)

.. _renpy-7-4-0-depreciations-and-removals:

折损和移除
----------

如上面所说，Ren'Py不再支持Windows XP。

如上面所说，Ren'Py不再支持32位iOS设备。

Ren'Py内移除了下载Editra文本编辑器的选项。
Editra编辑器已经超过5年未更新，并且原始发布网站已经关闭。

基于软件的渲染器没有完全移除，而是做了精简，并且在游戏运行时不再作为可选项。原因是防止基于GPU的渲染器在实际游戏中显示错误而导致玩家认为游戏有问题。

.. _renpy-7-4-0-miscellaneous:

其他杂项
---------

对游戏控制器的支持提升。手柄控制器可以实现连发效果。Ren'Py使用的库重新编译以支持更多主流游戏控制设备。

Ren'Py在安卓和iOS设备上使用软件解码播放视频影片(movie)，这意味着相同的视频文件可以在全平台播放。

定义了鼠标光标配置项 :var:`config.mouse` ，使用SDL2的色彩光标API，能用利用硬件加速功能并降低了鼠标移动延迟。

现在 ``define`` 语句可以用于设置字典中的一个key值。
::

    # Ren'Py项目起源于2004年。
    define age["eileen"] = 2021 - 2004

``define`` 语句可以使用 += 和 \|= 运算符，并用于对应的运算。

::

    define config.keymap['dismiss'] = [ 'K_KP_PLUS' ]

    # 这里假设 endings 是一个集合。
    define endings |= { "best" }

现在 ``play`` 和 ``queue`` 后面使用新增的 ``volume`` 分句，可以在播放音频文件的任意时候，指定某个音频通道的音量。

变换(transform)中新增的 :tpref:`fit` 特性提供了不同以往的图像填充方式，可以决定图像是否保持长宽比进行填充。
举例来说，图像可以缩放为给定尺寸，或者完全覆盖不缩放。

应用 :tpref:`xpan` 和 :tpref:`ypan` 特性的可视组件不再会被增大为原尺寸的两倍，便于与其他变换特性组合使用。

:func:`renpy.input` 函数可以使用正则表达式判断输入内容是否被允许。

Grid网格可以使用 :propref:`margin` 特性，用于指定整个网格的外延空白区域以及视口(viewport)的内部空白。

Ren'Py支持一种 {alt} 文本标签(text tag)。带有这种标签的文本会在自动语音模式下念出来，但不会显示在屏幕上。
另一种相反效果的文本标签是 {noalt} 。

启动器窗口可以调整尺寸。“设置”选项中新增了一个按钮，用于重置启动器窗口大小。

新增配置项 :var:`build.mac_info_plist` 便于定制化mac版的app。

Ren'Py内置了 `requests <https://requests.readthedocs.io/en/master/>`_ 库，联网功能更方便。

按下键盘的PAUSE键直接进入游戏菜单(game menu)。

.. _renpy-7.3.5:

7.3.5
=====

.. _fixes-7.3.5:

修复
-----

电脑平台的presplash界面重写，防止该界面下鼠标点击无响应的问题。

iOS端口更新，Ren'Py中新增一些新的模块(module)，可以编译iOS的app。

.. _other-changes-7.3.5:

其他变更
-------------

``audio`` 目录，也就是由 :ref:`audio namespace <audio-namespace>` 定义的音频目录，可以在启动器(launcher)中有快捷链接。同时，新建项目时会自动创建audio目录。

新增的配置项 :var:`config.exception_handler` 可以配置为某个应用程序，接替Ren'Py自带异常处理系统的所有工作。

.. _renpy-7.3.4:

7.3.4
=====

.. _fixes-7.3.4:

修复
-----

该版本修复了7.3.3版本中引入的严重图形故障。

* 在Windows平台，全屏和窗口模式之间进行切换会导致纹理(texture)加载失败，并导致显示错误的纹理。
* 在所有平台，使用 :func:`Flatten` 都可能导致图形故障。

.. _other-changes-7.3.4:

其他变更
-------------

当前版本中，动态图像(dynamic image)的任何地方都可以包含 "[prefix\_]" ，尤其是使用 ``add`` 将某个动态图像添加到按钮(button)、拖拽组件(drag)等类似可以获取焦点的对象时。

创作者自定义语句可以包含if语句。

界面更新时，拖放系统性能提升。

.. _renpy-7.3.3:

7.3.3
=====

.. _audio-7.3.3:

audio
-----

当前版本Ren'Py新增 ``audio`` 目录，在 :ref:`audio命名空间 <audio-namespace>` 中自动根据文件名定义音频名。
如果有个音频文件 ``game/audio/overture.ogg`` ，可以在脚本中直接播放：

::

    play music overture

新增类 :func:`AudioData` ，可以让创作者在Ren'Py中直接使用压缩音频数据，而不再需要使用其他程序预处理。
为实现这个功能，Ren'Py引入了Python的wave和sunau模块。


单声道音频文件混音的一个问题已经修复。该问题可能会导致很多WAV文件无法播放。
(我们始终不推荐使用WAV文件。)

.. _playform-7.3.3:

平台
--------

鉴于苹果公司的条款要求，Mac版的Ren'Py重建为一个未签名的二进制程序。现在需要按住ctrl并点击renpy.app程序，然后选择“打开”才能启动Ren'Py。

对安卓的版本要求降低为Android 19(Android 4.4 KitKat)。

Ren'Py的web端口有一些变更：

* :ref:`Screen variants <screen-variants>` 可以检测配置和进行设置。
* 全屏功能提升，尽管用户可能需要点击对应选项才能启用全屏。
* 关闭web页面的行为可以被检测到，并保存持久化数据。
* 原先默认生成的‘game.zip’文件名可以修改。在index.html文件中的‘DEFAULT_GAME_FILENAME’配置项控制该项。
* 针对移动设备的HTTP请求(原生+renpyweb)：详见 https://github.com/renpy/renpyweb/blob/master/utils/asyncrequest.rpy
* 启用Python的web端口用作测试WebSocket，可以使用Python的‘socket’模块监测端口。
* HTTP缓存控制功能，允许游戏更平滑更新。
* 引入pygame.draw模块，支持Canvas绘图板。
* 提升WebGL兼容性。

.. _other-changes-7.3.3:

其他变更
-------------

在进行重写GL项目时，我们发现在7.3.0版的性能下降问题，原因在于framebuffer对象的切换。
修改了FBO的使用方法后，Ren'Py性能得到了提升。

:func:`renpy.input` 函数可以接收界面的名称，用于用户输入的提示语。

使用界面语言创建的列表、字典和集合可以正确解析。这可以让更多可视组件可以解析为常数，提升界面性能。

回滚时隐藏通知界面。

NVL模式界面默认显示对话窗口，防止 ``windows show`` 语句已生效导致的问题。

在一个多段语句(比如对话中的菜单)中，当使用 `from_current` 将 :ref:`Call` 设置为True 时，主控流程将恢复为多段语句的第一段(这样才能显示对话内容)。

更多函数使用图像标签(tag)的默认图层。

新增 :func:`renpy.is_init_phase` 函数。

当对话内容是menu语句的一部分时，自动语音功能也可以生效。

移除对GLES1的支持。(多年没用的东西了。)

:func:`SelectedIf` 和 :func:`SensitiveIf` 行为(action)可以支持将其他行为作为入参。

很多条值(BarValue)可以使用一个 `force_step` 入参，强制将某个条(bar)的值调整为最接近的某个档位(step)值。

:func:`Frame` 支持tile入参是一个整数字符串，该整数表示frame中tile图像的重复次数。

.. _translationw-7.3.3:

多语言支持
------------

韩语和西班牙语更新。

.. _renpy-7.3.2:

7.3.2
=====

.. _fixes-7.3.2:

修复
-----

在上个版本中的平台变量后退问题已修复。

.. _translations-7.3.2:

多语言支持
------------

更新西班牙语的支持。

.. _renpy-7.3.1:

7.3.1
=====

.. _changes-7-3-1:

变更
-------

描述文本(descriptive text，为视力受损人群设计，在开启自动语音的情况下显示并描述场景信息)功能更新。
描述文本的角色改为使用 ``alt`` (原先的 ``sv`` 角色作为别名)。还可以使用定制角色显示描述文本，而不仅限于旁白。

当前版本Ren'Py每次都会初始化媒体播放系统，这样无声视频也可以正常模仿。

大多数可视组件中，用作选择默认获取焦点的可视组件的 `default` 特性，重命名为 `default_focus`，避免与 ``default`` 语句发生冲突。
该特性值是一个整数，值最大的可视组件获得焦点。

可视组件 :func:`Flatten` 会从入参 `child` 获取坐标。。

使用renpy.random.Random并带种子的随机数生成器支持回滚。

模拟安卓或iOS系统时，运行平台的配置变量(例如renpy.android、renpy.ios、renpy.windows和renpy.mobile)将被正确设置。

当前版本Renpyweb创建存档文件时会存储日期和时间。

.. _fixes-7-3-1:

修复
-----

当前版本修复了一个很重要的问题，该问题可能会导致界面内插(interpolate)文本不更新或更新出错。

当前版本的图像预加载规则将根据图像预加载进程运行。

修复了一个与 {clear} 文本标签相关的问题。

在很多情况下，配置项 :var:`config.end_game_transition` 无法正常运行的问题已经修复。

.. _translations-7-3-1:

多语言支持
------------

对俄语、汉语和西班牙语的支持更新。

.. _renpy-7.3.0:

7.3.0
=====

Renpyweb
--------

由于Sylvain Beucler的贡献，当前版本Ren'Py可以生成HTML网页平台版本。所有支持WebAssembly的主流web浏览器都可以运行HTML版的Ren'Py项目。
HTML网页版会下载整个游戏再运行，所以适合做一些小型项目或大型项目的演示版本。
Web版目前标记为beta测试版，web平台本身存在很多问题(最明显的就是单一线程)，所以加载较大图片时会导致音频卡顿。
所以，在其他平台运行良好的Ren'Py项目，在web端运行可能运行很糟糕。
我们将随着Web浏览器一起改进，目标是最终移除beta标志。
在Ren'Py启动器点击“Web”按钮就可以生成一个工程的Web版本。当前版本的启动器还附带一个小型Web服务器，配合Web浏览器就能进行测试。

.. _cds-7-3-0:

创作者定义语句(CDS)
--------------------------

Ren'Py中的创作者自定义语句(creator-defined statement)和使用这些语句的Lexer对象，在多处进行了扩展并提升了功能。
相关语法如下：

* 现在可以要求Lexer对象将某一行代码作为一条Ren'Py语句或一个Ren'Py的语句块处理。

* 可以要求Lexer捕获错误，便于将报错范围限定在创作者定义语句(CDS)内，而不是整个CDS。

:func:`renpy.register_statement` 函数有新的入参，对应新功能。

* 在预加载语句中使用 `predict_all` 和 `predict_next` 两个入参，可以控制预加载所有后续所有语句，亦或每次只预加载下一条可用语句。


* 新增的 `post_execute` 入参可以让我们指定下个语句(通常是CDS语句后面那句)运行时执行某个函数。
  当语句运行并执行内部的语句块时，还可以使用一个表达式，执行某些工作然后退出时执行清理。
  (举个例子，某个脚本标签接到一个消息事件并执行后，跳转回原来的调用点。)

* 新增的 `post_label` 入参可以让我们指定一个脚本标签名，并在CDS执行完跳转到对应的脚本标签，功能类似调用 ``from`` 语句。

当前版本Ren'Py会将CDS语句的处理结果缓存在 .rpyc 文件中。这样设计可以运行更加复杂的语法，执行效率也会提升。
同时这也意味着，如果修改CDS处理函数时，可能需要执行强制重新编译。

.. _screen-language-improvements-7-3-0:

界面语言提升
----------------------------

当前版本可以引用界面语言可视组件的语句中应用 ``as`` 分句。
在拖拽组件中这点非常实用，可以让界面捕获到拖拽对象并需要时调用对应方法。

``on`` 语句可以使用支持一个事件消息列表。

界面(screen)新增了 `sensitive` 特性。这个特性决定该界面是否可以发生互动。

在界面语言中，如果某个Python语句后面带有不正常的特性名时，当前版本的Ren'Py会生成一个错误。(虽然很少见，但这往往是一个语法错误。)

.. _text-improvement-7-3-0:

文本提升
-----------------

当前版本Ren'Py支持自闭合的自定义文本标签(tag)，这是不需要成对闭合标签的 :ref:`自定义文本标签 <custom-text-tags>` 。

当前版本Ren'Py支持三种新的表示，可以用于格式化文本：

* "[varname!u]" 强制文本大写。
* "[varname!l]" 强制文本小写。
* "[varname!c]" 强制首字母大写。

.. _android-ios-improvements-7-3-0:

安卓和iOS提升
----------------------------

当前版本Ren'Py会在支持的设备上使用Framebuffer对象。因此，安卓和iOS设备上运行时配置项 :propref:`focus_mask` 会生效。

当前版本Ren'Py将为安卓生成64位的arm二进制文件。这是Google Play商店将在今年晚些时候执行的强制要求。

安卓上文本输入的功能再次重写，修复了用户卡输入的问题。
Completion was eliminated, as it was the source
of the problems. While languages that require input methods will need
a larger rewrite to function, Ren'Py should now properly handle all direct
input keyboards.

.. _translations-7-3-0:

多语言支持
------------

Ren'Py启动器和样例工程已由Arda Güler翻译为土耳其语。

Ren'Py教程工程已由Moshibit翻译为西班牙语。

法语、韩语、俄语和西班牙语均有更新。

.. _other-improvements-7-3-0:

其他提升
------------------

``side`` 可视组件的子组件渲染顺序调整，将根据在控制字符串中的顺序进行渲染。

``say`` 语句、 ``menu`` 语句和 ``renpy.call_screen`` 语句新增入参 `_mode` ，可以用来指定语句执行时的运行 :ref:`模式 <modes>` 。

函数 :func:`renpy.show_screen` 和 :func:`renpy.call_screen` 可以使用入参zorder。

当前版本Ren'Py播放单声道音频文件时，音量将与双声道音频文件一致，而不再是音量减半。

新增的 :var:`config.load_failed_label` 将指定一个脚本标签(label)，当Ren'Py读取存档失败时自动跳转。因为在读档失败时不能定位到当前语句。

这个新函数可以实现游戏的自动恢复机制。

新增配置项 :var:`config.notify` ，可以拦截系统通知消息并使用自己定义的内容。

:var:`config.say_attribute_transition_callback` 的接口已做兼容处理，同时接受新旧两种标签。

.. _fixes-7-3-0:

修复
-----

Ren'Py丢失某些字符的问题，特别是阿拉伯语中设置为强调色部分，已经修复。

内部使用的OpenDyslexic字体文件已变更，解决直接复制游戏可能出现的问题。

.. _renpy-7.2.2:

7.2.2
=====

在此版本中，Ren'Py新增了一个辅助菜单，打开方式为按键盘“a”键。
该菜单面向玩家开放，让玩家可以覆盖游戏字体，修改文本大小和启用自动语音。

在此版本中，Ren'Py将允许覆盖公共game目录(/mnt/sdcard/Android/`package`/files/game)内容。
该功能出现在7.2.0版本的功能列表中，但当时还无法正常运行。

在此版本中，Ren'Py支持say语句中的临时图像属性(attribute)，应用于多语言支持(translation)。

上传到itch.io时，Ren'Py会自动下载butler模块。这表示现在上传时不需要安装独立的Itch应用程序，而之前的版本是需要的。

各种条(bar)值对象，包括 :func:`DictValue` ，:func:`FieldValue` ， :func:`VariableValue` 和 :func:`ScreenVariableValue`
都可以使用新增的 `action` 参数。该参数对应一个在值发生改变时，执行的某个行为函数(action)。

回滚系统优化，减少了GC数量。

.. _renpy-7.2.1:

7.2.1
=====

.. _ios-improvements:

iOS版提升
----------------


现在Ren'Py生成iOS版工程时，会设置iOS应用的版本字段。

从此版本起，Ren'Py将搜索ios-icon.png和ios-launchimage.png文件，使用合适的尺寸用作iOS版本的图标和启动图像。

.. _other-improvements:

其他提升
-------------------

当读档后立刻使用回滚，:func:`renpy.in_rollback` 函数将返回True。可以使用下面的脚本：

::
    python:
        if not renpy.in_rollback():
            renpy.run(ShowMenu('save'))

实现在初始化阶段就显示存档菜单，而不用等到读档或回滚。

新增配置项 :var:`config.say_attribute_transition_callback` ，可以选择say语句的基础转场效果。

新增环境变量 ``RENPY_SEARCHPATH`` ，可以覆盖启动参数 :var:`config.searchpath`。

.. _fixes-7-2-1:

修复
-----

Ren'Py自身代码经过一轮审核，确保运算符 == 和 != 匹配，无论 == 是否被重定义过。

使用 ``add`` 语句在界面中添加变换(transform)时可能出现的问题，已经得到修复。

``extend`` 语句处理入参的机制发生改变，确保较新的入参优先级高于 ``extend`` 之前的say语句中的入参。

当前版本Ren'Py在判断动态图像(dynamic image)是否相等时会考虑作用域。这个改动也修复了界面中某些动态图像不更新的问题。

macOS上 :var:`config.save_dump` 的值为True时导致崩溃的问题已经修复。

:var:`config.profile` 的值为True时导致崩溃的问题已经修复。

安卓平台显示数字键盘时，Ren'Py明确要求文本(而不是邮箱地址、密码和电话号码等)输入。

某些menu语句导致前向滚动无法运行的问题已经修复。

.. _renpy-7.2.0:
.. _renpy-7.2:
.. _renpy-7.1.4:

7.2
===

.. _menu-arguments-7-2:

菜单入参(menu arguments)
-------------------------

Ren'Py现在已支持 :ref:`菜单入参(menu arguments) <menu-arguments>`。
入参可以传给整个菜单，或者菜单内的某些选项，语法如下：

::

    menu ("jfk", screen="airport"):

        "伊利诺伊州，芝加哥" (200):
            jump chicago_trip

        "德克萨斯州，达拉斯" (150, sale=True):
            jump dallas_trip

        "阿肯色州，温泉城" (300) if secret_unlocked:
            jump hot_springs_trip


除了 `screen` 入参选择对应界面，`nvl` 入参选择NVL模式菜单，其他传入菜单的入参会应用在界面上。传给菜单选项的入参会应用在菜单界面的所有元素。

.. _temporaty-say-attributes:

临时性say语句
--------------

Ren'Py现在支持临时性say语句。用法与普通say语句相同，可与普通say语句混用。
临时性say语句中的设置的各类属性(attribute)，在语句执行完后将恢复为上一条语句的状态。
比如下面这段脚本：

::

    show eileen happy

    e "我很开心。"

    e @ vhappy "我真的很开心！"

    e "我还是很开心。"

对话中的第一行和最后一行，Eillen将使用happy表情。对话的第二行中，Eileen将使用vhappy表情。

.. _changes-7-2:

变更
-------

新增 ``window auto show`` 和 ``window auto hide`` 语句，可以在显式展示和隐藏对话窗口后，保持 :ref:`自动对话窗口管理 <dialogue-window-management>` 有效。

:func:`Preference`(“display”，“window”)` 现在可以避免创建比整个界面更大的窗口。
在 :func:`gui.init` 中配置的窗口最大尺寸就是上限。

:ref:`创作者定义的语句 <cds>` 新增了几个语法分析器方法，可以处理入参、图像命名的组件、脚本标签(label)和使用特定分隔符的Python代码。

:func:`renpy.force_autosave` 函数新增一个入参，可以防止自动存档未完成的情况下再次强制自动存档。

:ref:`点击继续界面 <ctc-screen>` 新增一些参数。

放置文本型对象时， :propref:`yanchor` 特性(property)的值可以是 renpy.BASELINE。设置为该值时，锚点就会设置为文本第一行的底线(baseline)。

新增的图像操纵器(image manipulator) :func:`im.Blur` 可以模糊图像。感谢大佬Mal Graty的贡献。


层叠式图像(layeredimage)组支持 ``multiple`` 特性(property)，允许在同一个组内同时使用多个图像属性(attribute)。
这是个很实用的功能，可以让一组自动定义的函数应用在很多不冲突的图像上。

(有多个显示设备时)当鼠标切换到不同的桌面时，Ren'Py会保持全屏。在重新最大化窗口的加载过程中不再会出现抖动现象。

:var:`config.allow_duplicate_labels` 配置项可以定义或设置一段init python代码，然后允许游戏内出现重复的脚本标签(label)。

可视组件 :func:`Movie` 可以设定循环或不循环，并在停止循环播放后显示关联的静态图像。
还可以在影片播放之前显示某个指定的图像。

.. _android-changes-7.2:

安卓平台变更
---------------

安卓SDK的下载更新。修复工具无法下载的问题。

针对键盘制定了一个显式行为函数，确保回车键(enter)正常。

当使用sideload模式安装在亚马逊的设备时，Ren'Py使用亚马逊的支付API，可以使用“双商店”APK进行支付系统测试。

Ren'Py现在可以使用公共游戏目录(/mnt/sdcard/Android/`package`/files/game)，前提是在游戏中定义好使用的目录。

.. _fixes-7-2:

修复
------

使用dissolve效果时界面底部会出现一条不透明的黑色或灰色线，这个bug已经被修复。

对imagefont字体的支持问题已修复。

从启动器导航菜单创建新文件的功能已经可以运行。

菜单集功能再次有效。

当 :func:`Function` 和其他行为函数被传入不兼容的数据类型时，Ren'Py不会挂死。

某个情况下前向滚动失败的问题已修复。

MacOS上Steam消息无法正确显示的问题已修复。

.. _renpy-7.1.3:

7.1.3
=====

这个版本是相当于7.1.2的再次发布，只修复了一个bug。那个bug是在测试版本残留的问题，会导致在初始启动阶段就设置 :var:`config.default_language` 的值。

.. _renpy-7.1.2:

7.1.2
=====

.. _7.1.2-improvements:

功能提升
------------

Ren'Py的界面语言现在支持包含匿名的ATL变换(transform)。比如现在可以这样写：

::

    screen hello_title():
        text "你好。":
            at transform:
                align (0.5, 0.5) alpha 0.0
                linear 0.5 alpha 1.0

新增的 :func:`SetLocalVariable` 和 :func:`ToggleLocalVariable` 行为函数，可以用来设置界面使用的变量。


新增的 :var:`config.menu_include_disabled` 配置项，决定菜单是否应该包含可由if分句禁用的入口(entry)。

在安卓模拟器模式中可以使用Shift类组合键(比如Shift+I和Shift+R)。

在文本标签(tag)需要一个值却没有提供的情况下，Ren'Py提升了报错信息。

新增的 :var:`_version` 配置项标识游戏在创建时的版本号。这个值仅仅存储创建时定义的版本号。后续是否更新取决于创作者的需求。

可视组件 :func:`Movie` 添加一个新的模式，让同一个文件内的色彩数据和alpha mask数据按边对齐。
这个模式防止main影片与mask影片出现不同步的问题。

:func:`FilePageNext` 和 :func:`FilePagePrevious` 函数可以通过入参控制，是否可以将玩家带入自动或快速存档页。

新增的 :var:`config.skip_sounds` 配置项决定Ren'Py是否跳过非循环播放的音频文件。

.. _7.1.2-translations:

多语言支持
------------

现在Ren'Py能够自动检测使用者系统中的地区，并设置相应的语言。
详见 :var:`config.enable_language_autodetect` 和 :ref:`多语言支持 <translation>` 部分文档。

德语部分更新。

.. _7.1.2-fixes:

修复
-----

修复了一个Windows平台的bug。这个bug仅在使用阿拉伯语和希伯来语时出现(译者注：就是说中文用户不用管，所以这也不按原文翻译了)。

如果读取某个图像(image)时，发现完全匹配图像名的图像不存在，但相同前缀(prefix)的图像存在时，现在Ren'Py会报一个错误(error)。在这次修改之前，如果图像eileen happy而要显示eileen happy unknown时，那个unknown属性(attribute)会被忽略。

Lint工具功能提升，能够处理带属性(attribute)的非同名图像，比如层叠式图像(layerd image)。

Ren'Py会生成适合手机显示的选项菜单图像。


.. _history-7.1.1:

7.1.1
======

.. _history-fixes-7.1.1:

历史记录方面的bug修复
-----------------------

这个版本解决了Ren'Py中“历史”界面的一个问题(issue)。这个问题的触发条件是，一行对话中出现不成对的方括号，比如：

::

    "I [[think] I'm having a problem."

出现这种情况时，字符串“I [think] I'm having a problem.”会添加到历史记录中。如果Ren'Py中显示这段历史记录，并尝试内插 ``think`` 变量，就会挂掉。


新版本的修复办法是，在历史界面中添加了 ``substitute False`` 的情况。这个办法只对新建的项目有效。
之前已经存在的老项目，创作者只能自己修复了。
下面是一个新的历史界面定义：

::

    screen history():

        tag menu

        ## 因为历史界面可能很大，所以不预加载界面。
        predict False

        use game_menu(_("History"), scroll=("vpgrid" if gui.history_height else "viewport"), yinitial=1.0):

            style_prefix "history"

            for h in _history_list:

                window:

                    ## 如果history_height的值是None，就使用自适应布局。
                    has fixed:
                        yfit True

                    if h.who:

                        label h.who:
                            style "history_name"
                            substitute False

                            ## 如果对应角色的文本颜色有单独设置，就获取设置的文本颜色。
                            if "color" in h.who_args:
                                text_color h.who_args["color"]

                    $ what = renpy.filter_text_tags(h.what, allow=gui.history_allow_tags)
                    text what substitute False

            if not _history_list:
                label _("The dialogue history is empty.")


新的历史界面定义中包含一行 ``substitute False`` 。创作者可以在自定义的历史界面中添加这行，避免上面提到的程序卡死问题。

.. _changelog-android-improvements:

安卓版本的提升
--------------------

现在Ren'Py分配给安卓发布工具的内存总量增大到1.5GB，也就是谷歌套件中的默认值。为了确保创作者具有发布更大游戏的能力，请确认电脑上安装了64位版本的Java 8。

Ren'Py明确要求安卓系统，将软键盘的“回车(Enter)”键作为一次输入的结束。

现在Ren'Py在安卓8(Oreo)以下版本中将剪裁和重新调整app图标(icon)的尺寸。

Ren'Py生成x86_64版本的apk时，会使用一个不同的版本号数字。这样就可以同时让适配x86_64和armeabi-v7a处理器的发布包上传到Google Play或其他应用商店里，
这样就不需要每次分别生成一个apk并手工修改名称。

.. _7.1.1-other-improvements:

其他提升
---------

现在Ren'Py会自己处理0字宽的字符绘制问题，防止不支持0字宽的字体依然会被绘制在屏幕上的情况出现。

Ren'Py支持非断行空格和0字宽非断行空格字符，防止文本中的图像空间被挤占。

Ren'Py支持 :func:`Character` 对象中 `ctc_position` 参数的一种新值“nestled-close”。
使用该值可以防止“点击继续”型标志和其他行之间出现断行。

(拖放组件中的)Drags类现在支持变换的点击事件。(桌面电脑的鼠标右键点击和触控平台的长按操作。)


.. 7.1.1-fixes

修复
-----

函数 :func:`SetVariable` 和 :func:`ToggleVariable` 入参类型已经扩展，可以接受命名空间加字段形式。
所以现在可以使用类似 ``SetVariable("hero.strength", hero.strength + 1)`` 或 ``ToggleVariable("persistent.alternate_perspective")`` 这样的写法。

对话窗口自动管理(使用 ``window auto`` 语句启用)是指，当游戏内菜单有关联的对话或标题时，会自动调整布局和尺寸。

Ren'Py生成程序时必须的fribidi内嵌版本源代码已经包含在 -source 归档中。

还有一些语音支撑方面的修复点，优化了对历史记录和语音回放功能的支持。

.. _renpy-7.1:

7.1
===

.. _7.1-android:

安卓
-------

这个版本重点重新编写的Ren'Py对安卓平台支持，以适应现在移动端的需求。
这样Ren'Py游戏可以在Google Play商店上架。某些变更可能需要创作者更新游戏内的某些文件。
特别需要注意的是，icon图标格式已经改变，所以icon图标需要重新制作。

Ren'Py运行要求的最低安卓版本号已经提升至安卓19(aka 4.4 KitKat)，最佳运行版本为安卓28(aka 9 Pie)。

(译者注：这里的安卓19和安卓28是指安卓的API级别。每个API级别对应一个安卓版本号，例如LEVEL 19对应的是安卓4.4系统，LEVEL 28对应的是安卓9.0。)

添加了x86_64结构，原有的x86已经删除。(某些x86设备可以通过二进制转义层运行arm平台版本。)

.. _changelog-monologue-mode:

独白模式
--------------

现在使用3个双引号，可以直接在脚本中写大段的对话或旁白。例如：

::

    e """
    这是一段对话。

    而这是第二段。
    """

这将创建两端对话。详见 :ref:`monologue-mode` 。

在独白中还可以使用新的文本标签(tag)——{clear}。
当{clear}标签单独占一行时，作用相当于 ``nvl clear`` 语句。详见 :ref:`NVL独白模式 <nvl-monologue-mode>` 。

.. _say-with-attribute-change:

带属性的say语句变更
-------------------------

带属性的(attribute)的say语句中，如果对应标签(tag)的图像不存在，处理机制有所变化。
以前，Ren'Py会使用名图像，并且最近带属性的say语句中的属性，以及显示那个属性对应的头像(side image)。

现在，Ren'Py会根据提供的属性和已存在的属性决定显示的头像。这个特性使得带属性的say语句以同一个工作机制实现显示或不显示图像。
当某个属性(attribute)对应的头像并非唯一时，Ren'Py会根据所有给定的属性，选用存在的属性中最有可能的图像作为头像。

这项改动主要是为了方便使用层叠式图像(layered image)作为头像，这样只需要选用不同的图像属性(attribute)就可以改变头像。

.. _updater_changes:

更新器变更
---------------

现在Ren'Py每次更新时，更新器会提示使用者选择更新渠道。这个设计意在让使用者确认每次更新使用哪个渠道，
这样就不会意外更新为某个预发布或nightly版本。

你可能会发现，有时并找不到预发布版本的更新。这是正常的——与之前的版本不同，只有存在可用的预发布版本的更新渠道才会出现。

.. _7.1-translations:

多语言支持
------------

Ren'Py启动器(launcher)、模板游戏和The Question的脚本，已经由Muhammad Nur Hidayat Yasuyoshi翻译为马来语。

韩文也已更新。

现在RAPT使用的字符串也可以翻译为非英语的其他语言了。

.. _7.1-other:

其他
-----

现在Ren'Py可以在游戏退出时使用可靠的方法自动存档。(相比之前版本要可靠，原来的自动存档可能会失败或陷入死循环。)
这个特性由配置项 :var:`_quit_slot` 控制。

文件行为函数(比如 :func:`FileSave`， :func:`FileLoad` 和 :func:`FileAction` )现在可以使用一个 slot=True 入参。
当这个入参存在时，行为函数会加载一个已命名的槽位，而不需要进入存档页面。

开发者菜单(使用快捷键Shift+D)现在会显示一个界面，能够展现已显示和已隐藏图像的相关属性。

添加了函数 :func:`renpy.transform_text` ，该函数可以将不带触控文本标签或文本内插的文本执行变换(transform)操作。

现在使用Gallery对象的make_buttons方法创建的按钮(botton)现在继承空的样式(style)，而不再是按钮样式。
这样预防了按钮样式的某些特性(property)导致的故障。

现在，点击鼠标时，结束文本显示的代码通过事件消息(event)方法调用。
这样，菜单显示状态下时就不会因为鼠标点击而结束互动行为。

处理imagebutton和image map的自动图像时，支持可视组件的前缀名。

之前的版本中，在NVL模式下如果某个NVL模式语句后面跟着另一个NVL语句，并且后面的语句中含有某个未定义的角色名，运行会出现一个错误(error)。
现在这个bug已经修复。

当两个ATL变换(transform)嵌套时，使用变换的语句会同时实现两个变换效果，而不只是嵌套在外层的变换。

Ren'Py用于window、bar和frame的动态图像(dynamic image)已更新。(以及所有由可视组件派生出的对象，比如按钮和imagemap。)

当模态框(modal)状态置为True时，Ren'Py会将某个内核资源占用100%的问题(issue)已经修复。

Ren'Py现在已经包含了一份fribidi的拷贝，而不再使用操作系统中安装的版本。

(译者注：某些语言文字的书写打印是从右往左顺序进行的，当这些文字中出现其他字符，比如阿拉伯数字、英语单词等，又需要保持从左往右的打印顺序。fribidi是针对这种双向打印需求提供的库。)

如果配置了 :propref:`box_wrap` ，就可以使用新增的配置项 :propref:`box_wrap_spacing` 控制行间距和列间距。

配置项 :propref:`adjust_spacing` 的样式特性现在可以使用“horizontal”和“vertical”这两个值了。
设置为这两个值后，就可以指定只在水平或垂直方向调整间距。

LayerdImageProxy现在可以使用内插字符串。

开始游戏或者进入一个新的上下文(context)，比如一个菜单上下文时，会调用新增的配置项 :var:`config.context_callback` 。
这个配置可以用于进入那个上下文时，停止语音和音效的播放。

可视组件  :func:`Drag` 新增  `activated` 特性。这个特性是一个回调函数，当用户首次在某个可拖拽(drag)组件时被调用(在组件移动之前)。

.. _renpy-7.0:

7.0
===

自从Ren'Py 6带来ATL语言、界面语言、OpenGL和DirectX加速等特性后，到Ren'Py 7.0对安卓和iOS平台的支持、多语言支持、外部平台接入支持(Accessbility)等新功能，Ren'Py引擎的开发已经超过了10年。

6.0版和7.0版之间的变化，可以参看变更日志的其他部分，或者在Ren'Py的网站上查看更老版本的变更日志。这一层的内容是7.0跟6.99.14.3两个版本间的差异。

.. _changelog-layered-images:

层叠式图像
--------------

 :ref:`层叠式图像 <layered-images>` 是使用在Ren'Py中的新定义图像。它设计用于精灵(sprite)，该精灵是通过Photoshop等软件制作出的一系列图层。层叠式图像系统让图像根据属性(attribute)显示不同内容，由Python条件表达式决定显示哪个图层的图像。

层叠式图像用为 :func:`composite`
和 :func:`ConditionSwitch` 的一种替代方案。它使用的语言让定义合成图像更方便。而且Ren'Py可以根据被合适命名的文件，生成对应部分的定义。相比Ren'Py的其他功能，层叠式图像也更优秀。比如属性(attribute)可以预加载，而ConditionSwith却不行。层叠式图像还可以在交互式指导器(interactive director)中使用。

.. _changelog-dict-transitions:

字典转场
----------------

:ref:`字典转场 <dict-transitions>` 可以使用with语句和某些其他函数将转场应用于一个或多个图层。Ren'Py不会在使用这些转场时暂停。字典转场使精灵进行转场的时候也同时显示对话成为可能。

.. _changes-7-0:

变更
-------

现在的Ren'Py中已经不包含旧的教程和模板。不过从旧版本的Ren'Py中复制过来也可以用。

新 :func:`Scroll` 行为可以使按钮改变视口的位置或条(bar)的值。

:func:`Dissolve`、 :func:`ImageDissolve` 和 :func:`AlphaDissolve` 转场现在可以承认源可视组件的alpha通道，就像设置了 alpha=True参数一样。由于忽略alpha通道不再是最优，这种改变允许在更多地方使用相同的转场。

自动图像定义现在可以在init level 0级别运行，而不是原来的init level必须大于999。这个改动允许 :func:`renpy.has_image` 函数能在初始化语句块(block)中使用。

交互式指导器(interactive director)现在多了一个按钮，允许创作者选择显示在界面的顶部还是底部。

:ref:`界面语言的for语句 <sl-for>` 声明现在需要一个index子句::

    for i index i.name in party:
        ...

当被提供时，它应该返回一个唯一的值，该值可以像按钮地图信息和转换状态其来源的对象。

现在有可选的上标文字，允许两种不同的上标文字同时显示。(比如翻译和注音。)

新的 :ref:`可视组件前缀 <displayable-prefixes>` 系统可以定义你自己的可视组件，组件可以用字符串访问，这与图像，图像文件和solid具有的字符串形式相同。

Ren'Py现在支持创建具有单个文件的.zip文件(例如.rpa文件)大于2GB。这需要使用Zip64标准，在某些平台上可能不支持解压缩这种文件，最需要注意的是Windows XP。

新的 :func:`renpy.get_hidden_tags` 函数返回一组标签(tag)，包含隐藏属性，另一个 :func:`renpy.get_showing_tags` 函数则返回一组排列好的标签(tag)。


为了与ATL和其他动画保持一致，第二次显示视频精灵现在将重播视频。

.. _7.0-translations:

多语言支持
------------

Ren'Py 教程和The Question示例现已支持法语，感谢 Alexandre Tranchant。

对日语和俄语的支持更新。

.. _fixes-1:

修复
-----

当界面不显示时，处理hide和replace事件消息导致的界面无法恢复问题已经修复。(这种情况会在用户跳过游戏时出现。)

在交互式指导器(interactive director)中使用默认语言(英语)时，偶尔会切换为俄语的问题已经修复。

可视组件 :func:`Composite`、 :func:`Crop` 和 :func:`Tile` 分别对应各自的新名称。

接入控制台时，Ren'Py回滚位置不正确的问题已经修复。那个问题会导致控制台显示不正确的数据，不过仅限于控制台自身的数据。

