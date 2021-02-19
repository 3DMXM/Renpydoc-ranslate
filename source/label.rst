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

一个label语句可能只跟某一个语句块(block)关联。在那种情况下，主控流程遇到label语句就会进入关联语句块(block)，并顺序执行之后的语句。

总共有两种脚本标签(label)：*global* 和 *local* 。global标签在所有项目文件中都生效，所以每个游戏中都不能重复定义。local标签在逻辑上比global标签有效范围小，仅限于声明local标签的文件。需要声明一个local标签的话，在标签名前缀一个英文句号“.”即可。例如： ::

    label global_label:
        "这是在一个global脚本标签里。"
    label .local_name:
        ".这里属于local脚本标签。"
        jump .local_name

local脚本标签可以在global脚本标签中定义，并被被直接引用，引用时使用该local标签的完整名。一个关于global标签和local标签的例子如下： ::

    label another_global:
        "现在让我们跳转进入其他地方的local脚本标签。"
        jump global_label.local_name

lable语句可以带一些可选参数。这些参数的处理在PEP 3102中有详细说明，这里仅说两种例外:

* 语句被调用时，这些参数会被赋予默认值。
* 变量是可以动态变化的，而不是仅限于语法中的定义。

.. _jump-statement:

jump语句
--------------

jump语句用于将主控流程转入给定的脚本标签(label)处。

若出现了 ``expression`` (表达式)关键词，关键词后面的表达式将被赋值，而被计算后的对应字符串则会被用作跳转目标的标签语句。若未出现 ``expression`` (表达式)关键词，跳转目标的标签名字就必须精确指定。

与call语句不同，jump语句不会将下一个语句放入栈(stack)中。因此，执行完跳转标签对应的语句块之后，主控流程不会回到跳转前的脚本位置。 ::

    label loop_start:

        e "哦，不！看起来我们陷入了一个无限循环之中。"

        jump loop_start

.. _call-statement:

call语句
--------------

call语句用于将主控流程转入给定的脚本标签(label)处。call语句会将下一条语句压入到调用栈(stack)中，并允许主控流程在执行完这次调用后，回到调用发生的脚本位置。

若出现了 ``expression`` (表达式)关键词，关键词后面的表达式将被赋值，而被计算后的对应字符串则会被用作跳转目标的标签语句。若未出现 ``expression`` (表达式)关键词，跳转目标的标签名字就必须精确指定。

If the optional ``from`` clause is present, it has the effect of including a label
statement with the given name as the statement immediately following the call
statement. An explicit label helps to ensure that saved games with return
stacks can return to the proper place when loaded on a changed script.
``from`` 分句是可选的，在label语句后面直接添加入参名和值，并直接在该label下直接使用。一个命名直白的标签(lable)有助于我们能利用栈(stack)回到脚本里合适的地方，就算加载的是修改过的脚本。 ::

    e "首先，我们调用一个子程序(subroutine)。"

    call subroutine

    call subroutine(2)

    call expression "sub" + "routine" pass (count=3)

    # ...

    label subroutine(count=1):

        e "我来过这里 [count] 次了。"
        e "接着，我们会返回到子程序(subroutine)。"

        return

call语句可以带入参的情况，在PEP 3102中有详细说明。

当我们使用一个带入参列表的调用表达式时，必须在表达式和入参列表之间插入关键词 ``pass`` 。否则，入参列表会被当作表达式的一部分，而不是call语句的一部分。

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

.. _labels-control-flow-functions:

脚本标签(label)和主控流程函数
-------------------------------

.. function:: renpy.call_in_new_context(label, *args, **kwargs)

  该函数创建一个新的上下文(context)，并从这个上下文(context)中给定的脚本标签(label)处开始执行Ren'Py脚本。新的上下文(context)中禁用了回滚功能，并且存档/读档会发生在顶层的上下文(context)中。

  使用该函数可以在原有交互中启动第二层交互。

.. function:: renpy.get_all_labels()

  返回程序中定义所有标签(lable)的集合，包括在库(library)中定义为仅限内部引用的标签。

.. function:: renpy.get_return_stack()

  返回一个当前返回(return)栈(stack)的列表。返回栈是一个语句名组成的列表。

  该语句名应是字符串(针对标签)，或者非空元组(针对非标签型语句)。

.. function:: renpy.has_label(name)

  若参数name是一个程序内的合法脚本标签(label)就返回True，否则返回False。

  **name**
    name应该是一个用于字符串，用于检查某个脚本标签(label)是否存在。name也可以是一个非空元组，元组给定了非标签型语句名。

.. function:: renpy.invoke_in_new_context(callable, *args, **kwargs)

  该函数创建了一个新的上下文(context)，并在上下文(context)中显示调用了给定的python可调用内容(通常是函数)。当函数返回了值或者抛出异常时，主控流程会返回到原来的上下文(context)。当我们在同一个句柄(handle)中向玩家展示一些信息(比如确认提示)，就可以调用这个函数。

  某个上下文(context)包含显示(包括界面和图片)和音频系统的状态。当上下文(context)返回时，显示和音频状态都会被存储起来。

  附加参数和关键词参数会被传入可调用的(函数)。

  使用这个函数创建的上下文(context)无法执行Ren'Py脚本。会改变Ren'Py脚本流程的函数，比如renpy.jump()，只能在外层上下文(context)下被处理。如果你想要调用的是Ren'Py脚本而不是python函数，就应该使用renpy.call_in_new_context()函数。

.. function:: renpy.jump_out_of_context(label)

  调用该函数会引起主控流程离开当前上下文(context)，并转换到父上下文(context)中指定的脚本标签(label)处。

.. function:: renpy.seen_label(label)

  在当前用户系统内，名为label的标签语句至少被执行了一次，则返回True，否则返回False。该概述常用于解锁场景画廊(gallery)等。

.. function:: renpy.set_return_stack(stack)

  设置当前返回(return)栈(stack)。返回栈是一个语句名组成的列表。

  语句名可能是字符串(针对标签)或者非空元组(针对非标签语句)。
