.. _full-changelog:

=====================
变更日志(Ren'Py 7.x-)
=====================

*其他内容记录在* :doc:`不兼容的变更 <incompatible>`


.. _renpy-8.2.1:
.. _renpy-7.7.1:

8.2.1 / 7.7.1
=============

.. _8-2-1-7-7-1-text:

文本
----

使用Harfbuzz文字渲染器能获取更多文字信息。改动后，大部分情况下得到的结果不变。
某些情况下少量变动，比如下划线位置会有一点变化。

使用Harfbuzz渲染垂直文本的位置问题已修复。同时，freetype不再支持垂直文本。

详见 :propref:`vertical`。

.. _8-2-1-7-7-1-updater:

更新器
-------

Windows平台更新器对更新签名失败的某个问题已修复。

更新器将强制让Web服务器使用指定的编码，这样能提升某些Web服务器的兼容性。
此外，若服务器10秒无响应，更新器将超时退出。

.. _8-2-1-7-7-1-live2d:

Live2D
------

Ren'Py将自动猜测Live2D纹理尺寸，并调整相应的Live2D库匹配最大纹理尺寸。

显示Live2D图像时，Ren'Py会尽量避免过多的“渲染到纹理”操作。

.. _8-2-1-7-7-1-fetch:

Fetch
-----

:func:`renpy.fetch` 函数可以在处理图像和互动期间同时运行，不会干扰互动操作。

:func:`renpy.fetch` 函数新增 `params` 入参，用于指定请求URL时用到的参数。

.. _8-2-1-7-7-1-other-changes:

其他变更项
-------------

(使用{w})替换某个textbox组件后，将产生 ``replaced`` 事件，而不是hide事件。

添加带有 `default_focus` 特性的可视组件后，该组件就会获得焦点，不需要重启互动系统。

可以使用命令行发布iOS版本应用，不再需要安装rapt(安卓相关支持)。

Ren'Py使用的最大纹理尺寸配置项改名为 :var:`config.max_texture_size`。
该配置项不对2D纹理生效，仅用在 :class:`Model` 纹理。

:doc:`template_projects` 不再要求必须含有所有Ren'Py基本项目同名的文件。

.. _8-2-1-7-7-1-other-fixes:

其他修复项
-----------

安卓设备上从暂停状态恢复后可能会黑屏的问题已被修复。

Ren'Py运行时可以在目录中包含英文引号“:”。引号在Linux等系统中是合法的目录字符。

``camera`` 、 ``show layer`` 和 ``at`` 语句的时间轴不会受到 :var:`config.layer_transforms` 的影响而重置。

LayeredImage使用未赋值变量时，Lint不会崩溃。

:tpref:`blur` 的值小于0导致的崩溃问题已解决。已经对模糊的值做了范围限制(clamping)。

拖拽组件无法保存的问题已修复。

.. _renpy-8.2.0:
.. _renpy-7.7.0:

8.2.0 / 7.7.0
=============

.. _harfbuzz-intergration:

集成Harfbuzz字体渲染
--------------------

从此版本开始，Ren'Py使用Harfbuzz库实现文本渲染。
在所有版本的Ren'Py中，Harfbuzz渲染器都会提供额外信息，弥补Freetype渲染器。

在Ren'Py 8里，Harfbuzz也直接用于渲染文本。其会根据上下文和语言类型，记录和选择合适的字形。
该功能可用于渲染复杂的文本，比如印地/婆罗米文等(同时需要准备好对应语言的字体文件)。

新增样式特性 :propref:`shaper`，用于选择文本渲染器，同时兼容旧版本Ren'Py。

.. _emoji-related-text-improvements:

Emoj表情的提升
-------------------------------

Ren'Py可以渲染基于COLRv0标准的彩色字体。此新版本内置字体包含Twiemoji图片，覆盖了常用Emoji表情的大部分(但还不是全部表情)。

`Emoji 15.1 <https://unicode.org/Public/emoji/15.1/emoji-test.txt>`_ standard.
当Ren'Py发现文本中的Emoji字符时，会自动切换到Emoji字体。所以支持的字符都在
`Emoji 15.1 <https://unicode.org/Public/emoji/15.1/emoji-test.txt>`_ 标准中。

使用Harfbuzz字体渲染器的Ren'Py 8可以渲染Emoji连接起来的序列，包括性别和肤色修饰符。
不使用字体标签的情况，会自动切换字体渲染。

新增样式特性 :propref:`emoji_font` 和 :propref:`prefer_emoji`，用于选择Emoji字体。

最基本的用法是，在游戏脚本中直接写入Emoji。例如：

::

    e "I'm feeling 😃 today."

.. _variable-fonts:

可变字体
--------------

当前版本Ren'Py支持OpenType的可变字体。可变字体通过若干个axe来控制字体的渲染效果。
例如，字体如果有名为“weight”的axis，就可以控制字体粗细；字体如果有名为“width”的axis，就可以控制字体宽度。

必须使用Ren'Py 8的Harfbuzz字体渲染器，才能支持可变字体。

为了支持可变字体，Ren'Py新增了样式特性 :propref:`instance` 和 :propref:`axis`，
文本标签(tag) :tt:`instance` 和 :tt:`axis`，以及函数 :func:`renpy.variable_font_info`。

详见 :ref:`可变字体文档 <variable-fonts>`。

.. _font-hinting:

字体微调
------------

特性 :propref:`hinting` 新增了模式“auto-light”，会在垂直方向自动微调文本。

新增配置项 :var:`config.font_hinting`，可以对每一种字体设置不同的微调模式。例如：

::

    define config.font_hinting["MyFont.tff"] = "bytecode"

只针对字体MyFont.ttf，将其微调模式设置为“bytecode”。

.. _text-interpolation-improvements:

文本内插提升
-------------------------------

字符串内部的插值会以Python表达式形式处理，而不再看作简单的字段。
由于没有缩进，现在风格类似于Python的字符串格式化。这项改进可以在文本内插时放入一些简单逻辑。

::

    default exp = 1000

    label start:
        e "我的等级是LV [exp // 225] ！" # 将显示 "我的等级是LV 4 ！"
 
使用变量内插字符串时，如果存在命名空间interpolate，则优先搜索和应用interpolate中的同名变量。
例如：

::

    define t = "不显示。"
    define interpolate.t = "显示。"

    label start:
        e "[t]" # 将会显示 "显示。"

.. _speech-bubble-improvements:

气泡式对话提升
--------------------------

Ren'Py 8.1新增的气泡式对话功能增加了一种方式能保留对话气泡。气泡会逐个弹出并覆盖在前面的气泡上，
但不会消失，直到界面显式清理所有气泡。整个效果类似于动态漫画中的对话。
详见 :ref:`气泡式对话文档 <retained-bubbles>`。

新增配置项 :var:`bubble.properties_callback`，可以指定一个函数用作过滤器，基于对话角色的图像标签(image tag)筛选特定气泡。
该功能可以筛选某些角色的对话气泡，用于后续处理。

把一些改动结合起来使用，就能在气泡的出现和消失上添加动效。具体的例子可以在 :ref:`bubble-screen` 文档中找到。

.. _position-types-and-atl-interpolation:

坐标类型和ATL插值
-----------------

ATL插值，比如语句 ``linear 1. xpos .6``，现在可以使用不同的坐标类型数据来计算。
下面的例子在之前的版本中是明确禁止且无法运行的，现在则可以使用：

::

    transform mixed:
        xycenter (520, 300)
        easein 3. align (.0, .0)

    label muxed:
        show a at Transform(pos=(.5, .6))

        "..."

        show a at Transform(pos=(520, 150))

作为新功能特性成果的一部分，新增了一个 :term:`position` 数据类型，即 :class:`position` 类。
该类可以使用一个绝对像素数和一个组件比例值，指定一个可视组件的位置或者尺寸。
例如，可以将某个值指定为 ``xsize position(-10, .5)``，使用该值的可视组件就可以算出另一个数值并调整自己宽度，其是可视组件宽度的一半并减10。

.. _developer-tools:

开发工具
---------------

启动器设置中的选项页面，新增了一个“Skip splashscreen”勾选项。
勾选该项后，游戏启动会跳过splashscreen脚本标签。

使用Shift+D进入开发者菜单后，可以看到一个新增的“Show Filename and Line”勾选项。
启用该选项后，可以看到当前语句所对应的脚本文件名和所在的行号。
鼠标点击文件和行号，就会在默认的文本编辑器中打开脚本文件。
如果该编辑器支持的话，甚至直接跳转到对应的行。

.. _data-actions:

数据行为
------------

:ref:`data-actions` 文档进行了重新组织，使其更容易理解。
数据行为根据其操作类型(Set-, Toggle-, Cycle-, Increment-)和目标作用域范围(-Variable, -ScreenVariable,  -LocalVariable, -Field, -Dict)放入一个表格中。

新增两类操作：

* Cycle- 类行为(CycleVariable, CycleLocalVariable, CycleField...)会从一个列表中按顺序选取元素并修改变量的值。
  在每次执行某个行为时(比如点击按钮)，并将目标变量的值设置为列表中下一个元素的值。
  (译者注：即Ren'Py记录列表索引。每次将列表索引对应元素赋值给目标变量后，索引加1。索引超出列表长度时，索引号归0。)
* Increment- 类行为(IncrementVariable, IncrementDict, IncrementField...)会使目标变量增加一个固定数值(默认为加1)。
  此类行为也可以用于某个对象的字段。

考虑到完整性，新增了 :class:`LocalVariableValue` 和 :class:`LocalVariableInputValue` 两个类。

.. _https-http-fetch:

HTTPS/HTTP Fetch
----------------

Ren'Py now has better support for :doc:`fetch`, using the new renpy.fetch
function. While the Requests library still remains supported on Desktop and Mobile,
(it's used internally by Ren'Py), the new fetch function:
Ren'Py使用新的 :func:`renpy.fetch` 函数，能更好支持 :doc:`fetch`。
Requests库依旧保留在电脑和移动平台上(在Ren'Py内部使用)。新的fetch函数有如下功能：

* 可以使用GET、POST和PUT方式请求HTTPS和HTTP协议的URL。
* 符合Web平台规则的情况下，可以用fetch方式从Web端获取数据。
* 下载时不会阻塞游戏运行。
* 能获取二进制或数据对象形式编码的Json数据。
* 可以返回二进制、字符串或数据对象形式编码的Json数据。

.. _7-7-0-8-2-0-accessibility:

Accessibility
-------------

新增特性 :scpref:`group_alt` 。创作者可以指定一段文本，使自动语音系统首次遇到组内可视组件时播放指定文本对应语音。

新增特性 :scpref:`extra_alt` 。创作者可以指定一段文本，当用户按下键盘问号键时，自动语音系统播放对应指定文本语音，提供可视组件的额外信息。

可视组件设置了上述两项特性后，其子组件都会继承相同的特性。
除非子组件自身设置了不同的值，覆盖父组件的特性。

新增 :func:`renpy.alt` 函数，可以通过自动语音系统播放指定文本。

.. _futurn-in-python:

Python中的 \_\_future\_\_
-------------------------

此版本Ren'Py允许创作者使用Python代码中使用 `\_\_future\_\_ compiler directives <https://docs.python.org/reference/simple_stmts.html#future>`__ 。
若要使用该功能，需要在.rpy文件顶部添加 ``rpy python xxx``。其中的 ``xxx`` 就是未来(future)功能特性。
例如：

::

    rpy python annotations

.. _7-7-0-8-2-0-translation-improvements:

多语言支持提升
------------------------

Ren'Py目前针对大多数对话，只会创建三分之一的对象用于支持多语言。
这样减少了启动时间和内存占用。

此外，Ren'Py可以在明确切换到其他语言之前，不加载多语言相关内容。
这样减少了启动时间，在游戏很大并且可选语言很多的情况下效果显著。

延迟多语言加载功能默认情况下禁用。:ref:`deferred-translations` 文档描述了如何启用该功能。

.. _scene-show-and-hide-transition:

scene、show和hide语句中的转场
--------------------------------

scene、show和hide语句新增自动转场的设置。只要这些语句后面不带with从句或widown show，就会自动应用。

此功能用到新增配置项 :var:`_scene_show_hide_transition`，详见文档 :ref:`scene-show-hide-transition`。

.. _7-7-0-8-2-0-android:

安卓
-------

安卓的发布系统已升级，使用Gradle和安卓Gradle插件的近期新版本。
因此Ren'Py也支持和要求使用Jave 21——最近长期支持(Long Term Support)的Jave版本。

Ren'Py做了一系列改动，终于可以在安卓和苹果设备上，下载大于2GB的游戏。
具体内容详见 :doc:`downloader`。大体来说，就是把游戏分成两部分。
将较小的一部分下载到设备上后，再通过该游戏下载大的另一部分。而较大的部分才是实际游戏内容。

安卓版对游戏课件的版本号从配置项 :var:`build.version` 获取。其默认值与 :var:`config.version` 相同。

放在目录 :file:`rapt/prototype` 中的游戏资源会放入生成的项目目录中。

生成的安卓版文件名会包含版本号，便于区分。

.. _7-7-0-8-2-0-web:

Web
---

Web平台的全屏实现方式发生变化，提高了电脑和移动端Web浏览器的兼容性。

Ren'Py会在游戏开始时，顶部覆盖一个div透明组件，协助浏览器检测点击事件并播放音频。
div组件会把点击事件重定向到游戏，等检测完成后隐藏自身。

:doc:`fetch` 函数也可以在Web平台使用，只要只要符合相关规则(CORS)，就能向其他页面发送http和https请求。

.. _7-7-0-8-2-0-updater:

更新器
-------

:doc:`Ren'Py更新器 <updater>` 已完全重构。其兼容更多Web服务器，并且首次支持https协议。

更新器首次运行时将创建一个签名密钥(signing key)，并使用该密钥对更新文件签名。
更新器运行时后，会使用密钥检查更新。
This means it is no longer extra
work to produce a secure update.

.. _7-7-0-8-2-0-translations:

多语言支持
------------

启动器和样例项目增加了丹麦语。

其他语言也做了一些更新。

.. _7-7-0-8-2-0-features:

功能特性
--------

配置项 :var:`config.layer_transforms` 可以为各个图层指定一个变换列表并应用，
也可以为定义在 :var:`config.layers` 中的所有图层设置完全相同的变换列表。

新增行为 :class:`Continue`，能直接加载最新存档(默认情况下包括自动存档和快速存档)。
该行为设计用于快速继续游戏，特别是完全线性的视觉小说。

新增样式特性 :propref:`ruby_line_leading`，用于控制包含ruby文本(片假名)时的额外行距。
该特性通常使用的行距会比 :propref:`line_leading` 小一些。

可以使用参数“reset”调用 :func:`Preference`，将环境设定(preference)重置为默认值。

新增 :class:`defaultdict` 类，存在于Ren'Py默认的命名空间中，类似于Python的collections.defaultdict，
能够在滚回操作中同步回滚数据。

新增 :class:`MultiRevertable` 类。可以该基类派生出子类，同时拥有可恢复对象和可恢复数据结构(类似列表、集合和字典)的特点。

新增配置项 :var:`config.pass_controller_events` 和 :var:`config.pass_joystick_events`，
让游戏可以直接获取控制器和手柄的操作。

新增函数 :func:`renpy.get_screen_variable` 和 :func:`renpy.set_screen_variable`，可以操作界面变量。
主要通过 :class:`Action` 的派生类操作。

新增变量 :var:`build.time`，可以设置游戏生成时间。

新增变量 :var:`build.info`，可以在存储生成信息，并在发布版中也能看到这些信息。

:ref:`加载等待 <presplash>` 画面左上角像素为透明时，加载等待画面会显示在一个window组件中，并以单字节表示不透明度。
(译者注：通常不透明度是8字节。)

新增行为 :func:`EditFile`，用于在文本编辑器中打开一个文件。

SVG文件的虚拟dpi值可以用于设置 :func:`Image` 新增的 `dpi` 参数。

新增行为 :func:`CopyToClipboard`，可以把文本复制到剪贴板。

新增函数 :func:`renpy.confirm`，能使用Python代码弹出确认界面。

新增函数 :func:`renpy.reset_all_contexts`，移除栈中所有上下文(context)，并根据下一条语句创建新的上下文。
可以在读档或报错之后使用该函数。

新增函数 :func:`renpy.last_say`，返回最后一条say语句的信息。

新增函数 :func:`iap.request_review`，可以向Google Play和苹果App Store发送用户评分请求。

新增变量 :var:`gui.history_spacing`，可以控制新创建的项目中，各段对话历史的间隔。

新增文本标签(text tag) :tt:`nw`，可以指定一个等待时间(单位为秒)，之后立刻显示标签内文本。
之前的常用写法“{w=2}{nw}”，现在可以写作“{nw=2}”。

:class:`Movie` 类新增参数 `keep_last_frame`。当该参数为True时，非循环播放的影片播放结束后将显示最后一帧画面。

``jump expression`` 语句可以使用“.local_name”格式的本地脚本标签名。
之前只能使用“global_name”和“global_name.local_name”格式的脚本标签名。

:ref:`creator-defined-sl` 可以从其他界面语言语句复制所有特性(property)。

新增函数 :func:`renpy.invoke_in_main_thread`，可以使用Python线程在Ren'Py主线程中调用函数。
(大多数Ren'Py函数都只能在主线程中调用。)

.. _launcher-changes:

启动器变更项
----------------

启动器新增 :doc:`template_projects` 功能。该功能主要用于替换默认GUI之后新建的项目。
若使用项目模板创建新项目，Ren'Py会将模板内的文件复制到新项目，并更新项目名和翻译文件，但不会修改脚本和其他图片文件。

启动器界面布局略有调整，减少了一些空白区域，可以在某些界面容纳更多选项。
同时依然为多语言保留了足够空间。

新增 :doc:`cli` 部分的文档。现在可以通过命令行发布Ren'Py游戏。

.. _7-7-0-8-2-0-other-changes:

其他变更项
-------------

变换事件hide和relace应用到界面后会执行完，即使在隐藏过程中遇到让同一界面再次显示的事件，
也会先彻底隐藏或替换，再重新显示。
这样可以解决某些界面在隐藏过程中突然要求再次显示的问题，比如say界面和气泡。

当前版本开始，容器型组件(包括fixed、hbox、vbox、side、grid、viewport和vpgrid)会将变换事件(hover、idle、insensitive、selected_hover和selected_idle)
透传给自身的子组件，也就是说某个按钮的子组件可以针对各种事件编写变换效果。

:func:`persistent._clear` 函数会重新运行所有default语句，并更新持久化变量。但可以避免所有持久化数据都变回初始值。

:propref:`focus_mask` 使用像素不透明测试时，会让GPU仅仅对不透明像素包围框内做测试。
这在某些情况下可以提升性能。

从此版本起，Ren'Py全平台都是用GL2作为默认渲染器，并忽略配置项 config.gl2 。
旧的GL渲染器上报告的各种问题，在GL2渲染器上都没有出现。
若使用比较古老的硬件，依然可以使用快捷键Shift+G启用GL渲染器。

在电脑平台(Windows、Mac和Linux)上，当游戏窗口移动后，Ren'Py将记录窗口坐标。
当游戏再次运行时，窗口坐标将恢复成记录的值，但有前提：

* 玩家多个显示器的布局没有改变。
* 游戏窗口整个都在玩家显示器的显示范围内。

其他情况下，窗口都会显示在主显示器中心。

在控制器方面(包括Steam Deck)，B键的功能改为显示和隐藏游戏菜单。
之前的B键的功能是某个键的变种，现已转移到X键。

在安卓和苹果iOS设备上，默认启用视频播放硬件解码。Ren'Py在2020年时，取消了默认启用该功能。

此版本Ren'Py会将角度值强制限制在0到360度范围内，包括0度但不包括360度。
之前的版本中，超过这个范围的角度未明确定义。变化360度不再能显示动效，因为该值与0度相同。

使用ATL中的 :tpref:`angle` 和 :tpref:`anchorangle` 特性制作动效时，如果没有指定旋转方向则会使用劣弧，尽管这样旋转角度可能会小于0度。

Ren'Py遇到空的ATL代码块时将报错。(例如，``show eileen happy:`` 后面没有内容时。)

为了在UI层面适配某些从右往左书写的语言文字，:propref:`box_reverse` 样式在两方面做了调整：

* 启用 :propref:`box_reverse` 后，计算界面内各可视组件布局位置时，将按照与普通布局完全相反的顺序，
  计算和添加各组件的额外空白。添加的额外空白可能会改变某些可视组件的尺寸。
* 拥有 :propref:`box_wrap` 特性的hbox组件会从上往下组织子组件，而不是从下往上。
  拥有 :propref:`box_wrap` 特性的vbox组件会从左往右组织子组件，而不是从右往左。

某个文件导致自动重新加载时，Ren'Py会检查包含该文件所有上层目录是否有git锁定文件。
自动重新加载会在git相关操作完成后，所有锁定文件都移除后再执行。

AV1 movies that contained an previously-unsupported colorspace conversion could
cause Ren'Py to crash, and now will play properly.
之前AV1编码的视频可能包含不支持的色彩空间转换，并导致Ren'Py崩溃。现在可以正常播放了。

Ren'Py 8内置了websockets包，可用于在电脑和手机端(还不包括Web)连接基于Web Socket的API。
由于websockets包依赖Python 3，所以Ren'Py 7里没有此包。


.. _renpy-8.1.3:
.. _renpy-7.6.3:

8.1.3 / 7.6.3
=============

.. _8-1-3-7-6-3-changes:

变更项
-------

Ren'Py可能在后续的macOS版本中，将 :var:`config.gl2` 设置为True。
因为有一些针对窗口大小调整的修复项，仅仅对gl2渲染器有效。

Windows和Linux平台再次启用了MMX，实现视频播放加速。

Steam Deck主机的软键盘显示方式发生改变。仅在进入文本输入状态时，才会显示软键盘。
默认情况下，软键盘开头会覆盖在所有界面之上。
在某些导致软键盘被隐藏的操作(比如按下Steam Logo按键)后，用户需要同时按下 Steam+X 按键，才能再次显示软键盘。
该变更项是为了解决Steam Deck自身的缺陷。

32位Windows版的Live2D库已装入Ren'Py 7。可能需要重新安装Live2D相关组件才能使用该库。

.. _8-1-3-7-6-3-fixes:

修复项
------

按键映射系统无法识别键盘与文本绑定关系的某个问题(例如，可以识别“r”而不是别“K_r”)已修复。

文档方面做了一些修正。

游戏开头的某个回滚问题已修复。


.. _renpy-8.1.2:
.. _renpy-7.6.2:

8.1.2 / 7.6.2
=============

.. _8-1-2-7-6-2-changes:

变更项
-------

此版本有多处文档方面的提升。

使用 :func:`renpy.classify` 时，结尾不带 / 的目录名也能识别
(比如“renpy.app”会识别为 renpy.app 目录)。

ATL改为深度比对之后再决定，继续动效还是重启。
也就是说，某些全局变量改变后，相关的变换会重启。

viewport组件的子组件由于拖拽而获得焦点时，将无法更改样式。
涉及这项变更的情况很少见。在拖拽过程中更改样式可能会拖拽响应变慢或无响应。

读档后，回滚可以退到上一条带互动的语句。(之前的版本最多只能退到存档点的第一条语句开头。)
这个变更项使用户读档后可以使用更多回滚操作。

配置项 :var:`_autosave` 能对强制自动存档的点也生效，包括退出游戏和分支选择菜单。

从启动器运行某个Ren'Py项目时，Python变量的值会从环境变量配置中筛选并应用。

自动语音模式下，提示窗口消失后，Ren'Py依然会努力确保念完整条提示窗口的内容。

自动语音播放界面内容的顺序改为从最顶层到底层。

:func:`Frame` 组件要求绘制的图像至少有1像素。

:func:`renpy.pause` 函数可以前向滚动到call或jump点。

在Web浏览器中，``"display" : "window"`` 可以禁用全屏模式。

可以绑定鼠标按键用于快进(skipping)。

.. _8-1-2-7-6-2-fiexes:

修复项
------

Web端进入全屏时的问题已经修复。

在Windows平台上，由于系统文字编码问题导致Ren'Py用到的环境变量Path不可用时，Ren'Py 8启动器依然可以运行游戏。

从 game/ 目录导入的Python功能做了提升，更好地适配Python :pep:`302` 标准。

该修复项还有个副产物，在开发者模式的“帮助”界面会显示gamepad界面。

界面的歧义分析系统导致的一个问题已修复。之前该问题可能会使某些变量不可用。

在互动行为重启动画时，viewport的惯性表现依然有效。

:ref:`play语句 <play-statement>` (以及 :func:`renpy.music.play` 函数)中出现 if_changed 从句则会阻止循环。

Linux系统上启动VS Code时的问题已修复。

Ren'Py 7在Web端的某些崩溃问题已修复。

Movie函数会在播放视频前确认对应的通道(channel)可用。
此项解决了从存档文件中加载视频可能出现的问题。


.. _renpy-8.1.1:
.. _renpy-7.6.1:

8.1.1 / 7.6.1
=============

.. _8-1-1-7-6-1-android:

安卓
-------

创建安卓版本密钥(key)时，Ren'Py会让APK和Bundle两种安装包使用相同密钥。
新游戏用两个不同密钥确实没必要。
(对于已经之前的游戏，Ren'Py依然会继续使用已存在的两个不同密钥。)

我们收到了一些报告，有人把APK和Bundle使用不同密钥的游戏上传到Google Play后，被拒(rejected)了。
这是某个较早版本Ren'Py导致的问题，将APK的密钥误用到Bundle中。
解决方法详见 :ref:`不兼容的变更 <android-key-migration>`。

.. _8-1-1-7-6-1-fixes:

修复项
------

:func:`Preference` 中的“系统光标”可以使用 :var:`config.mouse_displayable` 配置的鼠标图案。

Web端的音频系统会将结束时间处理为一个时间戳，而不是一个时长。

回滚后音量和声相相关的某个问题已修复。

Live2D图像属性(attribute)不全导致可能会发生的问题已修复。

支持视频的开头、结束和循环时间。

Imagemap自身不是常量(const)时，其内部的Hotspot也不再是常量(const)。

macOS上，导致某些window组件无法改变尺寸的一个问题已修复。

font目录下关于Lint字体的一个问题已修复。

在某些情况下，某个从其他基类派生的类，如果改成不从基类派生的话，Ren'Py可能会崩溃(crash)。
现在Ren'Py会追踪这个错误，并且通过设置 :var:`config.ex_rollback_classes` 项可以抑制报错。
此类报错只会向开发者展示，正常游戏时后台直接忽略。

.. _8-1-1-7-6-1-other-changes:

其他变更项
-------------

Ren'Py可以使用样式前缀 ``sync`` 实现界面同步。不需要编辑界面，只需要一些基础的定制化设置即可实现。

禁用文本编辑功能后，Ren'Py会禁用text组件的input方法。这样在input允许空格键的情况下，依然可以使用空格键直接让游戏剧情前进。

ATL转场使用了动画时间轴。指向改动旨在解决某些互动重启后，转场无法正常展现的情况。

所有环境设定配置(preference)都不在有默认值。
所有配置项都可以使用 ``default`` 语句修改值。

:func:`absolute` 表示一个绝对的像素数，现在会确保参与计算的整数和浮点数都会转为绝对数值。
该变更修复了某个类，使用absolute类参数时会产生错误结果并导致布局出错的问题。

Live2D系统会在计算某个 `attribute_filter` 后检查结果动作，并直接开始演出新动作。

.. _renpy-8.1.0:
.. _renpy-7.6.0:

8.1 / 7.6
=========

.. _7.6-documentation-improvements-and-fixes:

文档提升与修复项
----------------

文档提升与修复了多处，很多内容并没有记录在变更日志中。

文档使用了新的主题，以及夜间模式。

.. _7.6-renpy-sync:

Ren'Py同步
-----------

Ren'Py同步是一个新特性。其可以将某个服务器作为整个Ren'Py项目的一部分，使同一个Ren'Py项目可以在不同设备间更便利地传输文件。
举例来说，某个用户在自己电脑上点击“Upload Sync”上传存档并得到一个验证码。
之后可以在自己手机上选择“Download Sync”并输入验证码，就可以下载最新存档，并在出门时继续玩游戏。

Ren'Py同步被设计为能保障隐私。存档需要加密，并且只有游戏标题的哈希值被传送到服务器端。

Ren'Py同步功能可以通过新增的两个类 :class:`UploadSync` 和 :class:`DownloadSync` 来实现。

.. _7.6-speech-bubble-dialogue:

气泡式台词
-------------

当前版本的Ren'Py包含了一个全新的 :doc:`气泡式台词 <bubble>` 系统。
气泡式台词系统可以让角色以类似于漫画对话的形式展示，并包含一个可交互编辑器用于对话气泡调整位置和根据互动调整气泡形状。

如要要在某个已经完成的游戏中添加气泡式台词，需要在游戏中添加一些文件和脚本。
气泡式台词章节文档详述了需要修改的内容。

.. _7.6-platform-improvements:

各平台提升
-----------

.. _7.6-web:

web
^^^^

Ren'Py 8.1可以创建直接运行在Web浏览器上的游戏。
在Web浏览器上运行游戏时，Ren'Py使用Python 3.11版本(其他平台则使用Python 3.9版本)。

从Ren'Py 8.1开始，Ren'Py可以直接创建在浏览器上运行的web应用。
创建的web应用可以与原生应用程序类似的方式安装在设备上，当然实际过程也取决于具体的浏览器和系统平台。
其他平台则可以在Home界面生成对应web应用的快捷运行路径。

在 :func:`Preference` 中新增“web cache preload”设置项。
启用该设置项后，游戏运行前将会从web服务端下载所有游戏数据到设备本地。
在线运行时，游戏会见车可下载数据，并只下载增量数据。
离线运行时，游戏可以直接使用下载好的数据。

在web平台的Ren'Py项目可以播放视频文件了。前提是浏览器支持对应的视频文件格式。

.. _7.6-macintosh:

Mac
^^^^

在Mac电脑上，Ren'Py使用统一的二进制格式，可以在Intel和苹果Silicon处理上都运行。

.. _7.6-android:

安卓
^^^^^^^

安卓平台做了一些调整。``android.keystore`` 和 ``bundle.keystore`` 文件移动到项目根目录中，而不再放在rapt目录中。
这样便于项目使用不同的密钥(key)进行构建，以及使用相同的密钥(key)在多个安卓版本进行构建。

新增“生成密钥”按钮。点击该按钮后，如果存在旧的keystore文件，Ren'Py会将原文件复制到项目中。

安卓配置文件 ``.android.json`` 改名为 ``android.json``。
Ren'Py遇到旧文件时会自动创建对应的新文件。

.. _7.6-sticky-layers:

粘滞图层
-------------

粘滞图层(sticky layer)是一种图层的临时性质。
当使用tag标签指定某个图层显示具体图像时，该图层就具有了粘滞图层性质。
粘滞图层的性质将持续到该图层隐藏，或有其他图层指定为粘滞图层。


具体来说，某个图像显示在其默认图层之外的图层上时，对应的图层就会设置为粘滞图层了。
后续的show和say语句都不需要指定图层名称，即可在该粘滞图层上显示对应内容。

下面的样例中，假设 ``eileen`` 默认使用 ``master`` 图层，那么在指定在 ``near`` 图层显示后，``near`` 图层就成为了粘滞图层：

::

    show eileen onlayer near
    eileen happy "Hello there!"  # 粘滞图层已生效，不需要指定图层名
    show eileen excited          # 省略onlayer near
    hide eileen                  # 省略onlayer near
    show eileen                  # 省略onlayer master，master图层是eileen的默认显示图层

该新增的特性默认是将 ``master`` 图层设置为粘滞图层。
如果使用 :func:`renpy.add_layer` 函数创建的任意图层也会被附加粘滞图层性质，除非将入参设置为 ``sticky=False`` 。

.. _7.6-detached-layers-layer-displayable:

独立图层和图层可视组件
-----------------------

独立图层(detached layer)是由创作者定义的图层，不会自动添加到场景中。
独立图层使用新增的可视组件类 :class:`Layer` 定义，覆盖在其他图层之上。

开发这个功能的深层原因是，可以让着色器和其他变换效果应用到一组标签(tag)上，同时保持其他系统能正常使用，比如show和say语句。
该功能也可以让同一图层显示多次，用在反射效果或某些电视的同频道复用。

将独立图层应用到场景中时，需要在配置项 :var:`config.detached_layers` 中添加对应图层名。
其他典型图层则使用 :func:`add_layer` 函数。并且独立图层固定具有粘滞图层性质。

.. _7.6-new-image-formats-and-image-oversampling:

新的图片格式和图像过采样方式
----------------------------------------

此次的版本新增两种图片格式的支持：

* AV1图片文件格式(AVIF)是一种全新的图片格式，使用了现代压缩技术，压缩后可以获得比常见的JPEG、PNG和WebP之类存储空间更小的图片文件。
  在很多情况下，将图片转换为AVIF格式可以在不损失画质的情况下减少文件的大小。

* SVG文件是一种网上常用的矢量图形格式。
  Ren'Py支持的SVG文件是SVGs的一个子集。(Ren'Py不支持SVG文件中带文本。)
  游戏内容出现缩放时，Ren'Py会自动对SVG文件过采样(或降采样)，以保证任意分辨率下的图像边界依然锐利。
  该功能类似于Ren'Py对文本的过采样。
  对于需要保证锐度的UI元素，SVG文件是个不错的选择。

当前版本Ren'Py新增了对栅格化后图片的过采样支持，包括PNG、JPEG、WebP和AVIF格式文件。
遇到需要对这类图片进行过采样的情况时，可以在文件名结尾加一个 @ 符号和一个过采样率数字。
例如，“eileen happy@2.png”表示过采样系数为2。这样做可以更方便地把老游戏以更高清晰度重置，减少很多代码层面的修改。
图像处理器(image manipulator)也支持图片的过采样。

对栅格化后图片，过采样会加载图片的完整尺寸，但除以过采样系数后当作图片的实际尺寸。
例如，某个图片的尺寸是1000×1000，过采样系数为2，就会当作500×500的图片用于各种布局的计算。
当游戏画面放大后，所有图像数据都会等比放大，但依然能保持相当的锐度。

图片过采样也可以与新增的配置项 :var:`config.physical_width` 和 :var:`config.physical_height` 协同使用，
修改游戏分辨率后也不必调整游戏内元素的布局。

.. _7.6-av1-video:

AV1视频
---------

Ren'Py现在支持AV1编码的视频。
AV1可以支持WEBM和MKV容器。
同等视频质量下，AV1编码的视频可以比VP9编码的视频文件再小30%左右，而VP9可能是之前最好的编码格式。

需要注意，比较新的AV1格式可能要求更好的CPU性能实现解码。
对某些硬件来说可能VP9编码的视频反而更流畅。

.. _7.6-audio:

混音器音量变更项
--------------------

现在混音器以分贝(音量)计算，类似于音频设备和电脑计算音量的方式。
混音器滑块在最小值位置时表示最大音量的-40dB，在最大值位置时表示0dB即最大音量。
这样使混音器有更大的调整范围。之前的音量计算方法，会使音量滑块非常接近底部才有明显效果。
现在音量的调整会更符合人的感官直觉。

几个控制默认混音器音量的配置项，比如 :var:`config.default_music_volume`、:var:`config.default_sfx_volume`
和 :var:`config.default_voice_volume`，都已经改为0.0表示-40dB而1.0表示0dB模式。
:func:`SetCharacterVolume`、:func:`preferences.set_mixer` 和 :func:`preferences.get_mixer` 函数的计算方式也一样。

音频的淡入淡出功能也根据音量做了修改。
音量淡化效果会作用时间范围更大，而不仅限于原本淡入淡出的一小段。
重新实现了超短时间的淡化效果，解决的之前淡化时间太短导致的错误。

配置项 :var:`config.fadeout_audio` (即原来的config.fade_music)控制音频停止播放或使用 ``play`` 语句切换时的默认淡出时间。
默认时长为0.016秒，正好清楚突然停止音频可能导致的爆音。

音频声像(:func:`renpy.music.set_pan`)改为一个常数音量，这样修改声像不会改变音量。

.. _7.6-draggable-viewports:

可拖拽的视口
-------------------

视口(viewport)可以被用户拖拽，在视口内的按钮或其他可视组件获得焦点时依然可以进行拖拽操作。
Ren'Py会检测用户是否进行拖拽操作，并把焦点切换到视口组件，然后移动视口。

:ref:`视口 <sl-viewport>` 和 :ref:`vpgrids <sl-vpgrid>` 的 `draggable` 特性可以设置为新增的 :ref:`界面变种 <screen-variants>` “touch”，
这样仅在启用触控的设备上才能拖拽视口。

.. _7.6-renpy-in-python:

\_ren.py文件 - Python中的Ren'Py
---------------------------------

:doc:`\_ren.py 文件格式 <ren_py>` 可以在Ren'Py脚本中嵌入Python文件。
例如：

::

    """renpy
    init python:
    """

    flag = True

等效于：

::

    init python:

        flag = True

这项新格式的设计意图是，允许以原生Python为主的脚本文件可以在专门编辑Python代码的工具中更方便。

.. _7.6-constant-stores:

常量存储区
---------------

Ren'Py中可以通过设置 ``_constant`` 将某个 :ref:`命名存储区 <named-stores>` 标记为常量存储区。
如果 ``_constant`` 的值为True，则常量存储区中的对象不参与存档，只能通过存储区访问，并且不参与回滚操作。

设置常量存储区的考量是，剥离部分不需要回滚的存储区和变量，以降低性能开销。

下列存储区默认是常量存储区：

    _errorhandling
    _gamepad
    _renpysteam
    _sync
    _warper
    audio
    achievement
    build
    director
    iap
    layeredimage
    updater

常量存储区中的变量只能初始化阶段更新，之后就不允许修改。

.. _lenticular-bracket-ruby-text:

方头凹形括号Ruby文本
-----------------------------

:ref:`Ruby文本 <ruby-text>`，即用于阅读或翻译的上下双层文本，可以使用全角方头凹形括号(【】)与竖线符号(｜或|)结合的语法编写。
全角或半角的竖线符号(｜或|)用来分隔Ruby文本的上半与下半内容。

::

    e "Ruby 可以用来标识假名(【東｜とう】 【京｜きょう】)。"

    e "也可以用来翻译 (【東京｜Tokyo】)."

在某些地方，可能需要直接显示左方头凹形括号(【)。此时需要连续两个左括号"【【"的形式转义。
例如：

::

    e "【【这不是一段 | Ruby文本。】"

.. _7.6-accessibility:

可读性
-------

新增配置项 :var:`config.tts_substitutions`，用于自动语音中的分词规则。
这样创作者可以修正语音引擎对某些文本的发音问题。

例如：

::

    define config.tts_substitutions = [
        ("Ren'Py", "Ren Pie"),
    ]

就可以让自动语音把特殊词“Ren'Py”的发音改为“Ren Pie”。

自动语音可以受语音音量混音器的影响。

.. _7.6-save-token-security:

存档令牌安全机制
-------------------

用户在不同设备间迁移存档时，当前版本Ren'Py会使用令牌(token)提示用户，
防止用户误操作导致的各类问题。详见 :doc:`security documentation <security>`。

Ren'Py在某台电脑上首次运行时，将生成一个令牌(token)。所有存档和持久化数据都将包含该令牌。
如果来自不同电脑的存档中发现了与本机不同的令牌，用户会收到警示和询问是否继续。
如果用户选择“是”，会继续受到询问，是否自动许可来自那台电脑的所有存档。

只有当前电脑和获得许可令牌中的持久化数据才可以加载。

第一次运行支持存档令牌机制的Ren'Py时，Ren'Py将检查对应游戏的存档文件中是否存档令牌。
如果存档中没有令牌则添加令牌。
在Ren'Py 8.1/7.6及以后的版本中执行此步骤不会有提示。

无法禁用该特性，因为对终端用户来说这是重大安全问题。

.. _7.6-new-search-paths:

新的搜索路径
----------------

当前版本Ren'Py如果在game目录下没有找到对应的音频或字体文件时，
会从 ``game/audio`` 目录中搜索音频文件，从 ``game/fonts`` 目录中搜索字体文件。
图片文件依然会从 ``game/images`` 目录搜索，但其他类型的文件不会搜索该目录。

.. _7.6-new-3d-stage-properties:

新的3D舞台特性
---------------

3D舞台新增了几项特性：

:tpref:`point_to`
    指定一个点作为摄像机朝向，或者精灵(sprite)的朝向。

:tpref:`xrotate`, :tpref:`yrotate`, :tpref:`zrotate`
    使精灵(sprite)或摄像机安指定的坐标轴旋转。

:tpref:`orientation`
    使精灵(sprite)或摄像机同时在3个轴向旋转，一般按球面最短路径计算旋转。

.. _7.6-live2d:

Live2D
------

当前版本Ren'Py支持Live2D Cubism Editor 4.2的新特性。
如果要使用这些新特性，需要安装Cubism 4 Sdk for Native R6_2或更高版本。

Live2D可以在x86_64安卓平台运行了。

新的Live2D.blend_opacity方法结合update_function函数可以修改Live2D模型的不透明度。

.. _7.6-launcher-and-engine-translations:

启动器和引擎的多语言支持
-------------------------

如果可能的话，各类机器翻译的文本将用于启动器和引擎，特别是更新长久以来都没有支持的一些语种。

如果你想要提升翻译质量，可以这样做。
编辑启动器目录 launcher/game/tl/`language` 中的各种 .rpy 文件，然后发送给我们。
记得请删除标记“Automatic translation”的内容。

以下语种的翻译启用了自动更新：

* Finnish
* French
* German
* Greek
* Indonesian
* Italian
* Japanese
* Korean
* Polish
* Portuguese
* Russian
* Simplified Chinese
* Turkish
* Ukrainian

以下语种包含人工更新：

* French
* Portuguese
* Spanish
* Japanese
* Ukrainian

.. _7.6-more-new-features:

更多新功能特性
---------------

:ref:`输入框 <sl-input>` 组件可以支持多行输入了。

新增的 :ref:`JSONDB <jsondb>` 系统允许开发者在游戏脚本中读取Json文件存储的数据。
例如，JSONDB用于存储气泡式对话信息。

新增可视组件类型 :ref:`areapicker <sl-areapicker>`，提供了让用户可以框选一个屏幕区域的工具。

:class:`Movie` 新增入参 `group` 。在某个组内的Movie对象可以衔接同组的上一个Movie对象最后一帧画面。
此设计用于影片精灵直接的无缝衔接。

新增配置项 :var:`config.file_slotname_callback` 允许开发者自定义存档槽位名的生成方式。
该项的一种用法是可以在存档槽加前缀(比如，区别dlc存档和非dlc存档)。
新增配置项 :var:`config.autosave_prefix_callback` 可以让自动存档也有一个前缀。

新增一种工具，在开发者菜单中(Shift+D)可以查看持久化数据。

互动式编导器可以创建语句时移除某个image对象的属性(attribute)。

``show screen``、``hide screen`` 和 ``call screen`` 语句可以跟 ``expression``、``as``、``onlayer``、``zorder`` 和 ``with`` 从句。
效果和语法与 ``show`` 和 ``hide`` 语句后面的从句相同。

:func:`renpy.include_module` 函数可以加载 rpym 文件，穿插加载初始化语句块的内容。

新增环境设定配置 “voice after game menu”，用于控制是否在显示游戏菜单时继续播放语音。

创作者自定义语句可以与 ``default`` 语句相同的执行时机执行一个函数。
此实际在初始化阶段之后，但早于游戏运行之前，以及加载存档时、回滚后、lint检查前等类似时间点。

新增配置项 :var:`config.after_default_callbacks` 可以在 default 语句执行后立刻运行某些回调函数。

互动式编导器中可以使用鼠标右键点击某个属性名称来取消该属性。

:func:`Text` 组件新增入参 `tokenized`。若该入参为True，文本组件会从 :ref:`定制文本标签 <custom-text-tags>` 获取一个token列表。

Ren'Py新增两个内置图层。“top”图层会显示在其他所有图层之上，并且不受转场效果影响。通常用于显示常驻信息。
“bottom”图层显示在其他所有图像之下。通常用于处理总是激活状态的按键事件。

Ren'Py支持C90编码的泰文字体。

鼠标的按键映射也可以支持多按键事件。
例如，“shift_mouseup_1”会在鼠标按键1释放并且shift键按下时触发对应的事件。

重做了keysym系统，可以在NumLock键关闭状态时绑定小键盘按键(几个箭头和Home键)。
重做了 :doc:`按键映射 <keymap>`，便于更好利用小键盘按键。

通常，某个同名或带同名标签(tag)的可视组件或界面，从隐藏状态转为显示状态时，将移除组件或界面的隐藏属性，
变换中hide部分的效果将取消。新的 :propref:`show_cancels_hide` 变换特性可以控制这种情况的效果。

控制台(快捷键Shift+O)的 ``help`` 命令可以加表达式。表达式会显示匹配到的函数或类的说明。

新增 :func:`renpy.get_translation_identifier` 函数，返回对话当前行的唯一标识符。

新增 :var:`config.scene_callbacks` 配置项，可以设置为一个回调函数列表。
当运行scene语句或调用 :func:`renpy.scene` 函数时，将调用该配置项的函数列表。

文本标签 ``size`` 可以使用乘号“*”，用法如下：

::

    "{size=*2}两倍大{/size} {size=*0.5}一半大{/size}"

可视组件 :ref:`dismiss <sl-dismiss>` 可以使用 `keysym` 特性，指定dismiss的keysym。

新增配置项 :var:`config.autosave_callback`，在后台自动存档时运行对应的回调函数。

新增 :func:`renpy.music.pump` 函数，调用后可以让音频播放更改立即生效，而不需要等待下一次互动。
主要用于播放某个音效，然后淡出。
(默认情况下，``play`` 语句后面跟的 ``stop`` 从句会将音频停止但没有淡出。)

新增 :func:`renpy.clear_attributes` 函数，可以移动某个图像的所有标签(tag)。
以前要实现效果的方式是隐藏并在此显示图像，同时会导致图像在界面中的位置也被重置。
使用该函数则没有这个问题。

新增配置项 :var:`config.check_conflicting_properties`，默认对已存在的游戏禁用而对新创建的游戏启用。
可以让创作者检查样式和变换特性的当前设置是否会有冲突。
原因是不同平台和版本的Ren'Py运行相同的代码可能会有不同的结果。

新增配置项 :var:`config.font_name_map`，可以让创作者对字体文件和 :ref:`fontgroup` 重命名，使用在 {font} 文本标签时更方便。
在此之前的版本中，{font} 文本标签无法使用字体组(fontgroup)。

:class:`Scroll` 行为新增入参 `delay`，可以让滚动动画增加一段延迟。

新增环境设置 :var:`preferences.audio_when_unfocused`，可以让用户切换应用窗口时暂停游戏内音频播放。

界面中的 ``for`` 循环支持 ``continue`` 和 ``break`` 语句。

可以在需要的文件开头使用 ``rpy monologue none`` 语句，禁用对话的 :ref:`monologue-mode`。

.. _7.6-other-changes:

其他变更项
-------------

极坐标运动的特性(:tpref:`around`、:tpref:`radius` 和 :tpref:`angle`)改为圆周运动，而不再是椭圆运行。
圆周运动的半径会选取宽度和高度中较小的一方，并按比例换算。
新增的 :tpref:`anchoraround`、:tpref:`anchorradius` 和 :tpref:`anchorangle` 特性可以在极坐标下指定锚点。

当某个界面中设置两项互相冲突的特性时，Ren'Py会报错。
比如，同时设置 :propref:`align` 和 :propref:`xalign` 就会报错。
之前的版本中这属于未定义的情况。

lint工具会检查游戏中永远无法抵达的语句，并在生成的报告中列出这些语句。

lint工具会检查游戏中没有用到的多语言支持内容，并在生成的报告中列出这些内容。

可以使用 :var:`build.itch_channels` 指定上传到 itch.io 的通道。

连续三个双引号的转义字符串与单个双引号的用法一致。
这样在界面中也可以使用连续三个双引号的文本了。例如：

::

    screen example():
        text """\
    line 1
    line 2
    line 3"""

就可以在文本组件中创建出一行三个双引号的文本。

在环境设置中存储着最大化窗口的状态，当游戏窗口最大化并关闭后，下次启动游戏将直接最大化窗口。

界面语言定义可视组件时，可以直接在第一行使用 ``at transform`` ：

::

    text "Spinny text" at transform:
        rotate 0.0
        linear 2.0 rotate 360.0
        repeat

在界面语言中可以同时具有 `at` 特性并带有 ``at transform`` 语句块，应用顺序与脚本中的顺序一致。

本地变量(前缀为 __ )可以用于f-string。

在启用自动语言功能后，文本标签 {nw} 会等待自动语言说完某句台词再继续下一句。

使用样式特性 ``selected_insensitive`` 后，``selected`` 和 ``selected_insensitive`` 事件将在合适的时机发送给变换(transform)。

带有 `id` 特性的可视组件可以指定 `prefer_screen_to_id` 特性，控制是否接受界面中对应可视组件id的特性覆盖。
默认情况下，组件自身特性覆盖界面中定义的特性。

``fadein`` 从句可以用于音轨列队中。

在Steam Deck上运行时，Ren'Py会限制BOverlayNeedsPresent的调用次数，防止卡死。

对话框中正在显示的内容将进入对话历史记录(以及历史记录界面)中。之前的版本中，只有对话达到结尾处才会进入对话历史记录。

如果没有设置 :var:`config.steam_appid`，Ren'Py会删除game目录下所有存在的 ``steam_appid.txt`` 文件。
此举是为了防止启用错误的steam app id。

音频的音量值与静音设置做了隔离。(也就是说，游戏静音并不等于音量值就一定是0。)

文档中明确了非自闭合的文本标签会自动在对应的文本段落结尾添加闭合标签。
在之前的很多Ren'Py版本中，lint检查只是出现warning信息。从此版本开始，下面的脚本是合法的。

::

    e "{size+=20}这段文字加大！"

自动语音和自动前进可以同时启用。同时启用后，仅当对话框获得焦点时，自动前进才会起效。

Ren'Py不再要求grid和vpgrid组件必须填满——子组件数量不足时将使用null组件填充。

:func:`renpy.register_statement` 函数中的 `execute_init` 参数会受 `init_priority` 参数的影响。
之前的版本中，所有 `execute_init` 中指定的函数始终在优先级0级别运行。

config.label_callback 配置项改名为 :var`config.label_callbacks`，并且可以设置为一个回调函数列表。

文档中一系列函数、类和行为函数的签名(即入参列表)做了修正，使用起来更安全。

之前Ren'Py会将所有空白字符都转为标准空格。当前版本可以支持非标准空白，比如 \\u3000 这种全角空格。

.. _renpy-7.5.3:
.. _renpy-8.0.3:

8.0.3 / 7.5.3
=============

.. _7.5.3-security:

安全
-----

文档中新增 :doc:`security` 页面，用于帮助用户理解mod和分享存档可能设计的安全问题。

.. _7.5.3-modal-screen-pauses-and-timers:

模态界面、暂停和计时器
-----------------------

基于创作者们的反馈，模态窗口与暂停和计时器的交互彻底重做。
在当前版本中，显示模态界面时暂停不会结束，解释器也可以触发。

不过也有一些情况不希望这样。
为了解决那些需求， :ref:`timer 组件 <sl-timer>` 和 :func:`renpy.pause` 都新增了新的 `modal` 特性/参数。
如果该特性或参数为True，在显示模态界面后计时器将结束计时，暂停会立即结束。

.. _7.5.3-changes-and-fixes:

变更和修复项
-------------

Ren'Py对安卓API的支持提升到level 33，对应安卓13版本，允许新游戏加入Google Play商店。
Play Billing库升级到第5版。

使用 :func:`renpy.load_module` 加载模块的运行优先级改为 init 级别。

lint与 :var:`config.adjust_attributes` 配置项保持一致。

某个情况下模糊效果会变成透明的问题已定位。

将对话内容作为选项菜单标题显示时修改语言类型，Ren'Py会自动找到修改后语言的前一个say语句并作为选项菜单标题。

开发中的游戏如果没有指定 :func:`gui.preference` 的默认值，Ren'Py将报错。

多处文档做了修改和提升。

该版本修复的矩阵相等判断的问题，不再会出现使用矩阵实现动效的错误。

Ren'Py会对lambda匿名函数中绑定的变量进行正确解析。

添加了乌克兰语版本的教程和“The Question”。启动器的乌克兰语版本也做了更新。

.. _renpy-7.5.2:
.. _renpy-8.0.2:

8.0.2 / 7.5.2
=============

.. _7.5.2-fixes:

修复项
--------

自动加载脚本(Shift+R)方面有一些改动，尝试防止加载遇到错误时Ren'Py再次创建一个不可用的存档文件并导致Ren'Py进入不可用状态。
这些改动的目标是，在修改前保留存档文件并可以再次使用对应文件。

当前版本可以在0.68秒之内实现音频的淡入淡出效果。
在之前的版本中，如此之短的时间会导致音频直接终端而没有淡入淡出效果。
不过当前版本依然不能严格保证淡出淡出的精确时间。

针对achievement.steamapi的某些函数回退已经取消。

aarch64版本无法正确构建发行版的问题已修复。

存储区变量数量过大时，CPU和内存消耗急剧增大的问题已修复。

加载一个与当前设置的语言版本不同的存档时，可以正确显示 :var:`config.after_load_transition` 配置的转场。

Ren'Py 8中某些游戏内购无法使用的问题已修复。

在教程中的某些非英语样例无法正确运行的问题已修复。

Ren'Py源代码打包时已包含Tinydialogs.

.. _7.5.2-default-focus-changes:

默认获取焦点相关变更
---------------------

可以获取焦点可视组件，比如按钮和条(bar)，其 `default_focus` 特性有几项变更。
当某些可视组件被移除后，该特性可以让Ren'Py选择某个组件自动获取焦点。

新的焦点获取规则为：

* 当使用鼠标时，焦点跟随鼠标，`default_focus` 不起作用。
* 某个可视组件的 `default_focus` 值比其他组件大时，该组件获得焦点。
* 某个具有最大 `default-foucs` 值的可视组件被隐藏时，具有次高且非零值 `default-focus` 的组件获得焦点。

这项改动的目的是方便键盘和游戏控制器用户，对鼠标用户没影响。

.. _7.5.2-other-improvements:

其他性能提升
------------------

文档中记录了多处改动和性能提升。

控制台可以显示更多Python 3数据类型。

:func:`MouseDisplayable` 将与 :var:`default_mouse` 设置的值保持一致。

在Ren'Py 8中，Python代码编译时默认带 ``from __future__ import annotations`` 。

模态screen和dismiss将会阻止 ``pause`` 语句和 :func:`renpy.pause`` 函数的效果。
在之前的版本中此类情况没有明确定义，并且不同版本会发生的情况也各不相同。

在macOS平台上，Ren'Py游戏窗口在不同分辨率显示器间移动时，将会自动进行合理缩放。

macOS平台上可以使用Command+C和Command+V实现复制粘贴。

screens.rpy文件中的默认input界面发生变更，解决了vbox中 :propref:`xalign` 和 :propref:`xpos` 两个特性的冲突。
将使用xalign的地方都改为了 :propref:`xanchor`。

包括开发者模式下，Ren'Py可以无声卡启动。
音频硬件的错误将写入到log.text文件。

日语版本更新。

New games created with Ren'Py no longer filter out ruby/furigana text tags.

不再滤除“ruby/furigana”文本标签。

.. _renpy-7.5.1:
.. _renpy-8.0.1:

8.0.1 / 7.5.1
=============

.. _7.5.1-improvements:

性能提升
------------

启动器新增乌克兰语，感谢Matias B的协助。

Web端在循环播放音频文件时，可以服用音频数据，降低了内存使用。

:func:`MouseDisplayable` 内部使用的ATL变换可以在鼠标改变后重置。在之前的版本中，该行为未定义。

控制台的追踪界面改为每帧更新。

其他更多提升详见文档。

.. _7.5.1-fixes:

修复项
-------

ALT文本将按从前往后顺序执行。8.0版的某项改动使ALT文本的顺序反了。

CropMove转场不正确的问题，是某个数值取整错误导致，已修复。

zoomin和zoomout转场无法正常运行的问题已修复。

Movie组件再次可以播放一个视频文件列表，而不仅只能指定单一文件。

构建安卓版本时的一个问题已修复。

对象标识将用于比较 :func:`Function` 行为函数的入参。
这样做是为了避免，在两个行为函数入参相等但并实际不相同(比如，两个空列表)的情况下错误复用参数的问题。

获取和设置Steam统计数据的问题已修复。

:ref:`dismiss <sl-dismiss>` 已正确设置为模态(modal)。

.. _renpy-7.5.0:
.. _renpy-8.0.0:

8.0 / 7.5
=========

.. _8.0-python-3-support:

Python 3支持(Ren'Py 8.0)
-----------------------------

Ren'Py 8.0运行在Python 3环境下，即Python语言的最新主干版本。

如果你的游戏只使用了Python的基础功能(例如存储角色名字和flag)，运行起来不会跟以前有什么差别。
否则的话，请继续阅读以下内容。

对很多Ren'Py开发者来说，转移到Python 3将会带来很多Python语言和库方面的提升，详见文档 `What's new in Python <https://docs.python.org/3.9/whatsnew/index.html>`_ 。
文档中包含很多Python 3中的变化，请根据需要阅读。

值得着重一说的，一些Ren'Py游戏开发过程中的新东西如下：

* 函数可以仅有关键词入参。(脚本标签、变换和界面的入参也支持该特点)

* 对函数入参和返回值的数据类型进行注释(annotate)。(仅在Python中支持)

* 可以使用格式化字符串语法。比如字符串 ``f"characters/{character}.chr"``，
  在花括号中的文本将使用格式化后的Python变量，类似于Ren'Py对话中的字符串插值。
  不过该功能仅在Python语句中有效。大多数Ren'Py语句中不能使用。

此外还有一大堆提升，毕竟这是直接从Python 2.7到Python 3.9的巨大跨越。有兴趣的朋友请参阅其他Python文档，寻找各方面的提升。

Ren'Py从Python 2.7迁走的其中一个重大考量是，2.7版已经不再受Python软件基金会的支持。
所以迁移为Ren'Py的后续发展提供了有利基础。

如果你使用新版Python，需要注意一些转换要点。

* 在Python 3中，出发总会返回浮点型，而不再是整型(例如，``3 / 2`` 的结果是1.5而不是1)。
  操作符 ``//`` 用于取整除法。这项改变会对原来Ren'Py计算位置的部分产生影响，因为Ren'Py中对整数和浮点数的处理方式不同。

* 在Python 3中，字典类型的键、元素、值相关方法都只返回视图(view)类型，而不返回列表(list)类型。
  iterkeys、iteritems和itervalues方法不能使用。xrange方法已删除，range方法不再返回一个列表。

* except从句必须写成 ``except Exception as e:`` 类似的方式，不再支持旧写法 ``except Exception, e:`` 。

* 所有字符串默认使用unicode编码(Ren'Py从多年前就已强制如此)，文件默认使用文本模式打开。
  (但是，:func:`renpy.file` 函数还是以二进制模式打开文件。使用 :func:`renpy.open_file` 函数可以默认编码打开文件。)

* 很多Python模块(module)的命名发生了变化。

这里不是一个完整的变化列表。

Ren'Py只使用Python标准库的一个子集，并非所有Python模块在Ren'Py中都可以直接使用。
如果你觉得哪些模块好用，请务必让我们知道，特别是那些没有库依赖关系的模块。
由于 ``async`` 和 ``await`` 是可用的，Ren'Py并不直接支持协程(coroutine)。

Ren'Py 8.0使用Python 3.9.10版本，可以应用在Windows、macOS、Linux、安卓和各iOS平台。Web平台将在后续版本中支持。

运行Ren'Py 8时，默认Python环境不带 ``-O`` 标识，可以使用 docstring 和 assert 语句。

根据我们的经验，大多数使用游戏在Python3环境下运行完全无变化，特别是使用Ren'Py的API管理游戏状态的游戏。
Ren'Py 8已经尝试过运行最早开发于2006年的Ren'Py游戏。

.. _7.5-continued-python-2-7-support:

继续对Python 2.7的支持(Ren'Py 7.5)
-----------------------------------------

Ren'Py 7.5与8.0同步发行，继续提供基于Python 2.7的新版Ren'Py，作为对目前开发中游戏(或发行后维护中游戏)的支持。
这个版本依然需要Python 2.7环境。

该版本中，Ren'Py还支持Web平台。

Ren'Py 7.5和Ren'Py 8.0支持同样的功能特性。

我们计划继续支持Ren'Py 7系列，直到我们看到社区彻底迁移到Ren'Py 8系列，或者基于Python生态变化导致基于Python 2的Ren'Py无法维持时。

请在Ren'Py 8中随意测试你们的游戏。对大多数游戏来说，只需要极少量改动甚至完全不需要改动。
如果因为某些原因，你无法将游戏迁移到Ren'Py 8上，请让我们了解具体的掣肘原因。

.. _7.5-platform-support-changes:

支持的平台变化
------------------------

该版本增加了对64位ARM版Linux(linux-aarch64)平台的支持。
基于Ubuntu 20.04，该版本已在Chrome笔记本上做过测试，并且应该也能支持64位版本的ARM平台。

要想在ARM Linux上运行Ren'Py游戏，需要先下载新的ARM Linux SDK包，然后把游戏放入对应项目目录中，并使用该SDK启动游戏。
某些情况下Linux发布版本时会带有ARM Linux SDK文件，不过出于文件大小的考量，默认是不带那些文件的。

迁移到Ren'Py 8后，我们移除了以下平台的支持：

* 32-bit x86 Windows (i686)
* 32-bit x86 Linux (i686)

这项变化对32位的x86电脑有明显影响。上述两个平台依然可以使用Ren'Py 7.5，但未来永远无法使用Ren'Py 8.

.. _7.5-web-and-chromeos:

Web和ChromeOS
----------------

目前只有Ren'Py 7.5支持Web平台。

Safari和Chrome浏览器的改变导致了Ren'Py的内存占用大概提高了50倍，当浏览器的堆内存溢出时就会出现内存范围错误(RangeError)。
Ren'Py 7.5做出了一些修改，以降低对Web浏览器内存的占用。

新增 :var:`config.webaudio_required_types` 配置项，可以设置为一个列表，用于指定游戏使用的媒体类型(mime type)。
如果浏览器支持对应的媒体类型，Ren'Py将只适用浏览器的音频系统播放音频文件。
如果浏览器不支持对应的媒体类型，将使用webasm播放，而这可能会导致声音停顿或跳跃，尤其是在运行速度慢的设备上。

:var:`config.webaudio_required_types` 配置项的设计原意是在Safari上运行游戏时可以使用ogg和opus音频，并在只是用mp3时能灵活切换。

Web版导入存档文件后，Ren'Py将立刻刷新存档文件列表，而不用重启。

以安卓app形式运行在ChromeOS设备上时，变种项“chromeos”将激活。

ARM版本的Chromebook上可以运行Ren'Py SDK。

.. _7.5-android-and-ios:

安卓和iOS
---------------

如果游戏内包含app内购项目时，安卓配置项会再次提示选择app商店。
如果没有选择任何app商店，项目中不会包含支持游戏内购的库。
这些库中包括付费许可，会在游戏上架时标识为包含游戏内购内容，尽管可能游戏中实际没有内购内容。

由于某些底层库的问题， :func:`renpy.input` 函数和 ``input`` 可视组件不再支持安卓平台的基于输入法编辑器(非拉丁字符)的文本输入。(译者注：也就是不支持中文输入。)

在iOS平台上，对OpenGL ES的调用将会被转为原生Metal图形系统。
这项改动将提升新款苹果设备的适配性，并修复部分苹果使用Silicon芯片的设备上运行iOS模拟器时的问题。

.. _7.5-steam-steamdeck-and-epicgamesstore:

Steam、Steam Deck和Epic游戏商店
---------------------------------------

该版本重写对对Steam的支持，基于ctypes库实现接入和调用整套Steamworks的API。
不过对Steam的 :doc:`成就模块 <achievement>` 保持原样，便于高级Python程序员们接入Steam的各种功能。

当Steam激活时，Ren'Py将启用“steam”变种。

该版本包含对Steam Deck的硬件支持。
调用 :func:`renpy.input` 函数时，将在Steam Deck上显示屏幕软键盘。
在Steam Deck上运行Ren'Py时，将启用“steam_deck”、“steam”、“medium”和“touch”几项变种项。

我们写了一个 `Ren'PySteam Deck Guide <https://github.com/renpy/steam-deck-guide>`_
帮助你们实现游戏认证。感谢Valve提供的测试用Steam Deck。

构建分发包中的“Windows, Mac, and Linux for Markets”选项作用发生变化，不再会根据目录名称和版本号生成zip包的前缀。
这表示不需要每次在Steam上更新启动器配置信息，只需要第一次上传时更新即可。

Ren'Py支持从Epic游戏商店启动，不过启动时会忽略很多参数。

.. _7.5-visual-studio-code:

Visual Studio Code
------------------

Ren'Py支持下载和使用Visual Studio Code(VSC)，并且有一个VSC扩展 `Ren'Py语言 <https://marketplace.visualstudio.com/items?itemName=LuqueDaniel.languague-renpy>`_ 。

Ren'Py语言扩展提供了对Ren'Py的丰富支持，包括语法高亮、分段、自动填充、颜色预览、文档说明、跳转到定义、函数签名、错误分析和轮廓线等。

VSC还有海量的系统扩展，包括拼写检查等。可以与Ren'Py语言扩展插件一起使用。

可以通过编辑器设置选项下载VSC。还可以直接设置为已经装好Ren'Py语言扩展插件的VSC。


dismiss、nearrect和Focus Rectangles
---------------------------------------

Ren'Py中加入了两种新的可视组件，用于拖放菜单、下拉菜单和提示消息。

:ref:`dismiss <sl-dismiss>` 组件主要用在某个模态frame后面，激活后执行某个行为。
该组件可以用在其他组件的缝隙间，当用户点击frame之外的区域时直接隐藏整个frame。
(译者注：即常见的“点击空白处关闭窗口”。)

:ref:`nearrect <sl-nearrect>` 组件会在其上方或下方的矩形区域放置另一个可视组件。
改组件可以用于按钮上显示提示，或者弹出下拉菜单。
(文档中有使用nearrect组件实现下拉菜单以及使用 :ref:`tooltips <tooltips>` 组件实现提示消息的样例。)

新增行为函数 :func:`CaptureFocus` ，用于捕获nearrect组件需要的目标矩形区域。
捕获目标矩形区域后，:func:`GetFocusRect` 函数获取目标矩形焦点，:func:`ClearFocus` 函数清除目标矩形焦点，
:func:`ToggleFocus` 函数根据当前焦点情况使目标矩形区域获取或清除焦点。

.. _7.5-alt-and-transforms:

ATL和变化
------------------

现在可以在ATL插值操作中包含一个代码块了。具体来说：

::

    linear 2.0:
        xalign 1.0
        yalign 1.0

这种写法是允许的，等效于：

::

    linear 2.0 xalign 1.0 yalign 1.0

关于 :ref:`ATL 转场 <atl-transitions>` 和 :ref:`特殊ATL关键字参数 <atl-keyword-parameters>` 的信息，已添加对应文档。

``pause 0`` 语句作为特殊情况，将显示1帧，并且是唯一可以保证至少显示1帧的方式。
从6.99.13起，Ren'Py尝试了各种方式实现单帧显示，然而大部分都会有画面撕裂的问题。

当ATL图像用作某个图片按钮的子组件时，当其每次显示时，已显示时间(shown time)都会重新计时。

变换特性 :tpref:`crop_relative` 默认值改为True。

``function`` 语句仅在产生延迟时会阻止执行，前提是在变换中使用 ``function`` 语句并继承某个时间轴以实现更加自然的效果。

.. _7.5-image-gallery:

画廊
-------------

:class:`Gallery` 类新增一个字段 `image_screen`，用于定制画廊图片的现实方式。

:func:`Gallery.image` 和 :func:`Gallery.unlock_image` 方法可以使用前缀为 `show\_` 的关键词入参。
入参的前缀 `show\_` 将被剔除，然后传入Gallery.image_screen。该功能可用于在画廊中的图片保存额外信息。

.. _7.5-boxes-grids-and-vpgrids:

box、grid和vpgrid布局
------------------------

自身不占据任何空间的可视组件(比如 :ref:`key <sl-key>`、:ref:`timer <sl-timer>` 和判断为False时的 :ref:`showif <sl-showif>`)
放在布局组件 :ref:`vbox <sl-vbox>` 或 :ref:`hbox <sl-hbox>` 中时，:propref:`spacing` 特性没有实际效果。但那些可视组件在其他布局组件中会占据空间，例如grid。

完全重写了vpgrid组件，不允许指定 ``rows`` 和 ``cols`` 后超过总单元格数量的子组件。

没有完全填满的vpgrid可能会导致一个错误，除非默认启用(opt-out) ``allow_underfull`` 或 配置项 :var:`config.allow_underfull_grids`。

如果vpgrid指定了行数和列数，内部子组件数量却少于“行数×列出”，则称作未满(underfull)。
一个只指定了行数或列数其中之一的vpgrid，其内部的子组件数量如果不是指定行数或列数的整倍数，则这个vpgrid也是未满的。

.. _call-screen-roll-forward:

调用界面和前向滚动
----------------------------

默认情况下使用 ``call screen`` 将禁用前向滚动，原因是不安全并容易导致混乱。
关键问题是，在界面中前向滚动会对返回值产生副作用，使用jump的界面跳转也可能有影响。
有其他副作用的行为，例如修改变量和播放音乐，在前向滚动时都无法保持正确运行。

确定某个特殊界面使用前向滚动也是安全的前提下，使用 `roll_forward` 特性可以启用前向滚动。
如果确定游戏中所有界面都要支持前向滚动，可以直接设置 :var:`config.call_screen_roll_forward` 项。

.. _7.5-new-features:

新功能特性
------------

``show screen``、``hide screen`` 和 ``call screen`` 语句可以使用一个 ``expression`` 修饰符，允许通过Python表达式传递界面名称。

在设置 :func:`Preference` 中新增了“main”音量。“main”音量的值会乘以各其他音量的值，以实现对所有游戏音量的调整。

新增 :var:`config.preserve_volume_when_muted` 配置项，当某个音频通道静音时依然可以查看对应通道的音量值。

启动器的设置界面中新增一个按钮，可以一键清空临时目录文件。

新增 :var:`config.choice_empty_window` 配置项，用于定制选项菜单显示时的空window。
用法如下：

::

    define config.choice_empty_window = extend

选项菜单标题将使用前一句对话内容。

可视组件 :ref:`key <sl-key>` 新增支持 `capture` 特性，决定按下的按键是否在某次交互结束后依然需要处理按键事件。

样式特性 :propref:`language` 新增一个“anywhere”值，允许Ren'Py处理字符串时可在任意地方断行。

:func:`renpy.pause`函数新增入参 `predict` ，可以暂停等待图片预加载完成。
预加载可以由 :func:`renpy.start_predict` 和 :func:`renpy.start_predict_screen` 两个函数触发。

生成对话时可以选择一项语言，而不是原来只能使用默认项。

界面语言中的 ``add`` 语句新增 `alt` 特性，使用方法如下：

::

    screen test():
        add "icon.png" alt "The Icon"

行为函数 :func:`Hide` 可以使用None作为界面名，效果是隐藏当前界面。

:func:`Placeholder` 新增入参 `text` 。该项会覆盖自动检测到的占位符文本。

:func:`renpy.dynamic` 函数可以生成命名空间 daynamic 的变量。

新增配置项 :var:`config.always_shown_screens` ，允许创作者定义始终显示的界面(即使在主菜单或游戏菜单界面)。
同时参见 :var:`config.overlay_screens`。

OpenGL视口(viewport)的位置和尺寸在着色器(shader)中可用，名为u_viewport。

新增环境变量RENPY_PATH_TO_SAVES，可以在系统级别控制Ren'Py存档位置。
环境变量RENPY_MULTIPERSISTENT加入文档，与多项持久化(multipersistent)数据的用法相同。

新增配置项 :var:`config.at_exit_callbacks`，当游戏退出时调用配置的函数。
该项用途是在允许开发者保存自己需要的额外数据。

新增配置项 :var:`config.default_attribute_callbacks`，可以指定某个标签(tag)的默认属性(attribute)，并且不会与其他属性冲突。

.. _7.5-other-changes:

其他变更
-------------

可以在 :func:`renpy.input` 中使用快捷键Ctrl+C和Ctrl+V实现复制粘贴。
显示文本输入状态时，Ctrl键不再会触发跳过(skipping)。

:func:`renpy.file` 函数重命名为 :func:`renpy.open_file`，旧函数名保留。
新增 `encoding` 参数，可以在打开文件时指定编码。

可拖拽组件的样式特性 :propref:`focus_mask` 默认值改为None。
性能有提升，但组件的透明像素部分也可以拖拽。

向命名空间audio添加文件时，Ren'Py会重新扫描flac文件。

say语句用作选项菜单标题时，可以使用永久和临时的图像属相(attribute)，与其他地方的say语句用法一致。

所有位置相关特性都可以作为gui变量应用到按钮上。例如：

::

    define gui.navigation_button_text_hover_yoffset = -3

模态 :ref:`frame <sl-frame>` 的表现发生变化。
A modal frame now blocks mouse events when inside the frame, and blocks focus from
being transferred to displayables fully behind the frame, while allowing focus
to be given to other displayables.

新增配置项 :var:`config.main_menu_stop_channels`，控制进入主菜单界面时停止播放的音频通道。

层叠式图像将根据整个屏幕尺寸进行渲染。
在之前的版本中，层叠式图像内部使用布局管理(像hbox、vbox、side等)，层叠式图像内部元素之间的空隙和相对位置都会发生改变。
新增特性 `offer_screen` 控制以上表现。

定义角色对象 :func:`Character` 时若将 `interact` 设置为False，或用于不可互动的方式，将会使用自动语音，前提是相关文件存在。

在某个say语句或者带标题的menu语句前使用 ``window auto`` ，Ren'Py会自动判断角色是在NVL模式还是ADV模式下说话，并会显示正确的对话窗口。
在之前的版本中，只能将最后一个使用say语句的角色作为对话角色。

:propref:`activate_sound` 特性会在拖拽组件激活时播放指定音效。

:func:`VariableValue`、 :func:`FieldValue` 和 :func:`DictValue` 可以调用 :func:`Return`，让交互后返回特定的值。

:propref:`adjust_spacing` 特性可以在新游戏项目中，针对对话和旁白设置为False。
这样设置可能会导致，游戏窗口尺寸改变时，文本间距也发生变化。使用extend语句时则会保持文本间距。

播放或停止某个音频通道的音乐，将会取消对应通道的暂停状态。

新增设置 :var:`preferences.audio_when_minimized` ，当游戏窗口最小化时暂停游戏内音频。

:propref:`outline_scaling` 特性的默认值改为“linear”。

除Web平台外，Ren'Py使用的SDL版本升级到2.0.20

多种语言版本升级。

考虑到Ren'Py内置文件过大的问题，移除了jEdit编辑器。
不过，如果在7.4.0之前解包的目录中，依然可以从启动器中选择jEdit。

.. _7.5-versioning:

版本号规范
----------

Ren'Py的完整版本号格式改为major.minor.patch.YYMMDDCCnu。
各字段含义如下：

* YY表示(github)最后提交年份的后两位。
* MM is the month of the commit.
* MM表示提交月份。
* DD表示提交日期。
* CC表示当天提交次数。
* n表示每夜构建版。
* u表示非官方构建版。

.. _renpy-7.4.11:

7.4.11
======

.. _7.4.11-the-gui-variant-decorator:

gui.variant修饰器
-------------------------

Ren'Py新增 gui.variant 修饰器。其用于修饰某些的函数。
当函数运行时，若是游戏首次启动或每次gui重建后(调用 :func:`gui.rebuild` 函数或gui的设定变更，或应用语言变更)修饰器生效。

使用样例如下：

::

    init python:

        @gui.variant
        def small():

            ## 字号.
            gui.text_size = gui.scale(30)
            gui.name_text_size = gui.scale(36)
            # ...

无修饰器的原脚本为：

::

    init python:

        if renpy.variant("small"):
            ## 字号
            gui.text_size = gui.scale(30)
            gui.name_text_size = gui.scale(36)
            # ...

无修饰器版本只会运行一次，并且在gui重建后会丢失所有变更内容。

.. _7.4.11-fixed:

修复项
------

新增配置项 :var:`config.mouse_focus_clickthrough`，用于判断鼠标点击是否让游戏窗口获得焦点，并正常处理点击事件。

启动器的 :var:`config.mouse_focus_clickthrough` 设置为True，所以只要点击一次就可以直接启动游戏了。

输入框的 `caret_blink` 特性可以在界面语言中使用。

若Live2D动作中某条动画曲线的时间范围小于整个动作的时间，将维持该动画曲线的终值到动作结束。

可视组件在被不同类型可视组件替换时极小概率出现的问题已针对性防护。上述问题应该只出现在游戏更新后不同版本存档间。

模态(modal)可视组件不再阻止暂停。

某些情况(比如可视组件不可见状态)图像无法正常显示的问题已修复。

播放影片不再会导致暂停的音响恢复播放。

AudioData对象不再存储在持久化数据中。加载持久化数据后，类似对象将会删除。

平台标识，例如renpy.android和renpy.ios，将会与运行的模拟平台保持一致。

在iOS和安卓模拟器中，移动端回滚侧栏将被启用。

Ren'Py对保持显示的可视组件(或替代组件)将使用运行其 `unhovered` 行为，即使焦点发生变更。
在之前的版本中，组件失去焦点并显示另一个界面时，会不再运行unhovered行为。

若 :var:`config.log` 设置为True，选择的选项将会被记录在日志中。

新增的 :func:`gui.variant` 函数可以用来处理标准gui调用 :func:`gui.rebuild` 时可能导致的各种gui变量重置导致的问题。

Web浏览器端将每帧检查图片下载进度，允许在动画中加载图片。

Live2D现在使用饱和算法实现连接动作间的淡入淡出。例如，淡入动作贡献80&的参数值，淡出动作贡献20%，所有数值都源自这两个动作。
(之前的版本中，淡入和淡出动作独立启动。例如可能会导致淡入和淡出动作都贡献了数值的84%，其余的16%由默认动作贡献。)

从某个Live2D动作序列淡入到另一个序列时，前一个动作序列将在淡出后结束。

从某个专场恢复旧状态的界面时，later_at_list和camera列表会从旧状态获取值，防止意外。

`gl_depth` 特性可以让Ren'Py使用GL_LEQUALS。这个设置更适配Renpy语法。

矩阵的4元构造器已修复。

Ren'Py在构建安卓App Bundle(AAB)文件时，将清理构建目录，防止打包多个游戏时互相影响。

Live2D中重复多个同名动画可以无缝衔接。
(例如，``show eileen m1 m1 m2`` 中，两个 ``m1`` 都是无缝衔接的。)

ChromeOS设备上的鼠标动作可以追踪了。该功能可以防止鼠标光标在点击后隐藏的情况。

ChromeOS上窗口部分渲染渲染的问题已解决。

界面中transcludes相关的问题已修复。

在变换中将 :tpref:`perspective` 和 :tpref:`mesh` 设置为True可能会导致的问题都已修复。

按钮将只会向直接子组件广播变换状态，而不再对图片引用类型子组件生效。

``repeat_`` 修饰符可以用于游戏控制器事件。

从 :var:`config.debug_image_cache` 分离出 :var:`config.debug_prediction` 配置项。
该项控制预加载错误日志记录到log.txt，将后续的变量记录到日志中。

.. _7.4.11-translations:

多语言支持
------------

德语、印度尼西亚语、波兰语和俄语版本更新。


.. _renpy-7.4.10:

7.4.10
======

.. _7-4-10-fixes:

修复项
-------

该版本修复了使用gl2渲染器时，超大尺寸图片(超过大多数平台上的最大纹理尺寸4096×4096)无法正常显示的问题。

对话内容行尾使用 {nw} 标签(tag)时，将不会等待语音结束。

包含 {fast} (包括使用 ``extend`` 的角色)的对话行将从前一个语句起保持语音播放。

7.4.9版本变化的补充(变更日志中忘记写了)：{w}和{p}文本标签将不在等待语音播放完成后再前进。

:propref:`focus_mask` 特性可能会比较慢，但一些更改尝试并没有使其变快。
所以最好暂时避免使用该特性(拖放组件的该特性默认值是True，后续的7.5版本将改为None)，可以提升一些运行速度。

Live2D的相关日志不再强制写入log.text，可以通过 :var:`config.log_live2d_loading` 配置。

自动判断安卓应用商店的问题已修复。


Translations
------------

The Indonesian and Polish translations were updated.

.. _renpy-7.4.9:

7.4.9
=====

.. _7-4-9-android:

安卓
-------

这个版本特性最主要的变更在于对Ren'Py安卓版，开始支持安卓App的Bundle格式，要求将开发的游戏上传到Google Play上。

用于Bundle格式与APK格式使用不同的签名密钥，所以在切换格式时，最好卸载和重新游戏并进行测试。

运行Google Play时，Ren'Py会使用 Play Asset Delivery 将游戏安装到用户设备上。
与之前版本的Ren'Py相同，游戏依然有2GB的大小限制，以及最多分成4个500MB大小的资源包。
如果游戏在所有资源都正确安装完之前运行，Ren'Py会等待资源安装完成。

当Play Asset Delivery在下载游戏资源时，新的 android-downloading.jpg 替换了原来的 android-presplash.jpg 图片。
下载界面还有显示一个进度条。

Ren'Py依然只支持生成最大2GB的APK安装包，不过在设备上实际占用的空间可以超过2GB。
Ren'Py已逐步支持其他app商店。

当前版本Ren'Py使用安卓SDK v30生成安装包。

Ren'Py支持在安卓11版本设备上无线debug.

移除了安卓配置过程中的一系列问题，简化了流程。
最值得注意的是，现在Ren'Py将自动管理安卓中各个包(package)的版本号，因此不再需要每次生成安装包时都进行手工调整。

当前版本Ren'Py会搜索external文件目录，并自动寻找匹配的归档。
这样用户就可以构建补丁、更新和追加额外资源。

文档中新增 :ref:`Pyjnius <pyjnius>` ，这是一个安卓API的调用库。

新增变量 :var:`build.android_permissions`，函数 :func:`renpy.check_permission` 和 :func:`renpy.request_permission`，
可以向安卓系统申请权限许可。Ren'Py自身不需要那些权限。

创建安卓密钥时，Ren'Py会将密钥备份到脚本备份目录。创作者也可以自己主动备份。

安卓平台等平台截屏出现黑色图片的问题(希望)已修复。

安卓平台对存档和log.txt文件的权限将由安卓系统管理，即默认为同用户组可读。请确保用户有权限正确读写文件和日志。

.. _7-4-9-ios:

iOS
---

iOS版本生成应用程序的流程已更新。在启动器界面进行一些设置后即可使用，不再需要某些未使用的schemas对象。

如之前一样，Ren'Py更新之后每次需要重新创建iOS项目。

文档中添加 :ref:`Pyobjus <pyobjus>` 。Pyobjus库允许游戏在iOS和macOS平台调用系统API。

.. _7-4-9-updater:

更新器
-------

Ren'Py更新器性能提升。现在可以通过https连接更新，虽然这样做效率比较低。
因为使用https连接更新需要下载所有文件，而不仅仅是发生变更的文件。

勾选后每次启动Ren'Py都会检查是否有更新，如有可用更新则会高亮显示更新按钮。

.. _7-4-9-camera-perspective-improvements:

相机/透视 效果提升
-------------------------------

在某些罕见的情况下使用 ``camera`` 语句实现透视效果时，某些转场特别是镜头平移转场可能会导致显示错误的问题。
该问题已修复，各种转场能正确显示。

某些使用两个表面纹理(例如slide和wipe类转场，或者使用视口)的情况，无法正确应用透视变化。
该问题已修复。但现在会要求指定实际渲染的纹理操作方式，由创作者决定实际画面是否满足自己需求。

.. _7-4-9-accessibility:

Accessibility
-------------

Shift+A快捷键可呼出Accessibility菜单。可启用高对比度文本，将所有文本都转为黑底白字模式。
该功能用于某些需要高对比度文本体验游戏的用户。

descriptive文本功能禁用时，descriptive文本( :var:`alt` 角色)不再出现对话窗口淡入的情况。

启动自动语音时，图层、界面和同一个图层的可视组件的阅读顺序发生变化。
界面和可视组件与绘制顺序相反，最后绘制的最先阅读。
在同一个界面或布局型可视组件内的一系列可视组件的阅读顺序依旧，按照脚本内定义的顺序从头到尾依次阅读。

模态界面内所有内容都阅读之后，自动语音将停止。

.. _7-4-9-transform-properties:

变化特性
--------------------

变换特性 :tpref:`xsize` 和 :tpref:`ysize` 的用法略有改变。
原本它们的值表示像素数，现在可以表示“position”值。
也就是说，现在除了 ``int`` 和 ``absolute`` ，也可以使用 ``float`` 赋值表示可用空间的某个比例值。
之前的特性 :tpref:`size` 不再推荐使用，请改为使用新的 :tpref:`xysize`。

.. _7-4-9-other:

其他
-----

当前版本界面语言中的 :ref:`bar <sl-bar>` 语句新增 `released` 特性。该特性可以在条(bar)被释放时执行指定的行为。

当前版本界面语言中的 :ref:`key <sl-key>` 语句可以直接使用按键列表进行定义。

在Linux系统上，当Ren'Py检测到“C”运行语言环境时，它会启用支持UTF-8编码的文件系统。
这用于提供Linux版Steam的更好适配性。

启动器添加波兰语版本。

音乐鉴赏房间添加了一个“TogglePause”按钮，可以暂停和恢复音乐播放。

添加 --safe-mode 运行标识，可以在安全模式下启动Ren'Py。

静音操作可以对影片生效。

分析文件无节制增长，导致Ren'Py启动变慢的问题已经修复。分析文件将在脚本重新编译后缩减。

条(bar)新增 :propref:`hover_sound` 和 :propref:`activate_sound` 两个特性。

在ATL内部匹配事件时，如果前缀是 ``selected_`` 事件没有处理，前缀将去掉并再次匹配。
这意味着，如果 ``selected_hover`` 处理器不存在时， ``hover`` 处理器将处理 ``selected_hover`` 事件。类似的情况还有 ``selected_idle`` 。

Ren'Py版本号可以在结尾包含一个可选的字母。后缀 ``n`` 表示每夜版，后缀 ``u`` 用于非官方版。

每次回滚都将运行所有 ``default`` 语句。

按钮组件中阻止文本修改的某个回退已修复。

.. _renpy-7.4.8:

7.4.8
=====

.. _7-4-8-fixes:

修复项
-------

修复了一个重大问题。该问题是，在滚回后可能会导致列表、字典、集合和对象的数据错误。
使用7.4.7版本的用户推荐都升级到7.4.8以规避该问题。

已修复非整数值的轮廓线导致程序卡死问题已修复。

视口(viewport)边缘和鼠标滚轮的尺寸进行了修正。

游戏控制器检测的问题进行了修复。

.. _7-4-8-features:

特性
--------

播放视频时，可使用 :func:`PauseAudio` 或 :func:`renpy.music.set_pause` 函数暂停某个音频通道。

默认的影片播放通道可以通过配置项  :var:`config.single_movie_channel` 设置。

.. _7-4-8-changes:

变更
-------

在开发者模式下，无法正确显示图像时将向开发者报错，而不再显示占位符(灰色幽灵女孩)。

``centered`` 和 ``vcentered`` 角色的对话文本窗口将隐藏。

使用Shift+O打开控制台并作出的更改并应用后，回滚一步不会影响刚才的修改。
再多回滚一步才行。

.. _renpy-7.4.7:

7.4.7
=====

.. _7-4-7-web-and-web-audio:

Web版本与Web版音频
-------------------

在Web平台播放音频的方式已重写。不同于其他平台使用的ffmpeg，Ren'Py的Web版本将使用用户浏览器内置的音频播放器。
浏览器内置的音频播放器往往使用多线程技术，可以防止web平台上出现音频卡顿和爆音的问题。

Web平台上支持的音频格式也取决于浏览器。在目前常见的Web浏览器上可以支持Opus、Ogg和MP3格式，而Safari浏览器只支持MP3(详见后面Safari中某个issue的说明)。

新增配置项 :var:`config.audio_filename_callback` ，可以根据运行平台Web还是其他平台，调整实际播放的音频文件。

如果浏览器支持自动语音，在Web平台上可以使用键盘的“V”键开启自动语音。

只有基于webkit的浏览器才支持Ren'Py，原因详见 https://bugs.webkit.org/show_bug.cgi?id=227421 。
该bug对macOS的Safari浏览器，以及所有iOS系统的Web浏览器都有影响。
目前没有办法在Ren'Py层面修复这个问题，web的shell层做了修改以上报该isuue.

.. _7-4-7-ios:

iOS
---

生成(build)iOS版本时已使用更新版本的Clang，可以在iPhone12和iPhone SE2上运行，并且不会有左右两侧黑边(某些情况下则是四周都有黑边)。

Ren'Py可以编译专门Ml Mac版本iOS模拟器的版本，不过模拟器本身的运行时(runtime)会触发各种问题。

.. _7-4-7-input:

输入
-----

输入(input)可是组件新增了一些特性。主要是以下新特性：

* 光标移动到单词左端。(Windows快捷键Ctrl+左箭头，Mac电脑快捷键Alt+左箭头)
* 光标移动到单词右端。(Windows快捷键Ctrl+右箭头，Mac电脑快捷键Alt+右箭头)
* 删除一个单词。(Windows快捷键Ctrl+退格键，Mac电脑快捷键Alt+退格键)
* 删除一行。(Windows退格键，Mac电脑快捷键Command+退格键)

此外，Mac电脑有两个快捷键Command+左箭头、Command+右箭头，分别可以跳转到某一行的开头和结尾，分别对应其他平台的Home和End键。

输入光标将闪烁以提示输入。闪烁频率由配置项 :var:`config.input_caret_blink` 决定。

Other
-----

:func:`Preference` 函数现在会返回行为函数(action)，可以接入渲染和可读写菜单项。

新增 :func:`renpy.set_focus` 函数，可直接设置获取焦点的可视组件，尽管鼠标运动可能会立刻改变实际焦点。

使用变换(transform)修改层叠式图像特性(property)时，将按分组(group)生效。
之前的生效方式在某些情况下会造成矛盾，例如整个组设置了 :tpref:`align` ，而transform传入了 :tpref:`xalign` 作为图像属性(attribute).

通过控制台设置的变量也可以回滚了。

新增 :func:`renpy.mark_label_seen` 和 :func:`renpy.mark_label_unseen` 函数，可以直接控制脚本标签(label)是否已被阅读。

新增 :func:`renpy.mark_audio_seen` 和 :func:`renpy.mark_audio_unseen` 函数，可以直接控制某个音频文件是否已出现过。

新增 :func:`renpy.mark_image_seen` 和 :func:`renpy.mark_image_unseen` 函数，可以直接控制某个图像是否已查看过。

界面内的ATL变换将在界面第一次显示时就开始运行，而不再是包含那个变换的某一部分界面第一次显示时才运行。

新增 :var:`config.autosave_on_input` 配置项，根据输入设置自动存档。

固定位置参数后面跟关键字参数时，Ren'Py将报一个特定错误。

:propref:`xsize` 和 :propref:`ysize` 可以使用浮点数，并获得正确结果。
之前传入浮点数将会被乘以两次，并导致错误结果。
例如 :func:`xsize` 设置为0.5会将宽度设置为原来的1/4，正确的应该是1/2.

:func:`persistent._clear` 方法列入文档，作用是清除持久化数据。

西班牙语版本更新。

Atom更新。

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

其他修复项
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

其他修复项
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

修复项
-------

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

