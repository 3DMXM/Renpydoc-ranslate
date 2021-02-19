.. _store-variables:

存储区配置项
===============

Ren'Py有一些存储区配置项，控制存储区的功能。存储区配置项可以随时改变。如果在游戏启动后某个存储区配置项发生改变，配置项值会通过存档系统保存和读取，在发生回滚操作时也跟着回滚。

.. var:: adv = Character(...)

    这是一个ADV模式的模板角色，也是调用 :func:`Character` 时产生的默认角色类型。

.. var:: _autosave = True

    该项设置为False可以禁用自动保存。

.. var:: _confirm_quit = True

    这项决定了退出游戏时是否需要确认。在splashscreeen上这个值是False，在主菜单则会被忽略。

.. var:: default_mouse

    该项默认不做定义。如果定义该项，并且 :var:`config.mouse` 有设置过，而且游戏启动后在 config.mouse 中没有找到对应的图片资源，该项将作为鼠标光标图片的默认值。

.. var:: _dismiss_pause = True

    若为True，用户可以跳过暂停和转场(transition)。

.. var:: _game_menu_screen = "save"

    这项配置的是一个界面名，当进入游戏菜单而没有指定界面时，就会显示这个界面。(例如，右键点击、按下Esc键、不带入参调用 :func:`ShowMenu` 等。)若为None，则禁止进入游戏菜单。

    在splashscreeen启动阶段，这项会设置为None。直到splashscreen结束后会恢复为原来的值。

.. var:: _history = True

    若为True，Ren'Py会在某行对话显示时记录在对话历史中。(注意， :var:`config.history_list_length` 也需要同时设置。)

.. var:: _history_list = [ ]

    这是一个历史对象列表，分别对应从历史记录中从最早到最新的每一行。详见 :ref:`History <history>` 章节内容。

.. var:: _ignore_action = None

    当这项不为None时，表示在错误处理界面点击忽略(ignore)时运行的动作(action)。这个动作通常是 :func:`Jump`，跳转到游戏中能从错误中恢复的某个地方。若为None，主控流程会从下一个Ren'Py语句继续执行。

.. var:: main_menu = False

    当处于主菜单时，Ren'Py会把这项设置为True。这项可以用来处于主菜单时显示的界面有所差异。

.. var:: _menu = False

    当进入一个主菜单或者游戏菜单上下文(context)时，Ren'Py会将这项设置为True。

.. var:: menu = renpy.display_menu

    调用时显示游戏内菜单的函数。这个函数应使用与 :func:`renpy.display_menu` 相同的入参。声明为 :func:`nvl_menu` 就会显示nvl模式菜单。

.. var:: mouse_visible = True

    控制鼠标指针是否可见。当进入一个标准游戏菜单时，这项会被自动设置为True。

.. var:: name_only = Character(...)

    当某个say语句中的一个字符串作为一个角色名称时，这项就是创建的模板角色。这条语句：

    ::

        "Eileen" "Hello, world."

    等效于：

    ::

        $ temp_char = Character("Eileen", kind=name_only)
        temp_char "Hello, world."

    除非 temp_char 变量没有使用。

.. var:: narrator = Character(...)

    旁白角色(say语句中不需要给定角色名)。这条语句：

    ::

        "Hello, world."

    等效于：

    ::

        narrator "Hello, world."

.. var:: _rollback = True

    控制是否允许回滚。

.. var:: say = ...

    Ren'Py显示对话时调用的函数。该函数调用时使用3个入参。第一个入参(`who`)是发言角色名(None表示旁白)。第二个入参(`what`)表示对话具体内容。

    第三个入参必须是一个名为 `interact` 的关键词参数，默认为True。若为True，say函数会等待点击再返回。若为False，其会立刻返回界面显示的对话内容。

    直接调用这个函数的情况很稀少，因为我们可以使用对话方便地调用一个角色。

.. var:: save_name = ""

    在存档中使用的名称。

.. var:: _skipping = True

    控制是否允许跳过(skipping)。

.. var:: _window = False

    该项通过 ``window show`` 和 ``window hide`` 语句设置，也可以通过 ``window auto`` 语句间接设置。若为True，对话窗口在非对话型居于中依然显示。

.. var:: _window_auto = False

    该项会被 ``window auto`` 语句设置为True，被 ``window show`` 和 ``window hide`` 语句设置为False。若为True，窗口显示调整为自动检测。

.. var:: _window_subtitle = ''

    这项会添加到 :var:`config.window_title` 作为游戏窗口的标题。在游戏菜单内，这项会自动设置为 :var:`config.menu_window_subtitle` 的值。
