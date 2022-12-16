.. _lifecycle-of-a-renpy-game:

===============================
Ren'Py游戏的生命周期(lifecycle)
===============================

无论是直接运行可执行程序或使用启动器，运行一个Ren'Py时整个程序会执行一系列预订的步骤，直到游戏进程关闭。
本页旨在揭示整个生命周期(lifecycle)的各个步骤，以及相关的各语句。

.. _boot-time:

启动期
=========

在游戏窗口显示出来前，就已经处理了很多工作，即启动期。
启动阶段唯一能看到的内容只有 :ref:`presplash <presplash>`。

.. _early-phase:

脚本处理阶段
--------------------

Ren'Py会读取每个游戏中的 ``.rpy`` 文件(以及 ``_ren.py`` 文件)。读取时按照Unicode编码，根据路径和文件名顺序读取。
这就是脚本处理阶段，或者说“early”阶段。

创作者写的脚本中，最早被执行的代码是写在 ``python early`` 代码块的内容。
执行这些代码的前提是，代码所在的脚本文件已被读取和处理。
这就是修改处理机制的语句需要写在 ``python`` 中的原因，比如 :doc:`cds`、:ref:`creator-defined-sl` 和自定义的 :ref:`warpers`.

有时候可能会看到 ``init python early``，语法是正确的但多余。不会影响代码实际运行的顺序和结果。

.. _init-phase:

初始化阶段
----------

在脚本处理阶段之后，就轮到“init”阶段。某些语句在该阶段运行，包括 :ref:`init-python-statement`、:ref:`define-statement`、
:ref:`transform-statement`、:ref:`image-statement`、:ref:`screen-statement` 和 :doc:`style <style>`。
初始化阶段又可以细分为多个连续时间段，或者说初始化优先级，分别使用-999到999间的整数作为标记。
标记数值越小，对应的时间段越早执行，即优先级越高。

image define default transform (init) screen (testcase) (translation) style

默认情况下，以上语句会以“init优先级偏移量(offset)0”执行。
不过，也可以使用 :ref:`init-offset-statement` 等方式修改执行优先级偏移量。
:ref:`image-statement` 语句不遵循以上规则，其默认值在优先级500时间段执行。
``init offset`` 语句修改优先级都会自动避开500这个值，而不是替换这个时间段执行的内容。

使用 :ref:`image-directory` 根据图片文件名称自动生成图像定义的过程，发生在优先级0时间段。

注意，:ref:`default语句 <default-statement>` 不在初始化阶段执行，与变量相关的过程可能会相互影响。

.. _init-offset-statement:

init offset语句
^^^^^^^^^^^^^^^^^^^^^

The ``init offset`` statement sets a priority offset for all statements
that run at init time. It should be placed at the top of the file, and it applies to all following
statements in the current block and child blocks, up to the next
init priority statement. The statement
``init offset`` 语句为所有在初始化阶段运行的语句设置了优先级偏移量(offset)。
该语句应该写在脚本文件开头，指定的偏移量(offset)对之后同一个语句块(block)及其子语句块的所有语句均生效，
除非期间出现一个init priority语句。下面这条语句：

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

.. _script-execution:

脚本执行
========

当游戏窗口显示后，就进入了脚本执行阶段。
普通的Ren'Py语句在此阶段执行，:doc:`label` 中描述的各类规则开始生效。
:ref:`default语句 <default-statement>` 也在此阶段运行，首次对变量赋值。
有类似功能的 :ref:`define语句 <define-statement>` 则在初始化阶段进行赋值操作。

游戏正常启动后，配置项变量的值就不该再发生改变。

.. _splashscreen:

启动界面
------------

若设置了启动界面，则执行 :ref:`splashscreen <adding-a-splashscreen>` 标签直到返回。

启动界面仅在Ren'Py运行时显示一次，之后重新运行脚本时会自动跳过。

.. _main-menu:

主菜单
---------

若设置了主菜单，则先执行 ``before_main_menu`` 脚本标签。
该标签返回后，如果脚本中存在 ``main_menu`` 脚本标签则执行标签内容，否则直接显示 :ref:`主菜单 <main-menu-screen>` 界面。
详见 :ref:`special-labels` 部分。

主菜单运行在其自己的 :ref:`context <context>` 中。
Ren'Py可以通过调用 :class:`Start` 行为函数跳转到指定标签或默认 ``start`` 标签，同时保留主菜单的上下文。
从 ``main_menu`` 标签返回后，依然会进入游戏阶段的 ``start`` 标签。
游戏读档后也会直接跳转到游戏阶段的对应标签位置。

.. _in-game-phase:

游戏阶段
-------------

游戏阶段是实际可以进行游戏内容。用户花时间也主要是运行这部分内容。
该阶段在退出游戏、重启游戏或返回主菜单后结束。

在游戏阶段中，:class:`ShowMenu` 行为可用于在一个新的上下文(context)中显示某个界面。

调用栈为空时，游戏将返回到开头并重新开始，具体解释在 :doc:`label` 章节。
:class:`MainMenu` 行为和 :func:`renpy.full_restart` 函数也都可以用于重启游戏。

游戏重头开始时，所有非持久化数据都会重置为脚本处理阶段最后设置的值，然后脚本从头开始执行，跳过启动界面。