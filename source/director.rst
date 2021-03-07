.. _interactive-director:

交互式编导器(interactive director)
=====================================

交互式编导器(interactive director)是一个工具，允许你在Ren'Py中直接编辑游戏脚本，并能直接预览编辑的结果。编导器(director)并不意味着可能完全代替文本编辑器。我们依然需要文本编辑器来撰写视觉小说的对话、选项和逻辑。

编导器(director)意在帮助你完成游戏脚本，比如添加：

* image(say、show、hide)语句。
* transition(with)语句。
* audio(play、queue、stop、voice)语句。

.. _using-the-director:

使用编导器(director)
---------------------

你可以在游戏开始后按下键盘的D键(不带shift)接入编导器(director)。如果这是你在某个会话中首次接入编导器，Ren'Py会重新加载整个游戏以确保可能会被编辑的数据无误。

你会看到的第一个编导器界面是一个当前行之前运行过的行的列表。点击编导器窗口之外的部分让脚本继续前进或者回滚。点击各行之间的加号“+”能够添加一行，或者点击每行之前的 ✎ 符号能编辑对应的行。

编辑某一行时，可以选择语句类型，以及何时的参数。选择“添加”添加新行，“更改”修改已存在的某行，“取消”取消编辑，“移除”移除存在的某行。

当编辑完毕后点击“完成”。

.. _variables:

配置项
---------

在命名空间 ``director`` 定义了一些配置项，用于控制交互式编导器(interactive director)的功能。这些配置项可以使用define语句设置，或者使用Python语句修改。

.. _scene-show-and-hide:

scene、show和Hide
^^^^^^^^^^^^^^^^^^^^^

.. var:: director.tag_blacklist = { "black", "text", "vtext" }

    标签(tag)黑名单。黑名单内的标签(tag)不会通过show、scene和hide语句显示。

.. var:: director.scene_tags = { "bg" }

    标签(tag)的集合。集合内的标签(tag)会通过scene语句展示，并通过show语句隐藏。

.. var:: director.show_tags = set()

    若非空集，只有集合内标签才会通过show语句显示。

.. var:: director.transforms = [ "left", "center", "right" ]

    一个transform列表，显示为编辑器的一部分。除此之外，Ren'Py之外使用transform语句定义的transform都会添加到这个列表中，并排序。

.. _with:

With
^^^^

.. var:: director.transitions = [ "dissolve", "pixellate" ]

    一个转场(transition)列表，列表中的转场可以通过with语句使用。由于转场不能被自动检测到，这个列表内的转场必须手工添加。

.. _play-queue-stop-and-voice:

play、queue、stop和voice
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. var:: director.audio_channels = [ "music", "sound", "audio" ]

    可以被play、show和stop语句使用的音频通道名。

.. var:: director.voice_channel = "voice"

    可以被voice语句使用的音频通道名。

.. var:: director.audio_patterns = [ "*.opus", "*.ogg", "*.mp3" ]

    默认的音频文件名正则表达式列表，匹配正则表达式的文件都可以在音频通道中使用。

.. var:: director.audio_channel_patterns = { }

    从通道名到可用的音频文件名正则表达式的映射关系。例如，如果这项设置为 ``{ 'sound' : [ 'sound/*.opus' ], 'music' : [ 'music/*.opus' ] }`` ，music和sound通道就使用各自可用文件的正则表达式。

.. _access:

Access
^^^^^^

.. var:: director.button = True

    若为True，编导器(director)会显示一个带按钮的界面，用于接入编导器窗口。若为False，游戏提供自身的接入方式，通过执行可用的director.Start行为。

.. _line-spacing:

行间隔
^^^^^^^^^^^^

.. var:: director.spacing = 1

    编导器(director)行(包括scene、show、hide、with、play、queue和voice)，与非编导器行之间的间隔。间隔应该是0行或者1行，更大的间隔可能不会起效。

.. var:: director.director_spacing = 0

    连续两个编导器行的间隔。

.. var:: director.other_spacing = 0

    连续两个非编导器行的间隔。

.. _viewport:

视口
^^^^^^^^

.. var:: director.viewport_height = 280

    编导器使用的可滚动视口的最大高度。

.. _audio-filename-functions:

音频文件函数
------------------------

有一些音频文件函数可以用于把转换磁盘文件名转换为Python源代码的文件名。这些功能可以用于匹配Ren'Py的文件名映射。例如，我们有这样一段配置：

::

    define config.voice_filename_format = "v/{filename}.ogg"

我们就可以定义一个函数：

::

    init python in director:

        def audio_code_to_filename(channel, code):
            """
            这将在代码中看到的音频文件名的名称转换为磁盘上的文件名。
            """

            if channel == "voice":
                return "v/" + code + ".ogg"

            return code

        def audio_filename_to_code(channel, fn):
            """
            这将磁盘上的音频文件名的名称转换为文件名，如代码中所示。
            """

            if channel == "voice":
                return fn.replace("v/", "").replace(".ogg", "")

            return fn

        def audio_filename_to_display(channel, fn):
            """
            这会转换音频文件名，如同在磁盘上看到的一样，因此它可以呈现给创作者。
            """

            if channel == "voice":
                return fn.replace("v/", "").replace(".ogg", "")

            return fn

用于匹配音频文件名正则表达式。
