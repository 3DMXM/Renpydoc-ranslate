.. _self-voicing:

============
自动语音
============

Ren'Py支持自动语音模式。在自动语音模式下使用一个语音合成器朗读出文本和其他接口元素。这个功能能让有视力缺陷的人也能使用Ren'Py游戏。

自动语音模式可以按 ``v`` 键切换开关。

处于自动语音模式时，键盘导航会发生变化，上下方向键会让循环经过界面上所有可获得焦点的可视组件。

当某个可视组件获得焦点时，Ren'Py会大声朗读出与那个可视组件关联的文本。如果没有可视组件获得焦点，Ren'Py会读出界面上无法获得焦点的文本内容。自动语音通过这种方式大体上覆盖了构成游戏的所有对话和文本。

.. _speech-synthesis:

语音合成
----------------

Ren'Py针对不同的操作系统提供不同的语音合成服务。要调整语音合成的速度和使用的声音，就需要调整对应平台的语音设置。

Windows
    在Windows平台上，Ren'Py使用微软语音API。在控制面板“语音识别”中“文本到语音转换”标签可以修改语音合成的设置。

Mac OS X
    在Mac OS X平台，Ren'Py使用 ``say`` 命令。在“Dictation & Speech”控制面板的“Text to Speech”标签可以修改语音合成设置。

Linux
    在Linux平台上，Ren'Py使用 ``espeak`` 命令。在自动语音模式运行之前，需要先使用package管理器安装espeak。

Android, iOS, Chrome OS
    在安卓、iOS和Chrome OS上不支持自动语音模式。

默认声音可以在对应平台的基本设置中选择，使用
:var:`config.tts_voice` 配置项。举例：

::

    init python:

        if renpy.windows:
            config.tts_voice = "Mark"
        elif renpy.macintosh:
            config.tts_voice = "Alex"
        elif renpy.linux:
            config.tts_voice = "english_rp"

可用的声音与平台有关。

.. _creator-concerns:

创作者关注点
----------------

Ren'Py的自动语音会从可视组件中剥离文本并向阅读给用户。Ren'Py从两个地方剥离文本。

Text displayables
    Ren'Py会从文本组件剥离文本，并让文本可以向用户阅读。

Alternative text

    转换文本由可视组件的 :propref:`alt` 样式特性提供。还可以通过按钮(button)上的行为 :class:`Action` 和条(bar) :class:`BarValue` 的值来获取。显示提供的转换文本优先于行为和值的文本，从文本组件中的自带文本优先级最低。

    转换文本会使用Ren'Py的字符串多语言支持机制进行翻译。转换文本的优先级高于从可视组件及其子组件剥离出的文本，不过从文本组件剥离出的问题可以使用“[text]”型字符串替换。其他文本都不允许使用字符串替换。

    例如：

    ::

        screen information(message, planet, badness):
            text message:
                color color_from_badness(badness)
                alt "Information for you : [text]. Badness is " + str(badness)

            text "ORIGIN_OF_MESSAGE_{color=#f00}[planet!u]{/color}":
                alt "Origin of message is " + planet

    在上例中，变量 ``badness`` 和 ``planet`` 都不能直接使用“[badness]”替换。把所有变量连成一个字符串，是个解决方法。

    传入Character对象的 `who_alt` 和 `what_alt` 参数将alt样式特性分别设置为角色的名字文本和身体文本。举个例子，我们定义了一个角色使用斜体表示其内心想法，但通过自动语音显示表现其想法：

    ::

        define thought = Character(None, what_italic=True, what_alt="I think, [text]")

    界面中的可视组件可能会带有 :scpref:`group_alt` 特性。
    带有该特性匹配前缀的可视组件首次获得焦点时，将播放设置的文本转语音。
    但相同前缀的组件获得焦点后不会重复播放，直到不同前缀的组件获得焦点。

    可视组件可能还会带有 :scpref:`extra_alt` 特性。当该可视组件获得焦点且按下键盘问号键时，将播放额外的语音信息。

Descriptive Text
    描述文本是启用自动语音功能后，通过旁白显示(或表述)的文本内容。
    如果禁用自动语音则文本不显示。自动语音文本使用变量 :var:`alt` ，与角色的定义过程类似。

    .. var:: alt = ...

        一个类角色的对象，启动自动语音的情况下会念出旁白的文本。

    举例：
    
    ::

        e "Hang on, this is gonna be a bumpy ride!"

        alt "And then the sun exploded..."

        # 一个复杂而且亦可赛艇的特写场景。
        show event sun_exploding
        pause 10

    有一个配置项变量控制描述文本：

    .. var:: config.descriptive_text_character = None

        若不是None，该项应该是一个用于显示描述文本角色对象，且不是旁白。

使用快捷键shift+alt+V可以启用自动语音的debug模式。debug模式下会显示界面中会播放语音的文本，用于开发需求。

.. _self-voicing-python:

Python
------

自动语音系统中包含下列函数：

.. function:: renpy.alt(s, translate=True, force=False)

    以语音形式播放序列 `s`。若 `translate` 为True，播放语音前会转换成当前系统语言类型对应的文本。
    若 `force` 为True，禁用自动语音情况下依然可以播放语音。

    该函数主要用于功能测试，不应用于实际游戏中。