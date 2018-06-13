.. _nvl-mode-tutorial:

NVL模式教程
=================

视觉小说中总共有两种表现形式。ADV模式下使用界面底部的一个窗口显示对话和旁白，每次显示一行。NVL模式下使用几乎占据整个界面的一个窗口，每次能在界面上显示多行对话和旁白。

在这篇教程中，我们会解释如何使用Ren'Py制作NVL模式的游戏。教程假设你已经熟悉Ren'Py的基本功能，至少看过 :doc:`快速入门 <quickstart>` 内容。

.. _getting-started:

入门
---------------

NVL模式可以通过两步操作添加到Ren'Py脚本中。第一步是定义使用NVL模式的角色，第二步是在每页结尾添加 ``nvl clear`` 语句。

在每个角色定义阶段，加入一个 ``kind=nvl`` 参数就定义了一个使用NVL模式的角色。例如，如果我们在快速入门手册定义的角色：

::

    define s = Character('希尔维亚', color="#c8ffc8")
    define m = Character('我', color="#c8c8ff")

改为使用NVL模式，定义方法变成：

::

    define s = Character('希尔维亚', kind=nvl, color="#c8ffc8")
    define m = Character('我', kind=nvl, color="#c8c8ff")

NVL模式的旁白可以使用如下定义：

::

    define narrator = nvl_narrator

需要注意，我们也可以添加一个 ``narrator`` 的NVL模式定义。 ``narrator`` 角色用于不由任何其一个角色发言的内容。

如果我们一直这样运行，开头的几行文本可以正常显示。一会之后，文本会显示到界面底部下面，就看不到了。要将脚本分割为多页，可以在分页的地方使用一个  ``nvl clear`` 语句。

下面是一个使用分页的样例脚本：

::

    label start:
        "我得问问她！"

        m "嗯呣……你是否可以……"
        m "你是否可以做我的视觉小说画师？"

        nvl clear

        "沉默。"
        "她有些吃惊，然后……"

        s "当然，不过，什么是\"视觉小说\"？"

        nvl clear

NVL模式的游戏一般在每段都有更多文本，这个样例只是个最基础的的NVL模式脚本。(适合用于不需要转场效果的电子小说(kinetic novel)。)

.. _menus:

选项菜单
-----

ADV模式下，默认的菜单显示方式会占据整个界面。NVL模式下的菜单展现也有一个对应的变种，就是在当前NVL模式文本页面后面立刻显示菜单。

要使用这个变种菜单，可以这样写：

::

    define menu = nvl_menu

在选项菜单的某项被选择之后，菜单会消失，所以通常会在菜单之后使用一条“nvl clear”语句或者某些提示语。

.. _showing-and-hiding-the-nvl-mode-window:

显示和隐藏NVL窗口
--------------------------------------

使用标准的 ``window show`` 和 ``window hide`` 语句就可以控制NVL模式窗口。需要启用这项功能的话，可以在脚本中使用如下配置：

::

    init python:
        config.empty_window = nvl_show_core
        config.window_hide_transition = dissolve
        config.window_show_transition = dissolve

将 :var:`config.empty_window` 配置为 ``nvl_show_core`` 后，就能让NVL模式窗口使用转场(transition)显示。后面两行语句，配置了窗口显示和隐藏时使用的默认转场效果。

一个显示和隐藏窗口的样例如下：

::

    label meadow:

        nvl clear

        window hide
        scene bg meadow
        with fade
        window show

        "我们抵达了城镇外的牧场。这里的秋天格外秀美。"
        "童年时，我们经常在牧场里玩耍。"

        m "嗨……唔……"

        window hide
        show sylvie smile
        with dissolve
        window show

        "她把脸转向我，上面挂着微笑。"
        "我得问问她！"
        m "嗯呣……你是否可以……"
        m "你是否可以做我的视觉小说画师？"

这里显示使用了 ``nvl show`` 和 ``nvl hide`` 语句控制NVL模式窗口的显示和隐藏。窗口可选使用转场，并且可以在游戏中混合使用NVL模式和ADV模式窗口。

.. _customizing-characters:

定制角色
----------------------

NVL模式角色可以使用定制，具有几种不同的外观。希望创作者可以选取其中满足自己需求的。

1. 默认外观是角色名字在左侧。名字后边开始为对话内容。角色名字的颜色由参数“color”控制。

::

    define s = Character('希尔维亚', kind=nvl, color="#c8ffc8")

2. 第二种外观是角色名字内嵌在文本中。角色发言内容包含在引号中。这里需要注意，角色名字放在参数“what_prefix”中，使用开放的引号。(闭合的引号放的是“what_suffix”参数。) ::

    define s = Character(None, kind=nvl, what_prefix="希尔维亚: \"",
                         what_suffix="\"")

3. 第三种外观不直接分配角色名，把对话内容放在引号中。 ::

    define s = Character(None, kind=nvl, what_prefix="\"", what_suffix="\"")

4. 由于第三种外观可能会让人难以区分谁在发言，我们可以使用“what_color”参数把对话染色。

::

    define s = Character(None, kind=nvl, what_prefix="\"", what_suffix="\"",
                         what_color="#c8ffc8")

5.  当然，一个完全没有定制化的NVL模式角色也可以直接使用，前提是你想要把握整体显示效果。(常用于旁白。) ::

    define s = Character(None, kind=nvl)

.. _config-variables:

配置项
----------------

下列配置项控制NVL相关的功能。

.. var:: config.nvl_layer = "screens"

    NVL界面使用的图层(layer)。

.. var:: config.nvl_list_length = None

    若非None，这项表示NVL对话列表的最大长度。配置这项值(通常用于将对话强制限制在一个固定高度内)，可以模仿一个无限的可滚动NVL窗口。

.. var:: config.nvl_page_ctc = None

    若非None，这是用于NVL模式角色的“点击继续”提示，当到底页面底部时出现。(也就是后面跟一个“nvl clear”语句)。这项代替了 :func:`Character` 的ctc参数。

.. var:: config.nvl_page_ctc_position = "nestled"

    若非None，这是用于NVL模式角色的“点击继续”提示坐标，当到底页面底部时出现。(也就是后面跟一个“nvl clear”语句)。这项代替了 :func:`Character` 的ctc_position参数。

.. var:: config.nvl_paged_rollback = False

    若为True，NVL模式回滚时一次处理一整个页面。

.. _python-functions:

Python 函数
----------------

.. function:: nvl_clear()

  等效于 ``nvl clear`` 语句。

.. function:: nvl_hide(with_)

  等效于 ``nvl hide`` 语句。

  `with_`
    隐藏NVL模式窗口使用的转场(transition)。

.. function:: nvl_menu(items)

  使用NVL样式显示窗口的Python函数。很少直接使用。通常用于声明菜单变量，像这样：

  ::

      define menu = nvl_menu

.. function:: nvl_show(with_)

  等效于 ``nvl show`` 语句。

  `with_`
    显示NVL模式窗口使用的转场(transition)。

.. _paged-rollback:

Paged Rollback
--------------

页面回滚操作会让Ren'Py一次回滚NVL模式的一个页面，而不是一次一个文本段落。在脚本中如下配置就能启用。

::

    init python:
        config.nvl_paged_rollback = True

.. _script-of-the-question-nvl-mode-edition:

“The Question”的脚本(NVL模式版本)
-----------------------------------------

你可以在
:ref:`这里 <thequestion_nvl>` 查看MVL模式版本的“The Question”。
