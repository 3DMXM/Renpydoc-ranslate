.. _other-functions-and-variables:

=============================
其他函数和配置变量
=============================

此页面记录的是，其他地方没有列出的各类函数和变量。

.. _ren-py-version:

Ren'Py版本相关
--------------

.. function:: renpy.version(tuple=False)

    若 *tuple* 为False，返回一个带有“Ren'Py”的字符串，字符串后半部分是Ren'Py的当前版本信息。

    若 *tuple* 为True，返回一个元组。元组内每个元素分别表示版本信息的一个整数部分。

.. var:: renpy.version_string

    Ren'Py的版本号，类似于字符串“Ren'Py 1.2.3.456”的格式。

.. var:: renpy.version_only

    Ren'Py的版本号，不带Ren'Py前缀，类似于字符串“1.2.3.456”的格式。

.. var:: renpy.version_tuple

    Ren'Py的版本号，类似于元组(1, 2, 3, 456)的格式。

.. var:: renpy.version_name

    一个人类可能的版本名称，类似“Example Version”的格式。

.. var:: renpy.license

    一个表示许可证文本的字符串，这个字符串应该在游戏的“关于”界面中显示。

.. _platform-detection:

平台检测
-------------------

Ren'Py包含许多变量需要基于运行的平台进行设置。

.. var:: renpy.windows

    在Windows平台运行时为True。

.. var:: renpy.macintosh

    在macOS平台运行时为True。

.. var:: renpy.linux

    在Linux或者POSIX类操作系统运行时为True。

.. var:: renpy.android

    在安卓平台运行时为True。

.. var:: renpy.ios

    在iOS平台运行时为True。

.. var:: renpy.emscripten

    在浏览器内运行时为True。该变量仅在浏览器内才能通过emscripten模块获取，详见 :func:`renpy.emscripten.run_script`。

.. var:: renpy.mobile

    在安卓、iOS平台或浏览器运行时为True。

只有在实际设备运行而非模拟器上运行时，才会设置这些配置项。 这些配置项对平台敏感的Python是有用的。对显示布局(layout)的问题，详见 :ref:`界面变种 <screen-variants>`.


内存分析
-----------------

.. function:: renpy.diff_memory(update=True, skip_constants=False)

    分析Ren'Py和游戏使用的对象(object)、贴图(surface)和纹理(texture)内存。将上次调用该函数时和这次调用该函数的内容使用差异，并(在memory.txt和stdout)记录下。

    计算方式是，按照存储区的名称和Ren'Py实现中所有可达的内存。
    如果某个对象通过多个名称可达，就声明为最短可达路径。

    `skip_constants`
        若为True，调试器将不会扫描巨大的Ren'Py容器，因为那些内存在启动后就不会变化。

    由于通过该函数可以扫描所有Ren'Py使用的内存，所以执行完毕相当耗时。

.. function:: renpy.profile_memory(fraction=1.0, minimum=0, skip_constants=False)

    分析Ren'Py和游戏使用的对象(object)、贴图(surface)和纹理(texture)内存。将使用的内存总数写入memory.txt和stdout。

    计算方式是，按照存储区的名称和Ren'Py实现中所有可达的内存。
    如果某个对象通过多个名称可达，就声明为最短可达路径。

    `fraction`
        显示使用内存总数的比例。1.0会显示所有使用的内存，.9显示最高的90%。

    `minimum`
        如果某个名称的内存使用小于 *minimum* 字长，就不会显示。

    `skip_constants`
        若为True，调试器将不会扫描巨大的Ren'Py容器，因为那些内存在启动后就不会变化。

    由于通过该函数会扫描所有Ren'Py使用的内存，所以执行完毕相当耗时。

.. function:: renpy.profile_rollback()

    分析回滚系统使用的内存。将回滚系统使用的内存写入到memory.txt和stdout。该函数尝试计算各种存储变量用于回滚的内存量，以及回滚系统内部使用的内存量。

renpy.random
-------------

这个对象是一个随机数生成器，实现了 `Python随机数生成接口 <http://docs.python.org/release/2.3.4/lib/module-random.html>`_ 。调用这个对象衍生的各种方法可以生成需要的随机数。详见Python中的完整列表。最常用的几个如下：

* ``renpy.random.random()``
    返回一个位于(0.0, 1.0)开区间的随机浮点数。

* ``renpy.random.randint(a, b)``
    返回一个整数N，a <= N <= b。

* ``renpy.random.choice(seq)``
    从非空序列 *seq* 随机返回一个元素。

* ``renpy.random.shuffle(seq)``
    打乱序列 `seq` 中元素的顺序。该函数不会返回列表，而是直接修改原列表。

与标准的Python随机数生成器不同，这个对象可以与回滚兼容，无论回滚多少次都生成相同的随机数。所以可以使用这个对象代替标准Python随机模块。

::

    # 返回一个介于0到1之间的随机浮点数。
    $ randfloat = renpy.random.random()

    # 返回一个介于1到20之间的随机整数。
    $ d20roll = renpy.random.randint(1, 20)

    # 返回列表中的一个随机元素。
    $ randfruit = renpy.random.choice(['apple', 'orange', 'plum'])

* ``renpy.random.Random(seed=None)``
    返回一个新的随机数生成器对象。与主随机数生成器不同，新的对象使用指定的值作为种子。

.. _SDL:

SDL
----

通过函数 :func:`renpy.get_sdl_dll` 可以接入SDL2动态链接库(dll)，之后即可直接使用SDL2的函数了。
不过，通常要求有一些Python ctypes模块的知识，才能正确使用SDL2的函数。

Ren'Py不保证包含的SDL2版本编译后包含或不包含某些特性(feature)。
某些平台可以运行，但其他平台可能会报错。
使用这些函数的返回值之前需要确认是否返回了None。

下面的例子中，窗口位置信息来源于SDL2：

::

    init python:

        import ctypes

        def get_window_position():
            """
            通过SDL2检查窗口坐标。返回以窗口左上角为原点坐标的(x, y)值。如果是未知坐标也会返回(0, 0)。
            """

            sdl = renpy.get_sdl_dll()

            if sdl is None:
                return (0, 0)

            win = renpy.get_sdl_window_pointer()

            if win is None:
                return (0, 0)

            SDL_GetWindowPosition = sdl.SDL_GetWindowPosition

            x = ctypes.c_int()
            y = ctypes.c_int()

            result = sdl.SDL_GetWindowPosition(win, ctypes.byref(x), ctypes.byref(y))

            return result

.. function:: renpy.get_sdl_dll()

    该函数返回一个ctypes.cdll对象，指向Ren'Py正在使用的SDL2实例中的库。

    如果无法获取，则返回None。

.. function:: renpy.get_sdl_window_pointer()

    :rtype: ctypes.c_void_p | None

    返回主窗口的指针。如果主窗口没有显示(或发生其他问题)，返回None。

.. _miscellaneous:

其他林林总总
-------------

.. function:: renpy.add_python_directory(path)

    将 *path* 添加在Python模块(module)和包(package)的路径列表中。这个路劲应该是一个游戏目录相对路劲的字符串。必须在import语句之前调用该函数。

.. function:: renpy.add_to_all_stores(name, value)

    在创作者定义的命名空间中，添加名为 `name` 的变量，值为 `value` 。
    如果同名变量已存在，则不做任何操作。
    该函数只能在init代码块中运行。游戏启动后再运行该函数将报错。

.. function:: renpy.can_fullscreen()

    当前平台支持全屏模式就返回True，否则返回False.

.. function:: renpy.capture_focus(name=u'default')

    若某个可视组件当前获得焦点，捕获该组件的包围矩形，并将其存储为 `name`。
    若没有可视组件获得焦点，移除名为 `name` 的存储内容。

    保存游戏时，捕获的焦点区域不会同时保存。

    `name`
        该参数应是一个字符串。入参值“tooltip”是特殊的，会自动捕获可视组件提示区域。

.. function:: renpy.choice_for_skipping()

    告诉Ren'Py即将出现一个选项。该函数当前有两种影响：

    - 如果Ren'Py正在跳过(skip)，并且“跳过后面选项”设置为停止跳过，那么跳过就会终止。
    - 触发自动保存。

.. function:: renpy.clear_capture_focus(name=u'default')

    清除名为 `name` 的焦点捕获。

.. function:: renpy.clear_game_runtime()

    重置游戏运行时间计数器。

.. function:: renpy.clear_retain(layer='screens', prefix='_retain')

    清空所有留存的界面。

.. function:: renpy.confirm(message)

    该函数可以弹出一个包含指定信息的 “确认/取消” 提示界面，并在用户点击任意选项后隐藏界面。

    如果用户点击“确认”则返回True，如果用户点击“取消”则返回False。

    `message`
        需要显示的提示信息。

    :func:`Confirm` 是一个类似功能的行为(action)。

.. function:: renpy.count_dialogue_blocks()

    返回游戏原生语言的对话段落数量。

.. function:: renpy.count_newly_seen_dialogue_blocks()

    返回本次会话(session)中用户首次看到的对话段落数量。

.. function:: renpy.count_seen_dialogue_blocks()

    返回用户在当前游戏进度中看过的所有对话段落数量。

.. function:: renpy.display_notify(message)

    :func:`renpy.notify` 函数的默认实现。

.. function:: renpy.focus_coordinates()

    该函数会尝试找到当前获得焦点可视组件的坐标。如果成功找到，返回一个(x, y, w, h)元组。如果没有找到，返回一个(None, None, None, None)元组。

.. function:: renpy.force_autosave(take_screenshot=False, block=False)

    强制后台自动存档。

    `take_screenshot`
        若为True，进行新的截屏。若为False，使用已存在的截屏。

    `block`
        若为True，将屏蔽所有事件和操作，直到自动存档完成。

.. function:: renpy.free_memory()

    尝试释放一些内存。在运行基于renpy的minigame前很有用。

.. function:: renpy.full_restart(transition=False, label=u'_invoke_main_menu', target=u'_main_menu', save=False)

    让Ren'Py重启，将用户带回到主菜单。

    `transition`
        如果给定了转场，就运行转场；如果这项是None则不运行转场；如果这项是False，就用 :func:`config.end_game_transition` 。

    `save`
        若为True，将先存档在 :var:`_quit_slot`，然后让Ren'Py重启，将用户带回到主菜单。

.. function:: renpy.get_game_runtime()

    返回游戏运行时间计数器。

    游戏运行时间计数器返回用户从顶层上下文(context)等待用户输入经过的秒数。(在主菜单和游戏菜单消耗的时间不计入。)

.. function:: renpy.get_image_load_log(age=None)

    图像加载激活日志生成器。对最后100项图像加载来说，该函数返回：

    - 图像加载的时间(1970-01-01 00:00:00 UTC开始计算的秒数)。
    - 加载图像文件名。
    - 如果图像预加载返回True，如果延迟加载返回False。

    输出结果按从新到旧排序。

    `age`
        如果不是None，只统计经过 *age* 秒之后加载的图像。

    在config.developer = True的情况下，才保存图像加载日志。

.. function:: renpy.get_menu_args()

    返回一个元组，其中包含传给当前menu语句的所有入参(以元组形式)和所有关键词入参(以字典形式)。

.. function:: renpy.get_mouse_name(interaction=False)

    返回显示鼠标名称。

    `interaction`
        若为True，根据互动类型获取鼠标名称。(极少使用)

.. function:: renpy.get_mouse_pos()

    返回一个(x, y)元组，表示鼠标指针或当前触摸位置的坐标。如果设备不支持鼠标并且当前没有被触摸，x和y值无意义。

.. function:: renpy.get_on_battery()

    如果Ren'Py当前运行设备使用内部电池供电，则返回True；
    如果当前运行设备使用外部电源，则返回False。

.. function:: renpy.get_physical_size()

    返回物理窗口的尺寸。

.. function:: renpy.get_refresh_rate(precision=5)

    返回当前屏幕的刷新率，这是一个fps浮点数。

    `precision`
        Ren'Py能获得的裸数据，fps向下取整。就是说，如果显示器运行在59.95fps，那么函数返回的就是59fps。
        precision参数进一步降低了实际显示的帧数，只能能pricision的整倍数。

        由于所有显示器帧率都是5的整倍数(25、30、60、75和120)，该函数可能会提高准确性。将precision设置为1表示禁用这个功能。

.. function:: renpy.get_renderer_info()

    返回一个字典，表示Ren'Py当前使用的渲染器信息。自定中包含下列键(key)：

    ``"renderer"``
        ``"gl"`` 或 ``"sw"`` ，分别对应OpenGL和软件渲染。

    ``"resizable"``
        仅当窗口可重新调整尺寸的情况下为True。

    ``"additive"``
        仅当那个渲染器支持额外混合(blend)的情况下为True。

    ``"model"``
        如果支持基于模型渲染器，则为True。

    另外，键值也可能存在特定渲染器。这个字典应该被认为是不能修改的。可视组件启动后(也就是初始化段落已经结束)，该函数应该只被调用一次。

.. function:: renpy.get_say_attributes()

    获得与当前say语句相关的属性(attribute)，如果没有相关属性(attribute)则返回None。

    只有执行或预加载一条say语句时，该函数才可用。

.. function:: renpy.get_skipping()

    如果Ren'Py跳过中则返回True，如果Ren'Py快速跳过中则返回“fast”，如果Ren'Py不在跳过状态则返回False。

.. function:: renpy.get_statement_name()

    返回当前语句的名称，结果是一个字符串，类似“say”、“say-nvl”或“window hide”。
    函数的返回结果与 :var:`config.statement_callbacks` 用到的语句名相同。

.. function:: renpy.get_transition(layer=None)

    获取 *lay* 的转场(transition)，如果 *layer* 为None则获取整个场景(scene)的转场。该函数返回了在下次交互行为中，队列上层的转场(transition)。如果不存在符合条件的转场则返回None。

.. function:: renpy.iconify()

    游戏窗口最小化。

.. function:: renpy.include_module(name)

    类似于 :func:`renpy.load_module` ，但不会直接加载对应模块，而是根据当前AST码穿插进入初始化队列。

    加载初始化优先级数值不能比包含模块的代码块更小。
    比如，你的模块包含一个优先级为init 10的代码块，那加载的最低优先级数值也至少是10.

    加载模块的部分只能用在初始化代码块(init block)中。

.. function:: invoke_in_main_thread(fn, *args, **kwargs)

    在主线程中使用指定入参运行指定函数。该函数运行在类似于事件处理器的交互上下文中。
    这是为了能从其他线程调用该函数。其他线程可以使用 :func:`renpy.invoke_in_thread` 函数创建。

    如果在单一线程中存在多个可调用的函数，这些函数并不一定会按预计的顺序依次执行。
    
    ::

        def ran_in_a_thread():
            renpy.invoke_in_main_thread(a)
            renpy.invoke_in_main_thread(b)

    在这个例子中，``a`` 肯定先返回，然后再调用 ``b``。从几个不同线程的调用则不一定按此顺序。

    在初始化阶段不能调用该函数。

.. function:: renpy.invoke_in_thread(fn, *args, **kwargs)

    使用后台线程调用函数 *fn* ，传入该函数收到的所有入参。线程返回后重新启动交互行为。

    该函数创建一个守护线程(daemon thread)，当Ren'Py关闭后这个线程也会自动停止。

    该线程使用Ren'Py的API能做的事情非常受限。可以调用下列函数修改存储区的变量：

    * :func:`renpy.restart_interaction`
    * :func:`renpy.invoke_in_main_thread`
    * :func:`renpy.queue_event`

    最好在主线程中使用其他Ren'Py的API。

    然而该函数还无法在Web平台正常运行，仅仅能在不报错的情况下直接返回。

.. function:: renpy.is_init_phase()

    当Ren'Py正在执行init代码时返回True，其他情况返回False.

.. function:: renpy.is_mouse_visible()

    如果鼠标光刻可见则返回True，否则返回False。

.. function:: renpy.is_seen(ever=True)

    如果用户已经看过当前的行，则返回True。

    如果 *ever* 为True，我们检查用户是否看过该行。如果 *ever* 为False，我们检查该行是否在当前游戏过程中被看过。

.. function:: renpy.is_skipping()

    如果Ren'Py当前正处于跳过(skipping)状态则返回True，否则返回False。

.. function:: renpy.is_start_interact()

    如果在当前交互行为中调用了restart_interaction，就返回True。该函数可以用于确定是否某个交互行为已经开始，或者已重新开始。

.. function:: renpy.language_tailor(chars, cls)

    该函数可用于替换unicode字符的换行类。例如，字符串的换行类可以将其设置为某个象形文字的编码，这个字符的前后就会换行。

    `chars`
        一个字符串，包含定制的每一个字符。

    `cls`
        A string giving a character class. This should be one of the classes defined in Table
        1 of `UAX #14: Unicode Line Breaking Algorithm <http://www.unicode.org/reports/tr14/tr14-30.html>`_.
        一个字符串，指定字符串类。其须是下表定义中的其中一个类：`UAX #14: Unicode Line Breaking Algorithm <http://www.unicode.org/reports/tr14/tr14-30.html>`_。

.. function:: last_say()

    返回一个对象，包含最后一条say语句的信息。

    在某个say语句中调用该函数，若是某个普通Character对象使用say语句，则返回结果就是 *当前* 这条say语句，而不是上一句。

    `who`

        发言角色。通常是一个 :func:`Character` 对象，不一定有。

    `what`
        一个字符串，表示对话内容。如果对话还未显示，则可能是None。这种情况会发生在游戏刚启动时。

    `args`
        一个元组，包含传入最后一条say语句的入参。

    `kwargs`
        一个字典，包含传入最后一条say语句的关键词入参。

    .. warning::

        与其他类似函数一样，该函数的返回对象短期内还在被其他地方使用或修改。不建议在存档或回滚相关操作中使用此函数的返回对象。

.. function:: renpy.load_module(name)

    该函数加载名为 *name* 的Ren'Py模块(module)。Ren'Py模块包含的Ren'Py脚本会加载进通用(存储)命名空间。Ren'Py脚本包含在名为name.rpym或name.rpymc的文件中。如果某个.rpym文件存在，并且比对应的.rpymc文件更新，就加载.rpym文件并创建新的.rpymc文件。

    模块中所有的初始化语句块(block)(以及其他初始化代码)都在函数返回前运行。模块名未找到或有歧义的情况下会报错。

    应该仅在初始化语句块(init block)中加载模块。

.. function:: renpy.load_string(s, filename='<string>')

    将 *s* 作为Ren'Py脚本加载。

    返回 *s* 中第一个语句的名称。

    *filename* 是加载 *s* 后生成的所有语句对应的文件名称。
    (译者注：该函数内部调用renpy.game.script.load_string，要求必须有一个文件名入参。)

.. function:: renpy.maximum_framerate(t)

    强制Ren'Py在 *t* 秒内以最大帧率重绘界面。如果 *t* 是None，则不要求使用最大帧率。

.. function:: renpy.munge(name, filename=None)

    munge式命名 *name* ，开头必须是双下划线“__”。

    `filename`
        需要使用munge处理的文件名。若为None，就使用调用此次munge的文件名。

.. function:: renpy.not_infinite_loop(delay)

    将无限循环探测计时器重置为 *delay* 秒。

.. function:: renpy.notify(message)

    让Ren'Py使用notify界面显示 *message* 。默认情况下，显示的 *message* 消息会以dissolve方式出现，显示2秒，最后以dissolve方式消失。

    对一些不会产生回调函数的行为(action)，比如截屏和快速保存，该函数很有效。

    一次只能显示一条通知。显示第二条通知时，会直接替换第一条通知。
    
    该函数只是调用 :var:`config.notify` 。可以通过配置项重新实现并替换原函数。

.. function:: renpy.prediction()

    若Ren'Py处于预加载阶段则返回True。

.. function:: renpy.queue_event(name, up=False, **kwargs)

    使用给定的 *name* 将某个事件放入消息队列。 *name* 应该是在 :func:`config.keymap` 中列出的事件名称之一，或者是这些事件组成的列表。

    `up`
        当事件开始阶段(例如，键盘按键被按下)时，这项应该是False。当事件结束(比如按键被松开)是，这项才会变成True。

    当调用该函数时，事件会被同时放入消息队列。该函数不能替换事件——替换会修改事件的顺序。(替换事件可以使用 :func:`config.keymap` 。)

    该函数是线程安全的(threadsafe)。

.. function:: renpy.quit(relaunch=False, status=0, save=False)

    该函数让Ren'Py完全退出。

    `relaunch`
        若为True，Ren'Py会在退出前运行自身的一个副本。

    `status`
        Ren'Py返回给操作系统的状态代码。大体来说，0表示成功，负数表示失败。

    `save`
        若为True，在Ren'Py进程结束前，游戏将在 :var:`_quit_slot` 位置存档。

.. function:: renpy.quit_event()

    触发一个退出(quit)事件，比如用户点击了窗口的退出按钮。

.. function:: renpy.reset_physical_size()

    尝试将物理窗口尺寸设置为renpy.config配置的指定值。(就是配置的screen_width和screen_height。)这在全屏模式下超出屏幕的情况有副作用。

.. function:: renpy.restart_interaction()

    重新启动当前交互行为。包括以下内容，将显示的图像添加到场景(scene)，重新规划界面(screen)，并启动所有队列中的转场(transition)。

    仅在某个交互行为中，该函数才会执行所有工作。交互行为之外，该函数不产生任何效果。

.. function:: renpy.scry()

    返回当前语句的scry对象。

    scry对象告知Ren'Py当前语句哪些部分未来必定会是True。目前的版本中，scry对象有下列字段：

    ``nvl_clear``
        如果在下一个交互行为之前会执行一个 ``nvl clear`` 语句则为True。

    ``say``
        如果在下一个交互行为之前会执行一个 ``say`` 语句则为True。

    ``menu_with_caption``
        如果在下一个交互行为之前会执行一个含标题的 ``menu`` 语句则为True。

    ``who``
        如果在下一个交互行为之前会执行一个 ``say`` 语句或含标题的 ``menu`` 语句，则角色对象将使用该字段。

    scry对象有一个next()方法，可以返回下一条将执行语句的scry对象。如果没有下一条将执行的语句，则返回None。
    
    .. warning::
    
        与其他类似函数一样，该函数的返回对象短期内还在被其他地方使用或修改。不建议在存档或回滚相关操作中使用此函数的返回对象。

.. function:: renpy.set_mouse_pos(x, y, duration=0)

    让鼠标指针跳到入参x和y指定的位置。如果设备没有鼠标指针，则没有效果。

    `duration`
        执行鼠标指针移动的时间，单位为秒。这段时间内，鼠标可能不响应用户操作。

.. function:: renpy.set_physical_size(size)

    尝试将物理窗口的尺寸设置为 *size* 。这对全屏模式下的有显示超出屏幕的副作用。

.. function:: renpy.shown_window()

    调用该函数确认窗口已经显示。使用“window show”语句的交互行为，会显示一个空窗口，无论该函数是否被调用。

.. function:: renpy.split_properties(properties, *prefixes)

    将 *properties* 切割为多个字典，每一个都带上前缀 *prefix* 。
    该函数轮流使用每一个 *prefix* 检查 *properties* 中每一个键(key)。
    如果匹配到某个前缀，将就键(key)的前缀部分去掉作为最终字典的键(key)。

    如果没有匹配到前缀，会抛出异常。(空字符串，""，可以用作最后一个前缀，创建一个全匹配字典。)

    例如，下面的语句将“text”开头的properties分割：

    ::

        text_properties, button_properties = renpy.split_properties("text_", "")

.. function:: renpy.stop_skipping()

    若Ren'Py处于跳过(skipping)状态，则停止跳过。

.. function:: renpy.transition(trans, layer=None, always=False)

    设置下次交互行为使用的转场(transition)。

    `layer`
        转场应用于这个参数表示的图层(layer)。若为None，转场应用于整个场景(scene)。

    `always`
        若为False，函数遵循定义的转场环境设定设置。若为True，使用运行转场。

.. function:: renpy.vibrate(duration)

    让设备震动 *duration* 秒。现在只支持安卓。

.. function:: layout.yesno_screen(message, yes=None, no=None)

    该函数产生一个yes/no提示界面，并显示给定的提示信息。当用于选择了yes或者no之后，就隐藏界面。

    `message`
        显示的提示消息。

    `yes`
        用户选择yes后运行的行为(action)。

    `no`
        用户选择no后运行的行为(action)。