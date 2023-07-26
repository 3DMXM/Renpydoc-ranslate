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

    在浏览器内运行时为True。

.. var:: renpy.mobile

    在安卓、iOS平台或浏览器运行时为True。

只有在实际设备运行而非模拟器上运行时，才会设置这些配置项。 这些配置项对平台敏感的Python是有用的。对显示布局(layout)的问题，详见 :ref:`界面变种 <screen-variants>`.


内存分析
-----------------

.. function:: renpy.(update=True, skip_constants=False)

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

.. _context:

上下文(context)
----------------

.. function:: renpy.context()

    返回一个对象，这个对象对当前上下文(context)唯一。进入一个新的上下文时，这个对象会复制一个副本。但对副本的修改不会影响原来的对象。

    这个对象在回滚中会被保存和恢复。

.. function:: renpy.context_nesting_level()

    返回当前上下文的嵌套等级。最外层的上下文的等级是0(例如保存、读取和回滚)，非0等级其他上下文有菜单和回放等。

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

这些函数允许创作者使用Python的ctypes模块调用SDL中dll的函数。
Ren'Py不保证自身的SDL2版本包含所有功能特性。其他地方可以运行的函数也不一定能在Ren'Py里运行，因此在实际使用前需要检查对应函数是否为空。

.. function:: renpy.get_sdl_dll()

    该函数返回一个ctypes.cdll对象，指向Ren'Py正在使用的SDL2实例中的库。

    如果无法获取，则返回None。

.. function:: renpy.get_sdl_window_pointer()

    该函数返回(ctypes.c_void_p类型)主窗口坐标。主窗口没有显示或发生问题时，返回None>

::

    init python:

        import ctypes

        def get_window_position():
            """
            通过SDL2检查窗口坐标。返回窗口左上角坐标的(x, y)值。如果是未知坐标也会返回(0, 0)。
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

            SDL_GetWindowPosition(win, ctypes.byref(x), ctypes.byref(y))

.. _miscellaneous:

其他林林总总
-------------

.. function:: renpy.add_layer(layer, above=None, below=None, menu_clear=True)

    向界面添加一个新图层。如果图层已经存在，则不做任何事。

    *below* 和 *above* 必须提供至少一项。

    `layer`
        表示添加的新图层名称的字符串。

    `above`
        如果不是None，表示被新图层覆盖的图层的名称字符串。

    `below`
        如果不是None，表示覆盖在新图层上的图层的名称字符串。

    `menu_clear`
        若为True，进入游戏菜单上下文(context)时会清空这个图层，并在离开××××时恢复。

.. function:: renpy.add_python_directory(path)

    将 *path* 添加在Python模块(module)和包(package)的路径列表中。这个路劲应该是一个游戏目录相对路劲的字符串。必须在import语句之前调用该函数。

.. function:: renpy.add_to_all_stores(name, value)

    在创作者定义的命名空间中，添加名为 `name` 的变量，值为 `value` 。
    如果同名变量已存在，则不做任何操作。
    该函数只能在init代码块中运行。游戏启动后再运行该函数将报错。

.. function:: renpy.call_stack_depth()

    返回当前上下文(context)调用栈(stack)的深度——这个数表示调用栈中还没有返回或弹出，但依然在运行的调用数量。

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

.. function:: renpy.clear_keymap_cache()

    清空快捷键缓存。该函数允许对 :func:`config.keymap` 的修改立刻生效，而不需要重启Ren'Py。

.. function:: renpy.context_dynamic(*vars)

    该函数可以将一个或多个变量作为入参。函数让变量根据当前上下文(context)动态调整。当调用返回后，变量会重置为原来的值。
    
    一个调用的样例如下：

    ::

        $ renpy.context_dynamic("x", "y", "z")

.. function:: renpy.count_dialogue_blocks()

    返回游戏原生语言的对话段落数量。

.. function:: renpy.count_newly_seen_dialogue_blocks()

    返回本次会话(session)中用户首次看到的对话段落数量。

.. function:: renpy.count_seen_dialogue_blocks()

    返回用户在当前游戏进度中看过的所有对话段落数量。

.. function:: renpy.display_notify(message)

    :func:`renpy.notify` 函数的默认实现方法。

.. function:: renpy.dynamic(*vars, **kwargs)

    可以向该函数传入一个或多个入参。该函数可以通过本地调用生成动态变量作用域。
    调用该函数并返回时，对应的变量值将会被设置为传入的值。


    如果变量以关键词参数传入，会根据变量名匹配并设置对应变量。

    调用样例为：

    ::

        $ renpy.dynamic("x", "y", "z")
        $ renpy.dynamic(players=2, score=0)

.. function:: renpy.flush_cache_file(fn)

    引用文件fn的所有图片缓存都将被冲洗(flush)。
    当硬盘上的图片文件都发生了变更后，可以调用该函数强制Ren'Py使用游戏新版本。

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

.. function:: renpy.get_adjustment(bar_value)

    传入一个 :class:`BarValue` 对象 `bar_value` ，返回 :func:`ui.adjustment()` 。adjustment对象定义了下列属性(attribute)：

    .. attribute:: value

        条(bar)的当前值。

    .. attribute:: range

        条(bar)的当前值域。

.. function:: renpy.get_autoreload()

    获得自动加载标识(flag)。

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

.. function:: renpy.get_mouse_name(interaction=False)

    返回显示鼠标名称。

    `interaction`
        若为True，根据互动类型获取鼠标名称。(极少使用)

.. function:: renpy.get_mouse_pos()

    返回一个(x, y)元组，表示鼠标指针或当前触摸位置的坐标。如果设备不支持鼠标并且当前没有被触摸，x和y值无意义。

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

.. function:: renpy.get_transition(layer=None)

    获取 *lay* 的转场(transition)，如果 *layer* 为None则获取整个场景(scene)的转场。该函数返回了在下次交互行为中，队列上层的转场(transition)。如果不存在符合条件的转场则返回None。

.. function:: renpy.iconify()

    游戏窗口最小化。

.. function:: renpy.invoke_in_thread(fn, *args, **kwargs)

    在背景线程调用函数 *fn* ，传入该函数收到的所有入参。线程返回后重新启动交互行为。

    该函数创建一个守护线程(daemon thread)，当Ren'Py关闭后这个线程也会自动停止。

    该线程使用Ren'Py的API能做的事情非常受限。可以调用 :func:`renpy.queue_event` 修改存储区的变量。
    最好在主线程中使用其他Ren'Py的API。

    该函数的主要用途是：通过web API创建第二线程，调用该函数修改存储区变量，通过互动行为在界面上展示变量的变化。

    然而该函数还无法在Web平台运行。

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

.. function:: renpy.pop_call()

    从调用栈(stack)弹出当前调用，并不再返回那个位置。

    如果调用方决定不需要返回到那个脚本标签(label)的情况下，可以使用该函数。

.. function:: renpy.prediction()

    若Ren'Py处于预加载阶段则返回True。

.. function:: renpy.queue_event(name, up=False, **kwargs)

    使用给定的 *name* 将某个事件放入消息队列。 *name* 应该是在 :func:`config.keymap` 中列出的事件名称之一，或者是这些事件组成的列表。

    `up`
        当事件开始阶段(例如，键盘按键被按下)时，这项应该是False。当事件结束(比如按键被松开)是，这项才会变成True。

    当调用该函数时，事件会被同时放入消息队列。该函数不能替换事件——替换会修改事件的顺序。(替换事件可以使用 :func:`config.keymap` 。)

    该函数是线程安全的(threadsafe)。

.. function:: renpy.quit(relaunch=False, status=0)

    该函数让Ren'Py完全退出。

    `relaunch`
        若为True，Ren'Py会在退出前运行自身的一个副本。

    `status`
        Ren'Py返回给操作系统的状态代码。大体来说，0表示成功，负数表示失败。

.. function:: renpy.quit_event()

    触发一个退出(quit)事件，比如用户点击了窗口的退出按钮。

.. function:: renpy.reload_script()

    让Ren'Py保存游戏，重新加载脚本，并加载存档。

.. function:: renpy.reset_physical_size()

    尝试将物理窗口尺寸设置为renpy.config配置的指定值。(就是配置的screen_width和screen_height。)这在全屏模式下超出屏幕的情况有副作用。

.. function:: renpy.restart_interaction()

    重新启动当前交互行为。包括以下内容，将显示的图像添加到场景(scene)，重新规划界面(screen)，并启动所有队列中的转场(transition)。

    仅在某个交互行为中，该函数才会执行所有工作。交互行为之外，该函数不产生任何效果。

.. function:: renpy.screenshot(filename)

    将截屏保存为 *filename* 。

    如果截屏保存成功就返回True。如果由于某些原因保存失败就返回False。

.. function:: renpy.screenshot_to_bytes(size)

    以二进制对象形式返回一个截屏，可以作为参数传入 :func:`im.Data` 。该二进制对象将是一张png格式图片，例如：

    ::

        $ data = renpy.screenshot_to_bytes((640, 360))
        show expression im.Data(data, "screenshot.png"):
            align (0, 0)

    将显示一个截屏图像。这个二进制对象可以存储到存档文件和持久化数据中。不过这个对象可能很大，注意不要存储太多类似的对象。

    `size`
        截屏后重新缩放的目标尺寸。若为None，截屏将按用户窗口的尺寸进行调整，不包含窗口的标题栏。

    该函数运行可能比较慢，通常用在类似存档的截屏需求中，而不应该用在需要实时生效的功能中。

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

.. function:: renpy.set_autoreload(autoreload)

    设置自动重新加载标识(flag)。这个标识决定在文件发生变化后游戏是否会自动重新加载。自动重新加载不是完全启用，直到游戏使用 :func:`renpy.utter_restart()` 重新加载之后。

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

.. function:: renpy.substitute(s, scope=None, translate=True)

    对字符串 *s* 应用多语言支持(translation)和新样式格式。

    `scope`
        若不是None，格式中使用的scope，添加到默认存储区。

    `translate`
        决定是否启用何种语言支持。

    返回多语言支持和格式的字符串。

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