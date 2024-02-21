.. _screen-actions:

=====================================
界面行为(action)、值(value)和函数
=====================================

Ren'Py带来了一大堆行为、值和函数，与界面和界面语言协同作用。

.. _screen-action:

行为(action)
=============

当某个按钮(包括图片按钮、文本按钮和hotspot按钮)被激活、被鼠标悬停或失去鼠标悬停状态时，某个行为(action)就会被唤起。当某个按钮被选中或者非启用时，行为(action)就可能已经决定了。

与这些行为一样，某个行为可以是一个不带任何入参的函数。当行为被唤起时，对应的函数就会调用。如果那个行为返回某个值，返回的值就会传到来源交互动作。

需要使用行为的地方也可能出现的是一个行为的列表，列表内的行为会顺序运行。

.. _control-actions:

控制行为
---------------

这些行为用于管理界面，交互结果和流程控制。

.. function:: Call(label, *args, **kwargs)

    结束当前语句，并调用某个脚本标签(label)。入参和关键词参数会传给 :func:`renpy.call` 。

.. function:: Hide(screen=None, transition=None, _layer=None)

    如果名为 *screen* 的界面已经显示，则隐藏这个界面。
    
    `screen`
        若为字符串，表示待隐藏界面的名称。若为None，表示待隐藏界面为当前界面。

    `transition`
        如果非None，隐藏界面时使用转场(transition)。

    `_layer`
        该项将作为layer参数传入 :func:`renpy.hide_screen`。若该项为None则忽略。

.. function:: Jump(label)

    触发主控流程转到脚本标签 *label* 处。

.. function:: NullAction(*args, **kwargs)

    不做任何事。

    可以用作某个按钮的“鼠标悬停/鼠标离开”事件响应，不执行任何行为。

.. function:: Return(value=None)

    使用提供的值返回给当前的互动行为，提供的值不可以为None。常用于菜单和imagemap，用来选择交互行为的返回值。如果使用的是 ``call screen`` 语句调用界面，返回值就会放置在 *_return* 变量中。

    如果出现在某个菜单中，值会返回给来源菜单。(这种情况下就需要返回None。)

.. function:: Show(screen, transition=None, *args, **kwargs)

    触发另一个界面的显示。 *screen* 是给定待显示的界面名。入参会传给正在显示的界面。

    如果 *transition* 非空，则会用作新界面显示时的转场效果。

.. function:: ShowTransient(screen, transition=None, *args, **kwargs)

    显示一个临时界面。临时界面会在当前交互完成后隐藏。入参会传给当前显示的界面。

    如果 *transition* 非空，则会用作新界面显示时的转场效果。

.. function:: ToggleScreen(screen, transition=None, *args, **kwargs)

    切换界面的可视性。如果某个界面当前没有显示，则会使用提供的入参显示那个界面。相反，则隐藏那个界面。

    如果 *transition* 非空，则会用作新界面显示时的转场效果。

.. _data-acitons:

数据行为
------------

这些行为设置或者切换数据。

.. function:: AddToSet(set, value)

    将 *value* 添加到 *set* 中。

    `set`
        待添加元素的集合。其可以是一个Python的集合或者列表数据列表。如果是列表的话，新增的值会追加到列表结尾。

    `value`
        待添加或追加的值。

.. function:: RemoveFromSet(set, value)

    将 *value* 从 *set* 中移除。

    `set`
        待移除元素的集合，可以是一个集(set)或者列表(list)型数据。

    `value`
        待移除的元素。

.. function:: SetDict(dict, key, value)

    将字典型数据 *dict* 中键值 *key* 对应的值设置为 *value* 。

.. function:: SetField(object, field, value)

    将某个对象的字段(field)设置为给定的值。 *object* 是目标对象， *field* 是待设置的字段名称的字符串， *value* 是需要设置成的值。

.. function:: SetLocalVariable(name, value)

    将指定的变量 `name` 设置为当前本地上下文中的值 `value`。

    只有在某个界面(screen)被另一个场景(scene)使用的情况，才会用到该函数。其提供了一种方法，可以设置界面使用变量的值。
    在其他需要修改变量值的情况下，推荐使用 :func:`SetScreenVariable` ，那可以缓存更多的界面数据。

    该函数能赋值的变量仅限当前上下文中创建——其他地方创建的变量不能通过该函数进行设置和传递。

.. function:: SetScreenVariable(name, value)

    将与当前界面关联的变量 *name* 值设置为 *value* 。

.. function:: SetVariable(variable, value)

    将变量 *variable* 设置为 *value* 。

.. function:: ToggleDict(dict, key, true_value=None, false_value=None)

    切换 *dict* 中键 *key* 的值。“切换”的意思是，当对应的行为执行后，原布尔值取反。

    `true_value`
        如果非None，这就是我们使用的True值。

    `false_value`
        如果非None，这就是我们使用的False值。

.. function:: ToggleField(object, field, true_value=None, false_value=None)

    切换 *object* 上 *field* 的值。“切换”的意思是，当对应的行为执行后，原字段(field)上所有布尔值取反。

    `true_value`
        如果非None，这就是我们使用的True值。

    `false_value`
        如果非None，这就是我们使用的False值。

.. function:: ToggleLocalVariable(name, true_value=None, false_value=None)

    切换当前本地上下文中 `name` 的值。

    只有在某个界面(screen)被另一个场景(scene)使用的情况，才会用到该函数。其提供了一种方法，可以设置界面使用变量的值。
    在其他需要修改变量值的情况下，推荐使用 :func:`ToggleScreenVariable` ，那可以缓存更多的界面数据。

    该函数能赋值的变量仅限当前上下文中创建——其他地方创建的变量不能通过该函数进行设置和传递。

    `true_value`
        如果非None，这就是我们使用的True值。

    `false_value`
        如果非None，这就是我们使用的False值。


.. function:: ToggleScreenVariable(name, true_value=None, false_value=None)

    切换当前界面变量 *name* 的值。

    `true_value`
        如果非None，这就是我们使用的True值。

    `false_value`
        如果非None，这就是我们使用的False值。

.. function:: ToggleSetMembership(set, value)

    切换集 *set* 中 *value* 的成员。如果对应的值在集里不存在，会添加那个值到集合中。否则，就会移动那个值。

    带有这个行为的按钮会被标记为被选中(selected)状态，仅当那个值存在于集 *set* 中。

    `set`
        待添加或移除成员的集合。其可以是一个集(set)或列表(list)。如果是列表，就会在列表中结尾添加新元素。

    `value`
        需要添加的值。

.. function:: ToggleVariable(variable, true_value=None, false_value=None)

    切换 *variable* 。

    `true_value`
        如果非None，这就是我们使用的True值。

    `false_value`
        如果非None，这就是我们使用的False值。

.. _menu-actions:

菜单行为
------------

以下行为(action)会唤起菜单，或者主要用在主菜单和游戏菜单中。

.. function:: MainMenu(confirm=True)

    触发Ren'Py回到主菜单。

    `confirm`
        若为True，触发Ren'Py询问用户是否希望返回主菜单，而不是直接返回。

.. function:: Quit(confirm=None)

    退出游戏。

    `confirm`
        若为True，提示用户是否希望退出，而不是直接退出。若为None，仅当用户不处于主菜单时才询问。

.. function:: ShowMenu(screen=None, *args, **kwargs)

    如果不在游戏菜单中的话，就进入游戏菜单。如果已经处于游戏菜单，就显示某个界面或跳转到某个脚本标签(label)。

    *screen* 通常是某个界面的名称，使用界面机制显示。如果界面不存在，就会在 *screen* 后面加上“_screen”，并跳转到对应的脚本标签(label)处。

    - ShowMenu("load")
    - ShowMenu("save")
    - ShowMenu("preferences")

    也可以用来显示用户自定义的菜单界面。例如，创作者定义了一个名为“stats”的界面，可以把“stats”界面显示为游戏菜单的一部分，使用如下语句：

    - ShowMenu("stats")

    不带入参的ShowMenu语句默认进入游戏菜单。

    额外的入参和关键词参数会传给对应的界面。

.. function:: Start(label=u'start')

    让Ren'Py从菜单上下文跳转到目标名的脚本标签(label)处。主要用处是从主菜单开始新游戏。通常的用法如下：

    - Start() - 从start脚本标签(label)处开始。
    - Start("foo") - 从“foo”脚本标签(label)处开始。

.. _file-actions:

文件行为
------------

这些行为会处理文件的保存、读取和删除。其中很多都是用 `name` 和 `page` 入参。

`name`
    待保存内容的文件名。其可以是一个字符串或者一个整数。与 `page` 一起创建文件名。

`page`
    行为实际执行的页面(page)。其值是“auto”、“quick”或者一个正整数。若为None，page的值会根据持久化页面编号自动确定。

如果设置了 :var:`config.file_slotname_callback`，则会使用该配置项并转为一个存档槽位名称。

.. function:: FileAction(name, page=None, **kwargs)

    对文件“进行正确操作”。这意味着在load界面显示时进行文件读取操作，相反在save界面显示时进行文件保存操作。

    `name`
        存档或读档时，槽位的名称。如果为None，一个未被使用的槽位(基于当前时间的巨大数字)就会被使用。

    `page`
        存档或读档时使用的页面编号(page)。若为None，就使用当前页面。

    其他关键词入参会传给FileLoad或者FileSave。

.. function:: FileDelete(name, confirm=True, page=None)

    删除文件。

    `name`
        要删除的存档槽名称。

    `confirm`
        若为True，删除文件前提示用户确认。

    `page`
        存档或读档时使用的页面编号(page)。若为None，就使用当前页面。

.. function:: FileLoad(name, confirm=True, page=None, newest=True)

    读取文件。

    `name`
        读取的槽位名称。若为None，an unused slot the file will not be loadable。

    `confirm`
        如果为True且当前不在主菜单，在读取文件前提是用户确认。

    `page`
        文件读取的页面编号。如果为None，就是用当前页面。

    `newest`
        如果为True，按钮会被选中，前提是其为最新的文件。

    `cycle`
        忽略。

    `slot`
        若为True，使用 *name* 参数，而忽略 *page* 参数。

.. function:: FilePage(page)

    将文件页面设置为 *page* ，其可以是“auto”、“quick”或一个整数。

.. function:: FilePageNext(max=None, wrap=False)

    前往下一个文件页面(page)。

    `max`
        若该值存在，应该是整数，给定了我们前往的文件最大页面编号。

    `wrap`
        若为True，我们可以从文件最后的页面前往第一页面，前提是设置了页面最大编号。

    `auto`
        若此参数和 *warp* 都为True，将会把玩家带往自动存档页。

    `quick`
        若此参数和 *warp* 都为True，将会把玩家带往快速存档页。

.. function:: FilePagePrevious(max=None, wrap=False)

    前往上一个文件页面，前提是上一个页面存在的话。

    `max`
        若该值存在，应该是整数，给定了我们前往的文件最大页面编号。需要启用wrap。

    `wrap`
        若为True，我们可以从文件第一页面前往最后的页面，前提是设置了页面最大编号。

    `auto`
        若此参数和 *warp* 都为True，将会把玩家带往自动存档页。

    `quick`
        若此参数和 *warp* 都为True，将会把玩家带往快速存档页。

.. function:: FileSave(name, confirm=True, newest=True, page=None, cycle=False)

    保存文件。

    带槽位的按钮被选中，如果其被标记为最新存档文件。

    `name`
        待存档的槽位名。如果为None，一个未被使用的槽位(基于当前时间的巨大数字)就会被使用。

    `confirm`
        若为True，覆盖文件前提示用户确认。

    `newest`
        忽略。

    `page`
        槽位所在页面名称。若为None，使用当前页面。

    `cycle`
        如果为True，在提供的页面上存档会循环使用而并不会显示给用户看。:var:`config.quicksave_slots` 配置了循环使用的槽位。

    `slot`
        若为True，使用 *name* 参数，而忽略 *page* 参数。

.. function:: FileTakeScreenshot(*args, **kwargs)

    当游戏存档时，截取屏幕快照并使用。通常使用存档界面显示之前的界面截图，用作存档的快照。

.. function:: QuickLoad(confirm=True)

    快速读档。

    `confirm`
        若为True，且目前不在主菜单界面，读档前提是用户确认。

.. function:: QuickSave(message=u'Quick save complete.', newest=False)

    快速存档。

    `message`
        当快速存档完成时向用户显示的一条信息。

    `newest`
        设置为True用于标记快速存档为最新的存档。

.. _sync-actions:

同步行为
---------

.. function:: DownloadSync()

    该行为会从Ren'Py同步服务器端下载数据并同步。

.. function:: UploadSync()

    该行为会将最后存档文件上传到Ren'Py同步服务器端。

.. _audio-actions:

音频行为
-------------

关于音频通道(channel)的概念和工作机制，大多数信息都可以在 :doc:`audio` 中找到解释。

.. function:: PauseAudio(channel, value=True)

    音频通道 *channel* 设置暂停标识(flag)。

    如果 *value* 为True，通道channel会暂停。相反，通道channel会从暂停恢复。如果值为“toggle”，暂停标识会进行切换，即布尔值进行“逻辑非”操作。

.. function:: Play(channel, file, selected=None, **kwargs)

    在指定通道(channel)播放一个音频文件。

    `channel`
        播放使用的通道(channel)。

    `file`
        播放的文件。

    `selected`
        若为True，当文件在通道上播放时，使用这个行为的按钮会被标记为“被选中”。若为False，这个行为不会触发按钮启动播放。若为None，当通道是一个音乐(music)通道时按钮会被标记为“被选中”。

    其他关键词参数会被传给 :func:`renpy.music.play`。

.. function:: Queue(channel, file, **kwargs)

    在给定的通道上将音频文件队列化。

    `channel`
        播放使用的通道(channel)。

    `file`
        播放的文件。

    其他关键词参数会被传给 :func:`renpy.music.queue`。

.. function:: SetMixer(mixer, volume)

    将 *mixer* 的音量设置为 *value* 。

    `mixer`
        需要调整音量的混合器(mixer)。这个字符串通常是“main”、“music”、“sfx”或“voice”。混合器的信息详见 :ref:`volume` 。 

    `value`
        调整的目标音量值。是一个位于0.0至1.0闭区间内的数值。

.. function:: SetMute(mixer, mute)

    将一个或多个混合器设置为静音状态。当混合器静音时，与混合器关联的音频通道会停止播放音频。

    `mixer`
        给出单个混合器名称的字符串，或一个混合器列表名称的字符串列表。混合器名称通常是“music”、“sfx”或“voice”。

    `mute`
        若为True则静音混合器，若为False则取消混合器静音。

.. function:: Stop(channel, **kwargs)

    停用某个音频通道。

    `channel`
        停用的音频通道名。

    关键词参数会传给 :func:renpy.music.stop()。

.. function:: ToggleMute(mixer)

    切换混合器的静音状态。

    `mixer`
        单个混合器名称的字符串，或一个混合器列表名称的字符串列表。混合器名称通常是“music”、“sfx”或“voice”。

.. _focus_actions:

获取焦点行为
--------------

.. function:: CaptureFocus(name=u'default')

    若某个可视组件获得焦点并执行该行为，将存储一块包含可视组件的矩形区域，并根据入参 `name` 命名。
    该矩形区域可通过 :func:`GetFocusRect` 或 :ref:`sl-nearrect` 组件的 `focus` 特性访问。
    若没有可视组件获得焦点，上次捕获的矩形区域将从存储区移除。

    `name`
        获得焦点矩形区域存储名称。其应是一个字符串。
        如果设置为“tooltip”则比较特殊，当提示消息改变时，将执行自动捕获。

.. function:: ClearFocus(name=u'default')

    使用 :func:`CaptureFocus` 函数清除存储的矩形区域焦点。

.. function:: GetFocusRect(name="default")

    若指定名称的矩形区域在存储区中(无论是使用 :func:`CaptureFocus` 捕获还是tooltip自动捕获)，返回一个(x, y, h, w)形式的矩形。否则返回None。

    `name`
        获得焦点矩形区域检索名称。其应是一个字符串。
        如果设置为“tooltip”则比较特殊，当提示消息改变时，将执行自动捕获。

.. function:: ToggleFocus(name="default")

    若焦点矩形区域存在则清除，否则捕获。

    `name`
        获得焦点矩形区域存储名称。其应是一个字符串。
        如果设置为“tooltip”则比较特殊，当提示消息改变时，将执行自动捕获。

.. _other-actions:

其他行为
-------------

这些是其他地方找不到的一些行为。

.. function:: Confirm(prompt, yes, no=None, confirm_selected=False)

    提示用户进行确认的一种行为。如果用户点击了“是”，将执行 *yes* 行为。否则，执行 *no* 行为。

    `prompt`
        向用户显示的提示内容。

    `confirm_selected`
        若为True，当yes行为被选中后，提示 *prompt* 依然会显示。若为False，也是默认值， *yes* 行为选中后提示就不再显示。

    这个行为的可用性和可选择性与 *yes* 行为相匹配。

.. function:: DisableAllInputValues()

    禁用所有活动的输入项。如果存在默认输入项的话，它将重新获得焦点。否则，任何输入项都不会获得焦点。

.. function:: Function(callable, *args, **kwargs)

    这个行为会使用 *args* 和 *kwargs* 调用 *callable* 。

    `callable`
        可调用的对象。该项假设遇到两个相等的可调用对象，调用任意一个都是相同的。

    `args`
        传给 *callable`* 的固定位置入参。

    `kwargs`
        传给 *callable* 的关键词入参。

    这个行为使用一个可选的 _update_screens 关键词参数，而且这个参数默认为True。参数为True时，函数返回后，互动行动会重新开始，各界面会更新。

    如果函数返回一个非空值，互动行为会停止并返回那个值。(使用call screen语句得到的返回值放置在 *_return* 变量中。)

    创作者可以从 :class:`Action` 派生自己的子类，并替代此Function函数。
    这样就可以自己命名行为，并判断对应组件是否选中和可激活的。

.. function:: Help(help=None)

    显示帮助。

    如果定义过一个名为 ``help`` 的界面，使用 :func:`ShowMenu` 就可以显示那个界面，并且 *help* 参数会被省略。

    `help`
        用于提供帮助的字符串。其被用于以下两种情况：

        - 如果存在一个对应名称的文本标签(label)，对应的标签会在新的上下文中被调用。
        - 否则，内嵌某个给定文件名称，并使用web浏览器打开。

    若 *help* 为None， :func:`config.help` 配置项会被用作默认值。

.. function:: HideInterface(*args, **kwargs)

    隐藏用户接口，直到出现用户点击事件。

.. function:: If(expression, true=None, false=None)

    根据 *expression* 的结果选择使用 *true* 或 *false* 的行为。这个函数用在基于某个表达式的结果选择执行行为。注意入参的默认值None，也可以用作一个行为，禁用某个按钮。

.. function:: InvertSelected(action)

    该行为将提供行为的选项状态反转，可以应用在别的方法上。

.. function:: MouseMove(x, y, duration=0)

    将鼠标指针移动到坐标 *x, y* 。如果设备没有鼠标指针，或者_preferences.mouse_move的值是False，那什么都不会发生。

    `duration`
        移动鼠标指针行为消耗的时间，单位为秒。这个时间段内，鼠标可能不会响应用户操作。

.. function:: Notify(message)

    使用 :func:`renpy.notify()` 函数显示 *message* 内容。

.. function:: OpenURL(url)

    在web浏览器中打开 *url* 。

.. function:: QueueEvent(event, up=False)

    使用 :func:`renpy.queue_event()` 将给定的事件消息加入到事件队列中。

.. function:: RestartStatement(*args, **kwargs)

    这个行为会触发Ren'Py回滚到当前语句之前，并再次执行当前语句。可以用在某些持久化变量改变后影响语句显示效果的情况。

    在菜单语境运行的话，等到用户退出并回到上一层语境时才会执行回滚行为。

.. function:: RollForward(*args, **kwargs)

    这个行为触发前滚，前提是前滚可行。否则，该行为是禁用状态。

.. function:: Rollback(*args, **kwargs)

    这个行为触发回滚，前提是回滚可行。否则，不会发生任何事。

    入参将传给 :func:renpy.rollback() 函数，除非参数 *force* 是默认值“menu”。

.. function:: RollbackToIdentifier(identifier)

    这个行为触发回滚至某个标识符(identifier)。回滚标识符会作为HistoryEntry对象的一部分返回。

.. function:: Screenshot(*args, **kwargs)

    屏幕截图。

.. function:: Scroll(id, direction, amount=u'step')

    `id`
        当前界面中条(bar)、视口(viewport)或vpgrid的id。

    `direction`
        如果是vbar，“increase”或“decrease”二选一；如果是视口或vpgrid，“horizontal increase”、“vertical increase”、“horizontal decrease”或“vertical decrease”，四选一。

    `amount`
        滚动数量。可以使用像素数，也可以写“step”或“page”。

    `delay`
        若非零，表示延迟时间值。

.. function:: SelectedIf(expression)

    这个行为允许某个表达式控制一个按钮是否被标记为选中状态。其应被用作包含一个或多个行为的列表的一部分。例如：

    ::

        # 如果mars_flag为True时，按钮会被选中
        textbutton "Marsopolis":
            action [ SelectedIf(SetVariable("mars_flag", True)), SetVariable("on_mars", True) ]

    点击按钮后，在SeletedIf内部的行为会被正常执行。

.. function:: SensitiveIf(expression)

    这个行为允许某个表达式控制一个按钮是否被标记为可用状态。其应被用作包含一个或多个行为的列表的一部分。例如：

    ::

        # 如果mars_flag为True时，按钮是可用的
        textbutton "Marsopolis":
            action [ SensitiveIf(SetVariable("mars_flag", True)), SetVariable("on_mars", True) ]

    点击按钮后，在SensitiveIf内部的行为会被正常执行。

.. function:: Skip(fast=False, confirm=False)

    触发游戏开始使用跳过(skipping)。如果游戏处于菜单语境下，这个行为导致回到游戏界面。否则，这个行为启用跳过(skipping)。

    `fast`
        若该值为True，直接跳到下一个菜单选项。

    `confirm`
        若该值为True，在使用跳过(skipping)前需要用户确认。

.. function:: With(transition)

    触发 *transition* 生效。

还有一些行为记录在文档的其他页面，比如 :class:`Language`、:class:`Replay`、:class:`EndReplay`、
:class:`gui.SetPreference`、:class:`gui.TogglePreference`、
:class:`StylePreference` 和 :ref:`voice actions <voice-actions>`。

可以通过 :class:`Action` 类创建新的行为。

.. _bar-values:

条(bar)值
==========

条值与条(bar)一同使用，设置条(bar)的值，且允许条(bar)调整某个潜在特性。可以通过创建 :class:`BarValue` 类的子类创建一个新的条值。
所有的BarValue类都有关键词 `step` ，也可以接受关键词 `force_step` ，具体情况详见 :func:`ui.adjustment` 。

.. function:: AnimatedValue(value=0.0, range=1.0, delay=1.0, old_value=None)

    将某个值序列化，使用 *delay* 秒的时间将 *old_value* 的值转为 *value* 的值。

    `value`
        value值自身，是一个数值。

    `range`
        value值的范围，是一个数值。

    `delay`
        序列化value值的时间，单位为秒。默认值是1.0。

    `old_value`
        旧的value值。若为None，我们使用AnimatedValue想要替换的value值。否则，其会初始化为 *value* 的值。

.. function:: AudioPositionValue(channel=u'music', update_interval=0.1)

    显示在 *channel* 通道播放音频文件播放位置的值。

    `update_interval`
        值的更新频率，单位为秒。

.. function:: DictValue(dict, key, range, max_is_zero=False, style=u'bar', offset=0, step=None, action=None, force_step=False)

    允许用户使用字典型数据的键调整对应的值。

    `dict`
        字典。

    `key`
        键。

    `range`
        调整的数值范围。

    `max_is_zero`
        若为True，当键对应的值为0时，条(bar)值范围会调整为从1到0，所有其他值都会被降低到1。同样的，当条(bar)被设置成最大值时，键的值将设置为0。

    `style`
        创建的条(bar)的样式。

    `offset`
        添加到条值的一个偏移量。

    `step`
        调整条(bar)值的步进大小。若为空，默认为条(bar)的十分之一。

    `action`
        若非None，当字段改变时，将调用指定行为(action)。

.. function:: FieldValue(object, field, range, max_is_zero=False, style=u'bar', offset=0, step=None, action=None, force_step=False)

    允许用户调整某个对象上字段(field)的条(bar)值。

    `object`
        调整的对象。

    `field`
        字段(filed)名称的字符串。

    `range`
        可调整的范围。

    `max_is_zero`
        若为True，当键对应的值为0时，条(bar)值范围会调整为从1到0，所有其他值都会被降低到1。同样的，当条(bar)被设置成最大值时，字段(filed)的值将设置为0。

        这偏向于某些内部使用。

    `style`
        创建的条(bar)的样式。

    `offset`
        添加到条值的一个偏移量。

    `step`
        调整条(bar)值的步进大小。若为空，默认为条(bar)的十分之一。

    `action`
        若非None，当字段改变时，将调用指定行为(action)。

.. function:: MixerValue(mixer)

    音频混合器的值。

    `mixer`
        待调整的混合器名。通常是“music”、“sfx”或“voice”，创作者也可以创建新的混合器。

.. function:: ScreenVariableValue(variable, range, max_is_zero=False, style=u'bar', offset=0, step=None, action=None, force_step=False)

    用于调整界面变量值的条(bar)值。

    `variable`
        一个字符串，给出了待调整的变量名。

    `range`
        可调整的范围。

    `max_is_zero`
        若为True，当键对应的值为0时，条(bar)值范围会调整为从1到0，所有其他值都会被降低到1。同样的，当条(bar)被设置成最大值时，variable的值将设置为0。

        这偏向于某些内部使用。

    `style`
        创建的条(bar)的样式。

    `offset`
        添加到条值的一个偏移量。

    `step`
        调整条(bar)值的步进大小。若为空，默认为条(bar)的十分之一。

    `action`
        若非None，当字段改变时，将调用指定行为(action)。

.. function:: StaticValue(value=0.0, range=1.0)

    这个行为允许某个值被指定为静态。

    `value`
        值自身，一个数值。

    `range`
        数值范围。

.. function:: VariableValue(variable, range, max_is_zero=False, style=u'bar', offset=0, step=None, action=None, force_step=False)

    允许用户调整默认存储区变量值的条(bar)值。

    `variable`
        一个字符串，给出了待调整的变量名。

    `range`
        可调整的范围。

    `max_is_zero`
        若为True，当键对应的值为0时，条(bar)值范围会调整为从1到0，所有其他值都会被降低到1。同样的，当条(bar)被设置成最大值时，variable的值将设置为0。

        这偏向于某些内部使用。

    `style`
        创建的条(bar)的样式。

    `offset`
        添加到条值的一个偏移量。

    `step`
        调整条(bar)值的步进大小。若为空，默认为条(bar)的十分之一。

    `action`
        若非None，当字段改变时，将调用指定行为(action)。

.. function:: XScrollValue(viewport)

    根据给定的id，在当前界面水平滚动视口(viewport)的可调整值。视口(viewport)必须在条(bar)值出现前定义。

.. function:: YScrollValue(viewport)

    根据给定的id，在当前界面垂直滚动视口(viewport)的可调整值。视口(viewport)必须在条(bar)值出现前定义。

.. _input-values:

输入(input)值
==============

输入(input)值与文本输入一起使用，用于设置默认文本、接受改变文本、响应回车键、决定文本是否可编辑。要创建新的输入(input)值，可以使用 :class:`InputValue` 类的子类。

Ren'Py定义的输入(input)值继承自InputValue类，这意味着所有输入值均含有Enable()、Disable()和Toggle()方法，分别执行启用(enable)、禁用(disable)和切换编辑(toggle edit)行为。可以参考 :func:`DisableAllInputValues` 行为。

.. function:: DictInputValue(dict, key, default=True, returnable=False)

    将字典 *dict* 中键 *key* 的值更新的输入(input)值。

    `default`
        若为True，默认情况下输入可以被编辑。

    `returnable`
        若为True，当用户按下回车键，输入的值就会被返回。

.. function:: FieldInputValue(object, field, default=True, returnable=False)

    一个更新某个对象上字段(field)值的输入值。

    `field`
        字段(filed)名称的字符串。

    `default`
        若为True，输入默认是可以被编辑的。

    `returnable`
        若为True，当用户按下回车键，输入的值就会被返回。

.. function:: FilePageNameInputValue(pattern=u'Page {}', auto=u'Automatic saves', quick=u'Quick saves', page=None, default=False)

    一个输入值用于更新文件页面(page)名。

    `pattern`
        用于页面(page)的默认名。使用Python风格的替换，例如花括号{}里的内容可以替换为页面(page)的编号。

    `auto`
        自动保存页面(page)的名称。

    `quick`
        快速保存页面(page)的名称。

    `page`
        若该参数存在，给出了要显示的页面(page)编号。通常该值设定为None，表示当前页面。

    `default`
        若为True，该输入默认可以被编辑。

.. function:: ScreenVariableInputValue(variable, default=True, returnable=False)

    一个更新变量的输入(input)值。

    `variable`
        待更新变量名，一个字符串。

    `default`
        若为True，该输入默认可以被编辑。

    `returnable`
        若为True，当用户按下回车键，输入的值就会被返回。

.. function:: VariableInputValue(variable, default=True, returnable=False)

    一个更新变量的输入(input)值。

    `variable`
        待更新变量名，一个字符串。

    `default`
        若为True，该输入默认可以被编辑。

    `returnable`
        若为True，当用户按下回车键，输入的值就会被返回。

.. _functions-and-classes:

函数和类
=====================

这些函数和类在界面方面很有用。

.. _preferences:

环境设定(preference)
---------------------

所有环境设定都可以基于上面给出的行为Action和值Value来定义。这需要一些Ren'Py方面的知识，才能选择正确的环境设定并运用。环境设定构造器(constructor)让这件事变得简单，通过创建一个行为或值，就能基于名称应用在默认的环境设定界面上。

.. function:: Preference(name, value=None, range=None)

    其从某项环境设定构造了合适的行为或者值。环境设定名称应该是在变准菜单中出现的名称，值应该是选项名、“toggle”轮询选项、一个指定的值，或者按钮的名称。

    可以与按钮和热区一起使用的行为如下：

    * Preference("display", "fullscreen") - 全屏模式显示。
    * Preference("display", "window") - 窗口模式显示，1倍大小。
    * Preference("display", 2.0) - 窗口模式显示，2倍大小。
    * Preference("display", "any window") - 用前一种窗口尺寸显示。
    * Preference("display", "toggle") - 切换显示模式。
    * Preference("transitions", "all") - 显示所有转场(transition)效果。
    * Preference("transitions", "none") - 不显示转场(transition)效果。
    * Preference("transitions", "toggle") - 切换转场(transition)效果。
    * Preference("video sprites", "show") - 显示所有视频精灵(sprite)。
    * Preference("video sprites", "hide") - 可能的话，将视频精灵(sprite)降格为图片显示。
    * Preference("video sprites", "toggle") - 切换图像降格行为。
    * Preference("show empty window", "show") - 允许“window show”和“window auto”语句在say语句之外显示一个空窗口。
    * Preference("show empty window", "hide") - 不允许“window show”和“window auto”语句在say语句之外显示一个空窗口。
    * Preference("show empty window", "toggle") - 切换上面两种情况。
    * Preference("text speed", 0) - 文本立刻显示。
    * Preference("text speed", 142) - 设置文本显示速度为每秒142字符。
    * Preference("joystick") - 显示joystick环境设定。
    * Preference("skip", "seen") - 只跳过看过的信息。
    * Preference("skip", "all") - 跳过所有信息，无论是否看过。
    * Preference("skip", "toggle") - 切换上面两种情况。
    * Preference("begin skipping") - 开始跳过(skipping)。
    * Preference("after choices", "skip") - 在选项后跳过。
    * Preference("after choices", "stop") - 在选项后停止跳过。
    * Preference("after choices", "toggle") - 切换上面两种情况。
    * Preference("auto-forward time", 0) - 将自动前进的时间设置为无限。
    * Preference("auto-forward time", 10) - 设置自动前进时间(单位为每秒250个字符)。
    * Preference("auto-forward", "enable") - 启用自动前进模式。
    * Preference("auto-forward", "disable") - 禁用自动前进模式。
    * Preference("auto-forward", "toggle") - 切换自动前进模式。
    * Preference("auto-forward after click", "enable") - 在一次点击后维持自动前进模式。
    * Preference("auto-forward after click", "disable") - 在一次点击后禁用自动前进模式。
    * Preference("auto-forward after click", "toggle") - 切换上面两种情况。
    * Preference("automatic move", "enable") - 启用自动鼠标模式。
    * Preference("automatic move", "disable") - 禁用自动鼠标模式。
    * Preference("automatic move", "toggle") - 切换自动鼠标模式。
    * Preference("wait for voice", "enable") - 自动前进时，等待当前语音播放完毕。
    * Preference("wait for voice", "disable") - 自动前进时，不等待当前语音播放完毕。
    * Preference("wait for voice", "toggle") - 切换语音等待模式。
    * Preference("voice sustain", "enable") - 当前互动行为中维持语音。
    * Preference("voice sustain", "disable") - 当前互动行为中不维持语音。
    * Preference("voice sustain", "toggle") - 切换语音维持模式。
    * Preference("music mute", "enable") - 音乐混合器静音。
    * Preference("music mute", "disable") - 取消音乐混合器静音。
    * Preference("music mute", "toggle") - 切换音乐静音状态。
    * Preference("sound mute", "enable") - 音效混合器静音。
    * Preference("sound mute", "disable") - 取消音效混合器静音。
    * Preference("sound mute", "toggle") - 切换音效静音状态。
    * Preference("voice mute", "enable") - 语音混合器静音。
    * Preference("voice mute", "disable") - 取消语音混合器静音。
    * Preference("voice mute", "toggle") - 切换语音静音状态。
    * Preference("mixer <mixer> mute", "enable") - 将指定的混合器静音。
    * Preference("mixer <mixer> mute", "disable") - 取消指定的混合器静音。
    * Preference("mixer <mixer> mute", "toggle") - 切换指定的混合器静音状态。
    * Preference("all mute", "enable") - 所有混合器静音。
    * Preference("all mute", "disable") - 取消所有混合器静音。
    * Preference("all mute", "toggle") - 切换所有混合器静音状态。
    * Preference("main volume", 0.5) - 设置对所有音频通道的调整值。
    * Preference("music volume", 0.5) - 设置音乐音量。
    * Preference("sound volume", 0.5) - 设置音效音量。
    * Preference("voice volume", 0.5) - 设置语音音量。
    * Preference("mixer <mixer> volume", 0.5) - 设置指定混合器音量。
    * Preference("emphasize audio", "enable") - 加强在config.emphasize_audio_channels中定义的音频通道。
    * Preference("emphasize audio", "disable") - 取消加强在config.emphasize_audio_channels中定义的音频通道。
    * Preference("emphasize audio", "toggle") - 切换音频加强状态。
    * Preference("self voicing", "enable") - 启用自动语音。
    * Preference("self voicing", "disable") - 禁用自动语音。
    * Preference("self voicing", "toggle") - 切换自动语音模式。
    * Preference("clipboard voicing", "enable") - 启用剪贴板语音。
    * Preference("clipboard voicing", "disable") - 禁用剪贴板语音。
    * Preference("clipboard voicing", "toggle") - 切换剪贴板语音状态。
    * Preference("debug voicing", "enable") - 启用自动语音debug。
    * Preference("debug voicing", "disable") - 禁用自动语音debug。
    * Preference("debug voicing", "toggle") - 切换自动语音debug状态。
    * Preference("rollback side", "left") - 触摸屏幕左侧触发回滚。
    * Preference("rollback side", "right") - 触摸屏幕右侧触发回滚。
    * Preference("rollback side", "disable") - 触摸屏幕不触发回滚。
    * Preference("gl powersave", True) - 使用省电模式降低帧率。
    * Preference("gl powersave", False) - 不使用省电模式降低帧率。
    * Preference("gl powersave", "auto") - 使用电池情况下自动启用省电模式。
    * Preference("gl framerate", None) - 运行时显示帧率。
    * Preference("gl framerate", 60) - 在给定的帧率下运行。
    * Preference("gl tearing", True) - (设备性能不足时)拖慢而不是跳帧。
    * Preference("gl tearing", False) - (设备性能不足时)跳帧而不是拖慢。
    * Preference("font transform", "opendyslexic") - 将字体转为opendyslexic(译者注：为阅读障碍人群设计的字体)的配置项。
    * Preference("font transform", "dejavusans") - 将字体转为deja vu sans的配置项。
    * Preference("font transform", None) - 禁用字体转换。
    * Preference("font size", 1.0) - 字号缩放因子配置项。
    * Preference("font line spacing", 1.0) - 字体行距缩放因子配置项。
    * Preference("system cursor", "enable") - 使用系统贯标，忽略 config.mouse。
    * Preference("system cursor", "disable") - 使用config.mouse的光标。
    * Preference("system cursor", "toggle") - 切换系统光标。
    * Preference("high contrast text", "enable") - 启用黑背景白文字。
    * Preference("high contrast text", "disable") - 禁用高对比文本。
    * Preference("high contrast text", "toggle") - 切换高对比文本。
    * Preference("audio when minimized", "enable") - 窗口最小化后保持声音播放。
    * Preference("audio when minimized", "disable") - 窗口最小化后停止声音播放。
    * Preference("audio when minimized", "toggle") - 切换窗口最小化后的声音播放设置。
    * Preference("audio when unfocused", "enable") - 窗口失去焦点后保持声音播放。
    * Preference("audio when unfocused", "disable") - 窗口失去焦点后停止声音播放。
    * Preference("audio when unfocused", "toggle") - 切换窗口失去焦点后的声音播放设置。
    * Preference("web cache preload", "enable") - 启用web缓存预加载。
    * Preference("web cache preload", "disable") - 禁用web缓存预加载，并删除预加载的数据。
    * Preference("web cache preload", "toggle") - 切换web缓存预加载设置。
    * Preference("voice after game menu", "enable") - 进入游戏设置菜单界面时继续播放声音。
    * Preference("voice after game menu", "disable") - 进入游戏设置菜单界面时停止播放声音。
    * Preference("voice after game menu", "toggle") - 切换进入游戏设置菜单界面时的播放声音设置。

    可以与条(bar)一起使用的值如下：

    * Preference("text speed")
    * Preference("auto-forward time")
    * Preference("main volume")
    * Preference("music volume")
    * Preference("sound volume")
    * Preference("voice volume")
    * Preference("mixer <mixer> volume")
    * Preference("self voicing volume drop")
    * Preference("font size")
    * Preference("font line spacing")

    *range* 参数可以指定某个条(bar)的数值范围。例如，“text speed”的默认值是200cps。“auto-forward time”的默认值是每段文本30秒。(这些是最大值，而不是默认值。)

    可以被按钮使用的行为包括：
    * Preference("renderer menu") - 显示渲染器(renderer)菜单。
    * Preference("accessibility menu") - 显示数据(accessibility)读写菜单
    
    上面的界面是内部定义的，无法定制化。

.. function:: GetCharacterVolume(voice_tag)

    该函数根据关联的语音标签(tag)，返回一个介于0.0到1.0之间的数值，表示对应 *voice* 声道最大音量的一个比例。

.. _gamepad:

游戏手柄
---------

这些函数和行为跟游戏手柄一起工作。

.. function:: GamepadCalibrate()

    调用手柄校正的行为。

.. function:: GamepadExists(developer=True)

    检测手柄是否存在的函数。存在返回True，不存在返回False。

    `developer`
        强制该函数返回True，config.developer必须配置为True。

.. _file-functions:

文件函数
--------------

这些函数返回关于文件的有用信息。它们使用相同的默认页面(page)相关的文件行为。

.. function:: FileCurrentPage()

    将当前文件页面(page)以字符串返回。

.. function:: FileCurrentScreenshot(empty=None, **properties)

    一个显示屏幕截图的可显示控件。其将保存你在当前文件中，前提是进入了菜单或使用 :func:`FileTakeScreenshot()` 采集了屏幕截图。

    如果没有当前屏幕截图，对应的位置上显示 *empty* 的图像。(如果 *empty* 是空值None，默认为 :func:`Null()` 。)

.. function:: FileJson(name, key=None, empty=None, missing=None, page=None, slot=False)

    根据 `name` 参数读取对应的Json数据。

    如果存档槽位是空的，则返回 *empty* 。

    如果存档槽位不是空的，并且 *key* 为None，返回包含Json数据的整个目录

    如果 *key* 不为None，则返回json[key]，前提是 *key* 在存档json对象中有定义。如果存档存在但不包含 *key* ，就返回 *missing* 。如果存档槽位为空，则返回 *empty* 。

    使用 :func:`config.save_json_callbacks` 注册的回调函数可以用于在存档槽位中添加Json。

.. function:: FileLoadable(name, page=None)

    该函数在文件可加载的情况下返回True，否则返回False。

.. function:: FileNewest(name, page=None)

    如果文件是最新版本返回True，否则返回False。

.. function:: FilePageName(auto=u'a', quick=u'q')

    以字符串形式返回当前文件页面(page)名称。如果是一个普通页面(page)，该函数返回页面编号。否则，返回 *auto* 或 *quick* 。

.. function:: FileSaveName(name, empty=u'', page=None)

    返回文件保存时生效的存档名，如果文件不存在则返回 *empty* 。

.. function:: FileScreenshot(name, empty=None, page=None)

    返回给定那个文件相关的屏幕截图。如果文件不能加载，返回 *empty* ，前提 *empty* 的值不是None。在文件不能加载且 *empty* 为空的情况下，一个空的可视组件会被创建。

    返回值是一个可显示对象。

.. function:: FileSlotName(slot, slots_per_page, auto=u'a', quick=u'q', format=u'%s%d')

    返回编号后的槽位名。前提是普通页面(page)下的槽位都按顺序从1开始编号，并且页面也从1开始编号。当槽位编号为2，每个页面槽位数(slots_per_page)为10，其他变量都是默认值的情况下：

    - 显示第一页面时，返回“2”。
    - 显示第二页面时，返回“12”。
    - 显示自动页面时，返回“a2”。
    - 显示快速存档页面时，返回“q2”。

    `slot`
        接入的槽位编号。

    `slots_per_page`
        每页槽位数量。

    `auto`
        自动存档页面的前缀。

    `quick`
        快速存档页面的前缀。

    `format`
        格式代码。包含两部分：一个页面前缀字符串，一个槽位编号整数。

.. function:: FileTime(name, format=u'%b %d, %H:%M', empty=u'', page=None)

    返回文件保存时间，格式根据 *format* 显示。如果未找到文件，返回 *empty* 。

    返回值是一个字符串。

.. function:: FileUsedSlots(page=None, highest_first=True)

    返回页面上所有可用的经过编号的文件列表。

    `page`
        待扫描的页面名。若为None，就使用当前页面。

    `highest_first`
        若为True，列表内文件按编号从大到小排序。否则，列表内文件按编号从小到大排序。

.. _side-image-functions:

头像函数
--------------------

该函数返回使用的头像。

.. function:: SideImage()

    返回与当前发言角色相关的头像。如果头像不存在则返回一个空的可视组件。

.. _tooltips:

Tooltips
--------

所有可视组件上可用的 ``tooltip`` 特性和GetTooltip函数都可以读写tooltip。当可视组件获得焦点时，GetTooltip函数会返回这个组件的tooltip特性的值。

提醒一下，传入 ``tooltip`` 特性的值需要支持是否相等的判断。

这里是一个样例：

::

    screen tooltip_example():
        vbox:
            textbutton "北":
                action Return("n")
                tooltip "去约见北极熊。"

            textbutton "南":
                action Return("s")
                tooltip "前往热带。"

            textbutton "东":
                action Return("e")
                tooltip "我们可以拥抱黎明。"

            textbutton "西":
                action Return("w")
                tooltip "去欣赏最美的日落。"

            $ tooltip = GetTooltip()

            if tooltip:
                text "[tooltip]"

可视组件 :ref:`sl-nearrect` 可用于显示“弹窗型”tooltip，并且可以获取一个特殊的“tooltip”焦点名，
会将最后获取焦点的位置设置为tooltip对象：

::

    screen tooltip_example2():
        frame:

            padding (20, 20)
            align (.5, .3)

            has vbox

            textbutton "北":
                action Return("n")
                tooltip "去约见北极熊。"

            textbutton "南":
                action Return("s")
                tooltip "前往热带。"

            textbutton "东":
                action Return("e")
                tooltip "我们可以拥抱黎明。"

            textbutton "西":
                action Return("w")
                tooltip "去欣赏最美的日落。"

        # 这是界面上最后显示的内容。

        $ tooltip = GetTooltip()

        if tooltip:

            nearrect:
                focus "tooltip"
                prefer_top True

                frame:
                    xalign 0.5
                    text tooltip

.. function:: GetTooltip(screen=None)

    返回当前获得焦点的可视组件的tooltip，如果可视组件未获得焦点则返回None。

    `screen`
        如果非空，这个参数应该是某个界面的名称或者标签(tag)。如果获得焦点的可视组件是界面的一部分，则该函数只返回tooltip。

.. _legacy:

传统方法
^^^^^^^^^^

.. warning:: 这种传统方法已被废弃，并使用上面说的方法替代。不过你可能会在一些老版本的项目中见到它。

当按钮处于指针悬停状态时，tooltip类会改变界面。

.. class:: Tooltip(default)

    当鼠标指针悬停在某个区域上时，一个tooltip对象可以用于提示对应界面的功能。

    tooltip对象有一个 ``value`` 字段，当tooltip对象被创建时会通过构造器传入 *default* 作为默认值。当通过tooltip创建的某个按钮行为被使用时，value字段就会根据关联的行为改变对应值。

    .. method:: Action(value)

        将按钮的hovered特性对应的行为返回。当按钮处于指针悬停状态时，tooltip的value字段会被设置为 *value* 。当按钮失去焦点时，tooltip的value字段会恢复为默认值。

在某个界面使用tooltip时，常用做法是在default语句中创建tooltip对象。tooltip的值和行为的方法可以在界面中使用。使用时可以按任何顺序——在行为执行前就可以使用tooltip的值。

tooltip可以使用任何类型的值。在下面的样例中，我们使用text语句在界面中显示字符串，使用add语句添加可视组件也是可行的。还可以设计更多复杂的行为。

::

    screen tooltip_test:

        default tt = Tooltip("没有选择任何按钮。")

        frame:
            xfill True

            has vbox

            textbutton "One.":
                action Return(1)
                hovered tt.Action("The loneliest number.")

            textbutton "Two.":
                action Return(2)
                hovered tt.Action("Is what it takes.")

            textbutton "Three.":
                action Return(3)
                hovered tt.Action("A crowd.")

            text tt.value
