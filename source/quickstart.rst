.. _quickstart:

快速入门
==========

欢迎来到Ren'Py快速入门手册。此手册意在指导你如何从零起步，
过一系列简单的步骤制作一个Ren'Py游戏。我们通过制作一个简单游戏 *The Question*，来实现这一目标。

.. _the-ren-py-launcher:

Ren'Py启动器(launcher)
-----------------------


在开始制作一个游戏之前，你最好首先花点时间学习Ren'Py启动器(launcher)的工作机制。
启动器(launcher)允许你创造、管理、编辑和运行Ren'Py工程。

**正式开始。** 正式开始前，你会需要
`下载 Ren'Py <https://www.renpy.org/latest.html>`_.

下载Ren'Py，然后解压并运行。

* 在Windows平台上，双击下载的可执行文件。它会自动解压Ren'Py到一个名为 ``renpy-<version>`` 的文件夹。进入这个文件夹并运行 ``renpy.exe`` 。(在扩展名隐藏的情况下，renpy.exe文件可能名字是renpy)

* 在Max OS X平台上，双击下载驱动器镜像，将其挂载为一个驱动器。当驱动器打开后，将目录命名为 ``renpy-<version>`` 并复制到其他任意地方。(复制到哪里不重要，但不能是只读驱动器。不要将renpy程序文件移动到其所有目录之外的地方——不然在其他地方该程序无法工作)进入这个目录并运行 ``renpy`` 程序。

* 在Linux平台上，解tar包，进入 ``renpy-<version>`` 目录，然后运行 ``renpy.sh`` 。

完成以上操作后，Ren'Py启动器(launcher)应该正常运行了。

Ren'Py启动器(launcher)已经被翻译为多种语言。需要更改语言的话，选择底部右侧的“preferences”项，就可以更改语言了。

(译者注：首次运行的启动器界面默认使用英语。请进入“preferences”，将“Language”修改为“Simplified Chinese”，就能切换为简体中文了。后续所有图片和描述均以简体中文界面为基础。)

**选择和启动一个工程。** 你首先会看到游戏“The Question”完成之后的样子。进入Ren'Py启动器(launcher)，在弹出的第一个窗口选择“The Question”。然后选择“启动工程”进入“The Question”。

通过同样的操作，你可以进入Ren'Py演示demo，不过请选择“教程”而不是“The Question”。

.. ifconfig:: renpy_figures

    .. figure:: quickstart/launcher.png
        :width: 100%

        Ren'Py启动器主界面。

    .. figure:: quickstart/project_name.png
        :width: 100%

        给一个新工程命名。

    .. figure:: quickstart/resolution.png
        :width: 100%

        选择工程分辨率。

    .. figure:: quickstart/color.png
        :width: 100%

        选择默认主题的强调颜色和背景颜色。


**创建一个新工程。** 在启动器(launcher)界面选择“创建新工程”创建一个新工程。

如果这是你第一次创建工程，Ren'Py可能会要求你选择一个工程目录。这个目录(或者称为文件夹)会被用于创建新的工程，并且会扫描已经存在的工程。目录选择窗口可能会弹出在Ren'Py主界面窗口后面，我们需要找到这个窗口。

然后，启动器(launcher)会询问工程名称。由于“The Question”已经被占用了，你需要输入一个不同的工程名称，比如“My Question”，然后输入回车确认。

之后，启动器(launcher)会询问工程分辨率。考虑到游戏(文件)大小和游戏画面质量，默认的1280x720分辨率是个良好的折中方案。由于是入门演示，我们将选择1280x720以匹配“The Question”游戏的美术资源，点击“继续”。

启动器(launcher)将继续询问颜色主题——新GUI(用户图形界面)的强调色和背景色。此时你选择什么颜色都不要紧，所以随心所欲选择，然后点击“继续”。

到了这一步，Ren'Py会处理一些(后台)工作，然后输出一个简单的游戏模板。该模板使用预置的美术和文本资源，但是可以运行的，并且支持一些预置的特性，例如回滚、读档、存档等。选择“启动工程”运行这个工程。

.. _a-simple-game:

一个简单游戏
-------------

::

    label start:

        "希尔维亚" "嗨！今天的课怎么样？"

        "我" "挺好的……"

        "我当然不会承认，上课的时候内容只是左耳进右耳出。"

        "我" "你现在要回家了吗？要不要跟我一起走？"

        "希尔维亚" "当然！"

这是一个非常简单的Ren'Py游戏。它不包含任何图片和音乐，但它展示了两个角色之间的一次对话，以及一行旁白。

如果想要尝试，从启动器(launcher)顶端选择“My Question”工程，进入“编辑文件”并选择“script.rpy”。如果这是你首次进入编辑模式，Ren'Py会询问选用哪一款编辑器(我们向新人推荐Editra)，并下载你选择的那款。启动器(launcher)会使用编辑器打开rpy脚本文件。

编辑器打开后，清除script.rpy里所有内容。我们将从零开始，所以你不需要原来的那些内容。将上面案例复制到script.rpy里并保存文件。

现在万事俱备，可以运行这个样例了。回到启动器(launcher)主界面，选择“启动工程”。Ren'Py会启动运行。注意，不需要额外的工作量，Ren'Py就已经提供了可以读档和存档以及改变配置项的菜单选项。当这些工作都完成时，点击“启动工程”，就可以玩这个样例游戏了。

这个样例展示了一些常用的Ren'Py语句。

第一行是一个 :ref:`label语句 <label-statement>`。label语句常用于在程序中给某个脚本点命名。在这个例子中，我们创建了一个名为 ``start`` 的标签。start标签是特殊的，因为当用户点击主菜单的“开始游戏”时，Ren'Py脚本会从这个标签开始运行。

其他行是 :ref:`say语句 <say-statement>`。say语句有两种格式。一种格式是，一行单独字符串(双引号开头，双引号结束，中间文字)，用于表现主视角角色的陈述或者内心想法。另一种格式有两个字符串组成。常用于对话，第一个字符串是说话角色名字，第二个字符串是该角色正在说的话。

注意，所有say语句都要用4个空格(半角)缩进.这是因为say语句属于同一个标签语句下的语句块(block)。在Ren'Py中，语句块(block)必须相对于从属的主语句缩进，并且同一个语句块(block)的语句使用同样的缩进量。

当文本自身包含双引号时，需要使用反斜杠作为转义符。例如

::

    ###
        "希尔维亚" "你有没有听过林肯著名的格言， \"网络无真相\"？"

当然这个简单游戏没什么可多看的，它只是一个演示如何在Ren'Py里简单构建框架的样例。之后我们会添加一些图片，不过首先，让我们看看如何定义角色。

.. _characters:

角色(character)
-------------------

*主要内容参见* :ref:`defining-character-objects`

在第一个样例里存在一个问题，每当角色说话时，你需要反复输入角色名字。在一个对话为主的游戏中，这可能是很繁重的工作。还有，游戏启动后角色名字始终会以强调色显示。为了解决这些问题，Ren'Py允许你在开头就定义角色。这可以使你用一个短名关联一个角色，并且能够改变角色名字显示的颜色。

::

    define s = Character('希尔维亚', color="#c8ffc8")
    define m = Character('我', color="#c8c8ff")

    label start:

        s "嗨！今天的课怎么样？"

        m "挺好的……"

        "我当然不会承认，上课的时候内容只是左耳进右耳出。"

        s "你现在要回家了吗？要不要跟我一起走？"

        m "当然！"


第一和第二行语句定义了角色。第一行定义一个短名为“s”，长名为“希尔维亚”的角色，名字颜色为淡绿色。(如同网页里常见的，这里的颜色使用RGB的16进制字符表示)

第二行创建一个短名为“m”，长名为“我”的角色，名字颜色为淡红色。其他角色的定义可以使用“复制-粘贴”，修改角色的长名、短名和名字颜色。

我们也已经使用角色对象代替了角色名字字符串。这会告诉Ren'Py使用我们定义的对应角色。

.. _quickstart-images:

图像(image)
-------------

*主要内容参见* :doc:`displaying_images`

一个视觉小说如果没有图像的话就称不上视觉小说了。在“The Question”里还有另外一个场景。这也包含了一些语句展现角色图像。如果你想尝试的话，用这段内容完全覆盖之前那个脚本。

::

    define s = Character('希尔维亚', color="#c8ffc8")
    define m = Character('我', color="#c8c8ff")

    label start:

        scene bg meadow

        "不久之后，我们就抵达了牧场，也是我们俩人出生的地方"

        "我就是在这样的风景环绕之中成长起来的。这里的秋天格外秀美。"

        "童年时，我们经常在牧场里玩耍，所以这里满满充斥着回忆。"

        m "嗨……唔……"

        show sylvie green smile

        "她把脸转向我，上面挂着微笑。她看起来兴致高昂。我觉得自己刚才的紧张情绪已经消散。"

        "我得问问她！"

        m "嗯呣……你是否可以……"

        m "你是否可以做我的视觉小说画师？"

        show sylvie green surprised

        "沉默。"

界面中的所有图像，都会显示在同一个画面上。这段脚本介绍了两种新的语句。第6行的scene语句清除了所有图像并显示了一个背景图像。从第16行至第26行的展示语句在背景上显示了一个精灵(sprite)， 并根据预设改变展示的精灵。

在Ren'Py中，每个图像都有一个名称。该名称包含一个tag(译者注：图像标签，与label脚本标签不同)，以及一个以上的可选属性(attribute)。tag标签和属性名必须以字母开头，包含字母、数字和下划线。例如：

* 第6行的scene语句中，tag标签是“bg”，属性是“meadow”。按照习惯，背景图像应该使用的bg作为tag标签。

* 第16行的第一个show语句中，tag标签是“sylvie”，属性是“green”和“smile”。

* 第26行的第二个show语句中，tag标签是“sylvie”，属性是“green”和“surprised”。

给定tag标签时，每次只能展示一副图像。当拥有同样tag标签的第二副图像需要展示时，它会直接替换第一副图像，如同在第26行里发生的情况。


Ren'Py会在images目录下搜索图像文件，可以通过启动器(launcher)的“打开目录”选项里选择“images”完成配置。Ren'Py能使用PNG或者WEBP文件作为角色美术资源，JPG、JPEG、PNG或者WEBP文件作为背景美术资源。文件的命名相当重要，Ren'py将使用除去扩展名后，强制字母变为小写的文件名来作为图象名。

例如，images目录下的这些文件，定义了下列图像：

* "bg meadow.jpg" -> ``bg meadow``
* "sylvie green smile.png" -> ``sylvie green smile``
* "sylvie green surprised.png" -> ``sylvie green surprised``

因为文件名会被转换为小写字母，所以下面这种方式也可行。

* "Sylvie Green Surprised.png" -> ``sylvie green surprised``

图像可以被放在images目录的子目录(子文件夹)中。目录名忽略，只使用文件名定义图像名。

**hide语句。** Ren'Py也支持hide语句，可以用来隐藏图像。

::

    label leaving:

        s "我立刻去办！"

        hide sylvie

        "..."

        m "我不是这个意思！"

实际上，你需要使用hide语句的情况非常少见。show语句能用在角色情感变化，而scene语句用在所有人离开的情况。当某个角色离开但场景不变化时，你才需要使用hide语句。

**image语句。** 有时候，制作者可能不想让Ren'Py自动定义图像。这时image语句就能派上用场。它应该出现在文件最顶层(不缩进，在label标签前面)，为图像文件指定对应的图像名称。例如：

::

    image logo = "renpy logo.png"
    image eileen happy = "eileen_happy_blue_dress.png"

image语句于初始化阶段就会运行，早于label标签开始以及其他的游戏脚本与玩家交互。

image语句也用于比较复杂的任务，但我们会在 :doc:`其他地方 <displaying-images>`_ 讨论这部分。

.. _quickstart-transitions:

转场(transition)
-----------------

*主要内容参见* :doc:`transitions`

在上面的脚本中，图像的切换十分生硬。由于切换地点或者角色的出场、离场很重要，Ren'Py支持图像的各种转场效果。

转场切换用于显示在最后一个交互(对话、菜单或来源于其他语句的转场)发生后，到下一个scene、show或hide语句运行之间。

::

    label start:

        scene bg meadow
        with fade

        "不久之后，我们就抵达了牧场，也是我们俩人出生的地方。"

        "我就是在这样的风景环绕之中成长起来的。这里的秋天格外秀美。"

        "童年时，我们经常在牧场里玩耍，所以这里满满充斥着回忆。"

        m "嗨……唔……"

        show sylvie green smile
        with dissolve

        "她把脸转向我，上面挂着微笑。她看起来兴致高昂。我觉得自己刚才的紧张情绪已经消散。"

        "我得问问她！"

        m "嗯呣……你是否可以……"

        m "你是否可以做我的视觉小说画师？"

这里的with语句决定了需要使用的转场效果名。最常用的转场效果是 ``dissolve`` (溶解)。 另一个有用的转场效果是 ``fade`` (褪色)，能让界面褪为全黑，然后逐渐亮起成新的界面。

当在多个scene、show、hide语句之后有一个转场效果，将对以上所有语句都有效。如果你写成这样：

::

    ###
        scene bg meadow
        show sylvie green smile
        with dissolve

“bg meadow”和“sylvie green smile”图像会同时使用dissolve转场。如果想要每次只让其中之一使用dissolve转场，你需要写两个转场语句：

::

    ###
        scene bg meadow
        with dissolve
        show sylvie green smile
        with dissolve

场景meadow里有第一个dissolve效果，而角色sylvie里有第二个dissolve效果。如果你想要立刻展现meadow场景，然后使用转场效果展现角色sylvie，你可以这样写：

::

    ###
        scene bg meadow
        with None
        show sylvie smile
        with dissolve

这里的“None”被用于标识一个特殊转场效果，对玩家来说主界面没有产生任何特殊效果。

.. _positions:

位置(position)
---------------

*主要内容参见* :doc:`transforms`

图像在展示时默认水平居中，图像底部与界面底部相接。这样设计通常对背景和单个角色没问题，但当界面上需要展现1个以上角色时，重新调整图像位置也是十分合理的。同样，基于剧情需要，调整单一角色的图像位置也可以理解。

::

   ###
        show sylvie green smile at right

为了重新调整图像位置，需要在show语句中添加一个at分句。at分句指定了图像的展示位置。Ren'Py中包含了多个域定义的位置关键字:  ``left`` 表示界面左端， ``right`` 表示屏幕右端， ``center`` 表示水平居中(默认位置)， ``truecenter`` 表示水平和垂直同时居中。

创作者可以自己定义位置关键字，甚至复杂的位置移动，不过那超过了本章“快速入门”的范畴。

.. _music-and-sound:

音乐和音效
---------------

*主要内容参见* :doc:`audio`

大多数Ren'Py游戏都会播放背景音乐。音乐播放需要使用play music语句。play music语句将语句中指定的文件名识别为一个音频文件并播放。Ren'Py跟识别音频文件名并在game目录下寻找关联文件。音频文件应该是opus、ogg vorbis或者mp3格式的文件。

举例::

    ###
        play music "audio/illurock.ogg"

更换音乐时，我们可以使用一个fadeout and fadein分句，fadeout and fadein分句用于旧音乐的淡出和新音乐的淡入。 ::

    ###
        play music "audio/illurock.ogg" fadeout 1.0 fadein 1.0

queue music语句表示，在当前音乐播放完毕后播放的音频文件。 ::

    ###
        queue music "audio/next_track.opus"

乐播放可以使用stop music语句停止，这个语句也可选用fadeout分句。 ::

    ###
        stop music

音效可以使用play sound语句来播放。与音乐不同，音效不会循环播放。 ::

    ###
        play sound "audio/effect.ogg"

在“game/audio”目录中的音频文件，如果其文件名去掉文件扩展名后符合Python变量的命名规则(以字母开头且仅包含英文字母、数字或下划线)，
则可以直接不带引号，直接使用文件名播放音频文件。

例如，存在一个音频文件“game/audio/illurock.ogg”。我们可以直接在脚本中写：

::

    ###
        play music illurock

.. _pause-statement:

pause语句
---------------

pause语句可以让整个Ren'Py进程暂停，直到出现鼠标单击事件。 ::

    ###
        pause

如果pause语句中给定一个数字，就只会暂停数字对应的秒数。 ::

    ###
        pause 3.0

.. _ending-the-game:

结束游戏
---------------

通过运行return语句，你可以结束游戏，而不需要做其他任何事。在此之前，最好设置一些东西能够提示游戏已经结束，并且可能的话给用户一个结局数字或者结局名称。 ::

    ###
        ".:. Good 结局。"

        return

这就是你制作一个动态小说(kinetic novel)所需要做的，动态小说是指没有任何分支选项的游戏。现在，我们将关注如何在游戏中为用户提供菜单。

.. _menus-labels-and-jumps:

menu，label和jump语句
-------------------------

*主要内容参见* :doc:`menus` *和* :doc:`label`

menu语句能够给玩家提供一个分支选项::

    ###
        s "当然，不过，什么是\"视觉小说\"？"

    menu:

        "是一种视频游戏。":
            jump game

        "是一种互动小说。":
            jump book

    label game:

        m "是一种可以在电脑和主机上玩的视频游戏。"

        jump marry

    label book:

        m "就像一种可以在电脑和主机上阅读的互动式图书。"

        jump marry

    label marry:

        "那么，我们已经成为视觉小说创作二人组了。"

这个例子展示了在Ren'Py中如何使用menu语句。menu语句提供了一个游戏内的分支选项。menu语句使用一段缩进的文字，每一段文字后都跟着一个冒号。这段文字描述是提供给玩家的选项。每一个选项下面一行的缩进文字，是选择之后对应选项后会运行的脚本内容。

在这个例子中，两个选项中各运行一个jump语句。jump语句将控制转换至label(脚本标签)对应的label语句。在跳转后，脚本会执行label下的语句。

在上面的例子中，Sylvie提出她的问题后，玩家会面临“二选一”的分支选项。如果玩家选择“是一种视频游戏。”，第一个jump语句会执行，Ren'Py会跳转到 ``game`` label脚本位置。这会引发主视角角色说“是一种可以在电脑和主机上玩的视频游戏。”，然后Ren'Py将跳转到 ``marry`` label。

如果label后面相关的语句块(block)之后没有jump语句，Ren'Py会顺序执行后面的语句。最后的jump语句在技术上不是必须的，不过带上一个会让游戏流程显得更清晰。

游戏目录中任意后缀为 .rpy 的文件中都可以定义label。对于Ren'Py来说文件名无关紧要，只有文件里的label才是重点。你可以认为，所有这些rpy文件的合集等价于一个很大的rpy文件，用于跳转和转换控制。这种设计提供了你“构建一个更庞大游戏”的脚本所需的灵活度。

.. _supporting-flags-using-the-default-python-and-if-statements:

使用default、Python和if语句实现flag(标识)
-------------------------------------------

*主要内容参见* :doc:`python` *和* :doc:`conditional`

上面那些语句已经足以用于制作某些游戏，其他一些游戏则需要保存数据及提取数据。例如，制作者需要游戏记下玩家做出的一个选择，先返回主线流程中，并在后面的流程中根据之前的选择出现对应的游戏变现，这是个合理的需求。这就是Ren'Py支持内嵌Python代码的原因。

这一段，我们将演示如何存储一个flag(标识)，该flag(标识)包含了玩家做过的某个选择。我们需要先初始化flag(标识)，在label之前，使用default语句。 ::

    # 如果玩家决定将视觉小说比作一本图书，则设置为True。
    default book = False

    label start:

        s "嗨！今天的课怎么样？"

名为“book”的flag(标识)被初始化为特殊值 ``False`` (请注意首字母大写)，表示该flag还未被设置。如果label “book”对应的路径被选择，我们将使用一个Python assignment(Python 赋值)语句将其设置为True。 ::


    label book:

        $ book = True

        m "就像一种可以在电脑和主机上阅读的互动式图书。"

        jump marry

以美元标志符“$”开头那行文本会被识别为Python语句。assignment(赋值)语句将这里的“book”判定为一个变量而不是一个值。Ren'Py已经支持一些其他包含Python代码的办法，例如多行的Python语句。我们将在本手册的其他章节讨论这点。
Ren'Py现在支持Python 2.7。不过我们还是强烈推荐写可以同时在Python2和Python3两个版本正常运行的Python语句。

需要检查flag(标识)时，请使用if语句::

        if book:

            "我们的第一个游戏是基于希尔维亚的一个主意，但是后面我想实现一个自己设计的故事。"

如果结果为True，if语句下的脚本语句块(block)将执行。相反，if语句下的脚本语句块(block)将被跳过。if语句也可以包含一个else分句，当if结果为False时，将执行else分句中的脚本语句块(block)。::

        if book:

            "我们的第一个游戏是基于希尔维亚的一个主意，但是后面我想实现一个自己设计的故事。"

        else:

            "我们的第一个视频游戏中，希尔维亚在脚本方面给了很多帮助。"

Python变量不仅仅可以是简单的布尔值。变量也可以存储玩家名字、分数或者其他一些想要记录的事情。由于Ren'Py支持Python编程语言的所有功能，许多想法都可能实现。

.. _releasing-your-game:

发布你的游戏
-------------------

一旦你制作了一个游戏，在你发布它之前还有一些事情需要完成。

**检查Ren'Py版本更新**
    基线的新版Ren'Py通常会修复bug和添加新特性。发布前，你需要在启动器(launcher)中点击“更新”，更新到最新版本的Ren'Py。你也可以手动下载新版本并查看版本更新列表，以上工作可以使用这个页面 `https://www.renpy.org/latest.html <https://www.renpy.org/latest.html>`_。

    少数情况下，Ren'Py版本升级变更后会要求你修改原来的游戏脚本。 `https://www.renpy.org/doc/html/incompatible.html <https://www.renpy.org/doc/html/incompatible.html>`_ 页面列出了这些变更明细。

**检查脚本**
    在启动器(launcher)的前端页面，选择“生成分发版”。基于options.rpy文件中的信息，启动器(launcher)会建立一个或多个包含创作者所作游戏的归档文件。

**打包**
    在启动器的首页，选择 "生成分发版"。基于 options.rpy 中所包含的信息，启动器将会建立一个或者更多个包含有游戏文件的归档文件。

**测试**
    lint代码检查工具不能替代完整的使用测试。在发布你的游戏之前，你有责任进行检查。可以考虑请求你的朋友们帮忙进行beta测试，测试者往往能发现你未能发现的问题。

**发布**
    一旦游戏完成并通过测试，你可以将生成的归档文件上传到网上，好让别人能找到它们。(如果你没有自己的网站，试试 `https://itch.io <https://itch.io>`_ 该站点里有一大票视觉小说。) 恭喜，你已经完成了人生中的第一部视觉小说！

    还有几个地方可以发布游戏信息：

    *  `Ren'Py Games List <https://games.renpy.org>`_ 帮助我们追踪记录制作中的Ren'Py游戏。

    * `Completed Games section of the Lemma Soft Forums <https://lemmasoft.renai.us/forums/viewforum.php?f=11>`_ 是个向后来人诉说关于你游戏故事的好地方。

更多定制化游戏打包的高级方式详见 :doc:`build` 章节。

.. _script-of-the-question:

“The Question”的游戏脚本
--------------------------

你可以在 :ref:`这里 <thequestion>` 查看完整的“The Question”游戏脚本。

.. _where-do-we-go-from-here:

离开这里之后我们可以去哪里进一步学习？
---------------------------------------

从零开始的快速入门只是Ren'Py功能的惊鸿一瞥。限于篇幅原因，我们省略了很多Ren'Py支持的特性，并尽可能地做出简化——专注于“制作一部视觉小说”的最小功能特性集。

想要感受Ren'Py所有功能的话，请玩一些演示游戏，可能的话通过网站 `Ren'Py website <https://www.renpy.org/>`_ 了解一些游戏特性。你也可能会想要阅读本手册的其他内容，从GUI(用户图形界面)定制向导开始吧。

除此之外，我们推荐你看看 `Lemma Soft Forums <https://lemmasoft.renai.us/forums>`_ 论坛的Ren'Py版块，该版块里有三个子版块，分别用于问答、各类库的使用手册以及可以用于二次开发的样例。Lemma Soft Forums论坛是Ren'Py的交流中枢，我们非常欢迎新近入坑的创作者以及他们带来的问题。

感谢你选择Ren'Py视觉小说引擎。我们期待着您使用它创造出作品的那一天！
