.. _persistent-data:

持久化数据
===============

Ren'Py支持持久化数据，保存游戏中与某个特定时间点无关的数据。绑定了变量 ``persistent`` 的持久化对象字段(field)，可以读写并实现持久化数据。

当Ren'Py进程结束时，所有与 ``persistent`` 关联的数据都会被保存，也可以通过调用 :func:`renpy.save_persistent()` 。当Ren'Py启动或者检测到磁盘上的持久化数据更新过时，会加载持久化数据。

持久化对象有个特殊情况，就是接入一个未定义的字段(field)时会得到一个None，而不是触发一个异常。

使用持久化的例子是创建一个能解锁的图片画廊。通过持久化存储一个标志(flag)，就能判断画廊是否被解锁，比如：

::

    label gallery:

        if not persistent.gallery_unlocked:
            show background
            centered "你还没有解锁画廊。"
            $ renpy.full_restart()

        # 这里实际展示画廊。

当用于获得了某个解锁画廊的结局，这个标志(flag)必须设置为True。

::

    $ persistent.gallery_unlocked = True

由于持久化数据在初始化Python语句块(block)之前加载，所以持久化数据应该只包含Python和Ren'Py的原生数据类型。不过，定义在 ``python early`` 语句块(block)中的类可以使用，提供的那些类可以被pickle和赋值。

.. _merging-persistent-data:

合并持久化数据
-----------------------

有些时候Ren'Py需要合并源自两处的持久化数据。例如，Ren'Py可能需要合并来自USB驱动器和本地设备两个地方的持久化数据。

Ren'Py使用“域到域”的形式进行分析，使用每个域中最后更新的值进行比较。在某些情况下，这不是我们需要的行为。这时，可以使用 :func:`renpy.register_persistent()` 函数。

例如，如果我们有一个已经看过的结局的集合(set)，我们合并数据时就希望取一个合集。

::

    init python:
        if persistent.endings is None:
            persistent.endings = set()

        def merge_endings(old, new, current):
            current.update(old)
            current.update(new)
            return current

        renpy.register_persistent('endings', merge_endings)

.. _persistent-functions:

持久化函数
--------------------

.. function:: renpy.register_persistent(field, func)

  注册一个函数，用于合并磁盘上的持久化字段(field)值和当前持久化对象的值。

  `field`

    持久化对象的字段(field)名。

  `func`

    该函数使用 *old* 、 *new* 和 *current* 三个参数。

    **old**

      旧对象域的值。

    **new**

      新对象域的值。

    **current**

      当前持久化对象域的值。这个参数用于域引用的对象标识符无法改变的情况。

    该函数需要返回持久化对象域的新值。

.. function:: renpy.save_persistent()

  将持久化数据保存到磁盘。

.. _multi-game-persistence:

多个游戏数据的持久化
----------------------

多游戏数据持久化是一个允许在多个Ren'Py游戏中共享信息的特性(feature)。如果你计划制作一个游戏系列，并在系列游戏中共同使用某些信息，就有可能用得上这个特性。

需要使用多元持久化数据，必须在初始化语句块(init block)中创建一个MultiPersisten对象。用户可以更新这个对象，并调用其save方法保存至磁盘。未定义的字段(field)默认值为None。为了确保这个对象可以能再次正确加载，我们不建议声明用户自定义类型数据对象。

.. class:: MultiPersistent(key)

    创建一个新的MultiPersistent对象。这个类的构造函数应该只能在初始化语句块(init block)中调用，并根据给定的key创建一个新的MultiPersistent对象。

    `key`
        用于接入多元持久化数据的key。使用相同key的游戏可以接入同一个多元持久化数据。


    .. method:: save()

        将多元持久化数据保存至磁盘。当数据修改后必须调用这个函数。


这里的样例，选取了一个分成两部的游戏。这是第一部：

::

    init python:
        mp = MultiPersistent("demo.renpy.org")

    label start:

        # ...

        # 记录用户运行第一部的结果

        $ mp.beat_part_1 = True
        $ mp.save()

        e "你打通了第一部。我们第二部再见！"

这是第二部：

::

    init python:
        mp = MultiPersistent("demo.renpy.org")

    label start:

        if mp.beat_part_1:
             e "你已经打通了第一步，欢迎来到第二部！"
        else:
             e "呣，你还没有玩过第一部，为什么不先试试第一部呢？"
