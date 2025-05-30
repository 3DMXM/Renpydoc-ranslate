.. _audio:

音频
=======

Ren'Py支持在后台播放音乐和音效，支持的音频文件格式如下：

* Opus
* Ogg Vorbis
* MP3
* MP2
* FLAC
* WAV (未压缩的有符号16bit型PCM编码格式)

在Web浏览器上，Ren'Py会检查一个音频格式列表，并根据浏览器支持的格式启用一个更快更少卡顿的模式。
如果你的游戏只是用mp3，而且不考虑Safari浏览器，可以直接修改 :var:`config.webaudio_required_types` 的值。

Ren'Py支持任意数量的音频通道。有三种一般音频通道是默认定义好的：

* ``music`` - 音乐播放通道。
* ``sound`` - 音效播放通道。
* ``voice`` - 语音播放通道。

通用通道支持音频的播放和音频队列，但同一时间只能播放1个音频文件。可以使用
:func:`renpy.music.register_channel` 函数注册新的通用通道。

游戏内自定义配置菜单中的“音乐音量”、“音效音量”和“语音音量”设置的值，会应用于以上对应的音频通道。详见 :ref:`volume` 。

另外，除了通用通道，还存在特殊音频通道 ``audio`` 。audio通道支持同时播放多个音频文件，但不支持队列播放和中途停止。

音效的用途，包括按钮(button)、菜单选项、图片地图(imagemap)的鼠标悬停和激活状态。详见
:ref:`按钮样式属性 <button-style-properties>`. 两个配置项， :var:`config.main_menu_music` 和 :var:`config.game_menu_music` ，分别对应主菜单和游戏菜单播放的音乐。

游戏内播放音乐和音效的常用办法，是使用Ren'Py的三种音乐/音效语句。

.. _play-statement:

play语句
------------------

``play`` 语句用于播放音效和音乐。如果某个文件正在通过通用通道播放，播放会被中断，并开始播放新的文件。

音频通道名(通常就是“sound”、“music”、“voice”或者“audio”)需要跟在关键词 ``play`` 后面。通道名后面是音频文件。音频文件可以是单个文件，也可以是文件列表。如果是文件列表的话，列表内元素顺序播放。


``fadein`` 和 ``fadeout`` 分句是可选的。 fadeout指定了正在播放音乐需要停止时的淡出时间，单位为秒。fadein指定了播放新音乐的开头淡入时间。如果没有fadeout时间没有指定，就使用 :var:`config.fadeout_audio` 的配置值。

``loop`` 和 ``noloop`` 分句也是可选的。 loop分句表示音乐循环播放，noloop分句表示音乐只播放一次。如果这两个分句都没有出现，根据通道的默认配置决定实际播放情况。

::

    play music "mozart.ogg"
    play sound "woof.mp3"
    play myChannel "punch.wav" # 'myChannel'需要先使用renpy.music.register_channel()定义。

    "我们也可以播放一个音效或音乐的列表。"
    play music [ "a.ogg", "b.ogg" ] fadeout 1.0 fadein 1.0

当提供了 ``if_changed`` 从句，并且对应的音频通道正在播放，播放指令不会中断当前播放的音频。

::

    label market_side:
        play music market
        "我们正在进入市场。"
        jump market_main

    label market_main:
        play music market if_changed
        "我们可能刚进入市场，也可能已经在市场里一段时间了。"
        "如果我们已经在市场里一段时间了，音乐不会停止并重从播放，只是继续播放。"
        jump market_main

``volume`` 从句也是可选的，可以指定音量值，音量范围为0.0到1.0。
这样每次指定音频文件时，也可以同时设置音量。

::

    play sound "woof.mp3" volume 0.5

在audio通道上，同时播放多个音效文件：

::

    play audio "sfx1.opus"
    play audio "sfx2.opus"

此处可以使用变量替代字符串。如果某个变量在 :ref:`音频命名空间 <audio-namespace>` 中存在，它就可以在默认的命名空间中直接引用。

::

    play music illurock

放入audio命名空间的文件会根据文件名自动定义变量并使用。

.. _synchro-start:

Ren'Py支持一种功能，可以确保多个音频文件同步播放。
该功能默认在不断循环的音频通道(比如music)上启用，
但也可以通过 `synchro_start` 选项用于 :func:`renpy.music.register_channel` 或 :func:`renpy.music.play` 。

启用synchro start功能后，多个play语句会同时运行，多个音频通道同步播放。
满足以下条件时，synchro就会开始：

* 当各音频通道的音频文件都已加载并且音频采样功能可用时。
* 当所有音频通道播放的内容都已淡出(fade out)时。

两个条件都满足时，还可以加入新的音频。

.. _stop-statement:

stop语句
--------------

``stop`` 语句以关键词 ``stop`` 开头，后面跟需要静音的音频通道名。最后有一个可选的 ``fadeout`` 分句。
如果没有fadeout时间没有指定，就使用 :var:`config.fadeout_audio` 的配置值。

::

    stop sound
    stop music fadeout 1.0

.. _queue-statement:

queue语句
---------------

``queue`` 语句用于组建音频文件队列。当前播放的文件被播放完毕之后，queue语句组建的音频文件队列就会开始播放。

queue语句以关键词 ``queue`` 开头，后面跟播放使用的音频通道名。最后是否带 ``fadein`` 、 ``loop`` 或 ``noloop`` 分句是可选的。

::

    queue sound "woof.mp3"
    queue music [ "a.ogg", "b.ogg" ]

queue语句也可以使用 ``volume`` 从句。

::

        play sound "woof.mp3" volume 0.25
        queue sound "woof.mp3" volume 0.5
        queue sound "woof.mp3" volume 0.75
        queue sound "woof.mp3" volume 1.0

当多个queue语句出现，且没有给任何队列指定互动行为情况下，所有的声音文件都将加入到队列中。
在某个互动行为发生后，第一个queue语句对应的队列将清空，除非其已经被某个play或stop语句清空过。

此处可以使用变量替代字符串。如果某个变量在 :ref:`音频命名空间 <audio-namespace>` 中存在，它就可以在默认的命名空间中直接引用：

::

    define audio.woof = "woof.mp3"

    # ...

    play sound woof


使用这些语句的优点是，当lint工具运行时，可以检测出你程序中是否有丢失的音乐音效文件。后面的一些函数允许python接入和控制这些文件，并且会揭示一些高级(却很少用到)的特性。

.. _partial-playback:

节选播放
----------------

Ren'Py支持节选播放音频文件。节选播放的语法是，在play语句的文件名之前，加上用英文尖括号<>包含的播放起始点。节选播放规范应该包含成对属性名和属性值，并用空格分隔。

属性值以秒为单位，集成在文件名前面的英文尖括号<>内。三种属性名分别为：

``from``
    指定播放文件的起始时间点。(默认值为0.0秒)

``to``
    指定播放文件的终止时间点。(默认值为文件结束。)

``loop``
    指定需要循环播放的文件起始和终止时间点。(默认的起始时间点为文件开头或 ``from`` 指定的时间点。)

举例：

::

    play music "<from 5 to 15.5>waves.opus"

将从5秒的标记处开始，播放总计10.5秒waves.opus文件内容。下面这条语句：

::

    play music "<loop 6.333>song.opus"

将会在完整播放完文件song.opus后，回到6.333秒标记处重新播放至结尾，并不断循环重复。

.. _sync-start:

同步起始位置
-------------------

某段音频音频的起始播放位置可以同步到另一个音频通道，只需要使用特定的文件名，比如“<sync channelname>track.opus”。
其中channelname就是需要同步的通道名称，可以是music、sound或其他任意注册过的音频通道。

该功能可用于多个循环播放音轨的同步。比如：

::

    play music_2 [ "<sync music_1>layer_2.opus", "layer_2.opus" ]

会直接将 :file:`layer_2.opus` 从当前播放 music_1 的音轨时间点开始播放。
music_1从头开始播放时也跟随从头播放，而不再会播放完之后再循环。
(默认情况下，:file:`layer_2.opus` 起始时间点的修改会永久生效。)

.. _volume:

音量
------

播放音频时的音量与以下变量都有关：

- 混音器“main”的音量值
- 相关音频通道的混音器音量值
- 音频通道的音量值
- 音频自身音量

以上4项音量值都介于0与1之间，最终音量值是它们相乘后的结果。

例如，main音量值80%(0.8)，混音器音量值100%，音频通道音量值50%(0.5)，音频自身音量25%(0.25)。
最终音量为 .8\*1.\*.5\*.25 = .1，即10% 。

混音器音量可以使用 :func:`preferences.set_mixer` 函数、:func:`SetMixer` 行为和 :func:`Preference` 行为指定 ``"mixer <mixer> volume"`` 进行设置。
audio和sound音频通道相关的混音器为“sfx”，music音频通道相关的混音器为“music”，而voice音频通道相关的混音器为“voice”。
每个音频通道都与“main”混音器相关。

使用 :func:`renpy.music.set_volume` 函数可以设置某个音频通道的音量。
通常仅当多个音频通道共用同一混音器时才需要用。
:func:`renpy.music.register_channel` 函数的 ``mixer`` 参数可以在注册音频通道时指定关联的混音器，如果混音器不存在则直接创建一个。

在 :ref:`play-statement` 后面加 ``volume`` 从句可以直接设置音频文件的相对音量。

除了音量值，各音频通道关联的混音器都有静音标识。
启用静音标识后，会将音量直接设置为0.
可以使用 :func:`SetMute`、:func:`ToggleMute`、:func:`Preference` 或 :func:`preferences.set_mute`，指定“mixer <mixer> mute”启用对应混音器的静音标识。

.. _playing-silence:

播放静音
---------------

一段指定时间范围播放静音，格式类似“<silence 3.0>”，其中3.0表示需要的静音持续时间，单位为秒。播放静音用于延迟音效文件的播放点。例如：

::

    play audio [ "<silence .5>", "boom.opus" ]

将播放半秒的静音，然后出现一个爆炸音效。

.. _audio-namespace:

音频命名空间和目录
-------------------

``play`` 和 ``queue`` 语句在音频命名空间内计算入参的值。这意味着可以使用define语句，为音频文件提供一个别名(alias)。

例如，我们可以这样写：

::

    define audio.sunflower = "music/sun-flower-slow-jam.ogg"

然后这样使用：

::

    play music sunflower

Ren'Py会将 ``game/audio`` 目录下的文件自动识别为音频文件，并根据文件名在audio命名空间中生成对应变量。
该目录下直接支持的几种音频音频，会被去掉文件扩展名(当前包括.wav、.mp2、.mp3、.ogg和.opus)，剩下的文件名强制转为小写字母，并放入audio命名空间。

需要注意，文件名会放入audio命名空间并不表示就会播放。如果需要播放一个名为 :file:`opening_song.ogg` 文件，需要写：

::

    play music opening_song

某些文件名无法使用这种方式，因为这些文件名不符合Python变量命名规范。例如，:file:`my song.mp3`、:file:`8track.opus` 和 :file:`this-is-a-song.ogg` 就有这种情况。

Ren'Py搜索音频文件时，如果在game目录中没有对应的匹配文件，会再次在audio目录中寻找。
例如：

::

    play music "opening.ogg"

会先搜索 :file:`game/opening.ogg`。若未果则会搜索 :file:`game/audio/opening.ogg`。

.. _a-actions:

行为函数
--------

详见 :ref:`audio-actions`。

.. _functions:

相关函数
---------

.. function:: AudioData(data, filename)

    该类会指向一个byte编码对象，包含音频数据。该对象可以传入音频播放系统。包含的音频数据应该是Ren'Py支持的格式(例如RIFF、WAV格式)。

    `data`
        包含音频文件数据的byte编码对象。

    `filename`
        与音频数据相关的复合文件名。它可以表示音频数据格式，也可以用做报错信息。

.. function:: renpy.mark_audio_seen(filename)

    将指定文件名的文件标记为当前用户已播放过至少一次。

.. function:: renpy.mark_audio_unseen(filename)

    将指定文件名的文件标记为当前用户未播放过。

.. function:: renpy.play(filename, channel=None, **kwargs)

    播放一个音效。如果channel为None，默认值为config.play_channel。该函数用在各种样式(style)定义，鼠标悬停声(hover_sound)和激活声(activate_sound)。

.. function:: renpy.seen_audio(filename)

    如果filename对应的音频文件在用户系统中至少被播放过一次，则返回True。

.. function:: renpy.music.get_duration(channel='music')

    返回目前 *channel* 通道上正在播放的音频或视频文件的全长。若 *channel* 通道上没有正在播放的文件，则返回0.0。

.. function:: renpy.music.get_loop(channel=u'music')

    返回音频通道上正在循环播放的文件列表，如果没有文件在循环播放则返回None。
    如果循环列表还在待播放队列中排队，并没有播放，依然会返回循环列表，而不是正在播放的音乐。

.. function:: renpy.music.get_pause(channel='music')

    返回 *channel* 通道上的pause标记的值。

.. function:: renpy.music.get_playing(channel='music')

    若入参channel上有音频正在播放，返回文件名。否则返回None。

.. function:: renpy.music.get_pos(channel='music')

    返回入参channel通道上正在播放的音频或者视频文件的已播放进度，单位为秒。如果 *channel* 通道上没有任何音频或视频文件正在播放，返回None。

    由于在某个通道开始播放前，总是会返回None；也可能对应的音频通道已经被静音(mute)。该函数的调用者应该能够处理空值。

.. function:: renpy.music.is_playing(channel='music')

    若入参channel上正在播放一个音频则返回True，否则返回False。或者当声音系统没有工作的情况也返回False。

.. function:: renpy.music.play(filenames, channel='music', loop=None, fadeout=None, synchro_start=False, fadein=0, tight=None, if_changed=False)

    该函数会立即停止入参channel上正在播放的声音，解散音频队列，并开始播放入参filenames指定的文件。

    `filenames`
        该值可以是单个文件，也可以是待播放的文件列表。

    `channel`
        播放声音使用的通道。

    `loop`
        若该值为True，音轨会循环播放，前提是其已经是播放队列最后一个音频。

    `fadeout`
        若不为空，这是一个淡出效果的持续时间，单位为秒。否则，淡出时间使用config.fade_music的值。

    `synchro_start`
        Ren'Py会确保所有synchro_start标志为True的通道，能够在几乎同一时间一齐开始播放音频。当我们需要两个音频文件相互同步时，synchro_start就应该被设置为True。

    `fadein`
        音频开始淡入效果持续时间，单位为秒，在循环播放时仅对第一遍播放有效。

    `tight`
        若该值为True，淡出效果将作用至同一个队列中后面的声音。若为空，当loop为True时tight也为True，否则为False。

    `if_changed`
        若该值为True，当前真在播放的音频不会被立刻停止/淡出，而会继续播放。

    `relative_volume`
        当前音频通道播放音频时的相对音量值。
        指定文件将以该音量值播放。
        如果没有指定该音量值则默认为1.0，表示以音频文件原始音量播放，再乘以混音器、音频通道和相关第二音量的值。

    该函数会清空对应通道上所有的pause标记。

.. function:: renpy.music.pump()

    “pump”是指对音频系统的操作。
    通常来说，使用 ``play``、``queue`` 和 ``stop`` 语句及等效函数后，会在下次互动时才正式生效。
    在某些情况下，多个语句之间会互相取消。例如，play语句后面跟随一个stop从句，会使得音频无法播放。

    如果在play和stop语句之间调用该函数，音频会在该函数返回结果前继续播放音频，并随后淡出。

    ::

        play music "mytrack.opus"
        $ renpy.music.pump()
        stop music fadeout 4

.. function:: renpy.music.queue(filenames, channel='music', loop=None, clear_queue=True, fadein=0, tight=None)

    该函数将文件名为filenames的文件加入指定通道channel的播放队列。

    `filenames`
        该值可以是单个文件，也可以是待播放的文件列表。

    `channel`
        播放声音使用的通道。

    `loop`
        若该值为True，音轨会循环播放，前提是其已经是播放队列最后一个音频。

    `clear_queue`
        若为True，当前播放文件结束后，播放队列中原有文件将被清空。若为False，新增文件会被加在原有队列结尾。无论实际哪种情况，如果当前没有任何音频正在播放，新队列中的音频都会立刻被播放。

    `fadein`
        音频开始淡入效果持续时间，单位为秒，在循环播放时仅对第一遍播放有效。

    `tight`
        若该值为True，淡出效果将作用至同一个队列中后面的声音。若为空，当loop为True时tight也为True，否则为False。

    `relative_volume`
        当前音频通道播放音频时的相对音量值。
        指定文件将以该音量值播放。
        如果没有指定该音量值则默认为1.0，表示以音频文件原始音量播放，再乘以混音器、音频通道和相关第二音量的值。

    该函数会清空对应通道上所有的pause标记。

.. function:: renpy.music.register_channel(name, mixer=None, loop=None, stop_on_mute=True, tight=False, file_prefix='', file_suffix='', buffer_queue=True, movie=False)

    该函数用于注册新的名为入参name的音频通道。之后就可以使用play或queue语句在name通道上播放音频了。

    `name`
        待注册音频通道名。

    `mixer`
        混合器(mixer)使用的通道名。默认情况下，Ren'Py能识别“music”、“sfx”和“voice”混合器。使用其他名称也是可行的，不过可能要修改个性化界面。

    `loop`
        若为True，在新注册通道上的音频默认循环播放。

    `stop_on_mute`
        若为True，当新注册通道被静音(mute)时，通道上所有音频都会停止播放。

    `tight`
        若为True，即使有淡出效果，依然可以循环播放。若要实现音效、音乐的无缝连接，就应该把这项设为True。若使用音乐的淡出效果则设置为False。

    `file_prefix`
        在该通道上播放的所有声音文件都会添加的文件名前缀。

    `file_suffix`
        在该通道上播放的所有声音文件都会添加的文件名后缀。

    `buffer_queue`
        我们是否应缓存一两个文件或者一个文件队列？如果通道是播放音频的话应该设置为True，如果播放视频的话应该设置为False。

    `movie`
        若值为True，该通道会被设为播放视频。

    `framedrop`
        该参数控制视频卡顿时的处理方式。若为True，则会跳帧以保持音视频同步。若为False，Ren'Py会无视视频迟延。

.. function:: renpy.music.set_audio_filter(channel, audio_filter, replace=False, duration=0.016)

    将指定的音频滤波器加入到 `audio_filter` 队列。

    `audio_filter`
        该项必须是一个 :doc:`音频滤波器<audio_filters>` 对象或者音频滤波器列表。
        该项也可以是None，表示移除当前所有音频滤波器。

    `replace`
        若为True，音频滤波器会立刻替换当前使用的音频滤波器，修改当前正在播放或播放队列中的声音。
        若为False，新的音频滤波器会在下次播放的声音或播放队列中的下一个声音才生效。

    `duration`
        从当前音频滤波器到新的滤波请生效的时长，单位为秒。
        该项可以防止突然更改滤波器时产生的爆音。

.. function:: renpy.music.set_mixer(channel, mixer, default=False)

    该函数可以设置指定音频通道的混音器。默认情况下，至少有两个混音器，分别是“sfx”和“music”。
    “sfx”占用的音频通道编号为0到3，“music”占用的音频通道标号为3到7。
    voice模块调用该函数时，会将2号音频通道用于语音。
    创作者可以创建自己的混音器，但也需要提供一个配置项，可以调整和设置该混音器。

    只能在初始化语句块中调用该函数。

.. function:: renpy.music.set_pan(pan, delay, channel='music')

    设置该通道的声像(pan)。

    `pan`
        控制音频的音源位置的一个值，位于-1至1的闭区间内。若该值为-1，所有音频使用左声道。若该值为0，左右声道均衡发声。若该值为1，所有音频使用右声道。

    `delay`
        为了形成声像使用的延迟时间。

    `channel`
        应用声像的通道名。可以是音乐或音效通道。通常使用通道7，也就是默认的音乐通道。

.. function:: renpy.music.set_pause(value, channel='music')

    将入参value赋值给通道名为channel的暂停标识。若value为True，通道会被暂停，否则正常播放。

.. function:: renpy.music.set_queue_empty_callback(callback, channel='music')

    该函数设置了一个callback函数，当播放队列为空时，将会调用callback函数。播放队列首次变空时callback函数将被调用，且每次会导致播放队列清空的互动行为都会至少调用一次。

    callback函数被调用时不带任何参数。其会使用合适的参数调用renpy.music.queue，将声音组件成一个队列。请注意，某个声音在播放时callback就可能会被调用，因为当时待播放队列已经空了。

.. function:: renpy.music.set_volume(volume, delay=0, channel='music')

    设置通道的音量volume。对于控制多个通道的混合器(mixer)，该值表示混合器的一个音量分量。
    Sets the volume of this channel, as a fraction of the volume of the mixer controlling the channel.

    `volume`
        该值位于0.0至1.0的闭合区间。对于控制多个通道的混合器(mixer)，该值表示混合器的一个音量分量。

    `delay`
        该值代表一个时间量，用于新旧音量值切换/平滑过渡时的时延，单位为秒。该值会保存在存档中，并接受回滚操作。

    `channel`
        需要设置的通道名。

.. function:: renpy.music.stop(channel='music', fadeout=None)

    该函数停止正在播放的音乐，并解散播放队列。如果入参fadeout为None，使用config.fade_music配置值作为淡出效果时间，否则就是用fadeout入参值。

    该函数将最后组建的待播放文件列表设置为None。

    `channel`
        需要停止播放的通道名。

    `fadeout`
        若不为None，包含一个淡出效果时间，单位为秒。否则淡出时间取决于config.fade_music。

.. _sound-functions:

音效函数
---------------

大多数 ``renpy.music`` 函数在 ``renpy.sound`` 有别名(alias)。这些函数功能类似，主要差别在于它们默认作用于音效(sound)通道而不是音乐(music)通道，且默认不循环播放。
