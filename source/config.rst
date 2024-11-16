.. _configuration-variables:

=======================
配置项变量
=======================

配置项变量控制Ren'Py的执行器行为，允许Ren'Py自身使用多种方式的定制化。配置项囊括了常见变量(比如改变界面尺寸)到罕见变量(添加新类型的归档文件)。

Ren'Py执行器会假设，GUI系统已完成初始化，配置项变量不会发生改变。在 ``init`` 语句块(block)之外修改配置项变量会导致未定义的行为。配置项变量不是存档文件的一部分。

大多数配置项变量可以使用 ``define`` 语句设置：

::

    define config.rollback_enabled = False

字典和列表变量可以使用 ``define`` 语句或在 ``init python`` 语句块(block)中定义：

::

    define config.preload_fonts += ["OrthodoxHerbertarian.ttf"]
    define config.adjust_attributes["eileen"] = eileen_adjust_function

    init python hide:
        def inter_cbk():
            # 这是一个糟糕的回调
            renpy.notify("Interacting !")

        config.interact_callbacks.append(inter_cbk)

.. project-info:

项目信息
-------------

.. var:: config.name = ""

    一个字符串给定了游戏名。这个配置项还会用作回溯等日志文件名的一部分，与版本号一起使用。

.. var:: config.version = ""

    一个字符串，指定游戏版本号。这个配置项还会用作回溯等日志文件名的一部分。

.. var:: config.window_icon = None

    若非None，该项应该是一个图片的文件名。这个图片用作主窗口的图标。该项不会用作windows平台的执行程序和mac电脑的app缩略图，那些使用 :ref:`特殊文件 <special-files>`。

.. var:: config.window_title = None

    包含Ren'Py游戏的窗口标题的静态部分。后面加上 :var:`_window_subtitle` 就是窗口的完整标题名。

    若为None，也就是默认情况，默认值取 :var:`config.name`。

.. _auto-forward-mode:

自动前进模式
-------------

.. var:: config.afm_bonus = 25

    自动前进模式生效的情况下，计算对话字符串长度时，额外添加的字符数量。

.. var:: config.afm_callback = None

    若非None，这是一个Python函数，用于判断启用自动前进是否安全。该项的意义在于，语音系统中播放某个语音途中禁用自动前进功能。

.. var:: config.afm_characters = 250

    自动前进模式下，播放各段对话间存在一个间隔时间。该配置项设置的值表示该长度的字符串与这个间隔时间等效。

.. var:: config.afm_voice_delay = .5

    语音文件播放完成后，在AFM能进入下一段文本之前，等待的时间值，单位为秒。

.. _config-callbacks:

回调函数
-----------

.. var:: config.after_default_callbacks = [ ... ]

    一个函数列表。当 dafault 语句执行时会无参调用列表中的函数。
    default语句除了初始化阶段执行之外，还会在游戏启动之前、加载存档时、回滚之后、lint检查前和少数其他时机。

    与default语句类似，这些回调函数也是一个添加游戏必要数据的好地方。

.. var:: config.context_callback = None

    当Ren'Py进入一个新上下文(context)时(比如某个菜单上下文)，调用的回调函数。

.. var:: config.interact_callbacks = [ ... ]

    一个(不带入参的)回调函数列表，当互动行为开始或重新开始时调用列表中的函数。

.. var:: config.label_callbacks = []

    这是到达某个脚本标签(label)后会调用的函数列表。调用时使用两个参数。第一个参数是脚本标签(label)名。第二个参数在通过jump、call或创建新上下文(context)的情况下为True，其他情况下为False。

.. var:: config.periodic_callbacks = [ ... ]

    若非None，该项应该是一个函数列表。列表中的函数会以大约20Hz的频率被不断调用，不带任何入参。

.. var:: config.python_callbacks = [ ]

    一个函数列表。列表中的函数会在初始化阶段之外的任何时候被调用，不使用任何入参。

    这种函数的可能用途之一，是某个变量每次调整后，都需要使用一个函数将其值限制在某个范围内的情况。

    当Ren'Py启动时游戏未启动前，这些函数就可以被调用，而且可能这些函数相关的变量还未进行初始化。这些函数被要求处理这种情况，通过使用 ``hasattr(store, 'varname')`` 检查某个变量是否定义过。

.. var:: config.python_exit_callbacks = [ ]

    一个函数列表。当Ren'Py退出应用程序时会调用该列表的函数。该项设计用于Python模块中对象析构和内存释放。

    由于很多Ren'Py自身的模块在调用这些函数前就已被释放，此时调用Ren'Py提供的函数就是不安全的。

.. var:: config.scene_callbacks = [ ]

    一个回调函数列表。当运行scene语句或调用 :func:`renpy.scene` 函数时，将调用该配置项的函数列表。
    调用时使用一个入参，即调用scene语句作用的图层名称。
    当对应图层清空后，在scene语句中指定的图像添加前，设置的函数列表将被调用。

    Ren'Py处于自身的原因可能也会调用 renpy.scene。所以建议在运行这些回调函数前检查图层名。

.. var:: config.start_interact_callbacks = ...

    一个函数列表，当某个互动行为开始后(不带入参)被调用。某个互动行为重新开始的情况下，这些回调函数不会被调用。

.. var:: config.statement_callbacks = [ ... ]

    一个函数列表，在某个语句执行后将调用该配置项的函数列表。
    调用时，会将语句的名字作为参数传给这些函数。下面是一些比较特殊的语句名。
    

    "say"
        普通say语句。

    "say-bubble"
        气泡模式的say语句。

    "say-nvl"
        NVL模式的say语句。

    "say-centered"
        被设置为 :var:`centered` 的角色使用say语句。

    "menu":
        普通menu语句。

    "menu-nvl"
        NVL模式的menu语句。

    "menu-with-caption"
        带一个标题的menu语句。

    "menu-nvl-with-caption"
        NVL模式下带一个标题的menu语句。

    默认的回调函数就是实现 ``window auto`` 效果的函数。

.. var:: config.with_callback = None

    若非None，该项应该是一个函数，会在使用 :ref:`with语句 <with-statement>` 时被调用。
    这个函数可以在转场(transition)过程中对添加在界面上的临时元素做出响应。
    转场(transition)过程中，调用该函数时使用两个入参：当前正使用的转场，以及后续要使用的转场。
    第二个入参通常为None，除了在with语句中显式声明。
    该函数会返回一个转场(transition)，可能就是作为入参的那个转场，也可能不是。

.. _characters-and-dialogue:

角色与对话
-----------

.. var:: config.all_character_callbacks = [ ]

    可以通过所有角色调用的回调函数列表。这个列表会前向添加到指定角色回调函数列表。
    Ren'Py会把自身用到的回调函数添加到该列表中。

.. var:: config.character_callback = None

    :class:`Character` 对象回调参数 `callback` 的默认值。

.. var:: config.character_id_prefixes = [ ... ]

    该项指定了一个可以用于 :func:`Character` 对象的样式特性(property)前缀列表。当某个样式前缀与列表中的前缀匹配，带有那个前缀的可视组件就会应用对应的样式。

    例如，给默认GUI添加“namebox”前缀。当某个角色给定了 `namebox_background` 特性时，它会将带有id “namebox”的可视组件设置为say界面的 :propref:`background`。

.. var:: config.say_allow_dismiss = None

    若非None，这应是一个函数。当用户尝试dismiss某个 :ref:`say 语句 <say-statement>` 时，该函数会被调用，不使用任何入参。如果该函数返回True就允许dismiss，否则就忽略。

.. var:: config.say_arguments_callback = None

    若非None，这个函数使用当前发言角色作为第一个参数，参数列表后面是其他固定位置参数和关键词参数。任何时候使用say语句都会调用该函数。调用时通常包含一个interact入参，还可以使用其他在say语句中提供的参数。

    该函数会返回一对结果，包含一个固定位置入参的元组(大多数情况下是空的)，以及一个关键词入参的字典(大多数情况只包含interact)。

    举例：

    ::

        def say_arguments_callback(who, interact=True, color="#fff"):
            return (), { "interact" : interact, "what_color" : color }

        config.say_arguments_callback = say_arguments_callback

.. var:: config.say_sustain_callbacks = [ ... ]

    不使用入参调用的函数列表，在某行带pause分句的对话中，第二次或之后其他互动行为时被调用。该函数用于在暂停状态保持语音播放。

.. _choice-menus:

选项菜单
---------

.. var:: config.auto_choice_delay = None

    若非None，这个变量给定了一个时间值(单位为秒)，这个时间值内Ren'Py会暂停，之后会在游戏内选项中随机选择一个。我们希望这个配置项在发布版本中始终设置为None，不过没有什么人工做互动的情况下可以用来自动演示。

.. var:: config.menu_arguments_callback = None

    若该项不是None，应是一个函数，可能有固定位置入参和关键词入参。当menu语句运行时，就调用该项配置的函数。入参就是menu语句。

    返回值有两个，一个是包含固定入参的元组(大多数情况下是空的)，以及关键词入参的字典型数据。

.. var:: config.menu_include_disabled = False

    设置了这个配置项后，可以使用if语句将某个分支选项(choice)禁用，效果类似禁用某个按钮(button)。

.. var:: config.menu_window_subtitle = ""

    进入主菜单或游戏菜单时，:var:`_window_subtitle` (窗口标题)变量设置为该项的值。

.. var:: config.narrator_menu = True

    若为True，菜单内的叙述会使用旁白(narrator)角色。否则，叙述会显示为菜单标题。

.. _config-display:

显示
-------

.. var:: config.adjust_view_size = None

    若非None，该项应该是一个函数，使用两个入参：物理窗口的宽度和高度。它会返回一个元组，给出OpenGL视点(viewport)的宽度和高度，也就是Ren'Py会绘制图片的一块屏幕区域。

    该项配置用于配置Ren'Py只允许使用某些尺寸的屏幕。例如，下列配置值允许使用原始屏幕的整数倍大小(保持宽高比)：

    ::

        init python:

            def force_integer_multiplier(width, height):
                multiplier = min(width / config.screen_width, height / config.screen_height)
                multiplier = max(int(multiplier), 1)
                return (multiplier * config.screen_width, multiplier * config.screen_height)

            config.adjust_view_size = force_integer_multiplier

.. var:: config.display_start_callbacks = [ ]

    该项包含一个函数列表，在Ren'Py显示某个窗口后渲染窗口第一帧之前调用。
    该项的主要用途是，允许某些需要初始化GUI的库，比如OpenGL函数，读取资源文件。

.. var:: config.gl_clear_color = "#000"

    在有意义的图像绘制前，用于清理窗口使用的颜色。当游戏在窗口或显示器全屏模式下的显示器高宽比与游戏定义的高宽比不匹配时，letterbox或pillarbox的边框就是用的这种颜色。

.. var:: config.gl_lod_bias = -0.5

    uniform变量 :ref:`u_lod_bias <u-lod-bias>` 的默认值，控制Ren'Py使用的mipmap。

.. var:: config.gl_resize = True

    决定是否允许用户调整OpenGL绘制窗口的大小。

.. var:: config.gl_test_image = "black"

    运行OpenGL性能测试时使用的图片名称。这个图片会在启动时显示5帧或者0.25秒，然后自动隐藏。

.. var:: config.minimum_presplash_time = 0.0

    设置了一个时间值，单位为秒。表示presplash、安卓presplash或iOS的启动画面最短显示的时间。如果Ren'Py在这段时间内完成初始化，它将会休眠，确保图像至少显示配置的时间。如果Ren'Py启动耗时较长，启动画面也可以显示更久。

.. var:: config.nearest_neighbor = False

    默认使用近邻过滤，支持像素化和柔化。

.. var:: config.physical_height = None

    若设置后，该项表示Ren'Py游戏窗口的默认高度，单位为像素。
    若没有设置，窗口的默认高度为 :var:`config.screen_height`。

.. var:: config.physical_width = None

    若设置后，该项表示Ren'Py游戏窗口的默认宽度，单位为像素。
    若没有设置，窗口的默认宽度为 :var:`config.screen_width`。

.. var:: config.screen_height = 600

    游戏窗口的虚拟高度，单位为像素。
    如果没有设置 :var:`config.physical_height` 的值，默认与游戏窗口尺寸相同。
    通常会该项设置为比 :func:`gui.init` 更大的数值。

.. var:: config.screen_width = 800

    游戏窗口的虚拟宽度，单位为像素。
    如果没有设置 :var:`config.physical_height` 的值，默认与游戏窗口尺寸相同。
    通常会该项设置为比 :func:`gui.init` 更大的数值。

.. var:: config.shader_part_filter = None

    若不是None，该项是一个函数，调用时使用一个shader组成的元组作为入参。返回值是一个新的shader元组。

.. _file-i-o:

文件 I/O
---------

.. var:: config.file_open_callback = None

    若非None，该项是一个函数，当某个文件需要被打开是会调用该函数。函数会返回一个类似文件的对象，或者使用Ren'Py的文件加载机制时返回None。类似文件的对象必须能用使用read、seed、tell和close方法。

    对应的，还需要定义 :var:`config.loadable_callback` 。

.. var:: config.open_file_encoding = False

    若非False，:func:`renpy.open_file` 的 `encoding` 参数为None时，则使用该配置项。
    该配置项主要用于Python 2游戏使用Python 3的 :func:`renpy.file` 函数可以默认以文本模式打开文件。

    该配置项的默认值源自环境变量RENPY_OPEN_FILE_ENCODING。

.. _config-history:

对话历史
--------

.. var:: config.history_callbacks = [ ... ]

    该项包含一个回调(callback)函数列表，其中的回调函数会在Ren'Py在_history_list中添加新对象之前被调用。调用回调函数时，新增的HistoryEntry对象会作为第一个入参，还可以在那个对象中添加新的字段(field)。

    Ren'Py使用内置的历史回调函数，所以创作者应该将自己的回调函数添加到这个列表中，而不是替换整个列表。

.. var:: config.history_current_dialogue = True

    若为True，当前对话会加入并显示在history界面中。

.. var:: config.history_length = None

    Ren'Py保存的对话历史层的数量。该项被默认GUI设置为250。

.. _input-focus-and-events

输入、获取焦点和事件
---------------------

.. var:: config.allow_screensaver = True

    若为True，游戏运行时可以激活截屏工具。若为False，禁用截屏工具。

.. var:: config.controller_blocklist = [ ... ]

    一个字符串列表，每个字符串都会尝试匹配对应游戏控制器的GUID。
    当字符串匹配到控制器GUID(可以在 :file:`log.txt` 中看到对应日志)或其前缀，将在初始化阶段就禁用对应控制器。

.. var:: config.focus_crossrange_penalty = 1024

    当用键盘移动焦点时，这是应用于垂直于所选方向的宽容度，单位为像素。

.. var:: config.input_caret_blink = 1.0

    若非False，将设置默认光标的闪烁间隔时间，单位为秒。

.. var:: config.keymap = { ... }

    这个配置项是一个字典，包含了键盘按键和鼠标按键跟每个操作之间的映射关系。详见 :doc:`定制按键映射 <keymap>` 章节内容。

.. var:: config.longpress_duration = 0.5

    在触控设备上，用户需要按住屏幕多少时间才会被认为是一次长按操作。

.. var:: config.longpress_radius = 15

    在触控设备上，用户长按需要维持的最小像素数量。

.. var:: config.longpress_vibrate = .1

    在触控设备上，用户长按操作后的震动时长。

.. var:: config.pad_bindings = { ... }

    等效于游戏手柄的 :var:`config.keymap`。详见 :doc:`keymap` 章节。

.. var:: config.pass_controller_events = False

    若为True，类似pygame控制器的相关事件会发送到可视组件的事件处理器。反之，则由Ren'Py处理以上事件。

.. var:: config.pass_joystick_events = False

    若为True，类似pygame手柄的相关事件会发送到可视组件的事件处理器。反之，则由Ren'Py处理以上事件。

.. var:: config.web_input = True

    若为True，Web平台会使用浏览器的输入系统处理 :func:`renpy.input`。
    若为False，Ren'Py使用自己的输入系统。浏览器的输入系统支持更多语言类型、虚拟键盘等一些便利功能，但无法定制化。

    该项可以在初始化阶段修改，也可以在translate python语句块中修改。

    若要在触控设备上使用浏览器的输入系统，可以这样设置：

    ::

        define config.web_input = renpy.variant("touch")

.. _config-layered-images:

层叠式图像
-----------

.. var:: config.layeredimage_offer_screen = True

    该项设置层叠式图像 ``offer_screen`` 特性的默认值。详见 :ref:`相关章节 <layeredimage-statement>` 。

.. _config-layers:

图层
------

.. var:: config.bottom_layers = [ "bottom", ... ]

    一个图层(layer)名的列表，该列表中的图层会显示在其他所有图层下面，并且不接受应用于所有图层上的转场(transition)。
    如果某个图层在该列表中，它就不能再存在于列表 :var:`config.layers`` 和 :var:`config.top_layers` 中。

.. var:: config.choice_layer = "screens"

    选择界面(使用menu语句)显示的图层(layer)名。

.. var:: config.clear_layers = [ ... ]

    一个图层(layer)名的列表，当进入主菜单和游戏菜单时，就会清除列表上所有图层的图像。

.. var:: config.context_clear_layers = [ 'screens', 'top', 'bottom', ... ]

    一个图层(layer)名的列表，当进入一个新的上下文(context)时，会清除列表上所有图层的图像。

.. var:: config.default_tag_layer = "master"

    图像显示的默认图层(layer)，前提是图像标签(tag)在 :var:`config.tag_layer` 不存在。

.. var:: config.detached_layers = [ ]

    该项设置的图层不会自动添加到场景中。
    它们总是被当作 :var:`粘滞图层 <config.sticky_layers>` ，并且用作嵌在 :class:`Layer` 可视组件中。

.. var:: config.interface_layer = "screens"

    内建界面显示时使用的图层。

.. var:: config.layer_clipping = { ... }

    控制图层(layer)剪裁。这是一个从图层名称到(x, y, height, width)元组的映射关系，其中x和y的值是从图层左上角开始计算的坐标值，height和width是图层的高和宽。

    如果某个图层没有在config.layer_clipping中提及，则该图层会使用其容器的完整尺寸，通常也就是整个界面。
    少数情况下其显示在一个可视组件 :class:`Layer` 内。

.. var:: config.layer_transforms = { }

    一个字典，用于表示图层名称与对应的变换列表。
    所有变换会在最后应用于图层，生效时间在 ``show layer`` 和 ``camera`` 变化之后。

    若图层名为None，变换会应用于所在定义在 :var:`config.layers` 中的图层，生效时间晚于各种转场(transition)。

.. var:: config.layers = [ 'master', 'transient', 'screens', 'overlay', ... ]

    该配置项是一个所有Ren'Py已知图层(layer)的列表，按这些图层在界面的显示顺序排列。(列表中第一个元素就是最底部的图层。)Ren'Py内部会使用“master”、“transient”、“screens”和“overlay”图层(未来可能还有其他图层)，所以这些图层应该总是保存在这个列表中。

    :func:`renpy.add_layer` 函数可以在不需要知道该配置项原始内容的情况下，新增图层到该列表。

.. var:: config.overlay_layers = [ 'overlay', ... ]

    该项是一个所有可覆盖图层(layer)的列表。可覆盖图层在overlay函数调用前会被清空。“overlay”图层应该总是放在这个列表中。

.. var:: config.say_layer = "screens"

    显示say界面的图层(layer)。指定的图层名必须配置在 :var:`config.context_clear_layers` 中。

.. var:: config.sticky_layers = [ "master", ... ]

    该项是一个图层名称的列表。当指定标签的图像显示在这些图层上时，可以暂时顶替 :var:`config.tag_layer` 项，作为图像标签的显示入口。

.. var:: config.tag_layer = { }

    一个字典，将图像标签(tag)字符串映射为图层(layer)名称字符串。当某个图像显示时没有指定图层，就可以根据图像标签在这个字典中找对应的图层。如果图像标签没有在字典中找到，就使用 :var:`config.default_tag_name` 配置的值。

.. var:: config.top_layers = [ "top", ... ]

    一个图层(layer)名的列表，该列表中的图层会显示在其他所有图层上面，并且不接受应用于所有图层上的转场(transition)。
    如果某个图层在该列表中，它就不能再存在于列表 :var:`config.layers`` 和 :var:`config.bottom_layers` 中。

.. var:: config.transient_layers = [ 'transient', ... ]

    该项变量是一个所有临时(transient)图层的列表。临时图层会在每次互动行为后被清空。“transient”应该总是保留在这个列表中。

.. _media-music-sound-and-video:

多媒体(音乐、音效和视频)
-------------------------

.. var:: define config.audio_filename_callback = None

    若非None，该函数调用时需要传入一个音频文件名，并返回另一个音频文件名，并实际播放后者。

    在音频文件格式需要改变，但又不想改游戏脚本时，可以使用该配置项。

.. var:: config.auto_channels = { "audio" : ( "sfx", "", ""  ), ... }

    该项用于定义自动音频通道。它将通道名映射为一个3元的元组：

    * 混合器使用的通道名。
    * 通道上播放文件的前缀。
    * 通道上播放文件的后缀。

.. var:: config.auto_movie_channel = True

    若为True，`play` 入参传入 :func:`Movie`。每个影片都会自动生成对应的音频通道名。

    :var:`config.single_movie_channel` 的优先级高于该配置项。

.. var:: config.context_fadein_music = 0

    上下文(context)发生变化时，Ren'Py播放音乐淡入的时间值，单位为秒。(通常是指游戏加载的情况)

.. var:: config.context_fadeout_music = 0

    上下文(context)发生变化时，Ren'Py播放音乐淡出的时间值，单位为秒。(通常是指游戏加载的情况)

.. var:: config.enter_sound = None

    若非None，这是进入游戏菜单播放的音效文件。

.. var:: config.exit_sound = None

    若非None，这是离开游戏菜单播放的音效文件。

.. var:: config.fadeout_audio = 0.016

    默认的音频淡出时间。
    使用 ``stop`` 语句和 :func:`renpy.music.stop` 函数停止某个音频，
    或者使用 ``play`` 语句和 :func:`renpy.music.play` 函数开始一段新的音轨都会用到淡出效果。
    不过音频队列不会使用淡出效果来衔接。

    这个暂短的淡出可以用来掩盖音频停止和切换时的点击声和爆音。

.. var:: config.game_menu_music = None

    若非None，该项是在游戏菜单时播放的音乐文件。

.. var:: config.main_menu_music = None

    若非None，就是一个在主菜单播放的音乐文件。

.. var:: config.main_menu_music_fadein = 0.0

    :var:`config.main_menu_music` 中用于淡入的时间，单位为秒。

.. var:: config.main_menu_stop_channels = [ "movie", "sound", "voice", ... ]

    一个音频通道列表名，当进入或返回主菜单时将停止对应音频通道的声音。

.. var:: config.mipmap_movies = False

    :func:`Movie` 的mipmap入参默认值。

.. var:: config.movie_mixer = "music"

    当某个 :func:`Movie` 对象自动定义的视频播放通道所使用的混合器(mixer)。

.. var:: config.play_channel = "audio"

    被 :func:`renpy.play` 、 :propref:`hover_sound` 和 :propref:`activate_sound` 使用的音频通道名称。

.. var::  config.preserve_volume_when_muted = False

    若为False，即默认值，当音频通道处于静音状态时，对应通道的音量值为0，并不能改变。
    否则，音频通道在静音状态下可以调整音量值。

.. var:: config.single_movie_channel = None

    若非None，当 `play` 参数传入 :func:`Movie` 时，该配置项决定了影片播放使用的通道。
    该项不能设置为“movie”，因为“movie”是Ren'Py预留的关键字。

.. var:: config.skip_sounds = False

    若为True，Ren'Py处于跳过(skipping)状态时将不会播放非循环播放的音频。

.. var:: config.sound = True

    若为True，使用声音。若为False，声音/混合器子系统完全禁用。

.. var:: config.sound_sample_rate = 48000

    声卡运行的采样率。如果你的所有wav文件都使用更低的采样率，修改该项配置可能会改善播放效果。

.. var:: config.web_video_base = "./game"

    在Web浏览器中播放影片时，该项是一个URL链接，与影片文件名相连后得到完整的视频播放链接地址。
    可以包括子目录，比如 “https://share.renpy.org/movies-for-mygame/” 。

    这样做可以让文件比较大的视频文件与游戏其他内容放在不同的服务器上。

.. var:: config.web_video_prompt = _("Touch to play the video.")

    iOS系统手机版Safari上运行时，用户需要点击后才能播放带音频的影片。
    该配置项是提示用户点击的消息。

.. var:: config.webaudio_required_types = [ "audio/ogg", "audio/mp3" ]

    运行在Web平台时，Ren'Py将会检查浏览器是否支持播放音频文件的媒体类型。如果支持则直接播放音频文件，如果不支持则使用可能会有声音跳跃问题的asm解码器。

    默认情况下，Chrome和火狐浏览器使用通用Web音频系统，而Safari使用wasm。
    如果游戏中只使用mp3音频文件，可以这样设置：

    ::

        define config.webaudio_required_types = [ "audio/mp3" ]

    在Safari上使用更快的Web音频系统也类似。

.. _config-mouse:


鼠标
-------

.. var:: config.mouse = None

    这个配置项控制用于定义的鼠标指针。若为空，使用系统鼠标，也就是一个黑白色的光标指针。

    否则，该项应该是一个给定多种鼠标类型动画的字典。默认库中使用的键(key)包括“default”、“say”、“with”、“menu”、“prompt”、“imagemap”、“pause”、“mainmenu”和“gamemenu”。键“default”必须存在，它会在其他特定键不存在的情况下使用。
    键可以带有一个 ``pressed_`` 前缀，表示鼠标按下时光标使用的图像。

    字典中的每个键对应的值都是一个(`image`, `xoffset`, `yoffset`)形式元组的列表，按帧排序。

    `image`
        鼠标指针图像。图像的最大尺寸取决于用户的硬件配置。32×32的图像可以用在任何地方，64×64在大多数硬件上可以运行。更大的图像可能就无法工作了。

    `xoffset`
        从指针左端开始算的热点(hotspot)偏移量，单位是像素。

    `yoffset`
        从指针顶端开始算的热点(hotspot)偏移量，单位是像素。

    序列帧以20Hz的频率播放，并在达到最后一帧时从头开始循环。

    :doc:`mouse` 有更多信息和样例。

.. var:: config.mouse_displayable = None

    若非None，该项可以是一个可视组件或者可以返回一个可视组件的可调用对象。
    如果可调用对象可以返回None，Ren'Py会预处理这种情况。

    如果该项的值指定为可视组件，鼠标光标将被隐藏，指定的可视组件会显示在其他所有画面元素之上。
    指定的可视组件可以相应所以鼠标光标位置和绘制的事件消息，与 :func:`MouseDisplayable` 等组件类似。

    :doc:`mouse` 有更多信息。

.. var:: config.mouse_focus_clickthrough = False

    若为True，鼠标点击使游戏窗口获取焦点，并正常处理点击事件。若为False，则鼠标点击事件将忽略。

.. var:: config.mouse_hide_time = 30

    在配置的时间值内没有鼠标操作就隐藏鼠标指针，单位为秒。该项应该配置成比读取一个界面的期望时间长，这样鼠标用户就不会遇到鼠标消失的时间比鼠标显示时间更长的情况。

    若为None，鼠标指针永远不会隐藏。

.. _config-paths:

文件路径
---------

.. var:: config.archives = [ ]

    用于搜索图片和其他数据的归档文件列表。所有归档文件的入口应该是包含归档文件基本名的字符串，不包含.rpa扩展名。

    归档文件的搜索按照列表中的顺序进行。第一个搜索到的归档文件会被使用。

    在启动阶段，Ren'Py会检索game目录内的所有归档文件，按照ascii码排序，自动插入到这个列表中。例如，如果Ren'Py找到了文件 :file:`data.rpa`、:file:`patch01.rpa` 和 :file:`patch02.rpa`，最终生成的列表为 ``['patch02', 'patch01', 'data']`` 。

.. var:: config.gamedir = ...

    游戏中 :file:`game/` 目录的完整路径。该项是一个只读变量。
    但不能保证所有文件都保存在该卢姆，尤其是在安卓之类的平台上。

.. var:: config.savedir = ...

    存档目录的完整路径。这只应该在 ``python early`` 语句块中配置。
    如果不在 ``python early`` 语句块中设置，则可以通过配置项 :var:`config.save_directory` 生成初始值。

.. var:: config.search_prefixes = [ "", "images/", ... ]

    搜索的文件名前添加的前缀列表。

.. var:: config.searchpath = [ 'common', 'game', ... ]

    一个目录列表，用于在这些目录下搜索图片、音乐、归档及其他媒体文件，但不包括脚本文件。该项会初始化为包含“common”和游戏目录的一个列表。

.. _config-quit:

退出
----

.. var:: config.quit_action : Action

    当用户点击程序窗口的退出按钮时调用的行为。默认的行为会提示用户确认是否真的想要退出。

.. var:: config.quit_callbacks = [ ... ]

    一个函数列表，在Ren'Py进程终止时将(无参)调用。用于释放资源，例如打开的文件或启动的线程。

.. var:: config.quit_on_mobile_background = False

    若为True，当移动app失去焦点时就会退出，而不是在后台保存自身状态。
    (参考配置项 :var:`config.save_on_mobile_background`，其控制具体表现。)

.. _config-replay:

回放
-----

.. var:: config.after_replay_callback = None

    若非None，该项是回放(replay)结束后，不使用入参那调用的函数。

.. var:: config.replay_scope = { "_game_menu_screen" : "preferences" }

    一个字典，在回放时将默认存储区的变量映射到指定的变量。

.. _config-rollback:

回滚
-----

.. var:: config.call_screen_roll_forward = False

    当界面的 `roll_forward` 特性值为None时，则使用该配置项的值。

.. var:: config.ex_rollback_classes = [ ]

    该项为一个对象列表，可以使之前的版本中回滚会告警的类，不再产生告警信息。
    如果创作者不想要某个类对回滚操作的支持，就把类的对象放在该列表中。

    有时候，并不需要如实一一添加，而只要把自定义类的基类 ``object`` 添加到列表中。

.. var:: config.fix_rollback_without_choice = False

    该项决定了回退时，内建菜单和imagemap的构建方式。该项默认值是False，表示只有之前选择的菜单选项是可以点击的。
    若设置为真(False)，之前的选择会被标记，但所有选项都不是可点击的。用户可以使用点击在回退缓存中处理随意向前。

.. var:: config.hard_rollback_limit = 100

    Ren'Py允许用会回滚的最大步数。该项设置为0则完全不允许回滚。我们不推荐这样做，因为回滚是用户错误使用跳过功能后，回看之前文本的有效途径。

.. var:: config.pause_after_rollback = False

    若为False，即默认值，回滚将跳过所有暂停，只在某些对话和菜单选项才会停止。
    若为True，Ren'Py在回滚时，所有用户可能遇到的没有设置时间的暂停都会停止。

.. var:: config.rollback_enabled = True

    设置是否允许用户在游戏中回滚(rollback)。若设置为False，用户不能主动回滚。

.. var:: config.rollback_length = 128

    当回滚(rollback)日志中存在超过这个配置项数量的语句时，Ren'Py会修剪日志。这也包括脚本改变导致的读取存档时，Ren'Py会回滚的最大步数。

    将该项设置得比默认值更低可能会导致Ren'Py运行不稳定。

.. var:: config.rollback_side_size = .2

	如果侧回滚被启用，则侧回滚的屏幕部分被单击或触摸时会导致回滚。

.. _config-saving-and-loading:

存档与读档
----------

.. var:: config.after_load_callbacks = [ ... ]

    读档时，(无入参)调用的回调函数列表。

    若回调函数会修改数据(例如，从旧版迁移数据到新版)，应该调用 :func:`renpy.block_rollback` 函数，以防止用户回滚导致修改回退。

.. var:: config.auto_load = None

    若非None，该项表示Ren'Py启动时自动加载的一个存档文件名。该项是提供给针对开发者用户，而不是终端用户用的。将该项设置为1的话，就会自动读取槽位1的存档。

.. var:: config.autosave_callback = None

    后台自动存档时，将调用的回调函数或行为函数列表。尽管可以在列表中添加行为函数，但如果返回其他行为函数则不会执行。

    若非行为类回调函数会显示一个可视组件或界面，需要调用 :func:`renpy.restart_interaction`。

    ::
        define config.autosave_callback = Notify("Autosaved.")

.. var:: config.autosave_frequency = 200

    表示经过多少次互动行为后会发生自动存档。如果要禁用自动存档，将 :var:`config.has_autosave` 设置为False，不需要修改该项的值。

.. var:: config.autosave_on_choice = True

    若为True，Ren'Py会在每次游戏内选项后自动存档。(当 :func:`renpy.choice_for_skipping` 被调用时。)

.. var:: config.autosave_on_input = True

    若为True，Ren'Py在用户输入文本时自动保存(调用 :func:`renpy.input` 时)。

.. var:: config.autosave_on_quit = True

    若为True，Ren'Py会在用户做出以下操作时尝试自动存档：退出、返回主菜单、游戏中读取其他存档。(存档时，当用户被提示确认就会执行自动存档。)

.. var:: config.autosave_prefix_callback = None

    若不是None，该项是一个无参调用的函数，会返回自动存档文件名的前缀。
    默认前缀为“auto-”，对应的存档文件名分别为“auto-1”、“auto-2”等。

.. var:: config.autosave_slots = 10

    自动存档使用的槽位编号。

.. var:: config.file_slotname_callback = None

    若非None，该项是一个回调函数，会被 :ref:`文件行为函数 <file-actions>` 使用，将某个存档页和对应的名称转换为存档槽的名称，
    并传给 :ref:`存档函数 <save-functions>`。

    `page`
        该项是一个字符串，对应当前存档页的名称。该字符串通常包含一个数字，但也可能会包含特殊字符串比如“quick”或“auto”。

    `name`
        该项是一个字符串，包含当前存档页上某个存档槽的名称。
        该项也可以包含正则表达式(比如 r'\d+')，所有匹配正则表达式的结果都将包含在返回结果中。

    默认行为等效于：

    ::

        def file_slotname_callback(page, name):
            return page + "-" + name

        config.file_slotname_callback = file_slotname_callback

    该配置项的用途之一是，给存档文件名加前缀。

    相关信息查看 :var:`config.autosave_prefix_callback`。

.. var:: config.has_autosave = True

    若为True，游戏会启动自动保存。若为False，禁用自动保存。

.. var:: config.load_failed_label = None

    如果配置为一个字符串，表示一个脚本标签(label)。脚本修改过多导致Ren'Py无法恢复产生读档失败的情况下，将跳转到该脚本标签。
    在执行读档前，Ren'Py将主控流程切换为最后执行语句开头，并清空调用栈。

    也可以配置为一个函数。该函数没有入参，返回值需要是一个脚本标签(label)。

.. var:: config.loadable_callback = None

    若非None，该函数调用时带一个文件名。当文件可以加载时，函数返回True，否则返回False。这个函数可以跟
    :var:`config.file_open_callback` 或 :var:`config.missing_image_callback` 协同生效。

.. var:: config.quicksave_slots = 10

    快速存档使用的槽位编号。

.. var:: config.save = True

    若为True，Ren'Py才允许玩家存档。若为False，Ren'Py则不允许玩家存档，甚至不会显示任何存档。

.. var:: config.save_directory = "..."

    用于生成游戏和保存持久化信息使用的目录。具体的游戏目录取决于不同的平台：

    Windows
        %APPDATA%/RenPy/`save_directory`

    Mac OS X
        ~/Library/RenPy/`save_directory`

    Linux/Other
        ~/.renpy/`save_directory`

    该项设置为None的话，将在game目录下创建一个“saves”文件夹。不推荐这样做，因为这无法防止game目录被系统的多用户共享。当某个游戏以管理员身份安装，以普通用户运行时，这种配置也会导致运行问题。

    配置该项时，必须使用define语句或者Python语句块。无论使用哪种，配置项的语句都会在其他任何语句之前运行，所以其应该是一个字符串而不能是表达式。

    需要打开存档目录时，使用 :var:`config.savedir` 而不是config.save_directory。

.. var:: config.save_dump = False

   如果设置为True，存档时Ren'Py会创建文件save_dump.txt。生成的文件包含所有存档文件中的对象。每一行包含相关的占用空间估测，对象路径，某个对象是否别名的信息，以及对象的行为表现。

.. var:: config.save_json_callbacks = [ ]

    用于创建json对象的一个回调函数列表，创建的json对象可以通过 :func:`FileJson`
    和 :func:`renpy.slot_json` 接入并执行存储和标记操作。

    每个回调函数都是用某个保存过的Python字典调用。回调函数修改字典内容时，应使用适配json的Python数据类型，比如数值、字符串、列表和字典。在字典结尾的回调函数会作为存档槽位的一部分保存。

    字典中的键值可能开始是一个下划线符号(_)。这些键是Ren'Py使用的，并且不应该修改。

    例如：

    ::

        init python:
            def jsoncallback(d):
                d["playername"] = player_name

            config.save_json_callbacks.append(jsoncallback)

    ``FileJson(slot)`` 和 ``renpy.slot_json(slot)`` 会在游戏存档时，将 ``d`` 的状态覆盖。
    游戏存档时，变量 ``player_name`` 的值依然可以通过 ``FileJson(slot, "playername")`` 访问。

.. var:: config.save_on_mobile_background = True

    若为True，移动app会在失去焦点时保存自身状态。保存状态的方式需要在app重新启动后能自动读档(并回复进度)。

.. var:: config.save_persistent = True

    若为True，Ren'Py会保存持久化数据。若为False，持久化数据不会保存在存档中，游戏结束后持久化数据任何改变都将丢失。

.. var:: config.save_physical_size = True

    若为True，窗口的物理尺寸会保存在环境设定(preference)中，并在游戏挂起时保存。

.. var:: config.save_token_keys = [ ]

    一个由键(key)组成的列表，用于存放一些游戏加载存档时的可信信息。
    这样可以让游戏创作者自定义存档文件，且加载不会显示警告。

    若要在当前电脑上允许存储token，需要打开 :ref:`console <console>` 并运行：

    ::

        print(renpy.get_save_token_keys())

    该命令会将key输出在log.txt文件中。然后就可以把这些输出结果用在 config.save_token_keys 中。
    必须使用define语句或python early语句块中定义该项的值。

.. var:: config.thumbnail_height = 75

    游戏存档使用的缩略图高度。读档时，会显示这些缩略图。
    请注意，缩略图会按自身实际尺寸显示，而不是根据该项。

    默认GUI可以改变该项的值。

.. var:: config.thumbnail_width = 100

    游戏存档使用的缩略图宽度。读档时，会显示这些缩略图。
    请注意，缩略图会按自身实际尺寸显示，而不是根据该项。

    默认GUI可以改变该项的值。

.. _config-screen-language:

界面语言
---------

.. var:: config.always_shown_screens = [ ]

    Ren'Py中始终强制显示的界面列表。该列表中的界面在UI隐藏时或打开菜单时，依然会显示。
    列表中的某个界面就算尝试隐藏或不显示，依然会被强制显示。
    一般只被Ren'Py内部使用，也可以根据需求修改该列表。

    通常直接设置 :var:`config.overlay_screens` 更合适。

.. var:: config.context_copy_remove_screens = [ 'notify', ... ]

    该项是一个界面列表。当回滚或保存时导致上下文(context)复制时，将移除列表中的所有界面。

.. var:: config.help = None

    :func:`Help` 行为的默认值。

.. var:: config.help_screen = "help"

    帮助界面名称，可以通过调用 :func:`Help` 行为函数或按键盘F1键呼出。

.. var:: config.imagemap_auto_function : Callable

    一个函数，可以将界面语言中 :ref:`imagebutton <sl-imagebutton>` 或 :ref:`imagemap <sl-imagemap>`
    `auto` 特性(property)扩展为可视组件。这个函数使用auto特性(property)值和使用的图像，以及下列状态之一：“insensitive”、“idle”、“hover”、“selected_idle”、“selected_hover”、“ground”。函数返回一个可视组件对象或None。

    默认的使用方法是使用图像格式化 `auto` 特性，并检查得到的文件名是否存在。

.. var:: config.keep_side_render_order = True

    若为True，Side位置的子串顺序将决定子组件的渲染顺序。

.. var:: config.menu_clear_layers = [ ... ]

    图层名(以字符串形式)列表，列表中的图层在进入游戏菜单时会清空。

.. var:: config.notify : Callable

    :func:`renpy.notify` 和 :func:`Notify` 函数会调用该配置项，入参为 `message` ，效果为显示通知消息。
    默认配置为 :func:`renpy.display_notify` 。
    该配置还可以让创作者拦截通知。

.. var:: config.overlay_screens = [ ... ]

    当覆盖(overlay)启用时，显示的界面列表；当覆盖(overlay)被阻止时，隐藏界面列表。(界面在screen图层上显示，而不是overlay图层。)

.. var:: config.per_frame_screens = [ ... ]

    该项是一个界面名字符串的列表，列表内的界面会在每一帧都更新，而不是每次互动后更新。Ren'Py内部使用这个列表。所以创作者需要在这个列表中添加界面名，而不是整个替换原列表。

.. var:: config.transition_screens = True

    若为True，界面会接受转场(transition)效果，使用溶解(dissolve)从旧的界面状态转为新的界面状态。若为False，只有界面的最新状态会被显示。

.. var:: config.variants = [ ... ]

    一个变换界面列表，用于搜索并选取向用户显示的界面。列表最后的元素总是None，确保能选到默认界面。详见 :ref:`界面变种 <screen-variants>`。

.. _config-screenshots:

截屏
----

.. var:: config.pre_screenshot_actions = [ Hide("notify", immediately=True), ... ]

    一个行为列表，当截屏时调用该列表中的行为函数。该功能用于隐藏一些不想在截图中出现的临时画面元素。

.. var:: config.screenshot_callback : Callable

    发生截屏时调用的函数。调用该函数时带一个参数，即截屏保存的完整文件名。

.. var:: config.screenshot_crop = None

    若非None，该项应是一个(x, y, height, width)元组。截屏会在保存前剪裁为元组描述的矩形。

.. var:: config.screenshot_pattern = "screenshot%04d.png"

    用作创建截屏文件的正则表达式。这个(使用Python的格式规则)表达式应用自然数列生成一个文件名序列。生成的文件名是绝对路径，或与config.renpy_base关联。首个当前不存在的文件名会用作截屏的文件名。

    如果表达式中的目录不存在，则会自动创建目录。详见 :var:`_screenshot_pattern` 。

.. _config-self-voicing-text-to-speech:

自动语音/文本转语音
--------------------

.. var:: config.tts_substitutions = [ ]

    这是一个列表，由(pattern, replacement)组成，用于在文本发到给TTS引擎前进行一些文本和谐。

    pattern可以是字符串或正则表达式，replacement必须是字符串。

    如果pattern是字符串，则会进行转义，然后根据r'\\b'添加对应的前缀和后缀，然后编译为正则表达式。
    当pattern是字符串时，replacement也会进行转义。

    如果pattern是正则表达式，就会直接使用，并且replacement不会进行转义。

    所有的文本替换顺序与该配置项列表顺序相同。
    字符串匹配时会自动考察大小写等情况，并且同时匹配多个替换条件时，只替换第一个匹配的情况。

    例如：

    ::

        define config.tts_substitutions = [
            ("Ren'Py", "Ren Pie"),
        ]

    会将字符串“Ren'Py is pronounced ren'py.”的语音修正为“Ren Pie is pronounced ren pie.”

.. var:: config.tts_voice = None

    若非None，这是一个字符串，表示自动语音模式下播放tts语音时使用的非默认声音。可用的选项跟运行的平台有关联，并且需要设置成特定平台对应特定语音的形式。(在多语言支持的情况下最好也修改该项。)

.. _config-showing-images:

显示图像
---------

.. var:: config.adjust_attributes = { }

    若非None，该项是一个字典型数据。
    当某个包含图像属性(image attribute)的语句或函数执行或预加载时，会将图像标签(tag)作为键值在字典内搜索。
    如果没有搜索到，则使用键值None再次搜索。

    如果搜索到了字典内的值，该值需要是某个函数。
    此函数的入参是一个由图像名称、图像标签(tag)和属性(attribute)组成的元组。
    函数返回值是另一个元组，由一组新的图像属性组成的元组。

    该函数可能会在预加载阶段被调用，所以其不应该依赖于图片的状态。

.. var:: config.cache_surfaces = False

    若为True，图像的底层数据存储在RAM中，允许图像处理器(manipulator)使用时不需要从磁盘加载。若为False，数据会从缓存中删除，但会在显存中存为一份纹理(texture)，降低RAM使用。

.. var:: config.conditionswitch_predict_all = False

    针对 :func:`ConditionSwitch` 和 :func:`ShowingSwitch` 的predict_all入参默认值，决定是否所有可用的可视组件都显示。

.. var:: config.default_attribute_callbacks = { }

    当某个含有图像属性(attribute)的语句或函数执行、预加载时，如果发现该属性的图像当前并没有显示，则从该配置项字典寻找对应图像。如果没有找到，则使用None作为键再次搜索。

    如果还是没找到，则需要执行某个函数。此函数会指定一个图像名称，一个包含必要图像标签和属性的元组。
    次函数会返回一个可迭代数据，包含图像初次显示时应用的额外属性。

    函数的执行结果被认为是附加的，任何显式的冲突和反向的属性都会优先于函数执行结果。

    由于此函数可能在预加载时调用，所以函数必须能在任意状态都响应。

.. var:: config.default_transform = ...

    使用show或scene语句显示某个可视组件时，从此项配置的transform获取并初始化可视组件transform特性(property)的值。

    默认的default_transform是 :var:`center`，居中。

.. var:: config.displayable_prefix = { }

    请见 :ref:`可视组件前缀 <displayable-prefixes>`。

.. var:: config.hide = renpy.hide

    当 :ref:`hide语句 <hide-statement>`
    执行时调用的函数。该项使用与renpy.hide一样的入参。

.. var:: config.image_cache_size = None

    如果非None，该项用于设置 :ref:`图像缓存 <images>` 的大小，是界面尺寸的整倍数，单位为像素。

    如果设置过大，是浪费内存的行为。如果设置过小，图像从磁盘直接加载，会降低性能。

.. var:: config.image_cache_size_mb = 300

    该项用于设置 :ref:`图像缓存 <images>` 的大小，单位是MB。如果 :var:`config.cache_surfaces` 的值是False，每个图像的一个像素占用4 byte的存储空间；否则，每个图像的一个像素占用8 byte的存储空间.

    如果设置过大，是浪费内存的行为。如果设置过小，图像从磁盘直接加载，会降低性能。只要
    :var:`config.image_cache_size` 的配置不是空值(None)，就不使用config.image_cache_size_mb。

.. var:: config.keep_running_transform = True

    若为True，上一个图像使用的transform或ATL语句块(block)会沿用，前提是新图像使用相同的图像标签(tag)。若为False，transform会被停用。

.. var:: config.max_texture_size = (4096, 4096)

    Ren'Py能加载的最大单一纹理(texture)尺寸。该项仅用于3D模型。
    2D图片在有需要时会切分为多个纹理。

    Live2d会将该项调整为符合最大Live2d纹理的尺寸。

.. var:: config.optimize_texture_bounds = True

    当该项为True，Ren'Py会扫描图像并找到所有不透明像素的包围框(bounding box)，并加载这些像素转为一张纹理(texture)。

.. var:: config.predict_statements = 32

    这是一个语句的数量值，包括当前语句，会被检查是否执行图像预加载。从当前语句开始执行广度优先搜索，直到包含配置数量的语句。在这个范围内的语句引用的图像都会在后台预先加载。将该项设置为0会禁用图像预加载功能。

.. var:: config.scene = renpy.scene

    在 :ref:`scene 语句 <scene-statement>` 中用于代替 :func:`renpy.scene` 的函数。需要注意，这个函数用于清空界面，:var:`config.show` 用于显示某个新图像。这个函数具有与 :func:`renpy.scene` 相同的签名(signature)。

.. var:: config.show = renpy.show

    在 :ref:`show <show-statement>` 和 :ref:`scene <scene-statement>` 语句中中用于代替 :func:`renpy.show` 的函数。
    这个函数具有与 :func:`renpy.show` 相同的签名(signature)，并会将未知的关键字参数不做修改直接传入。

.. var:: config.speaking_attribute = None

    若非None，该项是一个字符串，给出了图像属性(attribute)名。图像属性(attribute)会在角色发言时添加到图像上，在角色停止发言时移除。

    This is applied to the image on the default layer for the tag,
    which can be set using :var:`config.tag_layer`.
    

    This is very similar to temporary attributes shown using @ in dialogue
    lines. The attribute is not removed when the text apparition animation
    ends, but when the dialogue window gets dismissed.

.. var:: config.tag_transform = { ... }

    一个字典，将图像标签(tag)字符串映射为transform或者transform的列表。当某个不带at分句的新显示图像出现时，就会根据图像标签在这个字典中找对应的transform或transform列表并应用。

.. var:: config.tag_zorder = { }

    一个字典，将图像标签(tag)字符串映射为zorder值。当某个不带zorder分句的新鲜事图像出现时，就会根据图像标签在这个字典中找对应的zorder值并应用。如果没有找到zorder值，就使用0。

.. var:: config.transform_uses_child_position = True

    若为True，transform会从他们的子类继承 :ref:`位置特性 <position-style-properties>` 。若不是True，就不继承。

.. _config-skipping:

跳过
------

.. var:: config.allow_skipping = True

    如果设置为False，用户就不能跳过游戏的文本内容。 参见 :var:`_skipping` 。

.. var:: config.fast_skipping = False

    该项设置为True的话，允许在开发者模式之外也使用快速跳过。

.. var:: config.skip_delay = 75

    当使用ctrl键跳过语句时，每段对话显示的时间，单位为毫秒。(实际上只是接近配置的值。)

.. var:: config.skip_indicator = True

    若为True，当使用脚本跳过功能时，库(library)会显示一个跳过提醒标志。

.. _config-text-and-fonts

文本和字体
-----------

.. var:: config.font_hinting = { None : "auto" }

    该项是一个字典，指定了hinting模式下 :propref:`hinting` 样式特性各种情况使用的字体文件名。
    当 :propref:`hinting` 为True时，Ren'Py会在字典中搜索并启用对应字体。

    如果字典内没有匹配的键(key)，则启用键为None对应的值。

.. var:: config.font_name_map = { }

    该项是一个字典，表示字体与字体文件路径/字体组的映射关系。
    字体名称简化为 ``{font}`` 标签，并指定标签内文字对应的 :ref:`fontgroup` 功能特性。

.. var:: config.font_transforms = { ... }

    该项用于创建新的字体变换与字体文件的映射关系。
    字体变换可以使用 :func:`Preferences` 激活，将需要的“font transform”当作第一个参数传入即可。

    此字典的键(key)是字体名的字符串，值(value)是一个函数。
    函数可以使用字体或者 :class:`FontGroup` 对象作为入参，返回结果也是一个字体或字体组对象。
    例如，字体变换dejavusans可以这样定义：

    ::

        init python:
            def dejavusans(f):
                return "DejaVuSans.ttf"

            config.font_transforms["dejavusans"] = dejavusans

.. var:: config.font_replacement_map = { }

    该项是一个从(font, bold, italics)到(font, bold, italics)映射，用来使用指定的粗体或斜体替换默认字体。
    例如，如果想要 :file:`Vera.ttf` 版本的斜体使用 :file:`VeraIt.ttf` 代替，可以这样写：

    ::

        init python:
            config.font_replacement_map["Vera.ttf", False, True] = ("VeraIt.ttf", False, False).

    请注意，这种映射只能用于字体的特定变化。也就是说，请求“Vera”字体的粗体兼斜体版本，会得到一个粗体兼斜体版本的“Vera”字体，而不是斜体“Vera”的粗体版本。

.. var:: config.hyperlink_handlers = { ... }

    一个字典，建立超链接协议与协议处理器(handler)之间的映射关系。处理器(handler)是一个函数，使用超链接做为值(在英文冒号之后的内容)，并执行一些行为。如果有返回值，互动行为就停止。否则，点击操作会被忽略，互动行动继续。

.. var:: config.hyperlink_protocol = "call_in_new_context"

    没有关联任何协议的超链接所使用的协议。详见 :tt:`a` 文本标签中关于可用协议部分。

.. var:: config.mipmap_text = False

    :func:`Text` 的mipmap入参默认值, 包括在screen语句中使用的文本。

.. var:: config.new_substitutions = True

    若为True，Ren'Py会将应用新形式(圆括号)替换(substitution)所有显示的文本上。

.. var:: config.old_substitutions = True

    若为True，Ren'Py会将应用旧形式(百分号)替换(substitution) :ref:`say <say-statement>` 和 :doc:`menu <menus>` 语句中显示的文本。

.. var:: config.preload_fonts = [ ... ]

    Ren'Py启动时加载的TrueType和OpenType字体名列表。添加在这个列表中的字体名称可以防止引入新字体Ren'Py出现暂停。

.. var:: config.replace_text = None

    若非None，这是一个使用一个入参的函数，函数向用户展示一段文本。该函数可以将传入的文本原样返回，也可以返回某些数据被替换后的文本。

    只有文本替代执行后且文本已经使用标签(tag)分割，这个函数才会被调用，所以入参就是实际文本。所有可视文本都可以传入这个函数：不限于对话文本，还包括用户接口文本。

    这个函数可以用来把特定的ASCII编码序列替换为Unicode字符，样例如下：

    ::

        def replace_text(s):
            s = s.replace("'", u'\u2019') # apostrophe
            s = s.replace('--', u'\u2014') # em dash
            s = s.replace('...', u'\u2026') # ellipsis
            return s
        config.replace_text = replace_text

    .. seealso:: :var:`config.say_menu_text_filter`

.. var:: config.say_menu_text_filter = None

    若非None，这是一个函数，返回 :ref:`say <say-statement>` 和 :doc:`menu <menus>` 语句中的指定文本。这个函数用于返回新的(或者相同的)字符串替换原来的字符串。

    列表中的函数在say和menu语句的早期就会执行，早于多语言(translation)和文本插值(substitution)。
    若需要一个运行时机更晚的过滤器(filter)，参见 :var:`config.replace_text`。

.. var:: config.textshader_callbacks = { }

    该项是一个字典，键是字符串，值是可调用对象(callable)。当使用 :doc:`textshaders` 中的字符串时，可调用对象会返回另一个textshader名称的字符串。
    该项可以基于某个固定变量值修改textshader。

.. _config-transitions:

转场
-----

.. var:: config.adv_nvl_transition = None

    在ADV模式文本后直接显示NVL模式文本使用的转场效果。

.. var:: config.after_load_transition = None

    loading之后使用的转场效果。

.. var:: config.end_game_transition = None

    游戏正常结束后返回到主菜单使用的转场效果，比如调用return却没有明确的返回点，或者调用 :func:`renpy.full_restart`。

.. var:: config.end_splash_transition = None

    在splashscreen后显示主菜单时使用的转场效果。

.. var:: config.enter_replay_transition = None

    若非None，回放(replay)使用的转场效果。

.. var:: config.enter_transition = None

    若非None，进入游戏菜单时使用的转场效果。

.. var:: config.enter_yesno_transition = None

    若非None，进入yes/no提示界面的转场效果。

.. var:: config.exit_replay_transition = None

    若非None，退出回放(replay)时使用的转场效果。

.. var:: config.exit_transition = None

    若非None，退出游戏菜单使用的转场效果。

.. var:: config.exit_yesno_transition = None

    若非None，退出yes/no提示界面使用的转场效果。

.. var:: config.game_main_transition = None

    若非None，使用 :func:`MainMenu` 行为函数从游戏菜单离开显示主菜单时使用的转场效果。

.. var:: config.intra_transition = None

    在游戏菜单的各界面之间使用的转场效果。(即使用 :func:`ShowMenu` 切换界面。)

.. var:: config.nvl_adv_transition = None

    在NVL模式文本后直接显示ADV模式文本使用的转场效果。

.. var:: config.pause_with_transition = False

    若为False，``pause`` 语句将必定调用 :func:`renpy.pause`。
    若为True，可以指定一个延迟时间，``pause 5`` 语句等效于 ``with Pause(5)``。

.. var:: config.say_attribute_transition = None

    若非None，用image属性(attribute)的say语句改变图像时使用的转场效果。

.. var:: config.say_attribute_transition_callback : Callable

    这里可以配置一个函数，返回一个应用的转场和转场使用的图层。

    该函数有四个入参：图像标签(image tag)， `mode` 参数，含有前置转场标签的 `set` ，以及包含后置转场标签的 `set` 。
    `mode` 参数的值为下列之一：

    * “permanet”，永久修改属性(attribute)，当前say语句开始一直生效。
    * “temporary”，临时修改属性(attribute)，仅对当前say语句生效，之后保存修改过的临时属性。
    * “both”，永久和临时修改属性(attribute)同时生效。(针对部分属性需要在当前say语句之后继续生效，而部分属性需要恢复的情况。)
    * “restore”，临时属性(attribute)失效，恢复之前的值。。

    返回值是一个2元的元组，包含下列内容：

    * 使用的转场(transition)，如果不使用转场则发挥None。
    * 转场所在的图层名，应该是一个字符串或者None。大多数情况下都是None。

    默认应用返回值为(config.say_attribute_transition, config.say_attribute_transition_layer)。

.. var:: config.say_attribute_transition_layer = None

    若非None，这必须是给定图层(layer)名的字符串。(大多数情况都是“master”。)say属性(attribute)会应用于命名的那个图层，且Ren'Py不会暂停等待转场效果发生。在对话显示时，这也会对属性(attribute)中的转场生效。

.. var:: config.window_hide_transition = None

    没有显示指定转场效果时，window hide语句使用的转场效果。

.. var:: config.window_show_transition = None

    没有显示指定转场效果时，window show语句使用的转场效果。

.. _transition-control:

转场控制
----------

.. var:: config.implicit_with_none = True

    若为True，也就是默认值，等效于每次通过对话、菜单输入和imagemap等互动行为之后都使用了 :ref:`with None <with-none>`
    语句。该项用于确保在转场之后旧的界面不再显示。

.. var:: config.load_before_transition = True

    若为True，互动行为的启动会延迟到所用到的所有图像都加载完毕之后。(是的，这个名字很让人讨厌。)

.. var:: config.mipmap_dissolves = False

    :func:`Dissolve`，:func:`ImageDissolve`，:func:`AlphaDissolve` 和 :func:`AlphaMask` 的mipmap入参默认值。

.. var:: config.overlay_during_with = True

    如果我们想要在 :ref:`with 语句 <with-statement>` 覆盖已显示图像就设置为True，如果我们想要在with语句中隐藏重叠部分就设置为False。

.. _config-translation:

多语言支持
-----------

.. var:: config.default_language = None

    若不是None，该项是一个字符串，指定多语言框架下游戏默认使用的语言。

    详见 :doc:`多语言 <translation>`。

.. var:: config.defer_styles = False

    当该项为True时，style语句的执行会推迟到所有 ``translate python`` 语句块(block)执行后。这允许多语言支持python语句块更新某些变量。这些变量会用于多语言支持样式之外的style语句中。

    该项默认值是False， :func:`gui.init` 被调用时会将该项设置为True。

.. var:: config.defer_tl_scripts = Fasle

    当该项为True时，除非选择了指定的语言，Ren'Py不会从tl目录加载脚本。详见 :ref:`deferred-translations`。

.. var:: config.enable_language_autodetect = False

    若为True，Ren'Py会尝试根据玩家系统的地区信息自动决定使用的语言。若自动检测并设置成功，这种语言后续将作为默认的语言。

.. var:: config.locale_to_language_function : Callable

    该函数基于用户所在地区(locale)决定游戏使用的语言。

    函数有两个入参，分别为地区(locale)的ISO编码和行政区(region)的ISO编码。

    返回值是一个字符串，对应支持的语言名称，或者返回None表示使用默认语言。

.. var:: config.new_translate_order = True

    启用新的style和translate语句命令，详见 `Ren'Py 6.99.11 <https://www.renpy.org/doc/html/changelog6.html#ren-py-6-99-11>`_ 。

.. var:: config.translate_clean_stores = [ "gui", ... ]

    一个命名存储区的列表。当使用的语言改变时，列表内存储区的状态会清除并恢复为初始化阶段的值。

.. var:: config.translate_ignore_who = [ ]

    该项是一个角色名的字符串列表，指定的角色台词不会生成多语言转换。
    该项用于需要debug的角色或单纯用作笔记的内容。该项只会进行角色名的字符串匹配，而不是计算表达式的结果。
    (比如该项中包含角色名“e”，在 ``e`` 和 ``l`` 实际为同一个角色对象的情况下，只影响角色e而对角色l无效。)
    

.. _config-voice:

语音
------

.. var:: config.auto_voice = None

    该项可以是一个字符串、一个函数或者空值(None)。若为None，自动语音功能就被禁用。

    若是一个字符串，字符串格式带有与表示对话当前行标识绑定的变量 ``id`` 。如果该项给出了一个存在的文件，那个文件就被作为语音播放。

    若是一个函数，该函数会带一个入参被调用，即对话当前行标识号。该函数应该返回一个字符串，这个字符串给出的文件存在的情况下，文件就会作为语音播放。

    更多细节详见 :ref:`自动语音 <automatic-voice>` 。

.. var:: config.emphasize_audio_channels = [ 'voice' ]

    给出音频通道名的字符串列表。

    如果启用了“emphasize audio”环境设定，当列表内某个音频通道开始播放一个声音时，所有不在列表内的通道都将在 :var:`config.emphasize_audio_volume` 定义的时间(单位为秒)内将自身的音量中值降低到 :var:`config.emphasize_audio_time`
    的值。

    当没有列表内的通道播放声音时，所有不在列表内的通道将在
    :var:`config.emphasize_audio_time` 定义的时间(单位为秒)内将自身的音量中值提高到1.0。

    例如，将该项设置为 ``[ 'voice' ]`` 的话，播放语音时所有非语音通道的音量都会被降低。

.. var:: config.emphasize_audio_time = 0.5

    见上面的说明。

.. var:: config.emphasize_audio_volume = 0.5

    见上面的说明。

.. var:: config.voice_filename_format = "{filename}"

    该项配置的字符串会自动用voice语句的入参字符串替换“filename”，并作为向用户播放的语音文件名使用。例如，如果这里配置的是“{filename}.ogg”，那么  ``voice "test"`` 语句就会播放 :file:`test.ogg` 文件。

.. _config-window-management:

窗口管理
----------

.. var:: config.choice_empty_window = None

    若非None，并且(通常使用 ``menu`` 语句调用的)选项菜单没有标题，就调用此处定义的函数生成标题，入参为("", interact=False)。

    使用方法为：

    ::

        define config.choice_empty_window = extend

    这样就可以让选项菜单的标题显示为之前对话内容的最后一句。

    还有其他实现方式，前提是对话窗口总是显示。

.. var:: config.empty_window : Callable

    当_window项为True且界面上不显示任何窗口时，该项会被无参调用。(那表示， :func:`renpy.shown_window` 函数没有被调用。)通常用于在界面上显示一个空的窗口，返回后不会触发互动行为。

    该项的默认用法是，叙述者角色显示一个空白行不使用互动行为。

.. var:: config.window = None

    这个配置项控制对话窗口管理的默认方法。若不为空值(None)，该项应该是“show”、“hide”或者“auto”。

    当设置为“show”的情况下，对话窗口始终会显示。当设置为“hide”的情况下，除了say语句等需要显示对话内容之外，对话窗口会隐藏。当设置为“auto”的情况下，对话窗口会在scene语句前隐藏，显示对话时再出现。

    这个配置项设置了默认值。默认值可以使用 ``window show`` 、 ``window hide`` 和 ``window auto`` 语句改变。
    详见 :ref:`dialogue-window-management`。

.. var:: config.window_auto_hide = [ "scene", "call screen", "menu", "say-centered", "say-bubble", ... ]

    一个语句名称列表，列表内的语句会让 ``window auto`` 隐藏空的对话窗口。

.. var:: config.window_auto_show = [ "say", "say-nvl", "menu-with-caption", "nvl-menu", "nvl-menu-with-caption", ... ]

    一个语句名称列表，列表内的语句会让 ``window auto`` 显示空的对话窗口。

.. _config-developer:

开发者相关
----------

.. _config-compatibility:

兼容性
^^^^^^^

.. var:: config.label_overrides = { }

    该项配置给出了在Ren'Py脚本中jump和call脚本标签(label)时，重定向到其他脚本标签(label)的方法。例如，如果你需要添加一个“start”到“mystart”的映射关系，所有jump和call到“start”标签最终都会转到“mystart”。

.. var:: config.script_version = None

    若非None，这被解释为脚本的版本号。库(library)会根据脚本版本号启用适合的特性(feature)。若为None，我们假设脚本版本为最新。

    通常该项是项目构建时由Ren'Py启动器(launcher)自动添加在某个文件中。

.. _config-development:

开发者模式
-----------

.. var:: config.console = False

    该项会在 :var:`config.developer` 不是True的情况下依然能启用控制台。

.. var:: config.developer = "auto"

    若设置为True，启用开发者模式。开发者模式下能使用shift+D进入开发者菜单，使用shift+R重新加载脚本，以及各种不支持终端用户的功能特性。

    该项可以是True、False或“auto”。若设置为“auto”，Ren'Py会检查整个游戏是否已经构建打包，并设置合适的config.developer值。

.. _config-debugging:

解决bug
^^^^^^^^^

.. var:: config.clear_log = False

    若为True，每次Ren'Py启动时都会清空 :var:`config.log` 设置的日志文件内容。

.. var:: config.debug_image_cache = False

    若为True，Ren'Py会把关于 :ref:`图像缓存 <images>`
    的信息写入到image_cache.txt文件中。

.. var:: config.debug_prediction = False

    若为True，Ren'Py会将预加载(执行流程、图像、界面)时发生的错误记录到日志log.txt和控制台中。

.. var:: config.debug_sound = False

    启用声音调试功能。该项禁用了声音生成过程中的错误抑制机制。不过，如果声卡丢失或者故障，这样的错误是正常的，启用这个调试项可能会导致Ren'Py的正常功能无法工作。在发布版本中，该项应该是关闭的。

.. var:: config.debug_text_overflow = False

    该项为True时，Ren'Py会把文本溢出记录到text_overflow.txt文件中。文本组件渲染一个比其自身更大尺寸的区域时，会产生一个文本溢出。该项设置为True，并把样式特性中的 :propref:`xmaximum` 和 :propref:`ymaximum` 设置为对话窗口尺寸，就能在对话长度相对窗口过大时生成溢出报告。

.. var:: config.disable_input = False

    该项为True时， :func:`renpy.input` 函数立即终止，并返回其 `default` 参数。

.. var:: config.exception_handler = None

    如果不是None，该项应该是一个函数，并带有3个入参：

    * 一个字符串，表示记录traceback的缩略文本，仅包含创作者编写的文件。
    * traceback完整文本，同事包含传作者编写和Ren'Py的文件。
    * 包含traceback方法的文件路径。

    该函数用于控制是否向用户展现程序错误。若函数返回True，忽略异常(exception)并将主控流程切换到下一个语句。
    若函数返回False，启用内建的异常处理机制。
    该函数也可以调用 :func:`renpy.jump` 将主控流程切换至其他文本标签(label)。

.. var:: config.lint_character_statistics = True

    若为True，并且 :var:`config.developer` 也为True时，lint的分析报告会包含对话段落中每个角色的统计数据。
    游戏打包后，角色统计数据将禁用，以防止对游戏运行产生干扰。

.. var:: config.lint_hooks = [ ... ]

    当lint工具运行时，不使用入参被调用的函数列表。这些函数用于检查脚本数据是否有错误，并在标准输出打印找到的错误(这种情况下使用Python的print语句就行)。

.. var:: config.log = None

    若非None，该项应该是一个文件名。通过 :ref:`say <say-statement>` 或 :doc:`menu <menus>` 语句展示给用户的文本都会记录在这个文件中。

.. var:: config.log_events = False

    若为True，Ren'Py会在log.txt中记录pygame样式的事件。这样做会影响性能，但对某些问题的debug可能有用。

.. var:: config.log_width = 78

    使用 :var:`config.log`  时，每行日志的宽度。

.. var:: config.missing_image_callback = None

    若非None，当加载图片失败时会调用这个函数。调用时会将文件名或缺失的图像传入该函数。
    函数可能会返回None，也可能返回一个 :doc:`图像控制器 <im>`。如果返回的是图像控制器，可以使用图像控制器代替丢失的图片。

    创作者可能需要同时配置 :var:`config.loadable_callback` 的值，特别是使用 :func:`DynamicImage` 对象的情况。

.. var:: config.missing_label_callback = None

    若非None，当Ren'Py尝试转到某个不存在的脚本标签(label)时，配置的函数会被调用。该函数会返回一个脚本标签名称，用以代替那个丢失的脚本标签。若Ren'Py抛出异常(exception)时则返回None。

.. var:: config.profile = False

    若设置为True，某些档案(profile)信息会输出到stdout标准输出。

.. var:: config.profile_init = 0.25

    ``init`` 和 ``init python`` 语句块执行时间超过该配置项时，将会记录到日志文件中。

.. var:: config.raise_image_exceptions = None

    若为True，当出现找不到图片文件时，Ren'Py会抛异常。
    若为False，Ren'Py会在图片位置显示一个纹理错误信息。

    若为None，结果取决于config.developer的配置。

    Ren'Py忽略异常后，该项会设置为False。

.. var:: config.raise_image_load_exceptions = None

    若为True，加载图片时出错时Ren'Py会抛异常。
    若为False，Ren'Py会在图片位置显示一个纹理错误信息。

    若为None，结果取决于config.developer的配置。

    Ren'Py忽略异常后，该项会设置为False。

.. var:: config.return_not_found_label = None

    若非None，在主控流程返回时无法找到合适脚本标签位置时，则使用该项指定的脚本标签。
    这次标签跳跃前，调用栈将被清空。

.. _config-garbage-collection:

垃圾回收(GC)
^^^^^^^^^^^^^^

.. var:: config.manage_gc = True

    若为True，Ren'Py会自己管理GC。这意味着Ren'Py使用以下设置。

.. var:: config.gc_print_unreachable = False

    若为True，Ren'Py会在控制台和日志中打印出触发GC的对象信息。

.. var:: config.gc_thresholds = (25000, 10, 10)

    非空闲(idle)状态下Ren'Py使用的GC阈值。这些设置会尝试确保不会发生大规模GC。这三个数值分别表示：

    * level-0回收的对象净数。
    * 触发level-1回收的level-0回收次数。
    * 触发level-2回收的level-1回收次数。

    (level-0回收应该足够快，不会引发掉帧。level-1回收速度可能会引发掉帧，level-2则一定引发掉帧。)

.. var:: config.idle_gc_count = 2500

    当Ren'Py到达一个稳定状态时，触发GC的对象净数。(稳定状态是指界面更新第四帧之后)

.. _config-reload:

重新加载
^^^^^^^^^


.. var:: config.autoreload = True

    若为True，使用shift+R组合键可以自动重新加载脚本。并且，当自动重加载功能启用后，Ren'Py一旦发现使用的文件发生修改就会自动重加载。

    若为False，Ren'Py值在每次按下shift+R时才会重新加载脚本。

.. var:: config.reload_modules = [ ]

    一个字符串列表，表示游戏中会重新加载的所有Python模块名。这些模块的子模块也会重新加载。
