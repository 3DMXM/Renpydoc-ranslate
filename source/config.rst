.. _configuration-variables:

=======================
配置项变量
=======================

配置项变量控制Ren'Py的执行器行为，允许Ren'Py自身使用多种方式的定制化。配置项囊括了常见变量(比如改变界面尺寸)到罕见变量(添加新类型的归档文件)。

Ren'Py执行器会假设，GUI系统已完成初始化，配置项变量不会发生改变。在初始化语句块(block)之外修改配置项变量会导致未定义的行为。配置项变量不是存档文件的一部分。

配置项变量通常是初始化Python语句块(block)中修改：

::

    init python:

        # 使用宽屏分辨率。
        config.screen_width = 1024
        config.screen_height = 600

.. _commonly-used:

常用配置项
-------------

.. var:: config.name = ""

    一个字符串给定了游戏名。这个配置项还会用作回溯等日志文件名的一部分，与版本号一起使用。

.. var:: config.save_directory = "..."

    用于生成游戏和保存持久化信息使用的目录。具体的游戏目录取决于不同的平台：

    Windows
        %APPDATA%/RenPy/`save_directory`

    Mac OS X
        ~/Library/RenPy/`save_directory`

    Linux/Other
        ~/.renpy/`save_directory`

    这项设置为None的话，将在game目录下创建一个“saves”文件夹。不推荐这样做，因为这无法防止game目录被系统的多用户共享。当某个游戏以管理员身份安装，以普通用户运行时，这种配置也会导致运行问题。

    配置这项时，必须使用define语句或者Python语句块。无论使用哪种，配置项的语句都会在其他任何语句之前运行，所以其应该是一个字符串而不能是表达式。

    需要打开存档目录时，使用 :var:`config.savedir` 而不是config.save_directory。

.. var:: config.version = ""

    一个字符串给定了游戏版本号。这个配置项还会用作回溯等日志文件名的一部分。

.. var:: config.window = None

    这个配置项控制对话窗口管理的默认方法。若不为空值(None)，该项应该是“show”、“hide”或者“auto”。

    当设置为“show”的情况下，对话窗口始终会显示。当设置为“hide”的情况下，除了say语句等需要显示对话内容之外，对话窗口会隐藏。当设置为“auto”的情况下，对话窗口会在scene语句前隐藏，显示对话时再出现。

    这个配置项设置了默认值。默认值可以使用 ``window show`` 、 ``window hide`` 和 ``window auto`` 语句改变。详见
    :ref:`dialogue-window-management`。

.. _transitions:

转场
-----------

这些配置项控制各种场景的转场效果。

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

    从游戏菜单离开显示主菜单时使用的转场效果。从主菜单调用读档和环境设定界面，以及用户在游戏菜单选择返回主菜单也使用这个转场。

.. var:: config.intra_transition = None

    在游戏菜单的各界面之间使用的转场效果。

.. var:: config.main_game_transition = None

    从主菜单进入游戏菜单，以及点击“Load Game”或“Preferences”后使用的转场效果。

.. var:: config.nvl_adv_transition = None

    在NVL模式文本后直接显示ADV模式文本使用的转场效果。

.. var:: config.say_attribute_transition = None

    若非None，用image属性(attribute)的say语句改变图像时使用的转场效果。

.. var:: config.say_attribute_transition_layer = None

    若非None，这必须是给定图层(layer)名的字符串。(大多数情况都是“master”。)say属性(attribute)会应用于命名的那个图层，且Ren'Py不会暂停等待转场效果发生。在对话显示时，这也会对属性(attribute)中的转场生效。

.. var:: config.window_hide_transition = None

    没有显示指定转场效果时，window hide语句使用的转场效果。

.. var:: config.window_show_transition = None

    没有显示指定转场效果时，window show语句使用的转场效果。

.. _preference-defaults:

环境设定默认值
-------------------

Ren'Py有一些变量设置了环境设定的默认值。请查看 :var:`环境设定变量 <preference-variables>` 部分的内容。

.. _occasionally-used:

偶尔用到的配置项
-----------------

.. var:: config.after_load_callbacks = [ ... ]

    读档时，(无入参)调用的参数列表。

.. var:: config.after_replay_callback = None

    若非None，这项是回放(replay)结束后，不使用入参那调用的函数。

.. var:: config.auto_channels = { "audio" : ( "sfx", "", ""  ) }

    这项是用于定义自动音频通道。它将通道名映射为一个3元的元组：

    * 混合器使用的通道名。
    * 通道上播放文件的前缀。
    * 通道上播放文件的后缀。

.. var:: config.auto_load = None

    若非None，该项表示Ren'Py启动时自动加载的一个存档文件名。这项是提供给针对开发者用户，而不是终端用户用的。将这项设置为1的话，就会自动读取槽位1的存档。

.. var:: config.auto_voice = None

    这项可以是一个字符串、一个函数或者空值(None)。若为None，自动语音功能就被禁用。

    若是一个字符串，字符串格式带有与表示对话当前行标识绑定的变量 ``id`` 。如果该项给出了一个存在的文件，那个文件就被作为语音播放。

    若是一个函数，该函数会带一个入参被调用，即对话当前行标识号。该函数应该返回一个字符串，这个字符串给出的文件存在的情况下，文件就会作为语音播放。

    更多细节详见 :ref:`自动语音 <automatic-voice>` 。

.. var:: config.automatic_images = None

    若非None，则允许Ren'Py自动定义图像。

    非空的情况下，这项应该设置为一个分隔符列表。(例如， ``[ ' ', '_', '/' ]`` 。)

    Ren'Py会扫描磁盘和归档的文件列表。当找到后缀名是“.png”或“.jpg”文件，Ren'Py会省略这些后缀，并根据文件名创建新的图像名。如果文件名至少包含两部分，并且没有同名的图像被定义过，Ren'Py会根据文件名匹配文件名。

    根据分隔符列表样例，如果你的游戏目录中包含：

    * eileen_happy.png， Ren'Py 会定义图像 "eileen happy".
    * lucy/mad.png，Ren'Py会定义图像"lucy mad".
    * mary.png，Ren'Py不会做任何事。(因为图片文件名不包含两部分。)

.. var:: config.automatic_images_strip = [ ]

      一个字符串列表，给定了自动定义图像时省略的前缀。当某些目录下包含图片，可以用来删除目录名称。

.. var:: config.autosave_slots = 10

    自动存档使用的槽位编号。

.. var:: config.cache_surfaces = True

    若为True，图像的底层数据存储在RAM中，允许图像操作器(manipulator)使用时不需要从磁盘加载。若为False，数据会从缓存中删除，但会在显存中存为一份纹理(texture)，降低RAM使用。

.. var:: config.character_id_prefixes = [ ]

    这项指定了一个可以用于 :func:`Character` 对象的样式特性(property)前缀列表。当某个样式前缀与列表中的前缀匹配，带有那个前缀的可视组件就会应用对应的样式。

    例如，给默认GUI添加“namebox”前缀。当某个角色给定了namebox_background特性时，它会将带有id“namebox”的可视组件设置为say界面的 :propref:`background`。

.. var:: config.config.conditionswitch_predict_all = False

    针对  :func:`ConditionSwitch`
    和 :func:`ShowingSwitch` 的predict_all入参默认值，决定是否所有可用的可视组件都显示。

.. var:: config.debug = False

    启用调试功能(大多数时候将文件丢失问题转成错误信息)。在发布版本中，这项应该是关闭的。

.. var:: config.debug_image_cache = False

    若为True，Ren'Py会把关于 :ref:`图像缓存 <images>`
    的信息写入到image_cache.txt文件中。

.. var:: config.debug_sound = False

    启用声音调试功能。这项禁用了声音生成过程中的错误抑制机制。不过，如果声卡丢失或者故障，这样的错误是正常的，启用这个调试项可能会导致Ren'Py的正常功能无法工作。在发布版本中，这项应该是关闭的。

.. var:: config.debug_text_overflow = False

    当这项为True时，Ren'Py会把文本溢出记录到text_overflow.txt文件中。文本组件渲染一个比其自身更大尺寸的区域时，会产生一个文本溢出。该项设置为True，并把样式特性中的 :propref:`xmaximum` 和 :propref:`ymaximum` 设置为对话窗口尺寸，就能在对话长度相对窗口过大时生成溢出报告。

.. var:: config.default_tag_layer = "master"

    图像显示的默认图层(layer)，前提是图像标签(tag)在config.tag_layer不存在。

.. var:: config.default_transform = ...

    使用show或scene语句显示某个可视组件时，从此项配置的transform获取并初始化可视组件transform特性(property)的值。

    默认的default_transform是 :var:`center`，居中。

.. var:: config.defer_styles = False

    当该项为True时，style语句的执行会推迟到所有“translate python”语句块(block)执行后。这允许多语言支持python语句块更新某些变量。这些变量会用于多语言支持样式之外的style语句中。

    该项默认值是False， :func:`gui.init` 被调用时会将这项设置为True。

.. var:: config.developer = "auto"

    若设置为True，启用开发者模式。开发者模式下能使用shift+D进入开发者菜单，使用shift+R重新加载脚本，以及各种不支持终端用户的功能特性。

    该项可以是True、False或“auto”。若设置为“auto”，Ren'Py会检查整个游戏是否已经构建打包，并设置合适的config.developer值。

.. var:: config.displayable_prefix = { }

    请见 :ref:`可视组件前缀 <displayable-prefix>`。

.. var:: config.emphasize_audio_channels = [ 'voice' ]

    给出音频通道名的字符串列表。

    如果启用了“emphasize audio”环境设定，当列表内某个音频通道开始播放一个声音时，所有不在列表内的通道都将在 :var:`config.emphasize_audio_volume` 定义的时间(单位为秒)内将自身的音量中值降低到 :var:`config.emphasize_audio_time`
    的值。

    当没有列表内的通道播放声音时，所有不在列表内的通道将在
    :var:`config.emphasize_audio_time` 定义的时间(单位为秒)内将自身的音量中值提高到1.0。

    例如，将这项设置为 ``[ 'voice' ]`` 的话，播放语音时所有非语音通道的音量都会被降低。

.. var:: config.emphasize_audio_time = 0.5

    见上面的说明。

.. var:: config.emphasize_audio_volume = 0.5

    见上面的说明。

.. var:: config.empty_window = ...

    当_window项为True且界面上不显示任何窗口时，这项会被调用。(那表示， :func:`renpy.shown_window` 函数没有被调用。)通常用于在界面上显示一个空的窗口，返回后不会触发互动行为。

    这项的默认用法是，叙述者角色显示一个空白行不使用互动行为。

.. var:: config.enter_sound = None

    若非None，这是进入游戏菜单播放的音效文件。

.. var:: config.exit_sound = None

    若非None，这是离开游戏菜单播放的音效文件。

.. var:: config.fix_rollback_without_choice = False

    这项决定了回退时，菜单和imagemap的构建方式。该项默认值是False，表示只有之前选择的菜单选项是可以点击的。若设置为真(False)，之前的选择会被标记，但所有选项都不是可点击的。用户可以使用点击在回退缓存中处理随意向前。

.. var:: config.font_replacement_map = { }

    这项是一个从(font, bold, italics)到(font, bold, italics)映射，用来使用指定的粗体或斜体替换默认字体。例如，如果想要“Vera.ttf”版本的斜体使用“VeraIt.ttf”代替，可以这样写：

    ::

        init python:
            config.font_replacement_map["Vera.ttf", False, True] = ("VeraIt.ttf", False, False).

    请注意，这种映射只能用于字体的特定变化。也就是说，请求“Vera”字体的粗体兼斜体版本，会得到一个粗体兼斜体版本的“Vera”字体，而不是斜体“Vera”的粗体版本。

.. var:: config.game_menu = [ ... ]

    这项用于定制化游戏菜单选项。详见主菜单和游戏菜单的中关于此配置项的内容。

    使用界面定义游戏菜单的情况下，这项不会被使用。

.. var:: config.game_menu_music = None

    若非None，这项是在游戏菜单时播放的音乐文件。

.. var:: config.gl_clear_color = "#000"

    在有意义的图像绘制前，用于清理窗口使用的颜色。当游戏在窗口或显示器全屏模式下的高宽比与游戏定义的高宽比不匹配时，letterbox或pillarbox的边框就是用的这种颜色。

.. var:: config.gl_test_image = "black"

    运行OpenGL性能测试时使用的图片名称。这个图片会在启动时显示5帧或者0.25秒，然后自动隐藏。

.. var:: config.has_autosave = True

    若为True，游戏会启动自动保存。若为False，禁用自动保存。

.. var:: config.history_callbacks = [ ... ]

    该项包含一个回调(callback)函数列表，其中的回调函数会在Ren'Py在_history_list中添加新对象之前被调用。调用回调函数时，新增的HistoryEntry对象会作为第一个入参，还可以在那个对象中添加新的字段(field)。

    Ren'Py使用内置的历史回调函数，所以创作者应该将自己的回调函数添加到这个列表中，而不是替换整个列表。

.. var:: config.history_length = None

    Ren'Py保存的对话历史层的数量。该项被默认GUI设置为250。

.. var:: config.hw_video = False

    若为True，在移动平台播放视频启用硬件解码。硬件解码视频更快，但受到某些格式和全屏播放的限制。若为False，使用软解解码播放，但效率堪忧。

.. var:: config.hyperlink_handlers = { ... }

    一个字典，建立超链接协议与协议处理器(handler)之间的映射关系。处理器(handler)是一个函数，使用超链接做为值(在英文冒号之后的内容)，并执行一些动作。如果有返回值，互动行为就停止。否则，点击操作会被忽略，互动行动继续。

.. var:: config.hyperlink_protocol = "call_in_new_context"

    没有关联任何协议的超链接所使用的协议。详见 :ref:`文本标签 <a-tag>` 中关于可用协议部分。

.. var:: config.image_cache_size = None

    如果非None，该项用于设置 :ref:`图像缓存 <images>` 的大小，是界面尺寸的整倍数，单位为像素。

    如果设置过大，是浪费内存的行为。如果设置过小，图像从磁盘直接加载，会降低性能。

.. var:: config.image_cache_size_mb = 300

    该项用于设置 :ref:`图像缓存 <images>` 的大小，单位是MB。如果 :var:`config.cache_surfaces` 的值是False，每个图像的一个像素占用4 byte的存储空间；否则，每个图像的一个像素占用8 byte的存储空间.

    如果设置过大，是浪费内存的行为。如果设置过小，图像从磁盘直接加载，会降低性能。只要
    :var:`config.image_cache_size` 的配置不是空值(None)，就不使用config.image_cache_size_mb。

.. var:: config.key_repeat = (.3, .03)

    控制按键重复频率。如果启用了按键重复，这项应该是一个元组。元组内第一个元素是首次重复的延迟，第二个元素是之后每次重复的延迟。两个元素单位都是秒。如果这项是None，键盘重复功能被禁用。

.. var:: config.language = None

    若非None，这项应是一个字符串，指定了多语言支持框架下的默认语言。

.. var:: config.main_menu = [ ... ]

    不使用界面的情况下，默认的主菜单。详见主菜单和游戏菜单章节。

.. var:: config.main_menu_music = None

    若非None，就是一个在主菜单播放的音乐文件。

.. var:: config.menu_clear_layers = []

    图层名(以字符串形式)列表，列表中的图层在进入游戏菜单时会清空。

.. var:: config.menu_window_subtitle = ""

    进入主菜单或游戏菜单时， :var:`_window_subtitle` （窗口标题）变量。

.. var:: config.minimum_presplash_time = 0.0

    设置了一个时间值，单位为秒。表示presplash、安卓presplash或iOS的启动画面最短显示的时间。如果Ren'Py在这段时间内完成初始化，它将会休眠，确保图像至少显示配置的时间。如果Ren'Py启动耗时较长，启动画面也可以显示更久。

.. var:: config.missing_background = "black"

    当 :var:`config.developer` 为True且某个之前 :ref:`scene语句 <scene-statement>` 使用了未定义的图像时，该项就会作为背景使用。这项的值应该是一个图像名(字符串)，而不是可视组件。

.. var:: config.mode_callbacks = [ ... ]

    进入某个模式(mode)时调用的回调函数列表。详见 :ref:`模式(mode) <modes>` 章节的内容。

    默认值是定义在 :var:`config.adv_nvl_transition`
    and :var:`config.nvl_adv_transition`.

.. var:: config.mouse = None

    这个配置项控制用于定义的鼠标指针。若为空，使用系统鼠标，也就是一个黑白色的光标指针。

    否则，这项应该是一个给定多种鼠标类型动画的字典。默认库中使用的键(key)包括“default”、“say”、“with”、“menu”、“prompt”、“imagemap”、“pause”、“mainmenu”和“gamemenu”。键“default”必须存在，它会在其他特定键不存在的情况下使用。

    字典中的每个键对应的值都是一个(*image, xoffset, yoffset*)形式元组的列表，按帧排序。

    `image`
        鼠标指针图像。

    `xoffset`
        从指针左端开始算的热站(hotspot)偏移量，单位是像素。

    `yoffset`
        从指针顶端开始算的热站(hotspot)偏移量，单位是像素。

    序列帧以20Hz的频率循环播放。

.. var:: config.narrator_menu = False

    (默认情况下screen.ryp文件会将这项设置为True。)若为True，菜单内的叙述会使用旁白(narrator)角色。否则，叙述会显示为菜单内的文字说明。

.. var:: config.nearest_neighbor = False

    默认使用近邻过滤，支持像素化和弄瞎钛合金狗眼。

.. var:: config.optimize_texture_bounds = False

    当该项为True，Ren'Py会扫描图像并找到所有不透明像素的绑定框(box)，并加载这些像素转为一张纹理(texture)。

.. var:: config.overlay_functions = [ ]

    一个函数列表。当被调用时，每个函数都会用ui函数在overlay图层上添加可视组件。

.. var:: config.overlay_screens = [ ... ]

    当覆盖(overlay)启用时，显示的界面列表；当覆盖(overlay)被阻止时，隐藏界面列表。(界面在screen图层上显示，而不是overlay图层。)

.. var:: config.preload_fonts = [ ]

    Ren'Py启动时加载的TrueType和OpenType字体名列表。添加在这个列表中的字体名称可以防止引入新字体Ren'Py出现暂停。

.. var:: config.python_callbacks = [ ]

    一个函数列表。列表中的函数会在初始化阶段之外的任何时候被调用，不使用任何入参。

    这种函数的可能用途之一，是某个变量每次调整后，都需要使用一个函数将其值限制在某个范围内的情况。

    当Ren'Py启动时游戏未启动前，这些函数就可以被调用，而且可能这些函数相关的变量还未进行初始化。这些函数被要求处理这种情况，通过使用 ``hasattr(store, 'varname')`` 检查某个变量是否定义过。

.. var:: config.quicksave_slots = 10

    快速存档使用的槽位编号。

.. var:: config.quit_action = ...

    当用户点击程序窗口的退出按钮时调用的动作。默认的动作会提示用户确认是否真的想要退出。

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

.. var:: config.replay_scope = { "_game_menu_screen" : "preferences" }

    一个字典，在回放时将默认存储区的变量映射到指定的变量。

.. var:: config.save_json_callbacks = [ ]

    用于创建json对象的一个回调函数列表，创建的json对象可以通过 :func:`FileJson`
    和 :func:`renpy.slot_json` 接入并执行存储和标记操作。

    每个回调函数都是用某个保存过的Python字典调用。回调函数修改字典内容时，应使用适配json的Python数据类型，比如数值、字符串、列表和字典。在字典结尾的回调函数会作为存档槽位的一部分保存。

    字典中的键值可能开始是一个下划线符号(_)。这些键是Ren'Py使用的，并且不应该修改。

.. var:: config.say_arguments_callback = None

    若非None，这个函数使用当前发言角色作为第一个参数，参数列表后面是其他固定位置参数和关键词参数。任何时候使用say语句都会调用该函数。调用时通常包含一个interact入参，还可以使用其他在say语句中提供的参数。

    该函数会返回一对结果，包含一个固定位置入参的元组(大多数情况下是空的)，以及一个关键词入参的字典(大多数情况只包含interact)。

    举例：

    ::

        def say_arguments_callback(who, interact=True, color="#fff"):
            return (), { "interact" : interact, "what_color" : color }

        config.say_arguments_callback = say_arguments_callback

.. var:: config.screen_height = 600

    界面高度。通常使用 :func:`gui.init` 进行设置。

.. var:: config.screen_width = 800

    界面宽度。通常使用 :func:`gui.init` 进行设置。

.. var:: config.speaking_attribute = None

    若非None，这项是一个字符串，给出了图像属性(attribute)名。图像属性(attribute)会在角色发言时添加到图像上，在角色停止发言时移除。

.. var:: config.tag_layer = { }

    一个字典，将图像标签(tag)字符串映射为图层(layer)名称字符串。当某个图像显示时没有指定图层，就可以根据图像标签在这个字典中找对应的图层。如果图像标签没有在字典中找到，就是用 :var:`config.default_tag_name` 配置的值。

.. var:: config.tag_transform = { }

    一个字段，将图像标签(tag)字符串映射为transform或者transform的列表。当某个不带at分句的新显示图像出现时，就会根据图像标签在这个字典中找对应的transform或transform列表并应用。

.. var:: config.tag_zorder = { }

    一个字典，将图像标签(tag)字符串映射为zorder值。当某个不带zorder分句的新鲜事图像出现时，就会根据图像标签在这个字典中找对应的zorder值并应用。如果没有找到zorder值，就是用0。

.. var:: config.thumbnail_height = 75

    游戏存档使用的缩略图高度。读档时，这些缩略图也会显示。请注意，缩略图的会以其生成的尺寸显示，而不是缩略图向用户显示时设置的值。

    默认GUI可以改变这项值。

.. var:: config.thumbnail_width = 100

    游戏存档使用的缩略图宽度。读档时，这些缩略图也会显示。请注意，缩略图的会以其生成的尺寸显示，而不是缩略图向用户显示时设置的值。

    默认GUI可以改变这项值。

.. var:: config.tts_voice = None

    若非None，这是一个字符串，表示自动语音模式下播放tts语音时使用的非默认声音。可用的选项跟运行的平台有关联，并且需要设置成特定平台对应特定语音的形式。(在多语言支持的情况下最好也修改这项。)

.. var:: config.window_auto_hide = [ 'scene', 'call screen' ]

    一个语句名称列表，列表内的语句会触发 ``window auto`` 隐藏空的对话窗口。

.. var:: config.window_auto_show = [ 'say' ]

    一个语句名称列表，列表内的语句会触发 ``window auto`` 隐藏空的对话窗口。

.. var:: config.window_icon = None

    若非None，这项应该是一个图片的文件名。这个图片用作主窗口的图标。这项不会用作windows平台的执行程序和mac电脑的app缩略图，那些使用 :ref:`特殊文件 <special-files>`。

.. var:: config.window_overlay_functions = []

    一个覆盖(overlay)函数列表，仅当窗口显示时会被调用。

.. var:: config.window_title = None

    包含Ren'Py游戏的窗口标题的静态部分。后面加上 :var:`_window_subtitle` 就是窗口的完整标题名。

    若为None，也就是默认情况，默认值取 :var:`config.name`。

.. _rarely-or-internally-used:

极少使用或内部使用
-------------------------

.. var:: config.adjust_view_size = None

    若非None，这项应该是一个函数，使用两个入参：物理窗口的宽度和高度。它会返回一个元组，给出OpenGL视点(viewport)的宽度和高度，也就是Ren'Py会绘制图片的一块屏幕区域。

    该项配置用于配置Ren'Py只允许使用某些尺寸的屏幕。例如，下列配置值允许使用原始屏幕的整数倍大小(保持宽高比)：

    ::

        init python:

            def force_integer_multiplier(width, height):
                multiplier = min(width / config.screen_width, height / config.screen_height)
                multiplier = max(int(multiplier), 1)
                return (multiplier * config.screen_width, multiplier * config.screen_height)

            config.adjust_view_size = force_integer_multiplier

.. var:: config.afm_bonus = 25

    自动前进模式生效的情况下，添加到每个字符串的bonus角色数量。

.. var:: config.afm_callback = None

    若非None，这是一个Python函数，用于判断启用自动前进是否安全。这项的意义在于，语音系统中播放某个语音途中禁用自动前进功能。

.. var:: config.afm_characters = 250

    这是一个由数字字符组成的字符串，表示在自动前进模式生效前，环境设定设置中自动前进模式延迟时间。

.. var:: config.afm_voice_delay = .5

    语音文件播放完成后，在AFM能进入下一段文本之前，等待的时间值，单位为秒。

.. var:: config.all_character_callbacks = [ ]

    可以通过所有角色调用的回调函数列表。这个列表会前向添加到指定角色回调函数列表。

.. var:: config.allow_skipping = True

    如果设置为False，用户就不能跳过游戏的文本内容。

.. var:: config.archives = [ ]

    用于搜索图片和其他数据的归档文件列表。所有归档文件的入口应该是包含归档文件基本名的字符串，不包含.rpa扩展名。

    归档文件的搜索按照列表中的顺序进行。第一个搜索到的归档文件会被使用。

    在启动阶段，Ren'Py会检索game目录内的所有归档文件，按照ascii码排序，自动插入到这个列表中。例如，如果Ren'Py找到了文件data.rpa、patch01.rpa和patch02.rpa，最终生成的列表为 ``['patch02', 'patch01', 'data']`` 。

.. var:: config.auto_choice_delay = None

    若非None，这个变量给定了一个时间值(单位为秒)，这个时间值内Ren'Py会暂停，之后会在游戏内选项中随机选择一个。我们希望这个配置项在发布版本中始终设置为None，不过没有什么人工做互动的情况下可以用来自动演示。

.. var:: config.autoreload = True

    若为True，使用shift+R组合键可以自动重新加载脚本。并且，当自动重加载功能启用后，Ren'Py一旦发现使用的文件发生修改就会自动重加载。

    若为False，Ren'Py值在每次按下shift+R时才会重新加载脚本。

.. var:: config.autosave_frequency = 200

    表示经过多少次互动行为后会发生自动存档。如果要禁用自动存档，将 :var:`config.has_autosave` 设置为False，不需要修改这项的值。

.. var:: config.autosave_on_choice = True

    若为True，Ren'Py会在每次游戏内选项后自动存档。(当:func:`renpy.choice_for_skipping` 调用时。)

.. var:: config.autosave_on_quit = True

    若为True，Ren'Py会在用户做出以下操作时尝试自动存档：退出、返回主菜单、游戏中读取其他存档。(存档时，当用户被提示确认就会执行自动存档。)

.. var:: config.character_callback = None

    Character对象回调参数的默认值。

.. var:: config.choice_layer = "screens"

    选择界面(使用menu语句)显示的图层(layer)名。

.. var:: config.clear_layers = []

    一个图层(layer)名的列表，当进入主菜单和游戏菜单时，就会清除列表上所有图层的图像。

.. var:: config.context_clear_layers = [ 'screens' ]

    一个图层(layer)名的列表，当进入一个新的上下文(context)时，会清除列表上所有图层的图像。

.. var:: config.fade_music = 0.0

    这是一个单位为秒的时间值，表示在一个新的音轨开始前，旧音轨渐出的时间。这个值应该比较短，这样旧音乐不会播放过久。

.. var:: config.fast_skipping = False

    这项设置为True的话，允许在开发者模式之外也使用快速跳过。

.. var:: config.file_open_callback = None

    若非None，这项是一个函数，当某个文件需要被打开是会调用该函数。函数会返回一个类似文件的对象，或者使用Ren'Py的文件加载机制时返回None。类似文件的对象必须能用使用read、seed、tell和close方法。

    对应的，还需要定义 :var:`config.loadable_callback` 。

.. var:: config.focus_crossrange_penalty = 1024

    当用键盘移动焦点时，这是应用于垂直于所选运动方向的移动的惩罚量。

.. var:: config.gl_enable = True

    将这项设置为False即禁用OpenGL加速。如果检测系统不支持OpenGL加速时，OpenGL加速会自动关闭，所以通常没有必要将这项设置为False。

    启动时持续按住shift键也能手工禁用OpenGL。

.. var:: config.gl_resize = True

    决定是否允许用户调整OpenGL绘制窗口的大小。

.. var:: config.hard_rollback_limit = 100

    Ren'Py允许用会回滚的最大步数。这项设置为0则完全不允许回滚。我们不推荐这样做，因为回滚是用户错误使用跳过功能后，回看之前文本的有效途径。

.. var:: config.help = "README.html"

    在主菜单和游戏菜单，或者按下f1，或者在命令行界面输入“?”，都会调用配置的帮助页面文件。

    若为None，帮助系统会禁用，不会显示在菜单中。如果在脚本中有一个help脚本标签(label)，调用标签时会使用另一个新的上下文(context)。这允许创作者定义自己的游戏内帮助界面。否则的话，help文本标签(label)会关联一个在基础目录中的文件，能够在web浏览器中打开。

.. var:: config.hide = renpy.hide

    当 :ref:`hide语句 <hide-statement>`
    执行时调用的函数。这项使用与renpy.hide一样的入参。

.. var:: config.imagemap_auto_function = ...

    将界面语言中
    :ref:`imagebutton <sl-imagebutton>` 或 :ref:`imagemap <sl-imagemap>` 
    `auto` 特性(property)扩展为可视组件。这个函数使用auto特性(property)值和使用的图像，以及下列状态之一：“insensitive”、“idle”、“hover”、“selected_idle”、“selected_hover”、“ground”。函数返回一个可视组件对象或None。

    默认的使用方法是使用图像格式化 `auto` 特性，并检查得到的文件名是否存在。

.. var:: config.imagemap_cache = True

    若为True，imagemap的热点(hotspot)会缓存到PNG文件中，减少时间和内存消耗，但会增加整个游戏的磁盘空间大小。设置为False可以禁用该功能。

.. var:: config.implicit_with_none = True

    若为True，也就是默认值，等效于每次通过对话、菜单输入和imagemap等互动行为之后都使用了 :ref:`with None <with-none>`
    语句。这项用于确保在转场之后旧的界面不再显示。

.. var:: config.interact_callbacks = ...

    一个(不带入参的)回调函数列表，当互动行为开始或重新开始时调用列表中的函数。

.. var:: config.keep_running_transform = True

    若为True，上一个图像使用的transform或ATL语句块(block)会沿用，前提是新图像使用相同的图像标签(tag)。若为False，transform会被停用。

.. var:: config.keymap = dict(...)

    这个配置项是一个字典，包含了键盘按键和鼠标按键跟每个操作之间的映射关系。详见Keyman章节内容。

.. var:: config.label_callback = None

    若非None，这是到达某个脚本标签(label)后会调用的函数。调用时使用两个参数。第一个参数是脚本标签(label)名。第二个参数在通过jump、call或创建新上下文(context)的情况下为True，其他情况下为False。

.. var:: config.label_overrides = { }

    这项配置给出了在Ren'Py脚本中jump和call脚本标签(label)时，重定向到其他脚本标签(label)的方法。例如，如果你需要添加一个“start”到“mystart”的映射关系，所有jump和call到“start”标签最终都会转到“mystart”。

.. var:: config.layer_clipping = { }

    控制图层(layer)剪裁。这是一个从图层名称到(x, y, height, width)元组的映射关系，其中x和y的值是从图层左上角开始计算的坐标值，height和width是图层的高和宽。

    如果某个图层没有在config.layer_clipping中提及，则假设这个图层使用整个界面。

.. var:: config.layers = [ 'master', 'transient', 'screens', 'overlay' ]

    这个配置项是一个所有Ren'Py已知图层(layer)的列表，按这些图层在界面的显示顺序排列。(列表中第一个元素就是最底部的图层。)Ren'Py内部会使用“master”、“transient”、“screens”和“overlay”图层，所以这些图层应该总是保存在这个列表中。

.. var:: config.lint_hooks = ...

    当lint工具运行时，不使用入参被调用的函数列表。这些函数用于检查脚本数据是否有错误，并在标准输出打印找到的错误(这种情况下使用Python的print语句就行)。

.. var:: config.load_before_transition = True

    若为True，互动行为的启动会延迟到所用到的所有图像都加载完毕之后。(是的，这个名字很让人讨厌。)

.. var:: config.loadable_callback = None

    若非None，该函数调用时带一个文件名。当文件可以加载时，函数返回True，否则返回False。这个函数可以跟
    :var:`config.file_open_callback` 或 :var:`config.missing_image_callback` 协同生效。

.. var:: config.log_width = 78

    使用 :var:`config.log`  时，每行日志的宽度。

.. var:: config.longpress_duration = 0.5

    在触控设备上，用户需要按住屏幕多少时间才会被认为是一次长按操作。

.. var:: config.longpress_radius = 15

    在触控设备上，用户长按需要维持的最小像素数量。

.. var:: config.longpress_vibrate = .1

    在触控设备上，用户长按操作后的震动时长。

.. var:: config.log = None

    若非None，这项应该是一个文件名。通过 :ref:`say <say-statement>` 或 :ref:`menu
    <menu-statement>` 语句展示给用户的文本都会记录在这个文件中。

.. var:: config.missing_image_callback = None

    若非None，当加载图片失败时会调用这个函数。函数可能返回None，也可能返回一个图像操作器(manipulator)。如果返回的是图像操作器，可以使用图像操作器代替丢失的图片。

    创作者可能需要同时配置 :var:`config.loadable_callback` 的值，特别是使用 :func:`DynamicImage` 对象的情况。

.. var:: config.missing_label_callback = None

    若非None，当Ren'Py尝试转到某个不存在的脚本标签(label)时，配置的函数会被调用。该函数会返回一个脚本标签名称，用以代替那个丢失的脚本标签。若Ren'Py抛出异常(exception)时则返回None。

.. var:: config.mouse_hide_time = 30

    在配置的时间值内没有鼠标操作就隐藏鼠标指针，单位为秒。这项应该配置成比读取一个界面的期望时间长，这样鼠标用户就不会遇到鼠标消失的时间比鼠标显示时间更长的情况。

    若为None，鼠标指针永远不会隐藏。

.. var:: config.movie_mixer = "music"

    当某个 :func:`Movie` 对象自动定义的视频播放通道所使用的混合器(mixer)。

.. var:: config.new_translate_order = True

    启用新的style和translate语句命令，详见
    :ref:`Ren'Py 6.99.11 <renpy-6.99.11>`。

.. var:: config.new_substitutions = True

    若为True，Ren'Py会将应用新形式(圆括号)替换(substitution)所有显示的文本上。

.. var:: config.old_substitutions = False

    若为True，Ren'Py会将应用旧形式(百分号)替换(substitution) :ref:`say <say-statement>` 和 :ref:`menu
    <menu-statement>` 语句中显示的文本。

.. var:: config.overlay_during_with = True

    如果我们想要在 :ref:`with 语句 <with-statement>` 覆盖已显示图像就设置为True，如果我们想要在with语句中隐藏重叠部分就设置为False。

.. var:: config.overlay_layers = [ 'overlay' ]

    这项是一个所有可覆盖图层(layer)的列表。可覆盖图层在overlay函数调用前会被清空。“overlay”图层应该总是放在这个列表中。

.. var:: config.per_frame_screens = [ ... ]

    这项是一个界面名字符串的列表，列表内的界面会在每一帧都更新，而不是每次互动后更新。Ren'Py内部使用这个列表。所以创作者需要在这个列表中添加界面名，而不是整个替换原列表。

.. var:: config.periodic_callback = None

    若非None，这项应该是一个函数。这个函数会以20Hz的频率被不断调用，不带任何入参。

.. var:: config.play_channel = "audio"

    被 :func:`renpy.play`、
    :propref:`hover_sound` 和 :propref:`activate_sound` 使用的音频通道名称。

.. var:: config.predict_statements = 10

    这是一个语句的数量值，包括当前语句，会被检查是否执行图像预加载。从当前语句开始执行广度优先搜索，直到包含配置数量的语句。在这个范围内的语句引用的图像都会在后台预先加载。将这项设置为0会禁用图像预加载功能。

.. var:: config.profile = False

    若设置为True，某些档案(profile)信息会输出到stdout标准输出。

.. var:: config.quit_on_mobile_background = False

    若为True，当移动app退出时，就会失去焦点。

.. var:: config.rollback_enabled = True

    设置是否允许用户在游戏中回滚(rollback)。若设置为False，用户不能主动回滚。

.. var:: config.rollback_length = 128

    当回滚(rollback)日志中存在超过这个配置项数量的语句时，Ren'Py会修剪日志。这也包括脚本改变导致的读取存档时，Ren'Py会回滚的最大步数。

    将这项设置得比默认值更低可能会导致Ren'Py运行不稳定。

.. var:: config.rollback_side_size = .2

	如果侧回滚被启用，则侧回滚的屏幕部分被单击或触摸时会导致回滚。

.. var:: config.say_allow_dismiss = None

    若非None，这应是一个函数。当用户尝试dismiss某个 :ref:`say 语句 <say-statement>` 时，该函数会被调用，不使用任何入参。如果该函数返回True就允许dismiss，否则就忽略。

.. var:: config.say_layer = "screens"

    显示say界面的图层(layer)。

.. var:: config.say_menu_text_filter = None

    若非None，这是一个函数，返回 :ref:`say <say-statement>` 和 :ref:`menu
    <menu-statement>` 语句中的指定文本。这个函数用于返回新的(或者相同的)字符串替换原来的字符串。

.. var:: config.say_sustain_callbacks = ...

    不使用入参调用的函数列表，在某行带pause分句的对话中，第二次或之后其他互动行为时被调用。该函数用于在暂停状态保持语音播放。

.. var:: config.save_dump = False

   如果设置为True，存档时Ren'Py会创建文件save_dump.txt。生成的文件包含所有存档文件中的对象。每一行包含相关的占用空间估测，对象路径，某个对象是否别名的信息，以及对象的行为表现。

.. var:: config.save_on_mobile_background = True

    若为True，移动app会在失去焦点时保存自身状态。保存状态的方式需要在app重新启动后能自动读档(并回复进度)。

.. var:: config.save_physical_size = True

    若为True，窗口的物理尺寸会保存在环境设定(preference)中，并在游戏挂起时保存。

.. var:: config.savedir = ...

    存档目录的完整路径。这只能在前面的Python语句中配置。同样的情况也存在于config.save_directory。

.. var:: config.scene = renpy.scene

    在 :ref:`scene 语句 <scene-statement>` 用于代替renpy.scene的函数。需要注意，这个函数用于清空界面，config.show用于显示某个新图像。这个函数具有与renpy.scene相同的签名(signature)。

.. var:: config.screenshot_callback = ...

    发生截屏时调用的函数。调用该函数时带一个参数，即截屏保存的完整文件名。

.. var:: config.screenshot_crop = None

    若非None，这项应是一个(x, y, height, width)元组。截屏会在保存前剪裁为元组描述的矩形。

.. var:: config.screenshot_pattern = "screenshot%04d.png"

    用作创建截屏文件的正则表达式。这个(使用Python的格式规则)表达式应用自然数列生成一个文件名序列。生成的文件名是绝对路径，或与config.renpy_base关联。首个当前不存在的文件名会用作截屏的文件名。

.. var:: config.script_version = None

    若非None，这被解释为脚本的版本号。库(library)会根据脚本版本号启用适合的特性(feature)。若为None，我们假设脚本版本为最新。

    通常这项是项目构建时由Ren'Py启动器(launcher)自动添加在某个文件中。

.. var:: config.searchpath = [ 'common', 'game' ]

    一个目录列表，用于在这些目录下搜索图片、音乐、归档及其他媒体文件，但不包括脚本文件。这项会初始化为包含“common”和游戏目录的一个列表。

.. var:: config.search_prefixes = [ "", "images/" ]

    搜索的文件名前添加的前缀列表。

.. var:: config.show = renpy.show

    在 :ref:`show
    <show-statement>` 和 :ref:`scene <scene-statement>` 语句中中用于代替renpy.show的函数。这个函数具有与renpy.show相同的签名(signature)。

.. var:: config.skip_delay = 75

    当使用ctrl键跳过语句时，每段对话显示的时间，单位为毫秒。(实际上只是接近配置的值。)

.. var:: config.skip_indicator = True

    若为True，当使用脚本跳过功能时，库(library)会显示一个跳过提醒标志。

.. var:: config.sound = True

    若为True，使用声音。若为False，声音/混合器子系统完全禁用。

.. var:: config.sound_sample_rate = 48000

    声卡运行的采样率。如果你的所有wav文件都使用更低的采样率，修改这项配置可能会改善播放效果。

.. var:: config.start_callbacks = [ ... ]

    一个回调函数列表，列表内函数的调用时机在初始化环节之后，但在游戏开始之前，调用时不带参数。这主要通过framework用于初始化需要保存的变量。

    这个配置项的默认值包含了Ren'Py内部使用的回调函数，以支持nvl模式特性等。新的回调函数可以添加到这个列表，但已存在的回调函数不能删除。

.. var:: config.start_interact_callbacks = ...

    一个函数列表，当某个互动行为开始后(不带入参)被调用。某个互动行为重新开始的情况下，这些回调函数不会被调用。

.. var:: config.top_layers = [ ]

    一个图层(layer)名的列表，该列表中的图层会显示在其他所有图层上面，并且不接受应用于所有图层上的转场(transition)。如果某个图层名位于这里列表中，它就不能再存在于列表config.layers中。

.. var:: config.transient_layers = [ 'transient' ]

    这项变量是一个所有临时(transient)图层的列表。临时图层会在每次互动行为后被清空。“transient”应该总是保留在这个列表中。

.. var:: config.transform_uses_child_position = True

    若为True，transform会从他们的子类继承 :ref:`position properties
    <position-style-properties>` 若不是True，就不继承。

.. var:: config.transition_screens = True

    若为True，界面会接受转场(transition)效果，使用溶解(dissolve)从旧的界面状态转为新的界面状态。若为False，只有界面的最新状态会被显示。

.. var:: config.translate_clean_stores = [ "gui" ]

    一个命名存储区的列表。当使用的语言改变时，列表内存储区的状态会清除并恢复为初始化阶段的值。

.. var:: config.variants = [ ... ]

    一个变换界面列表，用于搜索并选取向用户显示的界面。列表最后的元素总是None，确保能选到默认界面。详见 :ref:`界面变种 <screen-variants>`。

.. var:: config.voice_filename_format = "{filename}"

    这项配置的字符串会自动用voice语句的入参字符串替换“filename”，并作为向用户播放的语音文件名使用。例如，如果这里配置的是“{filename}.ogg”，那么  ``voice "test"`` 语句就会播放“test.ogg”文件。

.. var:: config.with_callback = None

    若非None，这项应该是一个函数，会在使用 :ref:`with
    语句 <with-statement>` 时被调用。这个函数可以在转场(transition)过程中对添加在界面上的临时元素做出响应。转场(transition)过程中，调用该函数时使用一个入参。该函数会返回一个转场(transition)，可能就是作为入参的那个转场，也可能不是。

.. _garbage-collection:

垃圾回收(GC)
------------------

这些配置项允许创作者调整Python的垃圾回收(GC)和Ren'Py对Python垃圾回收管理器。

.. var:: config.manage_gc = True

    若为True，Ren'Py会自己管理GC。这意味着Ren'Py使用以下设置。

.. var:: config.gc_thresholds = (25000, 10, 10)

    非空闲(idle)状态下Ren'Py使用的GC阈值。这样设置会尝试确保GC不会发生。这三个数值分别表示：

    * level-0回收的对象净数。
    * 触发level-1回收的level-0回收次数。
    * 触发level-2回收的level-1回收次数。

    (level-0回收应该足够快，不会引发掉帧。level-1回收速度可能会引发掉帧，level-2则不会引发掉帧。)

.. var:: config.idle_gc_count = 2500

    当Ren'Py到达一个稳定状态时，触发GC的对象净数。(稳定状态是指界面更新第四帧之后)

.. var:: gc_print_unreachable = False

    若为True，Ren'Py会在控制台和日志中打印出触发GC的对象信息。
