.. _saving-loading-and-rollback:

=============================
存档、读档和回滚
=============================

Ren'Py支持保存游戏状态、载入游戏状态和回滚到之前的某个游戏状态。尽管实现的方式明显不同，回滚(rollback)可以认为每一条能与用户互动的语句开始时都保存了游戏状态，当用户进行回滚时加载之前保存的状态。

.. note::

  我们通常需要保证不同release版本存档的兼容性，但兼容性并不能得到绝对保证。如果能带来巨大的游戏表现提升，我们也可以打破存档兼容性的要求。

.. _what-is-saved:

保存了什么
=============

Ren'Py会保存游戏状态。保存的内容包括内部状态和Python的状态。

内部状态由几个部分组成：Ren'Py在游戏启动后就改变的所有内容，以及下列内容：

* 当前语句和所有主控流程可能返回到的语句。
* 正在显示的图像和可视组件。
* 正在显示的界面，以及界面内所有的变量值。
* Ren'Py正在播放的音乐。
* NVL模式文本块(block)列表。

Python状态包括从游戏启动后存储区变化过的所有变量，以及跟那些变量有关的所有对象。注意，只有变量相关才行——改变对象内的字段(field)并不会触发对象状态被保存。

使用 :ref:`default语句 <default-statement>` 定义的变量总是会保存。

在下例中：

::

    define a = 1
    define o = object()
    default c = 17

    label start:
         $ b = 1
         $ o.value = 42

只有 `b` 和 `c` 会被保存。 a 不会被保存，因为它从游戏启动后就没有变动。 `o` 不会被保存因为它也没有变动——这里的变动是指引用对象发生变化，而不是对象成员变量的值的变化。

.. _what-isnt-save:

不保存什么
================

游戏开始后没有改变过的Python变量不会保存。
这可能是个重大的问题，前提是某个保存的变量引用了相同的对象。(对象的别名(alias)。)在这个例子中：

::

    init python:
        a = object()
        a.f = 1

    label start:
        $ b = a
        $ b.f = 2

        "a.f=[a.f] b.f=[b.f]"

`b` 是 `a` 的别名。保存和加载可能打断这个别名关系，导致
`a` 和 `b` 引用不同的对象。因为这个问题让人十分头大，所以最好的办法就是避免在保存和不保存的变量间建立别名关系。(很少直接遇到这种情况，往往发生在不保存的变量和保存的字段(field)别名上。)

还有几种其他类型的状态不保存。

control flow path
    Ren'Py值保存当前语句，以及该语句需要返回的对应语句。Ren'Py不记得如何抵达当前语句。关键是，被添加到游戏的语句(包括变量声明)不会运行。

mappings of image names to displayables
    因为这个映射关系不会保存，游戏加载后图像可能变成了一个新的图像。随着游戏的进度，允许某个图像变为使用一个新的文件。

configuration variables, styles, and style properties
    配置项变量和样式不会作为游戏的一部分保存。所以它们应该只在初始化语句块(init block)中改变，游戏启动后就不再改变。

.. _where-ren-py-saves:

Ren'Py保存在哪里
==================

保存发生在外沿(outermost)互动上下文(context)中，Ren'Py语句的开头。

这里关注的重点是，保存发生在语句的 **开头** 。如果加载或回滚发生在某个语句中间，而且那个语句有多次互动，所有状态都会重置为语句开始的状态。

在使用Python定义的语句中，这可能会导致问题。在下面的语句：

::

    python:

         i = 0

         while i < 10:

              i += 1

              narrator("现在的计数是 [i] 。")

如果用户在中间保存和加载，循环会从头开始。使用Ren'Py脚本——而不是直接用Python语句——的循环就能避免这个问题：

::

   $ i = 0

   while i < 10:

        $ i += 1

        "The count is now [i]."

.. _what-ren-py-can-save:

Ren'Py能保存什么
====================

Ren'Py使用Python的pickle系统保存游戏状态。这个模块可以保存：

* 基本数据类型，比如True、False、None、整型(int)、字符型(str)、浮点型(float)、复杂字符(complex str)和unicode对象。
* 复合类型，比如列表(list)、元组(tuple)、集合(set)和字典(dict)。
* 创作者定义的对象(object)、类(class)、函数(function)、方法(methed)和绑定方法(bound method)。成功pickle后，它们可以使用原来的名称维持功能。
* 角色(character)、可视组件(displayable)、变换(transform)和转场(transition)对象。

.. _cant-save:

Ren'Py不能保存什么
===================

还有几种无法pickle的数据类型：

* 渲染(render)对象
* 迭代器(iterator)对象。
* 生成器(generator)对象。
* 协程任务和future线程，比如使用 ``async`` 和 ``await`` 创建的对象。
* 类文件(file-like)对象。
* 网络socket端口，及依附于端口的对象。
* 内部函数和lambda。

以下是一个不完整的清单。

无法使用pickle处理的对象依然可以使用，只是无法在Ren'Py存储而已，
但可以在存储命名空间的某些用法中存储(比如初始化变量值，存储空间内的函数，或 ``python hide`` 语句块)。

例如，像这样使用一个文件对象：

::

    $ monika_file = open(config.gamedir + "/monika.chr", "w")
    $ monika_file.write("不要删除。\r\n")
    $ monika_file.close()

是不能正常生效的，因为 ``f`` 会在3条Python语句中存储。
需要放在 ``python hide`` 语句块中才可以：

::

    python hide:

        monika_file = open(config.gamedir + "/monika.chr", "w")
        monika_file.write("不要删除。\r\n")
        monika_file.close()
 
(当然，使用Python中的 ``with`` 语句更简洁)：

::

    python hide:

        with open(config.gamedir + "/monika.chr", "w") as monika_file:
            monika_file.write("不要删除。\r\n")

使用 ``async``、``await`` 或 ``asyncio`` 开启的协程类似，这样处理：

::

    init python:

        import asyncio

        async def sleep_func():
            await asyncio.sleep(1)
            await asyncio.sleep(1)

接着直接使用：

::

    $ sleep_task = sleep_func()
    $ asyncio.run(sleep_task)

会产生问题，因为 `sleep_task` 无法保存。但如果不把定义的异步函数与变量做关联的话：

::

    $ asyncio.run(sleep_func())

反而可以正常运行。

.. _save-functions-and-variables:

保存函数和变量
============================

有一个变量用于高级保存系统：

.. var:: save_name = ...

    这是一个字符串，每次保存时都会存储。它可以用作存档名称，帮助用户区分不同存档。

    更多存档文件的定制化可以使用Json数据系统，详见 :var:`config.save_json_callbacks` .

在 :ref:`界面行为 <screen-actions>` 中定义了一些高级别的保存行为和函数。除此之外，还有一些低级别的保存和加载行为。

.. function:: renpy.can_load(filename, test=False)

    如果 *filename* 作为存档槽已存在则返回True，否则返回False。

.. function:: renpy.copy_save(old, new)

    将存档 *old* 复制到存档 *new* 。(如果 *old* 不存在则不做任何事。)

.. function:: renpy.list_saved_games(regexp='.', fast=False)

    列出保存的游戏。每一个保存的游戏返回的一个元组中包含：

    - 保存的文件名。
    - 传入的extra_info。
    - 一个可视组件，保存的截屏。
    - 游戏时间戳，UNIX时代开始计算的秒数。

    `regexp`
        在列表中过滤文件名的正则表达式。

    `fast`
        若为True，返回文件名而不是元组。

.. function:: renpy.list_slots(regexp=None)

    返回一个非空存档槽的列表。如果 *regexp* 存在，只返回开头为 *regexp* 的槽位。列表内的槽位按照字符串排序(string-order)。

.. function:: renpy.load(filename)

    从存档槽 *filename* 加载游戏状态。如果文件加载成功，这个函数不会返回。

.. function:: renpy.newest_slot(regexp=None)

    返回最新(具有最近修改时间)存档槽的名称，如果没有(匹配的)存档则返回None。

    如果 *regexp* 存在，只返回开头为 *regexp* 的槽位。

.. function:: renpy.rename_save(old, new)

    将某个名为 *old* 的存档重命名为 *new* 。(如果 *old* 不存在则不做任何事。)

.. function:: renpy.save(filename, extra_info='')

    将游戏状态保存至某个存档槽。

    `filename`
        一个表示存档槽名称的字符串。
        这是个变量名，不要求与存档文件名严格对应。

    `extra_info`
        会保存在存档文件中的一个额外字符串。通常就是 :func:`save_name` 的值。

    :func:`renpy.take_screenshot()` 应该在这个函数之前被调用。

.. function:: renpy.slot_json(slotname)

    返回 *slotname* 的json信息，如果对应的槽位为空则返回None。

.. function:: renpy.slot_mtime(slotname)

    返回 *slotname* 的修改时间，如果对应的槽位为空则返回None。

.. function:: renpy.slot_screenshot(slotname)

    返回 *slotname* 使用的截屏，如果对应的槽位为空则返回None。

.. function:: renpy.take_screenshot(scale=None, background=False)

    执行截屏。截屏图像会被作为存档的一部分保存。

.. function:: renpy.unlink_save(filename)

    删除指定名称的存档。

.. _retaining-data-after-load:

读取存档后保持数据
=========================

当游戏加载后，游戏状态会被重置(使用下面会提到的回滚系统)为当前语句开始执行的状态。

在某些情况下，这是不希望发生的。例如，当某个界面允许编辑某个值时，我们可能想要游戏加载后维持那个值。调用 :func:`renpy.retain_after_load` 后，当游戏在下一个带检查点(checkpoint)的交互结束前，进行保存和加载行为都会保持不变。

注意，当数据没有被改变，主控流程会被重置为当前语句的开头。这条语句将再次执行，语句开头则使用新的数据。

举例：

::

    screen edit_value:
        hbox:
            text "[value]"
            textbutton "+" action SetVariable("value", value + 1)
            textbutton "-" action SetVariable("value", value - 1)
            textbutton "+" action Return(True)

    label start:
        $ value = 0
        $ renpy.retain_after_load()
        call screen edit_value

.. function:: renpy.retain_after_load()

  在当前语句和包含下一个检查点(checkpoint)的语句之间发生加载(load)时，保持数据。

.. _rollback:

回滚
========

回滚(rollback)允许用户将游戏恢复到之前的状态，类似流行应用程序中的“撤销/重做”系统。在回滚事件中，系统需要重点维护可视化和游戏变量，所以在创作游戏时有几点需要考虑。

.. _what-data-is-rolled-back:

什么数据会回滚
===============

回滚操作的作用范围包括，初始化阶段之后还可以改变的变量，以及通过那些变量访问的可恢复的对象。
粗略来说，就是在Ren'Py脚本中定义并创建的类的实例，比如列表、字典和集合。
在Python和Ren'Py中内部创建的数据通常都是不可恢复的。

进一步来看，在Ren'Py脚本运行时，脚本内部的Python存储区中对象，包括列表、字典和集合类型都会替换为可恢复的类型。
从以上类派生的类型也是可恢复的。:class:`renpy.Displayable` 派生的类也是可恢复的类。

为了使可恢复的对象使用起来更便利，Ren'Py会对脚本中找到的Python语句做如下修改：

* 原生的列表、字典和集合会自动转为可恢复的等效对象。
* 包含在其他语句中的列表、字典和集合也会自动转为可恢复的等效对象。
* 其他Python语法中，类似解包之类的操作，会创建列表、字典和集合的部分也会转为可恢复的等效对象。
  但是，函数和方法中带两个星号的入参(即根据额外关键词入参创建字典)并不会转为可恢复的对象。
* 不显示从其他任意类型派生的类，会自动从可恢复对象的类型派生。

除此之外：

* 可恢复类型的方法和操作中产生的列表、字典和集合类型会修改可恢复对象。
* 内建函数如果返回列表、字典和集合的，都会返回可恢复的等效对象。

直接调用Python代码一般都不会生成可恢复对象。
某些情况下，获得的对象可能不会参与回滚：

* 调用内建类型的方法，比如 str.split 方法。
* 使用导入的Python模块创建的对象，返回给Ren'Py。
  (例如，collections.defaultdict的实例不参与回滚。)
* Ren'Py的API返回的对象，除非文档另有说明。

如果以上数据需要参与回滚，需要对其进行转换。例如：

::

    # Ren'Py中的Python代码中调用list函数
    # 可以将不可恢复列表转为可恢复列表
    $ attrs = list(renpy.get_attributes("eileen"))

.. _supporting-rollback-and-roll-forward:

支持回滚和前向滚动
====================================

大多数Ren'Py语句自动支持回滚和前向滚动。如果直接调用 :func:`ui.interact` ，就需要自行添加对回滚和前向滚动的支持。可以使用下列结构实现：

::


    # 非回滚状态这项是None；或前向滚动时最后传入检查点的值。
    roll_forward = renpy.roll_forward_info()

    # 这里配置界面……

    # 与用户交互
    rv = ui.interact(roll_forward=roll_forward)

    # 存储互动结果。
    renpy.checkpoint(rv)

重点是，你的游戏在调用renpy.checkpoint后不与用户发生交互。(不然，用户可能无法回滚。)

.. function:: renpy.can_rollback()

  如果可以回滚则返回True。

.. function:: renpy.checkpoint(data=None)

  在当前语句设置一个能让用户回滚的检查点(checkpoint)。一旦调用这个函数，当前语句就不该再出现互动行为。

  `data`
    当游戏回滚时，这个数据通过 :func:`renpy.roll_forward_info()` 返回。

.. function:: renpy.get_identifier_checkpoints(identifier)

  从HistoryEntry对象中寻找rollback_identifier，返回需要的检查点(checkpoint)数量，并传入 :func:`renpy.rollback()` 以到达目标标识符(identifier)。如果标识符不在回滚历史中，返回None。

.. function:: renpy.in_rollback()

  游戏回滚过则返回True。

.. function:: renpy.roll_forward_info()

  在回滚中，返回这条语句最后一次执行时返回并应用于 :func:`renpy.checkpoint()` 的数据。如果超出滚回范围，则返回None。

.. function:: renpy.rollback(force=False, checkpoints=1, defer=False, greedy=True, label=None, abnormal=True)

  将游戏状态回滚至最后一个检查点(checkpoint)。

  `force`
    若为True，所有情况下都可以回滚。否则，在存储区、上下文(context)和配置(config)中启用时才能进行回滚。

  `checkpoints`
    通过renpy.checkpoint回滚的目标检查点(checkpoint)。这种情况下，会尽可能快地回滚。

  `defer`
    若为True，调用会推迟到主控流程回到主语境(context)。

  `greedy`
    若为True，回滚会在前一个检查点(checkpoint)后面结束。若为False，回滚会在当前检查点前结束。

  `label`
    若不是None，当回滚完成后，调用的脚本标签(label)。

  `abnormal`
    若为True，也是默认值，异常(abnormal)模式下的转场(transition)会被跳过，否则显示转场。当某个互动行为开始时，异常(abnormal)模式结束。

.. function:: renpy.suspend_rollback(flag)

  回滚会跳过游戏中已经挂起回滚的章节。

  `flag`
    当 *flag* 为True时，回滚挂起。当 *flag* 为False时，回滚恢复。

.. _blocking-rollback:

阻塞回滚
=================

.. warning::

    阻塞回滚是一个对用户不友好的事情。如果一个用户错误点击了不希望进入的分支选项，ta就不能修正自己的错误。由于回滚等效于存档和读档，用户就会被强迫频繁地存档，破坏游戏体验。

部分或者完全禁用回滚是可能的。如果根本不想要回滚，可以使用 :var:`config.rollback_enabled` 函数关闭选项。

更通用的做法是分段阻塞回滚。这可以通过 :func:`renpy.block_rollback` 函数实现。当调用该函数时，Ren'Py的回滚会在某个点上停止。举例：

::

    label final_answer:
        "这就是你的最终答案吗？"

    menu:
        "是":
            jump no_return
        "不":
            "我们有办法让你开口。"
            "你还是好好想考虑下吧。"
            "我再问你一次……"
            jump final_answer

    label no_return:
        $ renpy.block_rollback()

        "然后到了这里。现在不能回头了。"

当到达脚本标签(label)no_return时，Ren'Py就停止回滚，不会进一步回滚到标签menu。

.. _fixing-rollback:

固定回滚
===============

固定回滚提供了一种介于完全无限制回滚和完全阻塞回滚之间的中间选项。回滚是允许的，但用户无法修改之前做出的选择。固定回滚使用 :func:`renpy.fix_rollback()` 函数实现，下面是样例：

::

    label final_answer:
        "这就是你的最终答案吗？"
    menu:
        "是":
            jump no_return
        "不":
            "我们有办法让你开口。"
            "你还是好好想考虑下吧。"
            "我再问你一次……"
            jump final_answer

    label no_return:
        $ renpy.fix_rollback()

        "然后到了这里。现在不能回头了。"

现在，调用fix_rollback函数后，用户依然可以回滚到标签menu，但不能选择一个不同的分支选项。

使用fix_rollback设计游戏时，还有几处要点。Ren'Py会自动关注并锁定传入 :func:`checkpoint()` 的任何数据。
但由于Ren'Py的天然特性，可以用Python语句穿透这个显示并修改数据，这样会导致不需要的结果。
特别注意，``call screen`` 不能与固定回滚共用。
这最终取决于游戏设计者是否在某些有问题的地方阻塞回滚来处理问题。

内部用户的菜单互动选项， :func:`renpy.input()` 和 :func:`renpy.imagemap()` 被设计为完全支持fix_rollback。

.. _styling-fixed-rollback:

样式化固定回滚
======================

因为fix_rollback改变了菜单和imagemap的功能，建议考虑应对这种情况。理解菜单按钮的组件状态如何改变很重要。通过 :func:`config.fix_rollback_without_choice` 选项，可以更改两种模式。

默认配置会将选过的选项设置为“selected”，进而激活样式所有带“selected\_”前缀的样式特性。所有其他按钮会被设置为不可用，并使用前缀为“insensitive\_”前缀的特性显示。这样的最终效果就是菜单仅有一个可选的选项。

当 :func:`config.fix_rollback_without_choice` 项被设为False时，所有按钮都会设置为不可用。之前选过的那项会使用“selected_insensitive\_”前缀的风格特性，而其他按钮会使用前缀为“insensitive\_”前缀的特性。

.. _fixed-rollback-and-custom-screens:

固定回滚和自定义界面
=================================

当使用fix_rollback系统编写定制Python路由，使游戏流程更舒服时，有几个简单的要点。首先是 :func:`renpy.in_fixed_rollback()` 函数可以用作决定游戏当前是否处于固定回滚状态。其次，当处于固定回滚状态时， :func:`ui.interact()` 函数总会返回使用的roll_forward数据，而不考虑行为是否执行。这表示，当 :func:`ui.interact()`/:func:`renpy.checkpoint()` 函数被使用时，大多数工作都已经完成了。

为了简化定制界面的创建，Ren'Py提供了两个最常用的行为(action)。当按钮检测到被按下时， :func:`ui.ChoiceReturn()` 行为会返回。 :func:`ui.ChoiceJump()` 行为可以用于跳转到某个脚本标签(label)。当界面通过一个  ``call screen`` 语句被调用时，这个行为才能正常工作。

举例：

::

    screen demo_imagemap:
        imagemap:
            ground "imagemap_ground.jpg"
            hover "imagemap_hover.jpg"
            selected_idle "imagemap_selected_idle.jpg"
            selected_hover "imagemap_hover.jpg"

            hotspot (8, 200, 78, 78) action ui.ChoiceJump("swimming", "go_swimming", block_all=False)
            hotspot (204, 50, 78, 78) action ui.ChoiceJump("science", "go_science_club", block_all=False)
            hotspot (452, 79, 78, 78) action ui.ChoiceJump("art", "go_art_lessons", block_all=False)
            hotspot (602, 316, 78, 78) action ui.ChoiceJump("home", "go_home", block_all=False)

举例：

::

    python:
        roll_forward = renpy.roll_forward_info()
        if roll_forward not in ("Rock", "Paper", "Scissors"):
            roll_forward = None

        ui.hbox()
        ui.imagebutton("rock.png", "rock_hover.png", selected_insensitive="rock_hover.png", clicked=ui.ChoiceReturn("rock", "Rock", block_all=True))
        ui.imagebutton("paper.png", "paper_hover.png", selected_insensitive="paper_hover.png", clicked=ui.ChoiceReturn("paper", "Paper", block_all=True))
        ui.imagebutton("scissors.png", "scissors_hover.png", selected_insensitive="scissors_hover.png", clicked=ui.ChoiceReturn("scissors", "Scissors", block_all=True))
        ui.close()

        if renpy.in_fixed_rollback():
            ui.saybehavior()

        choice = ui.interact(roll_forward=roll_forward)
        renpy.checkpoint(choice)

    $ renpy.fix_rollback()
    m "[choice]!"

.. _rollback-blocking-and-fixing-functions:

回滚阻塞和回滚混合函数
=======================================

.. function:: renpy.block_rollback()

  防止回滚到当前语句之前的脚本。

.. function:: renpy.fix_rollback()

  防止用于更改在当前语句之前做出的选项决定。

.. function:: renpy.in_fixed_rollback()

  如果正在发生回滚的当前上下文(context)后面有一个执行过的renpy.fix_rollback()语句，就返回True。

.. function:: ui.ChoiceJump(label, value, location=None, block_all=None)

  一个菜单选项行为(action)，返回值为 *value* 。同时管理按钮在固定回滚模式下的状态。(详见对应的 *block_all* 参数。)

  `label`
    按钮的文本标签(label)。对imagebutton和hotspot来说可以是任何类型。这个标签用作当前界面内选项的唯一标识符。这个标识符与 *location* 一起存储，用于记录该选项是否可以被选择。

  `value`
    跳转的位置。

  `location`
    当前选项界面的唯一位置标识符。

  `block_all`
    若为False，被选中选项的按钮会赋予“selected”角色，未选中的选项按钮会置为不可用。

    若为True，固定回滚时按钮总是不可用。

    若为None，该值使用 :func:`config.fix_rollback_without_choice` 配置项。

    当某个界面内所有选项都被赋值为True时，选项菜单变成点击无效状态(回滚依然有效)。这可以通过在 :func:`ui.interact()` 之前调用 :func:`ui.saybehavior()` 修改。

.. function:: ui.ChoiceReturn(label, value, location=None, block_all=None)

  一个菜单选项行为(action)，返回值为 *value* 。同时管理按钮在固定回滚模式下的状态。(详见对应的 *block_all* 参数。)

  `label`
    按钮的文本标签(label)。对imagebutton和hotspot来说可以是任何类型。这个标签用作当前界面内选项的唯一标识符。这个标识符与 *location* 一起存储，用于记录该选项是否可以被选择。

  `value`
    选择某个选项后返回的位置。

  `location`
    当前选项界面的唯一位置标识符。

  `block_all`
    若为False，被选中选项的按钮会赋予“selected”角色，未选中的选项按钮会置为不可用。

    若为True，固定回滚时按钮总是不可用。

    若为None，该值使用 :func:`config.fix_rollback_without_choice` 配置项。

    当某个界面内所有选项都被赋值为True时，选项菜单变成点击无效状态(回滚依然有效)。这可以通过在 :func:`ui.interact()` 之前调用 :func:`ui.saybehavior()` 修改。

.. _norollback:

不回滚
==========

.. class:: NoRollback

  从这个类继承的类的实例，在回滚操作中不执行回滚。一个NoRollback类实例的所有相关对象，仅在它们有其他可抵达路径的情况下才不回滚。

举例：

::

    init python:

        class MyClass(NoRollback):
            def __init__(self):
                self.value = 0

    label start:
        $ o = MyClass()

        "欢迎！"

        $ o.value += 1

        "o.value的值是 [o.value] 。你每次回滚并点到这里都会增加它的值。"
