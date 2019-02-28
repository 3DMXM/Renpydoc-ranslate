.. _keymap:

定制按键映射
======================

配置项 :var:`config.keymap` 中包含一个事件名称与触发事件的快捷键系统的映射关系。

.. note::

    许多用户已经学会了Ren'Py的默认按键绑定，并希望各游戏保持一致。

在Ren'Py快捷键系统中，使用字符串表示鼠标按键、游戏手柄按键和键盘按键。

鼠标按键的快捷键格式是‘mouseup_#’或‘mousedown_#’，其中的 # 符号代表按键的编号。Ren'Py假设鼠标有5个按键，其中按键1、2、3分别表示左、中、右键，按键4和5分别表示滚轮的上滑和下滑。例如，“mousedown_1”代表鼠标左键按下，“mouseup_1”表示鼠标左键弹起，“mousedown_4”表示滚轮上滑。

总共有两种键盘的快捷键。第一种是字符串里只有一个字符，有某个按键被按下时生成。通常用于绑定字母或数字按键。典型的快捷键包括“a”、“A”和“7”等。

键盘快捷键也可以是符号或者功能按键。可以是pygame.constants中定义的任意 K\_ 形式常量。这种快捷键字符串类似于
"K\_BACKSPACE"、 "K\_RETURN"和 "K\_TAB"；完整的快捷键定义详见 `这里 <http://www.pygame.org/docs/ref/key.html>`_。

键盘快捷键可以使用下列前缀，与后面的字符用下划线分割：

alt
    当alt键被同时按下时匹配。不同时按下alt键的快捷键与不带前缀的匹配。
meta
    当meta、command或windows键被同时按下时匹配。不同时按下那些键的快捷键与不带前缀的匹配。
ctrl
    当ctrl键被同时按下时匹配。不同时按下ctrl键的快捷键与不带前缀的匹配。(ctrl键很少用，因为它通常会触发跳过。)
shift
    当shift键被同时按下时匹配。
noshift
    当shift键没有被按下时匹配。一个 K\_ 形式快捷键忽略shift按键状态。
repeat
    由于按键始终处于按下状态时，则匹配为repeat。不带这个前缀的快捷键不会匹配到repeat。

例如，快捷键“shift_alt_K_F5”，当shift和alt键一直按下时，按下F5可以匹配到。


要修改快捷键和事件的绑定关系，就需要修改 :var:`config.keymap`。下面的脚本将“t”键添加到按键列表中，作用是dismiss某say语句，并从列表中移除了空格键。

::

    init:
        $ config.keymap['dismiss'].append('t')
        $ config.keymap['dismiss'].remove('K_SPACE')

默认的按键映射放在renpy/common/00keymap.rpy文件中，下面是6.99版本的配置：

::

    config.keymap = dict(

        # 除非明确禁用，各处都能使用的绑定快捷键。
        rollback = [ 'K_PAGEUP', 'repeat_K_PAGEUP', 'K_AC_BACK', 'mousedown_4' ],
        screenshot = [ 's' ],
        toggle_afm = [ ],
        toggle_fullscreen = [ 'f', 'alt_K_RETURN', 'alt_K_KP_ENTER', 'K_F11' ],
        game_menu = [ 'K_ESCAPE', 'K_MENU', 'mouseup_3' ],
        hide_windows = [ 'mouseup_2', 'h' ],
        launch_editor = [ 'E' ],
        dump_styles = [ ],
        reload_game = [ 'R' ],
        inspector = [ 'I' ],
        full_inspector = [ 'alt_I' ],
        developer = [ 'D' ],
        quit = [ ],
        iconify = [ ],
        help = [ 'K_F1', 'meta_shift_/' ],
        choose_renderer = [ 'G' ],
        progress_screen = [ 'alt_shift_K_p', 'meta_shift_K_p', 'K_F2' ],

        # 数据接入能力。
        self_voicing = [ 'v', 'V' ],
        clipboard_voicing = [ 'C' ],
        debug_voicing = [ 'alt_V', 'meta_V' ],

        # say相关。
        rollforward = [ 'mousedown_5', 'K_PAGEDOWN', 'repeat_K_PAGEDOWN' ],
        dismiss = [ 'mouseup_1', 'K_RETURN', 'K_SPACE', 'K_KP_ENTER', 'K_SELECT' ],
        dismiss_unfocused = [ ],

        # 暂停。
        dismiss_hard_pause = [ ],

        # 焦点相关。
        focus_left = [ 'K_LEFT', 'repeat_K_LEFT' ],
        focus_right = [ 'K_RIGHT', 'repeat_K_RIGHT' ],
        focus_up = [ 'K_UP', 'repeat_K_UP' ],
        focus_down = [ 'K_DOWN', 'repeat_K_DOWN' ],

        # 按钮。
        button_ignore = [ 'mousedown_1' ],
        button_select = [ 'mouseup_1', 'K_RETURN', 'K_KP_ENTER', 'K_SELECT' ],
        button_alternate = [ 'mouseup_3' ],
        button_alternate_ignore = [ 'mousedown_3' ],

        # 输入。
        input_backspace = [ 'K_BACKSPACE', 'repeat_K_BACKSPACE' ],
        input_enter = [ 'K_RETURN', 'K_KP_ENTER' ],
        input_left = [ 'K_LEFT', 'repeat_K_LEFT' ],
        input_right = [ 'K_RIGHT', 'repeat_K_RIGHT' ],
        input_up = [ 'K_UP', 'repeat_K_UP' ],
        input_down = [ 'K_DOWN', 'repeat_K_DOWN' ],
        input_delete = [ 'K_DELETE', 'repeat_K_DELETE' ],
        input_home = [ 'K_HOME' ],
        input_end = [ 'K_END' ],
        input_copy = [ 'ctrl_K_INSERT', 'ctrl_K_c' ],
        input_paste = [ 'shift_K_INSERT', 'ctrl_K_v' ],

        # 视口。
        viewport_leftarrow = [ 'K_LEFT', 'repeat_K_LEFT' ],
        viewport_rightarrow = [ 'K_RIGHT', 'repeat_K_RIGHT' ],
        viewport_uparrow = [ 'K_UP', 'repeat_K_UP' ],
        viewport_downarrow = [ 'K_DOWN', 'repeat_K_DOWN' ],
        viewport_wheelup = [ 'mousedown_4' ],
        viewport_wheeldown = [ 'mousedown_5' ],
        viewport_drag_start = [ 'mousedown_1' ],
        viewport_drag_end = [ 'mouseup_1' ],

        # 这些按键控制跳过。
        skip = [ 'K_LCTRL', 'K_RCTRL' ],
        stop_skipping = [ ],
        toggle_skip = [ 'K_TAB' ],
        fast_skip = [ '>' ],

        # Bar。
        bar_activate = [ 'mousedown_1', 'K_RETURN', 'K_KP_ENTER', 'K_SELECT' ],
        bar_deactivate = [ 'mouseup_1', 'K_RETURN', 'K_KP_ENTER', 'K_SELECT' ],
        bar_left = [ 'K_LEFT', 'repeat_K_LEFT' ],
        bar_right = [ 'K_RIGHT', 'repeat_K_RIGHT' ],
        bar_up = [ 'K_UP', 'repeat_K_UP' ],
        bar_down = [ 'K_DOWN', 'repeat_K_DOWN' ],

        # 删除存档。
        save_delete = [ 'K_DELETE' ],

        # 可拖拽组件。
        drag_activate = [ 'mousedown_1' ],
        drag_deactivate = [ 'mouseup_1' ],

        # 调试控制台。
        console = [ 'shift_O' ],
        console_older = [ 'K_UP', 'repeat_K_UP' ],
        console_newer = [ 'K_DOWN', 'repeat_K_DOWN'],

        # 忽略(保持后向兼容)。
        toggle_music = [ 'm' ],
        viewport_up = [ 'mousedown_4' ],
        viewport_down = [ 'mousedown_5' ],

        # Profile命令。
        profile_once = [ 'K_F8' ],
        memory_profile = [ 'K_F7' ],

        )

手柄的绑定工作会有一点不同。手柄绑定会将一个事件映射为一个或多个Ren'Py事件名。默认的手柄绑定设置如下：

::

    config.pad_bindings = {
        "pad_leftshoulder_press" : [ "rollback", ],
        "pad_lefttrigger_pos" : [ "rollback", ],
        "pad_back_press" : [ "rollback", ],

        "pad_guide_press" : [ "game_menu", ],
        "pad_start_press" : [ "game_menu", ],

        "pad_y_press" : [ "hide_windows", ],

        "pad_rightshoulder_press" : [ "rollforward", ],

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
        "pad_lefty_neg" :  [ "focus_up", "bar_up", "viewport_uparrow" ],
        "pad_righty_neg" : [ "focus_up", "bar_up", "viewport_uparrow" ],

        "pad_dpdown_press" : [ "focus_down", "bar_down", "viewport_downarrow" ],
        "pad_lefty_pos" : [ "focus_down", "bar_down", "viewport_downarrow" ],
        "pad_righty_pos" : [ "focus_down", "bar_down", "viewport_downarrow" ],
    }

手柄按键的事件名格式是“pad_*button*_press”和“pad_*button*_release”。模拟摇杆事件格式是“pad_*axis*_pos”、“pad_*axis*_neg”和“pad_*axis*_zero”。
