.. _voice:

=====
语音
=====

Ren'Py支持对话文本与语音播放的联结。使用voice语句可以实现这个功能，voice语句给定了播放的语音文件： ::

  voice "line0001.ogg"
  "欢迎来到Ren'Py"

通常来说，某个语音会被后面的互动行为中断。voice sustain语句则可以保证语音会播放完毕，即使遇到某个互动行为。::

  voice "line0001.ogg"
  "欢迎来到Ren'Py..."

  voice sustain
  "... 你的电子小说引擎。"

:var:`config.voice_filename_format` 配置项允许你定制化语音文件名，使用的时候省略文件夹和文件扩展名。

.. _voice-tags:

语音标签(tag)
--------------

Ren'Py内置了一个语音标签(tag)系统，使得针对某个选定的角色语音的静音和取消静音成为可能。若要活用这个优势，需要在使用 :func:`Character()` 创建每一个角色对象时都提供一个voice_tag入参，就可以使用 :func:`SetVoiceMute()` 或 :func:`ToggleVoiceMute()` 切换角色语音的静音和取消静音状态。

举例：::

  define e = Character("艾琳", voice_tag="eileen")
  define l = Character("露西", voice_tag="lucy")

  screen voice_toggle:
      vbox:
          textbutton "艾琳静音" action ToggleVoiceMute("eileen")
          textbutton "露西静音" action ToggleVoiceMute("lucy")

  label start:
      show screen voice_toggle

      voice "e01.ogg"
      e "你可以开关一个角色的语音。"

      voice "l01.ogg"
      l "耶！我现在终于可以让你闭嘴了！"

      voice "l02.ogg"
      l "等下……也就是说我也被静音了！真的假的？"

.. _automatic-voice:

自动语音
---------------

Ren'Py提供了自动匹配语音文件并播放的功能，不用在每行对话脚本之前都写一条voice语句就可以实现语音播放。

要实现这个功能的话，我们创建的语音文件名必须跟对话脚本每行的标识号(identifier)严格匹配。若要确定应该用那个标识号，需要将对话脚本导出为一个表格，操作如下：在启动器上选择“Extract Dialogue”，“Tab-delimited Spreadsheet (dialogue.tab)”，“Continue”。然后会生成一个文件——dialogue.tab，它可以使用表格程序打开。

表格的第一列就是需要使用的标识号，其他列则是对话的更多别的信息。

要让Ren'Py自动播放语音，需要将 :var:`config.auto_voice` 设置为一个包含 `{id}` 格式的字符串。当对话发生， `{id}` 会被对话标识符替换，并自动组成一个音频文件名。若音频文件名对应的文件真实存在，则那个文件就会播放。

举例，比如我们如下定义：::

    config.auto_voice = "voice/{id}.ogg"

对话标识号是 ``demo_minigame_03fc91ef`` ，那么当对应的对话显示时，Ren'Py会寻找文件 ``voice/demo_minigame_03fc91ef.ogg`` 。如果文件存在，Ren'Py会播放这个文件。


语音函数
---------------

.. function:: _get_voice_info()

  返回目前say语句对应正在播放语音的有关信息。只有当say语句执行时，该函数才能被调用。

  返回对象具有以下几个字段(field)：

  .. attribute:: VoiceInfo.filename

    正在播放语音的文件名，如果没有任何文件在播放则返回None。

  .. attribute:: VoiceInfo.auto_filename

    Ren'Py意图使用自动语音搜索的文件名，如果未找到则返回None。

  .. attribute:: VoiceInfo.tag

    目前发言角色(character)的voice_tag参数。

  .. attribute:: VoiceInfo.sustain

    该值为False时，用户互动行为会中断语音播放。改值为True时，一次用户互动行为后语音会持续播放。

.. function:: voice(filename, tag=None)

  播放voice通道上名为filename的文件。等效于voice语句。

  **filename**

    想要播放的语音文件名。函数会使用 :func:`config.voice_filename_format` 拼装成将用播放的文件名。

  **tag**

    若该入参非空，其值应该是一个字符串，给定了需要播放的语音标签(tag)。若该入参为None，将使用默认值，即触发下一次互动行为前角色的voice_tag。

    语音标签(tag)用于指定发言角色，并允许用户针对某个角色的语音进行静音或取消静音。

.. function:: voice_can_replay()

  若当前语音允许回放则返回True。

.. function:: voice_replay()

  若当前语音允许回放，则回放该语音。

.. function:: voice_sustain(ignored=u'', **kwargs)

  等效于voice sustain语句。



Voice Actions
-------------

.. function:: PlayCharacterVoice(voice_tag, sample, selected=False)

  在voice通道上播放sample语音文件，并将其视为由带有 *voice_tag* 的某个角色所说。

  **sample**

    语音文件完整路径。不会对该文件的做任何语音相关的处理。

  **selected**

    若该值为True，当sample文件正在播放，调用该行为(action)函数的按钮会被标记为“被选中(selected)”。

.. function:: SetCharacterVolume(voice_tag, volume=None)

  该动作允许每个角色的语音音量都可以调整。若 *volume* 值为None，将返回 *voice_tag* 对应的音量值。否则的话， *voice_tag* 对应的音量值会被设置为 *volume* 。

  *volume* 是一个介于0.0至1.0之间的值，在包含 *voice* 通道的混合器(mixer)音量中则是一个分量。

.. function:: SetVoiceMute(voice_tag, mute)

  若 *mute* 值为True，带有给定语音标签 *voice_tag* 的所有语音会被静音。若 *mute* 值为False，取消语音标签 *voice_tag* 所有语音的静音。

.. function:: ToggleVoiceMute(voice_tag, invert=False)

  切换 *voice_tag* 的静音状态。This is selected if the given voice tag is muted, unless *invert* is true, in which case it's selected if the voice is unmuted.

.. function:: VoiceReplay(*args, **kwargs)

  回放最近一次播放的语音。
