.. _labels-control-flow:

脚本标签(label)和主控流程
==========================

.. _label-statement:

label语句
---------------

label语句允许使用自定义的标签名声明一个程序点位。这些标签仅仅用来被调用或者跳转，可以使用在Ren'Py脚本、python函数及各类界面中。 ::

    label sample1:
        "这是一个'sample1'脚本标签。"

    label sample2(a="default"):
        "这是一个'sample2'脚本标签。"
        "a = [a]"

一个label语句可能只跟某一个语句块(block)关联。
这种情况下，主控流程遇到label语句就会进入语句块，并顺序执行之后的语句，直到运行到结尾：
下面的样例代码，在跳转到“origin”标签之后，会依次产生“a、b、c”。

::

    label origin:
    "a"
    label hasblock:
        "b"
    "c"
    return

总共有两种脚本标签(label)：*global* 和 *local* 。global标签存储在global命名空间中，整个项目中应该具有唯一性。
local标签可以同名，但需要与不同的global标签做关联。
需要声明一个local标签的话，在标签名前缀一个英文句号“.”即可。例如：

::

    label global_label:
        "这在一个global脚本标签里。"
    label .local_label:
        ".这里属于local脚本标签。"
        jump .another_local
    label .another_local:
        "另一个local脚本标签"
        jump .local_label

local脚本标签在关联的global标签内部可以直接引用。其他地方则需要使用标签全名，由关联的globle标签和local标签组成。
一个关于global标签和local标签的例子如下：

::

    label another_global:
        "现在让我们跳转进入其他地方的local脚本标签。"
        jump global_label.local_name

lable语句可以带一些可选参数。这些参数的处理机制在 :pep:`570` 中有详细说明，这里仅说两种例外:

第一，默认参数的值会在调用时才进行计算。

第二，变量具有动态声明周期。某个变量从标签参数获取值后，若出现return语句则会恢复原值。
使用某个变量指定语句后，该变量可能会也可能不会从标签参数获取值，具体取决于脚本中的语句。
这与纯Python代码不同。

::

    default a = 3

    label start:
        menu:
            "调用":
                call label_with_params(5)
            "跳转":
                jump label_without_params
        jump start

    label label_with_params(a):
    label label_without_params:
        e "a = [a]" # 显示5还是3，取决于通过何种路径执行到这里
        return

仅仅通过jump语句还是从上一条语句顺序执行这点信息，往往并不能完全判断出标签中变量的值。
对于标签变量的样例，请参考 :ref:`call语句 <call-statement>`。

如果某个变量具有动态生命周期，它的值会持续到其所属的label标签中出现一个return语句为止。
尝试使用jump或previous语句传递该变量的值都是不明智的。
带有参数的label样例，详见 :ref:`call语句 <call-statement>` 。

.. _jump-statement:

jump语句
--------------

jump语句用于将主控流程转入指定的脚本标签(label)处。

若出现了 ``expression`` (表达式)关键词，关键词后面的表达式将被赋值，而被计算后的对应字符串则会被用作跳转目标的标签语句。若未出现 ``expression`` (表达式)关键词，跳转目标的标签名字就必须精确指定。

与call语句不同，jump语句不会将下一个语句放入栈(stack)中。因此，执行完跳转标签对应的语句块之后，主控流程不会回到跳转前的脚本位置。 ::

    label loop_start:

        e "哦，不！看起来我们陷入了一个无限循环之中。"

        jump loop_start

.. _call-statement:

call语句
--------------

call语句用于将主控流程转入给定的脚本标签(label)处。call语句会将下一条语句压入到调用栈(stack)中，并允许主控流程在执行完这次调用后，回到调用发生的脚本位置。

若出现了 ``expression`` 关键词，将计算关键词后面的表达式，而计算得到的字符串则会被用作跳转目标的标签语句。若未出现 ``expression`` 关键词，跳转目标的标签名字就必须显式指定。

``from`` 分句是可选的，在label语句后面直接添加入参名和值，并直接在该label下直接使用。一个命名直白的标签(lable)有助于我们能利用栈(stack)回到脚本里合适的地方，就算加载的是修改过的脚本。 

call语句可以使用参数，详见 :pep:`448`。

当我们使用一个带入参列表的调用表达式时，必须在表达式和入参列表之间插入关键词 ``pass`` 。
否则，入参列表会被当作表达式的一部分，而不是call语句的一部分。

::

    label start:

        e "首先，我们调用一个支线。"

        call subroutine

        call subroutine(2)

        call expression "sub" + "routine" pass (count=3)

        return

    label subroutine(count=1):

        e "我来过这里 [count] 次了。"
        e "接着，我们会从支线返回。"

        return

.. warning::

    每条 ``call`` 语句后面都不加上 ``from`` 从句就发布游戏是危险的。当然也可以通过发布更新补丁解决。
    在没有 ``from`` 从句的情况下，编辑 ``call`` 相关的脚本，可能会有存档损坏的风险。

    构建发行版时，将选项“向call语句添加from从句”勾选上就能解决以上问题。

.. _return-statement:

return语句
----------------

return语句会在调用栈中弹出最顶层的那条语句，并将主控流程转到那条语句。若调用栈为空，返回语句将重启Ren'Py，将主控流程切换至主菜单。

若返回语句带有可选项表达式，表达式会被计算求值，并且结果会被存储在_return变量中。_return变量依赖于各种场景动态变化。

.. _special-labels:

特殊脚本标签(label)
--------------------

以下脚本标签(label)会在Ren'Py中使用：

``start``
    默认情况下，Ren'Py在游戏启动后会跳转至这个标签。

``quit``
    若该标签存在，当用户退出游戏时该标签内容会被调用。

``after_load``
    若该标签存在，当游戏读档后会调用这个标签内容。其可能被用于游戏内容更新后的数据修复。
    如果数据从此标签后发生变化，应该调用 :func:`renpy.block_rollback` 函数防止用户从该存档点回滚。

``splashscreen``
    若该标签存在，游戏首次运行时，在主菜单出现前，该标签内容会被调用。
    详见 :ref:`添加启动画面 <adding-a-splashscreen>` 。

``before_main_menu``
    若该标签存在，在主菜单出现前，该标签内容会被调用。在少数情况下，其用来设置主菜单，例如背景播放一段影片。

``main_menu``
    若该标签存在，标签内容会被调用，用来替代默认的主菜单。若其内容中包含return语句，Ren'Py将从start标签处开始游戏。例如，下面这段脚本在不显示主菜单的情况下开始游戏。 ::

        label main_menu:
            return

``after_warp``
    若该标签存在，则调用warp语句时，此标签至传送(warp)点前的语句都将被执行。详见 :ref:`传送至某行 <warping_to_a_line>`

``hide_windows``
    若该标签存在，当玩家使用鼠标右键或键盘H键隐藏对话窗口时，将调用此标签。
    若标签返回值为True，隐藏对话窗口行为将取消(依然当作隐藏已经发生)。否则，继续隐藏对话窗口。

Ren'Py also uses the following labels to show some of the :doc:`special screens <screen_special>`:
Ren'Py还是用下列标签显示某些 :doc:`特殊界面 <screen_special>` ：

* ``main_menu_screen``
* ``load_screen``
* ``save_screen``
* ``preferences_screen``
* ``joystick_preferences_screen``

.. _labels-control-flow-functions:

脚本标签(label)和主控流程函数
-------------------------------

.. function:: renpy.call_stack_depth()

    返回当前上下文(context)中调用栈的深度——即调用栈中还没有返回或弹出(pop)的call语句数量。

.. function:: dynamic(*variables, **kwargs)

    该函数可以将若干个变量名作为入参，并根据当前调用动态调整这些变量。当调用返回后，变量的值会恢复为该函数调用之前的值。

    :ref:`命名存储空间 <named-stores>` 中的变量都可以支持。

    如果变量以关键字入参形式传入，入参的值等于其关联的变量名对应的值。

    调用样例如下：
    
    ::

        $ renpy.dynamic("x", "y", "z")
        $ renpy.dynamic("mystore.serial_number")
        $ renpy.dynamic(players=2, score=0)

.. function:: renpy.get_all_labels()

    返回程序中定义所有标签(lable)的集合，包括在库(library)中定义为仅限内部引用的标签。

.. function:: renpy.get_return_stack()

    返回一个当前返回(return)栈(stack)的列表。返回栈是一个语句名组成的列表。

    该语句名应是字符串(针对标签)，或者非空元组(针对非标签型语句)。

.. function:: renpy.has_label(name)

    若参数name是一个程序内的合法脚本标签(label)就返回True，否则返回False。

    **name**
        name应该是一个字符串，用于检查某个脚本标签(label)是否存在。name也可以是一个非空元组，给定非标签型语句名。

.. function:: renpy.mark_label_seen(label)

    在当前用户系统内，将名为label的标签语句设置为已执行过。

.. function:: renpy.mark_label_unseen(label)

    在当前用户系统内，将名为label的标签语句设置为未执行过。

.. function:: renpy.pop_call()

    从调用栈顶部弹出(pop)当前call，但不返回到对应call的位置。
    该函数与Ren'Py的return语句一样，都会恢复 :func:`dynamic <renpy.dynamic>` 函数用到的参数。

    当确信某个脚本标签(label)不会返回到其调用点时，可以使用此函数。

.. function:: renpy.seen_label(label)

    在当前用户系统内，名为label的标签语句至少被执行了一次，则返回True，否则返回False。该概述常用于解锁场景画廊(gallery)等。

.. function:: renpy.set_return_stack(stack)

    设置当前返回(return)栈(stack)。返回栈是一个语句名组成的列表。

    语句名可能是字符串(针对标签)或者非空元组(针对非标签语句)。

    常用方法为：

    ::

        renpy.set_return_stack([])

    可以清空返回栈。

.. _context:

上下文
--------

上下文(context)是Ren'Py用于管理游戏中可以修改并且可以存档的各种状态值，具体包括：

* 当前Ren'Py运行状态
* 调用栈，已经上面提到的 :func:`renpy.dynamic` 使用的各种动态变量名和变量值。
* 当前显示的所有图像信息(包括图像属性和用到的各种变换等)
* 当前显示的界面和界面中的各种变量
* 正在播放或在播放队列中的音频

大多数时候游戏中仅有一个上下文，上下文中的各项也仅存在一个实例。
进入主菜单或游戏内菜单时，上下文中的各项可能会改变，但在离开菜单后各项会恢复。
其中一些改变是自动处理的，比如screen图层在上下文内容变化时会清空。

使用 :ref:`replay` 功能和 :func:`隐藏UI <HideInterface>` 函数时，Ren'Py会创建新的上下文。

:ref:`界面语言 <screens>` 的创立，很大程度上就是为了减少频繁创建上下文。

仅在基本上下文(即仅有一个上下文时的那个)中才能使用回滚(rollback)。也只有基本上下文才可以存档，这是游戏菜单会用到上下文。

.. function:: renpy.call_in_new_context(label, *args, **kwargs)

    该函数创建一个新的上下文(context)，并从这个上下文(context)中给定的脚本标签(label)处开始执行Ren'Py脚本。新的上下文(context)中禁用了回滚功能，并且存档/读档会发生在顶层的上下文(context)中。

    使用该函数可以在原有交互中启动第二层交互。

.. function:: renpy.context()

    返回一个唯一对象，指向当前上下文。进入某个新的上下文时，该对象也将被赋值为新的上下文。但对该对象的修改不会影响其指向的原上下文内容。

    该对象可以存档，并参与回滚操作。

.. function:: context_dynamic(*variables)

    该函数可以将若干个变量名作为入参，并根据当前上下文调整这些变量。当返回前一个上下文后，变量的值会恢复为该函数调用之前的值。

    :ref:`命名存储空间 <named-stores>` 中的变量都可以支持。

    调用样例如下：

    ::

        $ renpy.context_dynamic("x", "y", "z")
        $ renpy.context_dynamic("mystore.serial_number")

.. function:: renpy.context_nesting_level()

    返回当前上下文的嵌套层级(nesting level)。
    最外层的上下文的层级为0(该层上下文可以存档、读档和回滚)。其他上下文的嵌套曾经都不是0，比如菜单和回放的上下文。

.. function:: renpy.invoke_in_new_context(callable, *args, **kwargs)

    该函数创建了一个新的上下文(context)，并在上下文(context)中显示调用时指定的python可调用内容(通常是函数)。当函数返回值或者抛出异常时，主控流程会返回到原来的上下文(context)。当我们在同一个句柄(handle)中向玩家展示一些信息(比如确认提示)，就可以调用这个函数。

    其他额外入参都将传给callable处理。

    该函数创建的上下文无法执行Ren'Py脚本。能改变Ren'Py脚本执行流程的函数，比如 :func:`renpy.jump`都会由外层的上下文处理。
    如果想要调用Ren'Py脚本而不是Python函数，需要改用 :func:`renpy.call_in_new_context`.

.. function:: renpy.jump_out_of_context(label)

    调用该函数会使主控流程离开当前上下文(context)，并转换到父层上下文(context)中指定的脚本标签(label)处。

.. function:: renpy.reset_all_contexts()

    该函数会上下文栈中的所有元素都弹出(pop off)，恢复所有动态变量的值。完成以上内容后，再创建一个新的上下文。
    当前语句结束，游戏从下一条语句继续执行。遇到异常的数据或起始点时，这样做能将Ren'Py设置为初始状态。

    该函数可用于重置游戏内的一切——包括显示的图像、播放的音乐等，就像游戏刚开始运行。

    由于该函数会重置Ren'Py，当前语句会立刻结束。

    该函数设计用在after_load脚本标签后面，可以将游戏的状态数据重置为初始值。接着游戏可以重新绘制场景、播放音乐等，最后跳转到目标脚本标签并继续。


