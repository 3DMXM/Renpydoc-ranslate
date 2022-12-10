.. _python:

Python语句
=================

Ren'Py使用Python程序语言编写，并且支持在Ren'Py脚本中包含Python语句。对Python的支持可以用在很多方面，从立一个flag到创建新的可视组件等。本节内容主要涵盖Ren'Py脚本如何通过各种python语句直接调用Python的方法。

Ren'Py 7现在支持Python 2.7。Ren'Py 8支持Python 3.9。

.. note::
    如果你熟悉Python，将会是一项优势。
    但并不是任何关于Python的东西都可以直接使用。
    例如，Ren'Py中没有带的Python包(package)都不能在Ren'Py中使用。

    Python中还有几种数据结构，在存档时可能会有问题。
    详细信息请阅读 :doc:`存档、读档和回滚 <save_load_rollback>` 页面，尤其是 :ref:`不保存什么 <cant-save>` 部分。
    (对待文件、socket端口、迭代器、task、future线程和generator生成器需要特别小心。)
    
    最后，虽然很多语句都有等效的Python代码，但等效Python往往不如直接用Ren'Py语句。
    例如，使用Ren'Py中的 ``show`` 语句时，图像可以提前预加载，但如果用 :func:`renpy.show`` 函数则不能预加载。

.. _python-statement:

Python
------

python语句包含一个Python的语句块(block)，当主控流程达到该语句时就会执行对应的语句块。一条基本的python语句非常简练：

::

    python:
        flag = True

在必要时，python语句可以更复杂：

::

    python:
        player_health = max(player_health - damage, 0)
        if enemy_vampire:
            enemy_health = min(enemy_health + damage, enemy_max_health)

这里有两个标识符可以改变python语句的表现：

``hide``
    若出现了 ``hide`` 标识符，python语句将会以匿名者视角运行Python语句块。在该python语句块执行完毕后，匿名者视角就会丢失。

    hide标识符允许Python使用不能保存的临时变量——但也意味着存储(store)对象不能直接接入存储区(store)，而必须以字段(field)的形式接入。

``in``
    ``in`` 标识符包含一个变量名。Python会使用那个变量名所代表的存储区(store)，而非默认存储区。

.. _one-line-python-statement:

单行Python语句
-------------------------

最常见的情况就是只有一行Python语句，运行在默认存储区内。例如，一行Python可以用来初始化或者更新一个flag。为了让编写只有一行的Python更精炼，这里提供了单行Python语句。

单行Python语句以美元符号($)开头，一行语句内容可以包罗万象。这是一些单行Python语句样例：

::

    # 立一个flag。
    $ flag = True

    # 初始化一个变量。
    $ romance_points = 0

    # 变量自增。
    $ romance_points += 1

    # 调用Ren'Py函数。
    $ renpy.movie_cutscene("opening.ogv")

单行Python通常运行在默认的存储区。


.. _init-python-statement:

init python语句
---------------------

``init python`` 语句在初始化阶段运行，早于其他游戏资源加载。在其他方面，这种功能可以用于定义类(class)和函数(function)，或者初始化样式(style)、配置变量、持久化数据。

::

    init python:

        def auto_voice_function(ident):
            return "voice/" + ident + ".ogg"

        config.auto_voice = auto_voice_function

        if persistent.endings is None:
            persistent.endings = set()

    init 1 python:

        # bad ending始终是解锁状态。
        persistent.endings.add("bad_ending")

在 ``init`` 和 ``python`` 之间可以放一个运行优先级数值。如果没有指定优先级，默认使用0。init语句按照优先级数值从低到高的顺序运行。优先级相同的情况下，按照文件名的unicode字符顺序。文件内，从头到尾顺序运行。

为了避免与Ren'Py引擎产生冲突，创作者最好选用-999到999范围内作为优先级。负整数的优先级主要用在库(library)和主题设置。普通的init语句应该使用0或者正整数作为优先级。

init python语句也可以使用 ``hide`` 或 ``in`` 分句。

在init python语句中被赋值的变量不会用于存档、读档，且不接受回滚。因此，在初始化完成后，这些变量值就不该改动。

.. warning::

    在Ren'Py内创建的类，没有继承自任何类或显式继承自 ``object`` 类，及其以上类的所有子类，都不支持 ``__slots__`` 属性。
    在旧版本Ren'Py中回滚以上类的实例会出现奇怪的表现，在新版本中则会报错。

    如果要定义可以存档的类，创作者需要显式继承 ``python_object``，不过那个类不支持回滚。

.. _define-statement:

define语句
----------------

define语句在初始化时将一个变量赋值。例如：

::

    define e = Character("艾琳")

等价于(但会丢失一些好处，详见下文)：

::

    init python:
        e = Character("艾琳")

define语句可以选择使用一个命名存储区(详见下面的例子)，将存储区名放在变量前面，用英文句号(.)连接。举例：

::

    define character.e = Character("艾琳")

define语句可选择带一个索引值，使其可以在一个字典中设置元素：

::

    define config.tag_layer["eileen"] = "master"

除了使用等号 ``=`` ，define语句还可以使用另外两个运算符。
``+=`` 运算符用于添加元素，还主要用于列表合并。
``|=`` 运算符主要用于集合合并。例如：
::

    define config.keymap["dismiss"] += [ "K_KP_PLUS" ]
    define endings |= { "best_ending }

使用define语句的一个优点是，在声明时它会记录下文件名和该行脚本编号，供启动器(launcher)的导航(navigation)特性使用。
另一个优点是，:ref:`lint` 可以检查define后面的值，例如是否重复定义为不同的值。

通过define语句定义的变量会被当作一个常数，不会保存或读取，也不该被修改。
(Ren'Py不做强制要求，但修改那些参数会导致不可预见的情况出现。)

.. _default-statement:

default语句
-----------------

default语句给一个变量赋值，前提是该变量在游戏启动或者新游戏加载时未定义。举例：

::

    default points = 0

如果变量 ``points`` 在游戏启动时未定义，这条default语句等价于：

::

    label start:
        $ points = 0

如果变量 ``points`` 在游戏加载时未定义，这条default语句等价于：

::

    label after_load:
        $ points = 0

default语句可以选择使用一个命名存储区(详见下面的例子)，将存储区名放在变量前面，用英文句号(.)连接。
如果存储区名称不存在，则创建该名称的存储区。
举例：

::

    default schedule.day = 0

与 ``define`` 语句相同，:ref:`lint` 会对 ``default`` 语句进行检查和优化。

.. _python-init-offset-statement:

init offset语句
---------------------

init offset语句为所有在初始化阶段运行的语句设置了优先级偏移量(offset)。(init、init python、define、default、screen、transform、style等语句。)init offset语句中给定的偏移量(offset)对之后同一个语句块(block)及其子语句块的所有语句均生效，除非期间出现一个init priority语句。下面这条语句：

::

    init offset = 42

将优先级偏移量(offset)设置为42。而在下面段脚本中：

::

    init offset = 2
    define foo = 2

    init offset = 1
    define foo = 1

    init offset = 0

第一条define语句运行在优先级2，这意味着其会在第二条define语句后运行，因此变量 ``foo`` 的最终值为2。

.. _names-in-the-store:

存储区变量名
------------------

Ren'Py存储Python变量的地方称作存储区(store)。请务必保证你使用的存储区名没有冲突。

define语句将一个值声明为一个变量，也可用作定义一个角色对象。这也意味着角色和flag不能同名。

下面这段有问题的脚本：

::

    define e = Character("艾琳")

    label start:

        $ e = 0

        e "你好，世界。"

        $ e += 1
        e "你得了一分！"

无法运行，因为变量 `e` 同时用作角色和flag。

其他也常常需要放入存储区的对象是转场(transition)和变换(transform)。

以下划线 (\_) 开头的变量名是预留给Ren'Py内部使用。详情可以查看 :doc:`预留变量名目录 <reserved>` 。

.. _named-stores:

其他的命名存储区
------------------

命名存储区提供了一种将Python函数和变量有效组织成模块(module)的方法。利用Python的模块化功能，你可以将命名冲突的可能性降到最小。
每个存储区都对应一个Python模块。默认的存储区名为 ``store``，使用 ``store.named`` 可以访问对应名称的存储区。

使用 ``python in`` (``init python`` 或 ``python early``) 语句块，
或者 ``default``、``define`` 及 :ref:`transform <transform-statement>` 语句，都可以创建命名存储区。
使用 ``from store.named import variable`` 可以将变量导入存储区。
存储区自身可以使用 ``from store import named`` 导入脚本中。

Named stores can be accessed by supplying the ``in`` clause to
``python`` or ``init python`` (or ``python early``), all of which
run the Python they contain in the given named store.

命名存储区可以可以通过 ``python`` 或 ``init python`` 语句中的 ``in`` 分句接入。python和init python语句都在命名存储区内运行Python。每个存储区相当于一个Python模块(module)。默认存储区就是  ``store`` ，接入该存储区内的变量名格式为 ``store.name`` 。这些python模块可以通过使用Python import语句导入(import)，模块中的变量和函数名可以使用Python ``from`` 语句导入(import)。

举例：

::

    init python in mystore:

        serial_number = 0

        def serial():

            global serial_number
            serial_number += 1
            return serial_number

    default character_stats.chloe_substore.friends = {"Eileen",}

    label start:
        $ serial = mystore.serial()

        if "Lucy" in character_stats.chloe_substore.friends:
            chloe "露西是我的朋友！"
        elif character_stats.chloe_substore.friends:
            chloe "我有很多朋友，但露西并不是其中之一。"

        python in character_stats.chloe_substore:
            friends.add("Jeremy")

``python in`` 语句块中，默认的“outer”存储区可以使用 ``renpy.store`` 或 ``import store`` 读写数据。

命名存储区与默认存储区在存档、读档和回滚方面的情况一样。
特殊命名空间，比如 ``persistent``、``config``、``renpy`` 等，不支持在其内部再创建子存储空间。

.. _constant-stores:

常量存储区
---------------

定义存储区时，可以将内置变量 ``_constan`` 设置为True，这样存储区就会变成常量存储区：

::

    init python in mystore:
        _constant = True

存储区为常量时，其内部存储的所有变量都不会存档时保存，并在不参与回滚。

常量存储区中的变量仅能在初始化阶段修改。
在init语句块(包括 ``define``、``transform`` 等语句)中完成初始化后，存储区内所有数据都被当作常量。

Ren'Py没有办法强制保证常量存储区内的数据不会发生改变，所以创作者需要自己想办法确保初始化阶段之后不再会修改常量存储区的数据。

定义和使用常量存储区，可以将部分不会变化的数据分离出来，减少存档、读档和回滚时的数据操作，降低系统开销。

以下存储区默认为常量存储区：

::

    _errorhandling
    _gamepad
    _renpysteam
    _warper
    audio
    achievement
    build
    director
    iap
    layeredimage
    updater

.. _python-modules:

第一方和第三方Python模块(module)和包(package)
-------------------------------------------------

Ren'Py可以导入(import)纯python的模块和包。创作者需要用在游戏中的第一方的模块和包，可以直接放置在game文件夹里。第三方的包可以放在game/python-packages文件夹里。

例如，如果要安装requests包，创作者可以用命令行进入游戏所在目录，然后运行如下命令：

::

    pip install --target game/python-packages requests

无论何种情况，模块和包都可以导入(import)一个init python语句块(block)中::

    init python:
        import requests

.. warning::

    在.rpy文件里定义的Python语句会格式转换，使其允许回滚。从.py文件导入(import)的文件则不会发生这种格式转换。因此，在Python中创建的对象无法使用回滚(rollback)操作，且在创建之后就最好不要更改。
