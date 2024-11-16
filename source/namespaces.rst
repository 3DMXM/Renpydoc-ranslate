.. _namespace:

命名空间
==========

Ren'Py使用命名空间(namespace)来组织各种变量、函数和方法。本页包含Ren'Py已经定义的各种命名空间，主要用于帮助文档编辑者。

.. var:: achievement

    该命名空间的函数用于解锁和管理 :doc:`成就 <achievement>`，同时集成了Steamworks库的很多内容。

.. var:: bubble:

    该命名空间包含的变量，用于控制 :doc:`气泡式对话 <bubble>` 的显示效果。

.. var:: build:

    该命名空间包含的变量，用于控制 :doc:`构建发行版流程 <build>`。

.. var:: config:

    该命名空间包含的变量，用于控制Ren'Py的 :doc:`配置信息 <config>`。
    这些变量应该在游戏启动的初始化阶段(在 ``init python`` 语句块或使用 ``define`` 语句)进行修改。

.. var:: define:

    该命名空间包含的函数，用于定义新的变量，例如转场的族群。

.. var:: director:

    该命名空间包含的函数，用于控制 :doc:`交互式编导器 <director>`，可以让创作者在游戏中直接添加图片和音乐。

.. var:: gui

    该命名空间包含的函数，用于控制 :doc:`默认GUI系统 <gui>`。该命名空间中的变量仅在使用默认GUI系统时才会表现出效果。
    如果创作者替换了GUI则不会使用。当游戏中的多语言类型发生改变时，与gui命名空间有关的define语句会重新运行一遍。

.. var:: iap

    该命名空间包含的函数，用于控制 :doc:`游戏内购系统 <iap>`。

.. var:: im

    **注意：该命名空间内的大部分函数都已弃用。**

    该命名空间包含所有图像控制器，可以使用CPU加载和控制图像。此处的大多数函数都可以使用 :class:`Transform` 在GPU上实现。

.. var:: layeredimage

    :doc:`层叠式图像 <layeredimage>` 可以将多个图像合成为单一图像，使用属性(attribute)和条件语句控制具体显示的内容。
    该命名空间包含了所有的类，可以使用Python创建和控制层叠式图像，等效于 ``layerdedimage`` 语句。

.. var:: persistent

    持久化对象中的字段初始值为None，只要游戏运行就始终保留值的修改结果，甚至读档都不影响持久化对象。

    持久化对象中字段的数据类型应该是Python支持的类型，比如布尔型、数值、字符串、列表、元组和集合。
    自定义类不能声明为持久化对象。

.. var:: preferences

    该命名空间包含环境设定用到的各种变量。所有变量可读可写，因此常用 ``default`` 语句设置值，比如：

    ::

        default preferences.fullscreen = True

.. var:: preferences.volume

    该命名空间包含各混音器的默认音量值。常用 ``default`` 语句设置值，比如：

    ::

        default preferences.volume.music = 0.5

.. var:: renpy

    该命名空间包含Ren'Py引擎自带的各种函数和类。这些函数和类基本都有等效的Ren'Py脚本语言语句。
    也存在少量没有Ren'Py语言语句，只能以Python函数形式使用的函数和类。

.. var:: renpy.audio.filter

    该命名空间包含的类和函数，用于创建 :doc:`音频滤波器 <audio_filters>`。

.. var:: renpy.music

    该命名空间包含的函数，用于控制 :doc:`音频系统 <audio>`。这些函数默认用于music音频通道。

.. var:: renpy.sound

    该命名空间包含的函数，用于控制 :doc:`音频系统 <audio>`。这些函数默认用于sound音频通道。
    大多数函数与renpy.music命名空间中的函数名称和功能一样。

.. var:: style

    该命名空间包含的样式和函数，用于控制样式(style)。样式自身用于控制Ren'Py的文本、图像等元素。
    相比直接使用sytle命名空间中的函数，更推荐使用 ``style`` 语句。

.. var:: ui

    **注意：该命名空间内的大部分函数都已弃用。**

    该命名空间包含的陈旧函数和类型，用于显示UI元素。
    除了ui.adjustment、ui.interact、ui.callsinnewcontext和ui.invokesinnewcontext，所有函数都已废弃。

.. var:: updater

    该命名空间包含的函数、类和变量，用于控制 :doc:`HTTPS/HTTP更新器 <updater>`。