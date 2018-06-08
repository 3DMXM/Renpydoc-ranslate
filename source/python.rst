.. _python:

Python语句
=================

Ren'Py使用Python程序语言编写，并且支持在Ren'Py脚本中包含Python语句。对Python的支持可以用在很多方面，从立一个flag到创建新的可视组件等。本节内容主要涵盖Ren'Py脚本如何通过各种python语句直接调用Python的方法。


.. _python-statement:

Python
------

python语句包含一个Python的语句块(block)，当主控流程达到该语句时就会执行对应的语句块。一条基本的python语句非常简练：::

    python:
        flag = True

在必要时，python语句可以更复杂：::

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

单行Python语句以美元符号($)开头，一行语句内容可以包罗万象。这是一些单行Python语句样例：::

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

``init python`` 语句在初始化阶段运行，早于其他游戏资源加载。在其他方面，这种功能可以用于定义类(class)和函数(function)，或者初始化样式(style)、配置变量、持久化数据。 ::

    init python:

        def auto_voice_function(ident):
            return "voice/" + ident + ".ogg"

        config.auto_voice = auto_voice_function

        if persistent.endings is None:
            persistent.endings = set()

    init 1 python:

        # 解锁bad ending。
        persistent.endings.add("bad_ending")

在 ``init`` 和 ``python`` 之间可以放一个运行优先级数值。如果没有指定优先级，默认使用0。init语句按照优先级数值从低到高的顺序运行。优先级相同的情况下，按照文件名的unicode字符顺序。文件内，从头到尾顺序运行。

为了避免与Ren'Py引擎产生冲突，创作者最好选用-999到999范围内作为优先级。负整数的优先级主要用在库(library)和主题设置。普通的init语句应该使用0或者正整数作为优先级。

init python语句也可以使用 ``hide`` 或 ``in`` 分句。

在init python语句中被赋值的变量不会用于存档、读档，且不接受回滚。因此，在初始化完成后，这些变量值就不该改动。

.. _define-statement:

define语句
----------------

define语句在初始化时将一个变量赋值。例如：::

    define e = Character("艾琳")

等价于::

    init python:
        e = Character("艾琳")

define语句可以选择使用一个命名存储区(详见下面的例子)，将存储区名放在变量前面，用英文句号(.)连接。举例：::

    define character.e = Character("艾琳")

使用define语句的一个优点是，在声明时它会记录下文件名和该行脚本编号，供启动器(launcher)的导航(navigation)特性使用。

通过define语句定义的变量会被当作一个常数，不会保存或读取，也不该被修改。(Ren'Py不做强制要求，但修改那些参数会导致不可预见的情况出现。)

.. _default-statement:

default语句
-----------------

default语句给一个变量赋值，前提是该变量在游戏启动或者新游戏加载时未定义。举例：::

    default points = 0

如果变量 ``points`` 在游戏启动时未定义，这条default语句等价于：::

    label start:
        $ points = 0

如果变量 ``points`` 在游戏加载时未定义，这条default语句等价于：::

    label after_load:
        $ points = 0

default语句可以选择使用一个命名存储区(详见下面的例子)，将存储区名放在变量前面，用英文句号(.)连接。举例：::

    default schedule.day = 0


.. _init-offset-statement:

init offset语句
---------------------

init offset语句为所有在初始化阶段运行的语句设置了优先级偏移量(offset)。(init、init python、define、default、screen、transform、style等语句。)init offset语句中给定的偏移量(offset)对之后同一个语句块(block)及其子语句块的所有语句均生效，除非期间出现一个init priority语句。下面这条语句：::

    init offset = 42

将优先级偏移量(offset)设置为42。而在下面段脚本中：::

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

define语句将一个值声明为一个变量，而其通常用作定义一个角色。这表示角色和flag不能同名。

下面这段有问题的脚本：::

    define e = Character("艾琳")

    label start:

        $ e = 0

        e "你好，世界。"

        $ e += 1
        e "你得了一分！"

无法运行，因为变量 `e` 同时用作角色和flag。

其他也常常需要放入存储区的对象是转场(transition)和变换(transform)。

以下划线 (\_) 开头的变量名是预留给Ren'Py内部使用。详情可以查看 :ref:`预留变量名目录 <reserved-names>` 。

.. _other-named-stores:

其他的命名存储区
------------------

命名存储区提供了一种将Python函数和变量有效组织成模块(module)的方法。利用Python的模块化功能，你可以将命名冲突的可能性降到最小。

命名存储区可以可以通过 ``python`` 或 ``init python`` 语句中的 ``in`` 分句接入。python和init python语句都在命名存储区内运行Python。每个存储区相当于一个Python模块(module)。默认存储区就是  ``store`` ，接入该存储区内的变量名格式为 ``store.name`` 。这些python模块可以通过使用Python import语句导入(import)，模块中的变量和函数名可以使用Python from语句导入(import)。

举例：::

    init python in mystore:

        serial_number = 0

        def serial():

            global serial_number
            serial_number += 1
            return serial_number

    init python:
        import store.mystore as mystore

    label start:
        $ serial = mystore.serial()


命名存储区与默认存储区在存档、读档和回滚方面的情况一样。define语句也可以在命名存储区内定义变量或函数名。

.. _first-and-third-party-python-modules-and-packages:

第一方和第三方Python模块(module)和包(package)
-------------------------------------------------

Ren'Py可以导入(import)纯python的模块和包。创作者需要用在游戏中的第一方的模块和包，可以直接放置在game文件夹里。第三方的包可以放在game/python-packages文件夹里。

例如，如果要安装requests包，创作者可以用命令行进入游戏所在目录，然后运行如下命令：::

    pip install --target game/python-packages requests

无论何种情况，模块和包都可以导入(import)一个init python语句块(block)中::

    init python:
        import requests

.. warning::

    在.rpy文件里定义的Python语句会格式转换，使其允许回滚。从.py文件导入(import)的文件则不会发生这种格式转换。因此，在Python中创建的对象无法使用回滚(rollback)操作，且在创建之后就最好不要更改。
