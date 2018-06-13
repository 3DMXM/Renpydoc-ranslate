.. _image-gallery-music-room-and-replay-actions:

=============================================
画廊、音乐空间和场景回放
=============================================

.. _image-gallery:

画廊
-------------

画廊是一个专门的界面，允许用户解锁并查看图片。该界面有一个或多个相关联的按钮，每个按钮都有对应的图片。按钮和图片的状态取决于是否已被解锁。

Gallery类实例管理画廊。同一个gallery类的实例可能会被多个画廊界面共同使用。

画廊有一个或多个相关联的按钮，每个按钮都有对应的图片，每个图片对应一个或多个可视组件。当某个按钮对应的条件全部满足并与该按钮关联的图片至少解锁一张时，这个按钮也就被解锁了。所有关联条件全部满足时，图片就能解锁。

创建画廊需要下面四步。

1. 创建一个Gallery实例。

2. 在Gallery实例中添加按钮和图片，以及解锁按钮和图片需要的条件。这也是一个多步过程。

   1. 调用 :meth:`Gallery.button` 定义一个新的按钮。

   2. 可选，调用 :meth:`Gallery.unlock` 或 :meth:`Gallery.condition` 添加一个或多个解锁条件至按钮。

   3. 使用一个或多个可视组件作为参数，调用 :meth:`Gallery.image` 定义一个图像(image)。或者直接调用 :meth:`Gallery.unlock_image` 。

   4. 可选，调用 :meth:`Gallery.transform` 将可视组件与变换(transform)相关联。

   5. 可选，调用 :meth:`Gallery.unlock` 、:meth:`Gallery.condition` 或 :meth:`Gallery.allprior` 给图像添加一个或多个解锁条件。

   重复步骤3至5就可以再次添加按钮，重复所有5个步骤就可以再次添加图片。

3. 创建一个画廊界面。界面应该显示一个背景，并且包含导航，允许用户转到其他画廊或者返回主菜单及额外菜单(extras menu)。

4. 在主菜单和额外菜单上添加进入画廊界面的入口。

这是一个前3步的样例：

::

    init python:

        # 步骤1，创建Gallery对象。
        g = Gallery()

        # 步骤2，在画廊中添加按钮和图像。

        # 添加一个包含自动解锁图像的按钮。
        g.button("dawn")
        g.image("dawn1")
        g.unlock("dawn1")

        # 该按钮有多个关联图像。
        # 我们使用unlock_image函数，这样就不需要同时调用“.image”和“.unlock”了。
        # 我们也在第一张图像上添加了一个变换效果。
        g.button("dark")
        g.unlock_image("bigbeach1")
        g.transform(slowpan)
        g.unlock_image("beach1 mary")
        g.unlock_image("beach2")
        g.unlock_image("beach3")

        # 该按钮有一个关联的条件，允许游戏选择是否解锁图片。
        g.button("end1")
        g.condition("persistent.unlock_1")
        g.image("transfer")
        g.image("moonpic")
        g.image("girlpic")
        g.image("nogirlpic")
        g.image("bad_ending")

        g.button("end2")
        g.condition("persistent.unlock_2")
        g.image("library")
        g.image("beach1 nomoon")
        g.image("bad_ending")

        # 该按钮的最后一张图像有一个关联条件，只有只有达到两种结局才会解锁。
        g.button("end3")
        g.condition("persistent.unlock_3")
        g.image("littlemary2")
        g.image("littlemary")
        g.image("good_ending")
        g.condition("persistent.unlock_3 and persistent.unlock_4")

        g.button("end4")
        g.condition("persistent.unlock_4")
        g.image("hospital1")
        g.image("hospital2")
        g.image("hospital3")
        g.image("heaven")
        g.image("white")
        g.image("good_ending")
        g.condition("persistent.unlock_3 and persistent.unlock_4")

        # 后面两个按钮包含会同时显示的多个图片。
        # 这可能会用于在背景上显示人物立绘。
        g.button("dawn mary")
        g.unlock_image("dawn1", "mary dawn wistful")
        g.unlock_image("dawn1", "mary dawn smiling")
        g.unlock_image("dawn1", "mary dawn vhappy")

        g.button("dark mary")
        g.unlock_image("beach2", "mary dark wistful")
        g.unlock_image("beach2", "mary dark smiling")
        g.unlock_image("beach2", "mary dark vhappy")

        # 用于图像切换使用的转场(transition)。
        g.transition = dissolve

    # Step 3. 我们使用的画廊界面。
    screen gallery:

        # 确保画廊界面替换主菜单。
        tag menu

        # 背景图。
        add "beach2"

        # 按钮网格(grid)。
        grid 3 3:

            xfill True
            yfill True

            # 调用make_button显示具体的按钮。
            add g.make_button("dark", "gal-dark.png", xalign=0.5, yalign=0.5)
            add g.make_button("dawn", "gal-dawn.png", xalign=0.5, yalign=0.5)
            add g.make_button("end1", "gal-end1.png", xalign=0.5, yalign=0.5)

            add g.make_button("end2", "gal-end2.png", xalign=0.5, yalign=0.5)
            add g.make_button("end3", "gal-end3.png", xalign=0.5, yalign=0.5)
            add g.make_button("end4", "gal-end4.png", xalign=0.5, yalign=0.5)

            add g.make_button("dark mary", "gal-dark_mary.png", xalign=0.5, yalign=0.5)
            add g.make_button("dawn mary", "gal-dawn_mary.png", xalign=0.5, yalign=0.5)

            # 用于响应后返回主菜单的界面。
            # 也能用于导航到其他画廊界面。
            textbutton "Return" action Return() xalign 0.5 yalign 0.5

步骤4会由于游戏结构的不同而大相径庭，不过一种通用办法是添加下面这行：

::

        textbutton "Gallery" action ShowMenu("gallery")

主菜单界面添加画廊选项。

.. class:: Gallery(self)

  该类支持画廊实例的创建。该类提供的处理锁定图片的函数、显示一个或者多个图片的动作，以及创建按钮使用那个动作的方法。

  .. attribute:: transition

    改变图像时使用的转场(transition)。

  .. attribute:: locked_button

    make_button用于某个被锁定按钮的默认可视组件。

  .. attribute:: hover_border

    make_button使用的默认鼠标悬垂(hover)边界(border)。

  .. attribute:: idle_border

    make_button使用的默认空闲(idle)边界(border)。

  .. attribute:: unlocked_advance

    若为True，画廊只会在解锁的图片中advance through。

  .. attribute:: navigation

    若为True，画廊会在图片的上方显示导航和幻灯片按钮。

    若要定制导航外观，你可以重写gallery_navigation界面。默认的界面定义在common/00gallery.rpy中。

  .. attribute:: span_buttons

    若为True，添加span按钮。

  .. attribute:: slideshow_delay

    使用幻灯片模式时，画廊中每张图片的播放时间。

  .. method:: Action(name)

    一个动作(action)，显示与给定的按钮名name相关联的图像。

  .. method:: Next(unlocked=False)

    前进至画廊的下一个图片。

    `unlocked`
      若为True，只使用已解锁的图片。

  .. method:: Previous(unlocked=False)

    后退至画廊的上一个图片。

    `unlocked`
      若为True，只使用已解锁的图片。

  .. method:: Return(self)

    停止显示画廊图片。

  .. method:: ToggleSlideshow(self)

    切换幻灯片模式。

  .. method:: allprior(self)

    一个条件函数，当前按钮关联的所有主要图片都解锁的情况下为True。

  .. method:: button(name)

    创建一个名为 *name* 的按钮。

    `name`
      创建的按钮名称。

  .. method:: condition(expression)

    一个条件函数，expression为真时表示条件满足。

    `expression`
      一个Python表达式字符串。

  .. method:: display(*displayables)

    将一个新的图像添加至当前按钮。该图像由一个或多个可视组件构成。

  .. method:: get_fraction(name, format=u'{seen}/{total}')

    返回一个文本字符串，表示名为 *name* 的按钮的已解锁图片数和图片总数。

    `format`
      一个Python格式字符串，用于格式化数值。有三种可以被替换的值：

      **{seen}**
        已经看过的图片的数值。

      **{total}**
        按钮中图片总数。

      **{locked}**
        依然锁定的图片数量。

  .. method:: image(*displayables)

    将一个新的图像添加至当前按钮。该图像由一个或多个可视组件构成。

  .. method:: make_button(name, unlocked, locked=None, hover_border=None, idle_border=None, **properties)

    该函数创建一个按钮，显示与给定按钮名相关联的图像。

    `name`
      需要创建的按钮名称。

    `unlocked`
      当按钮解锁时显示的可视组件。

    `locked`
      当按钮锁定时显示的可视组件。若为None，将使用画廊对象的locked_button字段(field)值。

    `hover_border`
      当按钮解锁并得到焦点时，覆盖在按钮上的可视组件。若为None，将使用画廊对象的hover_border字段(field)值。

    `idle_border`
      当按钮解锁未得到焦点是，覆盖在按钮上的可视组件。若为None，将使用画廊对象的idle_border字段(field)值。

    更多的关键词入参会成为所创建按钮对象的样式特性(sytle property)。

  .. method:: transform(*transforms)

    将变换(transform)应用于注册的最后一张图片。该函数被调用时应该包含与图片中可视组件数量相同的变换(transform)数量。每个变换分别对应一个可视组件。

    如果某个变换为None，就使用默认的变换。

  .. method:: unlock(*images)

    一个条件函数，使用一个或多个图片名作为入参，当所有入参的图像都被用户看过时表示条件满足。图片名称应该是字符串。

  .. method:: unlock_image(*images)

    一个简便的函数，等效于使用相同的参数调用图片对象并解锁。这个函数会触发某个图片的显示，前提是这个图片之前被看过。

    指定的图片名应该是字符串。

.. _music-room:

音乐空间
----------

音乐空间是允许用于选择和播放游戏内音轨的界面。这些音轨可能在用户刚开始玩时是锁定的，随着游戏进度的推进逐步解锁。

音乐空间通过MusicRoom类的实例进行管理。游戏中允许存在多个MusicRoom实例，允许存在多个音乐空间。创建一个音乐空间包含以下四个步骤：

1. 创建一个MusicRoom实例。MusicRoom构造器使用的参数控制音乐播放使用的通道(channel)，以及音乐的淡入淡出效果时长。

2. 将音乐文件添加至实例。

3. 创建一个使用MusicRoom实例的界面，界面中包含按钮、图片按钮和热站(hotspot)。界面中还包含能拾取音轨、进入下一个或上一个音轨、暂停或开始播放音乐的动作(action)。

   需要注意，动作(action)用作某个MusicRoom实例的成员函数，所以如果MusicRoom实例名为mr，那么mr.Play("track1.ogg")就是播放动作的正确用法。

4. 将音乐空间界面添加到主菜单或者额外菜单。

这是一个前三步的样例：

::

    init python:

        #  步骤1，创建一个MusicRoom实例。
        mr = MusicRoom(fadeout=1.0)

        # Step 2. 添加音乐文件。
        mr.add("track1.ogg", always_unlocked=True)
        mr.add("track2.ogg")
        mr.add("track3.ogg")


    # Step 3. 创建音乐空间界面。
    screen music_room:

        tag menu

        frame:
            has vbox

            # 每条音轨的播放按钮。
            textbutton "Track 1" action mr.Play("track1.ogg")
            textbutton "Track 2" action mr.Play("track2.ogg")
            textbutton "Track 3" action mr.Play("track3.ogg")

            null height 20

            # 切换音轨按钮。
            textbutton "Next" action mr.Next()
            textbutton "Previous" action mr.Previous()

            null height 20

            # 用户退出音乐空间的按钮。
            textbutton "Main Menu" action ShowMenu("main_menu")

        # 音乐空间的音乐播放入口。
        on "replace" action mr.Play()

        # 离开时恢复主菜单的音乐。
        on "replaced" action Play("music", "track1.ogg")

步骤4会由于游戏结构的不同而大相径庭，不过一种通用办法是添加下面这行：

::

        textbutton "Music Room" action ShowMenu("music_room")

主菜单界面添加音乐空间选项。

使用 :func:`Preferences` 函数，特别是
``Preferences("music volume")`` ，就可以在音乐界面添加一个音量滑块。

.. class:: MusicRoom(channel=u'music', fadeout=0.0, fadein=0.0, loop=True, single_track=False, shuffle=False, stop_action=None)

  一个音乐空间类，包含一系列可由用户解锁的曲子，以及顺序播放音频列表的动作。

  `channel`
    音乐空间使用的音频通道。

  `fadeout`
    改变音轨时，渐出效果时长，单位为秒。

  `fadein`
    改变音轨时，渐入效果时长，单位为秒。

  `loop`
    当播放列表到达结尾时，决定循环播放还是停止播放。

  `single_track`
    若为True，每次只播放一条音轨。若 *loop* 为True，则循环播放这条音轨。否则在音轨结束时结束播放。

  `shuffle`
    若为True，所有音轨乱序播放。若为False，根据音轨加入到音乐空间的顺序播放。

  `stop_action`
    当音乐停止时执行的动作(action)。

  *single_track* 和 *shuffle* 两项是冲突的，二者最多只有一项能设置为True。(设置 *single_track* 和 *shuffle* 的动作会有这样的强制要求)。

  .. method:: Next(self)

    触发音乐空间播放列表中下一个已解锁音乐的动作。

  .. method:: Play(filename=None)

    这个动作触发音乐空间开始播放音乐。如果给定了 *filename* ，就开始播放对应的音频文件。否则，当前播放文件重新开始(前提是已经解锁)，或者播放第一个音频文件。

    如果给定了 *filename* ，但对应的音频依然被锁定，那对应的按钮是不可用状态，正在播放的 *filename* 会被设为被选中状态。

  .. method:: Previous(self)

    让音乐空间播放列表中上一个解锁文件的动作。

  .. method:: RandomPlay(self)

    让音乐空间播放随机选择的一个解锁音轨的动作。

  .. method:: SetLoop(value)

    这个动作设置loop特性的值。

  .. method:: SetShuffle(value)

    这个动作设置shuffle特性的值。

  .. method:: SetSingleTrack(value)

    这个动作设置single_track特性的值。

  .. method:: Stop(self)

    这个动作停止音乐播放。

  .. method:: ToggleLoop(self)

    这个动作切换loop特性的值。

  .. method:: TogglePlay(self)

    如果当前没有任何音乐在播放，这个动作会开始播放第一个解锁的音轨。否则，停止当前音乐的播放。

    任何音乐播放时，这个按钮都是可用状态。

  .. method:: ToggleShuffle(self)

    这个动作切换shuffle特性的值。

  .. method:: ToggleSingleTrack(self)

    这个动作切换single_track特性的值。

  .. method:: add(filename, always_unlocked=False, action=None)

    将音乐文件 *filename* 添加到音乐空间。音乐空间中文件被添加的顺序就是音乐播放的默认顺序。

    `always_unlocked`
      若为True，音乐文件始终是解锁状态。这个设置允许音乐文件在游戏播放过之前，就可以在音乐空间中使用。

    `action`
      这是一个动作或者动作列表。当文件播放时，这个动作或动作列表会被调用。

      例如，这些动作可以用于播放音乐文件时改变界面或者背景。

  .. method:: is_unlocked(filename)

    如果 *filename* 已被解锁(或一直是解锁)则返回True，否则返回False。

.. _replay:

回放
------

Ren'Py也提供了从主菜单或游戏菜单回放某个场景的能力。这可以用来创建一个“场景画廊”或者“回忆画廊”，允许用户重复重要的场景。在对应的场景结束后，Ren'Py会返回到启动回放前的菜单界面。

场景回放也可以使用 :func:`Start` 动作。这两种模式的差别如下：

* 回放可以从任何界面启动，而Start只能使用在主菜单或者主菜单显示的界面。

* 当回放结束，主控流程会回到回放启动的点。那个点可能是在主菜单或者游戏菜单中。如果某个游戏运行过程中调用了回放，游戏状态是可保存的。

* 在回放模式下禁用存档。

* 在回放模式下，调用 :func:`renpy.end_replay` 会结束回放。在普通模式下，renpy.end_replay()不产生任何效果。

需要使用回放模式的优势，需要在场景开始添加一个文本标签(label)，在结尾添加一个renpy.end_replay的调用。界面不应该假设在普通模式和回放模式下图层(layer)或变量的状态不同。(在回放开头，标签会被一个黑屏界面唤起。)

举例：

::

  ###

       "最后，我终于见到了魔导士本尊。"

  label meaning_of_life:

       scene

      "魔术师" "你问我，生命的意义？"

      "魔术师" "我曾经苦思冥想，并为获取这个问题的答案耗费了大量时光。"

      "魔术师" "而现在我会这样回答这个问题——生命的意义是……"

      "魔术师" "是43。"

      $ renpy.end_replay()

      "魔术师" "总之就是类似的玩意儿。"

(译者注：这个梗比较冷僻，稍作解释。道格拉斯·亚当斯的小说《银河系漫游指南》中提到，42是“生命、宇宙以及任何事情的终极答案”。
此后，42经常被用来表示致敬。援引维基百科上对 `42 <https://zh.wikipedia.org/wiki/42>`_ 的解释，几个最著名的致敬梗有：

- 若在Google输入the answer to life, the universe, and everything，Google会直接回答42——而且还是用Google计算器算出来的。
- 若在Wolfram Alpha中输入Answer to the Ultimate Question of Life, the Universe, and Everything，Wolfram Alpha也会回答42。
- 若在Siri中问“What's the meaning of life?”，Siri也会回答42。
- 在英雄联盟中召唤峡谷地图中使用汉默丁格能偶尔听到他说到“42~一个神秘的数字，某些东西与它有关~”

此处魔术师回答“43”也是对此的恶搞。)

这样定义的场景(scene)，就可以使用回放动作唤起回放了。

::

  textbutton "生命的意义" action Replay("meaning_of_life")

回放模式有一个专用的存储变量：

.. var:: _in_replay

   在回放模式下，这个变量就是回放开始的文本标签(label)。非回放模式下，这个变量值是None。

除此之外，:var:`config.enter_replay_transition` 和
:var:`config.exit_replay_transition` 会分别使用在进入和离开回放模式时。在进入回放时， :var:`config.replay_scope` 会向清理后的存储区添加变量，默认情况下会设置
:var:`_game_menu_screen` 以触发“右键点击动作”默认显示环境设定界面。

回放模式下一下变量和动作会被使用：

.. function:: EndReplay(confirm=True)

  结束当前回放。

  `confirm`
    若为True，结束回放前提示用户确认。

.. function:: Replay(label, scope={}, locked=None)

  从 *label* 处开始回放的动作。

  `scope`
    一个字典，表示从变量名与变量值的映射关系。进入回放时，所有变量会设置该字典的值。

  `locked`
    若为True，该回放锁定。若为False，该回放解锁。若为None，如果游戏进度未进展到对应标签则锁定回放。

.. function:: renpy.call_replay(label, scope={})

  将脚本标签(label)视为一个回忆。

  关键词入参用于设置回忆场景的变量初始值。

.. function:: renpy.end_replay()

  处在回放时，立刻结束回放。否则，不做任何事。
