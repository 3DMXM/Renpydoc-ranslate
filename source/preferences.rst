.. _preference-variables:

====================
环境设定配置
====================

环境设定配置存储在Ren'Py的环境设定(preference)中。由于环境设定的值被设置为实时使用 :func:`Preference` 行为，环境设定配置应该使用default语句来设置环境设定的默认值。

举例：

::

    default preferences.text_cps = 40

设置默认的每秒显示字符数为40。在环境设定值已经修改过的情况下，使用default语句修改环境设定值才会直接生效。例如，如果用户将cps设置为50，以后运行时cps将保持为50。如果之后还有使用default语句修改cps为42，那么用户的设置就会修改为42。(之后用户可以再次修改。)

.. var:: preferences.afm_after_click = False

    若为True，自动前进模式在遇到点击事件消息会保持。若为False，点击会终止自动前进模式。等效于“auto-forward after click”环境设定设置。

.. var:: preferences.afm_enable = False

    若为True，自动前进移动启用。否则禁用。
    等效于“auto-forward time”环境设置。

.. var:: preferences.afm_time = 15

    自动前进模式的等待时间。这个值越大，等待时间越长。由于文本分段等消耗，转为时钟时间(wall time)的机制比较复杂。等效于“auto-forward”环境设定。

.. var:: preferences.desktop_rollback_side = "disable"

    在桌面平台上，触摸或点击窗口边栏就能触发回滚。该项可以设置为“left”、“right”或者“disable”。等效于桌面平台上“rollback side”特性。

.. var:: preferences.mobile_rollback_side = "disable"

    在移动平台上，触摸或点击窗口边栏就能触发回滚。该项可以设置为“left”、“right”或者“disable”。等效于移动平台上“rollback side”特性。

.. var:: preferences.language = None

    游戏运行时供玩家选择的语言。
    该值为None表示默认语言，也可以是字符串，表示支持的其他语言。

    该项用于设置默认语言类型，也可以读取该值后决定当前使用语言。行为 :func:`Language` 可用于修改语言类型。

    详见 :doc:`translation`。

.. var:: preferences.emphasize_audio = False

    若为True，Ren'Py会通过降低 :var:`config.emphasize_audio_channels`
    列表中之外的音频通道音量，来加强那个列表中的通道。(例如，播放语音时降低音乐的音量)。若为False，就不做加强。

.. var:: preferences.fullscreen = False

    Ren'Py使用全屏模式时设置为True，以窗口模型运行时设置为False。等效于“display”环境设定。

.. var:: preferences.gl_framerate = None

    这项可能是一个整数，或者None。如果非None，这是Ren'Py希望达到的目标帧率。如果这项设置得比较低(例如，30)，而显示设备使用一个比较高的帧率，Ren'Py会每两帧绘制一次图像。

    若为None，Ren'Py会尝试使用显示设备的当前最高帧率绘制图像。

.. var:: preferences.gl_powersave = "auto"

    这项决定了Ren'Py对未改变过的界面的重绘频率。若为True，Ren'Py会每秒绘制界面5次。若为False，Ren'Py会尽可能以最高帧率绘制。若为“auto”，Ren'Py会在设备接通外置电源时使用最高帧率绘制，在设备使用电池运行时降低绘制频率到5Hz。

.. var:: preferences.gl_tearing = False

    这项决定了，无法使用预订的帧率运行时，是使用拖慢(设置为True)还是跳帧(设置为False)。

.. var:: preferences.mouse_move = False

    若为True，鼠标指针会自动移动到选中的按钮上。若为False，则不执行这种操作。等效于环境设定的“automatic move”。

.. var:: preferences.show_empty_window = True

    若为True，widown show和window auto语句将起作用。若为False，这些语句将不生效。等效于环境设定的“show empty window”。

.. var:: preferences.skip_after_choices = False

    若为True，在某个选项之后会恢复跳过(skipping)模式。若为False，选项就会停止Ren'Py的跳过(skipping)模式。等效于环境设定的“after choices”。

.. var:: preferences.skip_unseen = False

    若为True，Ren'Py会仅跳过未看过的文本。若为False，Ren'Py会跳过所有文本。等效于环境设定的“skip”。

.. var:: preferences.text_cps = 0

    文本显示速度。0表示立刻显示所有文本，否则表示每秒显示的字符数。等效于环境设定的“text speed”。

.. var:: preferences.transitions = 2

    决定显示何种转场(transition)。2表示显示所有转场，0表示不显示转场。(1是预留值。)等效于环境设定的“transitions”。

.. var:: preferences.video_image_fallback = False

    若为True，将使用图片代替视频精灵(videosprite)。若为False，视频精灵会正常显示。等效于环境设定的video sprites。

.. var:: preferences.voice_sustain = False

    若为True，语音会保持播放直到结束，或另一句语音播放代替它。若为False，当对话进入下一行则语音播放也结束。等效于环境设定的“voice sustain”。

.. var:: preferences.wait_voice = True

    若为True，自动前进模式会等待语音文件或自动语音播放之后再进入下一句。若为False，则不等待。等效于环境设定的“wait for voice”。

.. var:: preferences.system_cursor = False

    若为True，强制使用系统鼠标光标，忽略 :var:`config.mouse` 和 :var:`config.mouse_displayable` 的值。
    若为False，则不执行这种操作。等效于“system cursor”设置。

.. var:: preferences.audio_when_minimized = True

    若为Fasel，窗口最小化后音频通道停止，当窗口恢复后音频通道恢复。
    若为True，窗口状态与音频无关。等效于“audio when minimized”选项。

.. var:: preferences.audio_when_unfocused = True

    若为False，音频通道会在游戏窗口失去焦点时停止播放声音，在重新获得焦点后恢复。
    若为True，游戏窗口是否获得焦点都不影响声音。等效于设置“audio when unfocused”选项。

.. var:: preferences.web_cache_preload = False

    若为True，游戏文件可以下载到浏览器缓存中，允许游戏离线运行。
    若为False，游戏文件不能下载到浏览器缓存中，必须保持互联网连接才能运行游戏。
    等效于设置“web cache preload”选项。

.. var:: preferences.voice_after_game_menu = False

    若为True，显示游戏菜单时继续播放语音。
    若为False，显示游戏菜单时立刻停止语音。
    等效于设置“voice after menu”选项。

.. _mixer-functions:

混音器函数
---------------

广域混音器的内容详见 :ref:`volume`。

.. function:: preferences.set_mixer(mixer, volume)

    将混音器 `mixer` 的音量值设置为 `volume` 。

    `mixer`
        表示混音器名称的字符串。默认的混音器名称包括“main”、“music”、“sfx”和“voice”(“main”是个特殊混音器)。

    `volume`
        介于0.0到1.0之间的数值。0.0表示-40dB(电平)，1.0表示0dB.

.. function:: preferences.get_mixer(mixer)

    获取混音器 `mixer` 的音量。如果该混音器被静音了，则返回0.0。
    返回值是介于0.0到1.0之间的数值。0.0表示-40dB(电平)，1.0表示0dB.

.. function:: preferences.set_mute(mixer, mute)

    设置混音器 `mixer` 静音状态。如果 `mute` 的值是True，则将混音器 `mixer` 静音。

.. function:: preferences.get_mute(mute)

    获取混音器 `mixer` 的静音设置。


.. _audio-channel-defaults:

音频通道默认配置
-----------------------

这些配置项设置了各种音频混合器(mixer)的默认音量。

.. var:: config.default_music_volume = 1.0

    音乐混合器的默认音量，用于music和movie音频通道。这项值位于0.0和1.0的闭区间内，1.0表示最大音量。

.. var:: config.default_sfx_volume = 1.0

    sfx混合器的默认音量，用于sound音频通道。这项值位于0.0和1.0的闭区间内，1.0表示最大音量。

.. var:: config.default_voice_volume = 1.0

    语音混合器的默认音量，用于voice音频通道(包括voice语句和自动语音)。这项值位于0.0和1.0的闭区间内，1.0表示最大音量。
