.. _screen-special:

.. _special-screen-names:

====================
特殊界面名称
====================

在Ren'Py中总共有两类特殊界面名称。第一类是在Ren'Py脚本语言命令(或者等效的程序)运行时自动显示的部分。另一类是菜单界面。这些界面沿袭管用名称，实现惯用功能，但界面名可以省略或者修改为不需要实际写出来。

在本页内容中，我们会给出一些界面样例。需要意识到的重点是，一些界面必须包含精简的功能，界面系统允许在界面上添加额外的功能。例如，标准的say界面只能显示文本，使用界面系统就很容易添加跳过(skipping)、自动前进(auto-forwar)模式及静音(muting)。

一些特殊界面会使用参数。这些参数可以在界面的作用域(scope)中，以变量的形式访问。

一些界面也还有关联的专属id。专属id会被分配给指定类型的可视组件。其还可以导致特性(property)分配给对应的可视组件，并可以让Ren'Py显示界面的其他部分可以访问这个可视组件。

.. _in-game-screens:

游戏内界面
===============

当某个Ren'Py语句执行时，这些界面会自动显示。

.. _say-screen:

Say
---

``say`` 界面在ADV模式对话时，通过say语句被调用。其显示时使用下列参数：

`who`
    发言角色名的文本。
`what`
    发言角色说的内容。

需要使用下列id声明可视组件：

"who"
    一个文本组件，显示发言角色名。character对象可以使用入参提供组件样式。

"what"
    一个文本组件，显示发言角色说的内容。character对象可以使用入参提供组件样式。 **带有该id的可视组件必须被定义** ，因为Ren'Py会使用它继续按自动前进模式的时间，点击继续等。

"window"
    一个窗口或者框架。按照习惯其包含who和what文本。character对象可以使用入参提供组件样式。

::

    screen say(who, what):

        window id "window":
            has vbox

            if who:
                text who id "who"

            text what id "what"


.. _choice-screen:

Choice
------

``choice`` 界面使用menu语句显示游戏内选项。其会使用下列参数：

`items`
    这是一个菜单入口对象列表，表示菜单中的各个选项。每个菜单入口对象包含以下的字段(field)：

    .. attribute:: caption

        菜单选项标题字符串。

    .. attribute:: action

        当菜单选项被选择时执行的行为。如果这是菜单行为(action)的话，可以为None，且
        :var:`config.narrator_menu` 的值为False。

    .. attribute:: chosen

        整个游戏流程中该选项至少被选择过一次，则为True。

    .. attribute:: args

        一个元组，包含所以传入菜单选项的固定位置入参。

    .. attribute:: kwargs

        一个字典，包含所有传入菜单选项的关键词参数。

    以上内容和行为，都会在menu语句接受后失效。

另外，传入menu语句的所有入参都在调用对应界面时才真正执行传参。

::

    screen choice(items):

        window:
            style "menu_window"

            vbox:
                style "menu"

                for i in items:

                    if i.action:

                        button:
                            action i.action
                            style "menu_choice_button"

                            text i.caption style "menu_choice"

                    else:
                        text i.caption style "menu_caption"


.. _input-screen:

Input
-----

``input`` 界面用于显示 :func:`renpy.input`。其使用一项参数。

`prompt`
    应用于renpy.input的提示文本。

通常使用下面的id定义一个可视组件：

**"input"**
    一个必须存在的输入组件。其所有参数都会应用于renpy.input，所以必须存在。

::

    screen input(prompt):

        window:
            has vbox

            text prompt
            input id "input"


.. _nvl-screen:

NVL
---

``nvl`` 界面用于显示NVL模式的对话。其使用下列参数：

`dialogue`
    NVL层(entry)对象列表。每一个对象对应一行显示的对话。每一层(entry)都有如下的字段(field)：

    .. attribute:: current

        若是对话的当前行则返回True。对话当前行必须必须使用名为“what”的id来显示文本。

    .. attribute:: who

        发言角色名字，如果没有对应的角色则为None。

    .. attribute:: what

        发言内容文本。

    .. attribute:: who_id, what_id, window_id

        分别对应相关的层(entry)上发言者、对话和窗口的id。

    .. attribute:: who_args, what_args, window_args

        发言者、对话和窗口相关的特性(property)。这些字段(field)会自动被应用，前提是上述的id被正确配置。但也可以分开配置使这些字段(field)可用。

    .. attribute:: multiple

        如果使用 :doc:`多角色对话 <multiple>`，这就是个具有2个元素的元组。第一个元素是个从1开始的对话语句块(block)编号，第二个参数是multiple语句的对话语句块(block)总数。

`items`
    这是所有会用在
    :ref:`选择界面 <choice-screen>` 中的item列表。如果列表是空的，则菜单就不会显示。

如果 `items` 不存在，NVL界面通常会给出id为“what”的文本部件(widget)。Ren'Py使用这个文本不见计算自动前进模式时间、点击继续等。(如果使用默认what_id的话，就能启用自动模式。)

Ren'Py 也支持 ``nvl_choice`` 界面，这个界面与 ``nvl`` 界面使用相同的参数，而且当向用户展示游戏内选项时会使用这些参数作为显示环境设定。

::

    screen nvl(dialogue, items=None):

        window:
            style "nvl_window"

            has vbox:
                style "nvl_vbox"

            # 显示对话。
            for d in dialogue:
                window:
                    id d.window_id

                    has hbox:
                        spacing 10

                    if d.who is not None:
                        text d.who id d.who_id

                    text d.what id d.what_id

            # 如果存在菜单就显示。
            if items:

                vbox:
                    id "menu"

                    for i in items:

                        if action:

                            button:
                                style "nvl_menu_choice_button"
                                action i.action

                                text i.caption style "nvl_menu_choice"

                        else:

                            text i.caption style "nvl_dialogue"


.. _notify-screen:

Notify
------

``notify`` 界面被 :func:`renpy.notify` 函数用于向用户显示通知消息。其主要用于连接某个transform，以处理整个通知任务。它仅使用一个参数：

`message`
    显示的信息。

默认的notify界面和关联的transform如下：

::

    screen notify(message):
        zorder 100

        text message at _notify_transform

        # 这控制界面第一次显示和隐藏之间的时间。
        timer 3.25 action Hide('notify')

    transform _notify_transform:
        # 这些控制位置
        xalign .02 yalign .015

        # 这些控制显示隐藏的行为。
        on show:
            alpha 0
            linear .25 alpha 1.0
        on hide:
            linear .5 alpha 0.0

.. _skip-indicator:

跳过提示
--------------

``skip_indicator`` 界面在“跳过”过程中出现，完成“跳过”后隐藏。其不使用任何参数。

这是一个非常简单的跳过提示界面：

::


    screen skip_indicator():

        zorder 100

        text _("Skipping")

.. _ctc-screen:

CTC(点击继续)
-----------------------

``ctc`` 界面会在对话显示完毕，提示用户点击显示更多文本的情况下出现。其可能会使用一个参数。

`arg`
    如果 :func:`Character` 对象有一个 `ctc` 入参，就会被作为第一个固定位置入参传入ctc界面。

这是一个非常简单的ctc界面：

::

    screen ctc(arg=None):

        zorder 100

        text _("Click to Continue"):
            size 12
            xalign 0.98
            yalign 0.98

            add arg

            text _("点击继续"):
                size 12

.. _out-of-game-menu-screens:

游戏外菜单界面
========================

这些是菜单界面。 ``main_menu`` 和 ``yesno_prompt`` 会被隐式调用。当用户调用游戏菜单时，名为 :data:`_game_menu_screen` 的界面就会显示。(默认与 ``save`` 相同。)

记住，菜单界面可以任意组合和修改。

.. _main-menu-screen:

主菜单(Main Menu)
-------------------

``main_menu`` 界面是游戏开始时显示的第一个界面。

::

    screen main_menu():

        # 这步确保任何其他菜单界面都会被替换。
        tag menu

        # 主菜单背景。
        window:
            style "mm_root"

        # 主菜单按钮。
        frame:
            style_prefix "mm"
            xalign .98
            yalign .98

            has vbox

            textbutton _("Start Game") action Start()
            textbutton _("Load Game") action ShowMenu("load")
            textbutton _("Preferences") action ShowMenu("preferences")
            textbutton _("Help") action Help()
            textbutton _("Quit") action Quit(confirm=False)

    style mm_button:
        size_group "mm"

.. _navigation-screen:

Navigation
----------

``navigation`` 界面在Ren'Py中并不特殊。但按照惯例，我们会在名为 ``navigation`` 的界面放置游戏菜单导航，并在那个界面导向存档、读档和环境设定界面。

::

    screen navigation():

        # 游戏菜单背景。
        window:
            style "gm_root"

        # 变化后的按钮。
        frame:
            style_prefix "gm_nav"
            xalign .98
            yalign .98

            has vbox

            textbutton _("Return") action Return()
            textbutton _("Preferences") action ShowMenu("preferences")
            textbutton _("Save Game") action ShowMenu("save")
            textbutton _("Load Game") action ShowMenu("load")
            textbutton _("Main Menu") action MainMenu()
            textbutton _("Help") action Help()
            textbutton _("Quit") action Quit()

    style gm_nav_button:
        size_group "gm_nav"

.. _save-screen:

Save
----

``save`` 界面用于选择一个文件保存游戏进度。

::

    screen save():

        # 这步确保任何其他菜单界面都会被替换。
        tag menu

        use navigation

        frame:
            has vbox

            # 最顶部的按钮允许用户选取文件的某个页面(page)。
            hbox:
                textbutton _("Previous") action FilePagePrevious()
                textbutton _("Auto") action FilePage("auto")

                for i in range(1, 9):
                    textbutton str(i) action FilePage(i)

                textbutton _("Next") action FilePageNext()

            # 显示一个文件槽位的网格。
            grid 2 5:
                transpose True
                xfill True

                # 显示10个文件槽位，编号1到10。
                for i in range(1, 11):

                    # 每个文件槽位都是一个按钮。
                    button:
                        action FileAction(i)
                        xfill True
                        style "large_button"

                        has hbox

                        # 对按钮添加截屏和描述。
                        add FileScreenshot(i)
                        text ( " %2d. " % i
                               + FileTime(i, empty=_("Empty Slot."))
                               + "\n"
                               + FileSaveName(i)) style "large_button_text"

.. _load-screen:

Load
----

``load`` 界面用户选取一个文件加载游戏进度。

::

    screen load():

        # 这步确保任何其他菜单界面都会被替换。
        tag menu

        use navigation

        frame:
            has vbox

            # 最顶部的按钮允许用户选取文件的某个页面(page)。
            hbox:
                textbutton _("Previous") action FilePagePrevious()
                textbutton _("Auto") action FilePage("auto")

                for i in range(1, 9):
                    textbutton str(i) action FilePage(i)

                textbutton _("Next") action FilePageNext()

            # 显示一个文件槽位的网格。
            grid 2 5:
                transpose True
                xfill True

                # 显示10个文件槽位，编号1到10。
                for i in range(1, 11):

                    # 每个文件槽位都是一个按钮。
                    button:
                        action FileAction(i)
                        xfill True
                        style "large_button"

                        has hbox

                        # 对按钮添加截屏和描述。
                        add FileScreenshot(i)
                        text ( " %2d. " % i
                               + FileTime(i, empty=_("Empty Slot."))
                               + "\n"
                               + FileSaveName(i)) style "large_button_text"

.. _preferences-screen:

Preferences
-----------

``preference`` 界面用于提供游戏显示方面的环境设定选项。

环境设定主要是 :func:`Preference` 返回的行为或者条(bar)值。

::

    screen preferences():

        tag menu

        # 包含导航。
        use navigation

        # 将每行导航放入三列宽度的网格中。
        grid 3 1:
            style_prefix "prefs"
            xfill True

            # 左列。
            vbox:
                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Display")
                    textbutton _("Window") action Preference("display", "window")
                    textbutton _("Fullscreen") action Preference("display", "fullscreen")

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Transitions")
                    textbutton _("All") action Preference("transitions", "all")
                    textbutton _("None") action Preference("transitions", "none")

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Text Speed")
                    bar value Preference("text speed")

                frame:
                    style_prefix "pref"
                    has vbox

                    textbutton _("Joystick...") action ShowMenu("joystick_preferences")

            vbox:

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Skip")
                    textbutton _("Seen Messages") action Preference("skip", "seen")
                    textbutton _("All Messages") action Preference("skip", "all")

                frame:
                    style_prefix "pref"
                    has vbox

                    textbutton _("Begin Skipping") action Skip()

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("After Choices")
                    textbutton _("Stop Skipping") action Preference("after choices", "stop")
                    textbutton _("Keep Skipping") action Preference("after choices", "skip")

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Auto-Forward Time")
                    bar value Preference("auto-forward time")

            vbox:

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Music Volume")
                    bar value Preference("music volume")

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Sound Volume")
                    bar value Preference("sound volume")
                    textbutton "Test" action Play("sound", "sound_test.ogg") style "soundtest_button"

                frame:
                    style_prefix "pref"
                    has vbox

                    label _("Voice Volume")
                    bar value Preference("voice volume")
                    textbutton "Test" action Play("voice", "voice_test.ogg") style "soundtest_button"

    style pref_frame:
        xfill True
        xmargin 5
        top_margin 5

    style pref_vbox:
        xfill True

    style pref_button:
        size_group "pref"
        xalign 1.0

    style pref_slider:
        xmaximum 192
        xalign 1.0

    style soundtest_button:
        xalign 1.0

.. _yesno-prompt-screen:
.. _confirm-screen:

Confirm
-------

``confirm`` 界面用于让用户做出“yes/no”类型的选择。其使用下列参数：

`message`
    显示给用户的信息。其是下列问题之一：

    * gui.ARE_YOU_SURE - "Are you sure?" 如果详细信息未知，这是默认问题。
    * gui.DELETE_SAVE - "Are you sure you want to delete this save?"
    * gui.OVERWRITE_SAVE - "Are you sure you want to overwrite your save?"
    * gui.LOADING - "Loading will lose unsaved progress.\nAre you sure you want to do this?"
    * gui.QUIT - "Are you sure you want to quit?"
    * gui.MAIN_MENU - "Are you sure you want to return to the main\nmenu? This will lose unsaved progress."
    * gui.END_REPLAY - "Are you sure you want to end the replay?"
    * gui.SLOW_SKIP = "Are you sure you want to begin skipping?"
    * gui.FAST_SKIP_SEEN = "Are you sure you want to skip to the next choice?"
    * gui.FAST_SKIP_UNSEEN = "Are you sure you want to skip unseen dialogue to the next choice?"
    * UNKNOWN_TOKEN - This save was created on a different device. Maliciously constructed save files can harm your computer. Do you trust this save's
      creator and everyone who could have changed the file?
    * TRUST_TOKEN - Do you trust the device the save was created on? You should only choose yes if you are the device's sole user.

    这些变量的值都是字符串，表示都可以使用文本组件显示。

`yes_action`
    当用户选择“Yes”时执行的行为。

`no_action`
    当用户选择“No”时执行的行为。

直到Ren'Py的6.99.10版本为止，该界面都称之为 ``yesno_prompt`` 界面。如果没有出现 ``confirm`` 界面，就是用 ``yesno_prompt`` 界面替代。

此界面也可以使用 :func:`renpy.confirm` 函数和 :func:`Confirm` 行为唤起。

::

    screen confirm(message, yes_action, no_action):

        modal True

        window:
            style "gm_root"

        frame:
            style_prefix "confirm"

            xfill True
            xmargin 50
            ypadding 25
            yalign .25

            vbox:
                xfill True
                spacing 25

                text _(message):
                    text_align 0.5
                    xalign 0.5

                hbox:
                    spacing 100
                    xalign .5
                    textbutton _("Yes") action yes_action
                    textbutton _("No") action no_action
