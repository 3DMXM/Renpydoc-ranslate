.. _modes:

=====
模式
=====

在Ren'Py中，模式(mode)是一种描述交互类型的简练方法。当Ren'Py收到某个模式的报告，用户自定义的回调函数就可以运行。这些回调函数通过调整模式进行相应，可能会重新配置用户接口。例如，一个从ADV模式切换到NVL模式或进入菜单界面等，可能会触发一个转场(transition)。

模式系统的目标是提供一个强效和扩展性的方式，检测和响应这些变化。

.. _default-modes:

默认模式
=============

下列模式分别对应内建的交互行为：

start
    当创建一个新的上下文(context)时，比如游戏开始，Ren'Py就会处于这种模式。Ren'Py从不自动进入这个模式，但在初始化模式列表时包括了start。

say
    当ADV模式下say语句执行时，Ren'Py进入的模式。

menu
    当ADV模式下menu语句执行时，Ren'Py进入的模式。

nvl
    当NVL模式下say语句执行时，Ren'Py进入的模式。

nvl_menu
    当NVL模式下menu语句执行时，Ren'Py进入的模式。

pause
    当 :func:`renpy.pause` 运行时，Ren'Py进入的模式。在一个 ``pause`` 语句的暂停时间内，Ren'Py也处于这种模式。

with
    当使用 ``with`` 语句进入一个转场(transition)时，Ren'Py进入的模式。

    注意，在with语句开头，Ren'Py就进入了with模式，而在scene、show和hide语句执行后Ren'Py才会切换模式。

screen
    当使用 ``call screen`` 语句唤起某个界面时，Ren'Py进入的模式。

imagemap
    当使用 :func:`renpy.imagemap` 唤起旧样式的imagemap时，Ren'Py进入的模式。

input
    当使用
    :func:`renpy.input` 函数请求文本输入时，Ren'Py进入的模式。

其他模式可以通过调用renpy.mode函数进入。

.. function:: renpy.get_mode()

  返回当前模式，如果未定义则返回None。

.. function:: renpy.mode(mode)

  让Ren'Py进入某个模式，如果已经处于这个模式则保持。

.. _mode-callbacks:

模式回调函数
==============

:var:`config.mode_callbacks` 变量包含了一个模式回调函数的列表。当Ren'Py进入某个模式时，就会唤起列表中的模式回调函数。模式回调函数使用两个参数：

mode
    一个字符串，表示进入的模式名称。

old_modes
    一个字符串列表，表示系统之前曾进入过的所有模式，按时间从近到远排序。

注意，当进入的模式就是现在处于的模式时， `old_modes` 的第一个元素会等于 `mode`。

.. _example-mode-callbacks:

样例模式回调函数
----------------------

当从ADV模式切换到NVL模式时，模式回调函数会触发一个转场(transition)，反之亦然。这是Ren'Py内置功能的一部分，不需要显示调用。 ::

    init python:
        def _nvl_adv_callback(mode, old_modes):

            old = old_modes[0]

            if config.adv_nvl_transition:
                if mode == "nvl" or mode == "nvl_menu":
                    if old == "say" or old == "menu":
                        nvl_show(config.adv_nvl_transition)

            if config.nvl_adv_transition:
                if mode == "say" or mode == "menu":
                    if old == "nvl" or old == "nvl_menu":
                        nvl_hide(config.nvl_adv_transition)

        config.mode_callbacks.append(_nvl_adv_callback)
