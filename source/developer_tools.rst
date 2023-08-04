.. _developer-tools:

开发者工具
===============

Ren'Py包含一些功能，可以让开发工作变得更容易。其中很多功能需要配置项 :var:`config.developer` 设置为True才能执行。

.. _lint:

Lint
----

Lint工具(可从启动器中使用)可以检查游戏中的潜在错误和待优化项，并向开发组提供相关建议。
有些问题在当前平台不会出现，但可能会影响其他平台的使用者，所以还是推荐尽可能修复所有错误。

Lint工具包含游戏的很多有用信息和状态。

注意，通过了Lint的检查并不等于执行了完整的测试流程。

.. _console:
.. _shift-o-console:

Shift+O 控制台
---------------

调试控制台(debug console)可以在交互模式下运行Ren'Py脚本和Python语句，而且能立刻看到运行结果。控制台可以在开发者模式下，或者当 :var:`config.console` 为True时运行。组合键“shift+O”能打开控制台。

控制台可以用于：

* 跳转到某个脚本标签(label)。
* 在交互模式下尝试运行Ren'Py脚本语句。
* 运算某个Python表达式或语句并查看结果。
* 在游戏过程中追踪Python表达式。

主要命令如下：
* clear：清除控制台历史记录
* escape：启用转义 Unicode 字符串中的 Unicode 符号。
* exit：退出控制台
* help：显示此帮助信息
* jump <标签>：跳转到此标签
* load <档位>：读取该档位的存档
* long：在控制台中打印出对象的完整表征。
* reload：重新加载游戏，并刷新脚本
* save <档位>：存储存档到该档位
* short：在控制台中缩短对象的表征（默认）。
* stack：打印返回栈
* unescape：禁止转义 Unicode 字符串中的 Unicode 符号，并按原样打印（默认）。
* unwatch <表达式>：停止监视该表达式
* unwatchall：停止监视所有表达式
* watch <表达式>：监视该 python 表达式
* watch short：简短表征所跟踪的表达式（默认）
* watch long：按原样表征所跟踪的表达式
* <renpy 脚本语句>：运行此语句
* <python 表达式或语句>：运行此表达式或语句

(译者注：以上命令的内容源自SDK中的 launcher/game/tl/schinese/developer.rpy 文件，为zedraxlo在github上提交的翻译。
部分名词可能与文档其他部分有出入。)

.. _shift-e-editor-support:

Shift+E Editor 帮助与支持
-----------------------------

shift+E会打开默认的文本编辑器，在启动器中可以使用 :doc:`editor` 进行定制。
之后会打开脚本文件并跳转到当前语句对应的那行。

详见 :doc:`集成文本编辑器 <editor>` 。

.. _shift-d-developer-menu:

Shift+D 开发者菜单
----------------------

当 :var:`config.developer` 为True时，使用组合键“shift+D”会显示开发者菜单，并提供下面那些功能的简易接入。

.. _shift-r-reloading:

Shift+R 重新加载脚本
----------------------

当 :var:`config.developer` 为True时，使用组合键“shift+R”会保存当前游戏，重新加载游戏脚本，并重新加载游戏。这个操作通常会回到你使用“shift+R”之前未修改过的最近那条语句。

第一次使用重新加载功能后，游戏会进入自动重新加载模式。
游戏中使用的任何文件发生改变都会重新加载游戏。

这个功能允许开发者使用外部编辑器修改脚本后，不需要退出并重启Ren'Py就能看到修改后的效果。

需要注意的是游戏状态，包含了变量值和场景列表重载后会被重置。这意味着某些语句的执行结果可能也发生了变化，需要回滚并重新执行那些语句才能看到修改后的效果。

回放(replay)状态下使用shift+R不会生效。

下列函数使用纯Python实现。注意，这些函数只能在开发者模式下使用。

.. function:: renpy.get_autoreload()

    获取自动加载标识。

.. function:: renpy.reload_script()

    使Ren'Py保存游戏，重新加载脚本，然后读档。

    该函数只能在开发模式下调用，只支持Windows、macOS和Linux系统。

.. function:: renpy.set_autoreload(autoreload)

    设置自动重新加载标识，该标识决定是否在文件改变后自动重新加载游戏。
    在使用 :func:`renpy.reload_script` 重新加载脚本后，自动重新加载标识符才会变成启用状态。(译者注：如果脚本报错是不会启用自动加载的。)

.. _shift-i-style-inspecting:

Shift+I 样式检查
------------------------

当 :var:`config.developer` 为True，使用组合键“shift+I”能触发样式检查。样式检查中会显示鼠标指针下面的可视组件列表。并显示每一个可视组件的类型、样式和渲染尺寸。

点击样式名称会显示使用该样式的特性以及对应的可视组件。

.. _fast-skipping:

> Fast Skipping
---------------

当 :var:`config.developer` 或 :var:`config.fast_skipping` 为True时，使用“快速跳过”快捷键(默认是“>”)，将触发游戏立刻跳到下一个重要互动。出于这种需求，重要互动不由say语句、转场(transition)和暂停(pause)命令触发的。通常情况下，快速跳过会直接跳到下一个菜单选项，但也会在用户自定义的互动行为前停止。

.. _warping_to_a_line:

传送至某行
------------------

Ren'Py支持脚本中“传送(warp)至某行”功能，不需要开发者运行整个脚本到达那处。尽管使用传送技巧总是会伴随着一大堆告警(warning)信息，在提供实时预览方面依然很常用。

调用传送功能时，使用命令行运行Ren'Py，使用参数 ``--warp`` ，后面再跟上filename:line，这样就能传送到需要的那行。举例： ::

    renpy.exe my_project --warp script.rpy:458

(*my_project* 是工程基础目录的全路径。)

调用传送功能时，Ren'Py出列了一系列工作。它首先找到程序中的所有scene语句，然后尝试找到使用scene语句到达脚本中每条语句的路径，接着选取最接近目标行的路径(在目标行前或正好到达目标行)。Ren'Py从找到的语句倒推至某个scene语句，记录下使用的路径。然后Ren'Py会执行找到的路径上所有scene和show、hide语句。最后Ren'Py将主控流程切换到目标语句。

关于传送功能，有几条重要事项需要说明。第一条是，传送时只能检查单一路径，这意味着这条路径是实际执行路径之一，在其他路径上可能还是存在bug。总体来说，这条路径不考虑游戏逻辑，所以它也可能是一条实际上并不存在的路径。(对于重流程的游戏，这的确是个大问题，特别是包含大量Python语句的情况。)

然而，最大的问题是，在传送的目标语句前的Python语句不会执行。这表示所有变量都是未经初始化的，使用时可能直接让程序挂掉。为了防止这个问题，创作者可以定义一个脚本标签(label) ``after_warp`` ，写一些只有传送后才会执行的语句。这个脚本标签可以在程序中配置变量，并在预览中返回。

传送功能需要 :var:`config.developer` 设置为True。

.. _debug-functions:

调试函数
---------

.. function:: renpy.get_filename_line()

    返回当前语句的文件名和行号的二元元组。

.. function:: renpy.log(msg)

    若 :func:`config.log` 没有配置，则不执行任何操作。否则，将打开日志文件(如果还没有打开的话)，根据 :var:`config.log_width` 配置的宽度将信息格式化，并打印在日志文件上。

.. function:: renpy.unwatch(expr)

    停止监视(watch)指定的Python表达式。

.. function:: renpy.warp_to_line(warp_spec)

    该函数使用一个“文件名:行号”的键值对，然后尝试跳转到对应行号的语句。

    该函数的效果与 `--warp` 命令相同。

.. function:: renpy.watch(expr)

    监视(watch)指定的Python表达式，信息显示在屏幕的右上角。
