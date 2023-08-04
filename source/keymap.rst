.. _keymap:

定制按键映射
======================

配置项 :var:`config.keymap` 中包含一个事件名称与触发事件的keysym的映射关系。

.. note::

    许多用户已经学会了Ren'Py的默认按键绑定，并希望各游戏保持一致。

在Ren'Py的keysym系统中，使用字符串表示鼠标按键、游戏手柄按键和键盘按键。

鼠标按键的keysym格式是‘mouseup_#’或‘mousedown_#’，其中的 # 符号代表按键的编号。Ren'Py假设鼠标有5个按键，其中按键1、2、3分别表示左、中、右键，按键4和5分别表示滚轮的上滑和下滑。例如，“mousedown_1”代表鼠标左键按下，“mouseup_1”表示鼠标左键弹起，“mousedown_4”表示滚轮上滑。

总共有两种键盘的keysym。第一种是字符串里只有一个字符，有某个按键被按下时生成。通常用于绑定字母或数字按键。典型的keysym包括“a”、“A”和“7”等。
注意这里的字母对大小写敏感，“a”与“A”是不同字母。
这种keysym只对能生成文本的事件有用——例如，按键释放时无法匹配到 ``keyup_a``，因为没有产生文本。

键盘keysym也可以是符号或者功能按键。可以是pygame.constants中定义的任意 K\_ 形式常量。这种keysym字符串类似于
"K\_BACKSPACE"、 "K\_RETURN"和 "K\_TAB"；完整的keysym定义详见 `这里 <http://www.pygame.org/docs/ref/key.html>`_。

键盘和鼠标keysym可以使用下列前缀，与后面的字符用下划线分割：

alt
    当alt键被同时按下时匹配。不同时按下alt键的keysym与不带前缀的匹配。

meta
    当meta、command或windows键被同时按下时匹配。不同时按下那些键的keysym与不带前缀的匹配。

ctrl
    当ctrl键被同时按下时匹配。不同时按下ctrl键的keysym与不带前缀的匹配。(ctrl键很少用，因为它通常会触发跳过。)

osctrl
    针对Mac系统的alt键，和其他系统的ctrl键。

shift
    当shift键被同时按下时匹配。

noshift
    当shift键没有被按下时匹配。一个 K\_ 形式keysym忽略shift按键状态。

caps
    当Caps Lock键处于On状态时匹配。

nocaps
    当Caps Lock键处于Off状态时匹配。

num
    当Num Lock键处于On状态时匹配。

nonum
    当Num Lock键处于Off状态时匹配。

repeat
    按键长按状态时，则匹配为repeat。不能长按的keysym或者不带这个前缀的keysym不会匹配到repeat。(鼠标按键无效)

any
    匹配任意按键的按下或持续按下状态。

keydown
    默认情况下，匹配按键被按下状态。

keyup
    匹配按键被释放状态。

例如，keysym “shift_alt_K_F5”，当shift和alt键长按时，再按下F5可以匹配到。


要修改keysym和事件的绑定关系，就需要修改 :var:`config.keymap`。下面的脚本将“t”键添加到按键列表中，作用是dismiss某say语句，并从列表中移除了空格键。

::

    init python:
        config.keymap['dismiss'].append('K_t')
        config.keymap['dismiss'].remove('K_SPACE')

默认的按键映射放在renpy/common/00keymap.rpy文件中，下面是8.1.0版本的配置：

::

    config.keymap = dict(

        # 除非明确禁用，各处都能使用的绑定快捷键。
        rollback = [ 'any_K_PAGEUP', 'any_KP_PAGEUP', 'K_AC_BACK', 'mousedown_4' ],
        screenshot = [ 'alt_K_s', 'alt_shift_K_s', 'noshift_K_s' ],
        toggle_afm = [ ],
        toggle_fullscreen = [ 'alt_K_RETURN', 'alt_K_KP_ENTER', 'K_F11', 'noshift_K_f' ],
        game_menu = [ 'K_ESCAPE', 'K_MENU', 'K_PAUSE', 'mouseup_3' ],
        hide_windows = [ 'mouseup_2', 'noshift_K_h' ],
        launch_editor = [ 'shift_K_e' ],
        dump_styles = [ ],
        reload_game = [ 'alt_K_r', 'shift_K_r' ],
        inspector = [ 'alt_K_i', 'shift_K_i' ],
        full_inspector = [ 'alt_shift_K_i' ],
        developer = [ 'alt_K_d', 'shift_K_d', ],
        quit = [ ],
        iconify = [ ],
        help = [ 'K_F1', 'meta_shift_/' ],
        choose_renderer = ['alt_K_g', 'shift_K_g' ],
        progress_screen = [ 'alt_shift_K_p', 'meta_shift_K_p', 'K_F2' ],
        accessibility = [ 'K_a' ],

        # 数据读取。
        self_voicing = [ 'alt_K_v', 'K_v' ],
        clipboard_voicing = [ 'alt_shift_K_c', 'shift_K_c' ],
        debug_voicing = [ 'alt_shift_K_v', 'meta_shift_K_v' ],

        # say相关。
        rollforward = [ 'any_K_PAGEDOWN', 'any_KP_PAGEDOWN', 'mousedown_5', ],
        dismiss = [ 'K_RETURN', 'K_SPACE', 'K_KP_ENTER', 'K_SELECT', 'mouseup_1' ],
        dismiss_unfocused = [ ],

        # 暂停。
        dismiss_hard_pause = [ ],

        # 焦点相关。
        focus_left = [ 'any_K_LEFT', 'any_KP_LEFT' ],
        focus_right = [ 'any_K_RIGHT', 'any_KP_RIGHT' ],
        focus_up = [ 'any_K_UP', 'any_KP_UP' ],
        focus_down = [ 'any_K_DOWN', 'any_KP_DOWN' ],

        # 按钮。
        button_ignore = [ 'mousedown_1' ],
        button_select = [ 'K_RETURN', 'K_KP_ENTER', 'K_SELECT', 'mouseup_1',  ],
        button_alternate = [ 'mouseup_3' ],
        button_alternate_ignore = [ 'mousedown_3' ],

        # 输入。
        input_backspace = [ 'any_K_BACKSPACE' ],
        input_enter = [ 'K_RETURN', 'K_KP_ENTER' ],
        input_next_line = [ 'shift_K_RETURN', 'shift_K_KP_ENTER' ],
        input_left = [ 'any_K_LEFT', 'any_KP_LEFT' ],
        input_right = [ 'any_K_RIGHT', 'any_KP_RIGHT' ],
        input_up = [ 'any_K_UP', 'any_KP_UP' ],
        input_down = [ 'any_K_DOWN', 'any_KP_DOWN' ],
        input_delete = [ 'any_K_DELETE', 'any_KP_DELETE' ],
        input_home = [ 'K_HOME', 'KP_HOME', 'meta_K_LEFT' ],
        input_end = [ 'K_END', 'KP_END', 'meta_K_RIGHT' ],
        input_copy = [ 'ctrl_noshift_K_INSERT', 'ctrl_noshift_K_c', 'meta_noshift_K_c' ],
        input_paste = [ 'shift_K_INSERT', 'ctrl_noshift_K_v', 'meta_noshift_K_v' ],
        input_jump_word_left = [ 'osctrl_K_LEFT', 'osctrl_KP_LEFT' ],
        input_jump_word_right = [ 'osctrl_K_RIGHT', 'osctrl_KP_RIGHT' ],
        input_delete_word = [ 'osctrl_K_BACKSPACE' ],
        input_delete_full = [ 'meta_K_BACKSPACE' ],

        # 视口。
        viewport_leftarrow = [ 'any_K_LEFT', 'any_KP_LEFT' ],
        viewport_rightarrow = [ 'any_K_RIGHT', 'any_KP_RIGHT' ],
        viewport_uparrow = [ 'any_K_UP', 'any_KP_UP' ],
        viewport_downarrow = [ 'any_K_DOWN', 'any_KP_DOWN' ],
        viewport_wheelup = [ 'mousedown_4' ],
        viewport_wheeldown = [ 'mousedown_5' ],
        viewport_drag_start = [ 'mousedown_1' ],
        viewport_drag_end = [ 'mouseup_1' ],
        viewport_pageup = [ 'any_K_PAGEUP', 'any_KP_PAGEUP'],
        viewport_pagedown = [ 'any_K_PAGEDOWN', 'any_KP_PAGEDOWN' ],

        # 这些按键控制跳过。
        skip = [ 'K_LCTRL', 'K_RCTRL' ],
        stop_skipping = [ ],
        toggle_skip = [ 'K_TAB' ],
        fast_skip = [ '>', 'shift_K_PERIOD' ],

        # Bar。
        bar_activate = [ 'mousedown_1', 'K_RETURN', 'K_KP_ENTER', 'K_SELECT' ],
        bar_deactivate = [ 'mouseup_1', 'K_RETURN', 'K_KP_ENTER', 'K_SELECT' ],
        bar_left = [ 'any_K_LEFT', 'any_KP_LEFT' ],
        bar_right = [ 'any_K_RIGHT', 'any_KP_RIGHT' ],
        bar_up = [ 'any_K_UP', 'any_KP_UP' ],
        bar_down = [ 'any_K_DOWN', 'any_KP_DOWN' ],


        # 删除存档。
        save_delete = [ 'K_DELETE', 'KP_DELETE' ],

        # 可拖拽组件。
        drag_activate = [ 'mousedown_1' ],
        drag_deactivate = [ 'mouseup_1' ],

        # 调试控制台。
        console = [ 'shift_K_o', 'alt_shift_K_o' ],
        console_older = [ 'any_K_UP', 'any_KP_UP' ],
        console_newer = [ 'any_K_DOWN', 'any_KP_DOWN' ],

        # 编导器
        director = [ 'noshift_K_d' ],

        # 忽略(保持后向兼容)。
        toggle_music = [ ],
        viewport_up = [ ],
        viewport_down = [ ],

        # Profile命令。
        performance = [ 'K_F3' ],
        image_load_log = [ 'K_F4' ],
        profile_once = [ 'K_F8' ],
        memory_profile = [ 'K_F7' ],

        )

手柄的绑定工作会有一点不同。手柄绑定会将一个事件映射为一个或多个Ren'Py事件名。默认的手柄绑定设置如下：

::

    config.pad_bindings = {
        "pad_leftshoulder_press" : [ "rollback", ],
        "pad_lefttrigger_pos" : [ "rollback", ],
        "pad_back_press" : [ "rollback", ],

        "repeat_pad_leftshoulder_press" : [ "rollback", ],
        "repeat_pad_lefttrigger_pos" : [ "rollback", ],
        "repeat_pad_back_press" : [ "rollback", ],

        "pad_guide_press" : [ "game_menu", ],
        "pad_start_press" : [ "game_menu", ],

        "pad_y_press" : [ "hide_windows", ],

        "pad_rightshoulder_press" : [ "rollforward", ],
        "repeat_pad_rightshoulder_press" : [ "rollforward", ],

        "pad_righttrigger_pos" : [ "dismiss", "button_select", "bar_activate", "bar_deactivate" ],
        "pad_a_press" : [ "dismiss", "button_select", "bar_activate", "bar_deactivate"],
        "pad_b_press" : [ "button_alternate" ],

        "pad_dpleft_press" : [ "focus_left", "bar_left", "viewport_leftarrow" ],
        "pad_leftx_neg" : [ "focus_left", "bar_left", "viewport_leftarrow" ],
        "pad_rightx_neg" : [ "focus_left", "bar_left", "viewport_leftarrow" ],

        "pad_dpright_press" : [ "focus_right", "bar_right", "viewport_rightarrow" ],
        "pad_leftx_pos" : [ "focus_right", "bar_right", "viewport_rightarrow" ],
        "pad_rightx_pos" : [ "focus_right", "bar_right", "viewport_rightarrow" ],

        "pad_dpup_press" : [ "focus_up", "bar_up", "viewport_uparrow" ],
        "pad_lefty_neg" : [ "focus_up", "bar_up", "viewport_uparrow" ],
        "pad_righty_neg" : [ "focus_up", "bar_up", "viewport_uparrow" ],

        "pad_dpdown_press" : [ "focus_down", "bar_down", "viewport_downarrow" ],
        "pad_lefty_pos" : [ "focus_down", "bar_down", "viewport_downarrow" ],
        "pad_righty_pos" : [ "focus_down", "bar_down", "viewport_downarrow" ],

        "repeat_pad_dpleft_press" : [ "focus_left", "bar_left", "viewport_leftarrow" ],
        "repeat_pad_leftx_neg" : [ "focus_left", "bar_left", "viewport_leftarrow" ],
        "repeat_pad_rightx_neg" : [ "focus_left", "bar_left", "viewport_leftarrow" ],

        "repeat_pad_dpright_press" : [ "focus_right", "bar_right", "viewport_rightarrow" ],
        "repeat_pad_leftx_pos" : [ "focus_right", "bar_right", "viewport_rightarrow" ],
        "repeat_pad_rightx_pos" : [ "focus_right", "bar_right", "viewport_rightarrow" ],

        "repeat_pad_dpup_press" : [ "focus_up", "bar_up", "viewport_uparrow" ],
        "repeat_pad_lefty_neg" : [ "focus_up", "bar_up", "viewport_uparrow" ],
        "repeat_pad_righty_neg" : [ "focus_up", "bar_up", "viewport_uparrow" ],

        "repeat_pad_dpdown_press" : [ "focus_down", "bar_down", "viewport_downarrow" ],
        "repeat_pad_lefty_pos" : [ "focus_down", "bar_down", "viewport_downarrow" ],
        "repeat_pad_righty_pos" : [ "focus_down", "bar_down", "viewport_downarrow" ],
    }

手柄按键的事件名格式是“pad_*button*_press”和“pad_*button*_release”。
模拟摇杆事件格式是“pad_*axis*_pos”、“pad_*axis*_neg”和“pad_*axis*_zero”。
持续按住某个按键时，游戏手柄会生成另一个事件，前缀为“repeat\_”。

Gamepads that do not work without special initialization are disabled by
default. This includes the Nintendo Switch Pro Controller, which requires
special initialization to work on a PC. This blocklisting is controlled by
:var:`config.controller_blocklist`.
可以不执行特定初始流程就能使用手柄，但默认禁用该项功能。
包括任天堂Switch的Pro手柄，在电脑上使用时会要求特殊的初始化流程。
控制器黑名单详见 :var:`config.controller_blocklist` 。

.. :function:: renpy.clear_keymap_cache()

    清空按键映射缓存。可以不重启Ren'Py的情况下更改 :var:`config.keymap` 并直接生效。