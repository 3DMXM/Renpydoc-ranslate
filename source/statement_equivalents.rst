.. _statement-equivalents:

=====================
等效语句
=====================

为了允许Ren'Py能够在Python中脚本化，每个Ren'Py语句都有一条等效的Python语句。每条等效Python语句通常包含一个Python函数，也可能包含一个Python正则表达式，执行一个等效动作。


对话
========

Ren'Py的say语句等效于以一个函数的形式调用角色对象。下面的两个语句显示了同一行两次：::

    e "Hello, world."

    $ e("Hello, world.")

显示旁白也使用了同样的办法，用的是 ``narrator`` 角色。调用某个角色时，可以传入关键词入参 `interact`。当 *interact* 为False时，Ren'Py会显示角色对话框，并在执行某个互动操作后返回。

角色和函数对象的等效语句在其他方面也能正常运行。还可以定义一个Python函数，然后在角色对象的地方使用那个函数。例如，下面定义的函数使用一个变量，在两个角色中选择一个。 ::

    define lucy_normal = Character("Lucy")
    define lucy_evil = Character("Evil Lucy")

    init python:

        def l(what, **kwargs):
            if lucy_is_evil:
                lucy_evil(what, **kwargs)
            else:
                lucy_normal(what, **kwargs)

    label start:

        $ lucy_is_evil = False

        l "Usually, I feel quite normal."

        $ lucy_is_evil = True

        l "But sometimes, I get really mad!"

这种使用函数的方式，要么忽略未知的关键词入参，要么将那些入参传给某个角色函数。这样做可以在Ren'Py添加角色调用时的新关键词入参时，使游戏依然能运行。

.. function:: renpy.say(who, what, *args, **kwargs)

  say语句的等效语句。

  **who**

    None表示旁白，不然是发言角色对象，或表示角色名的字符串。最后那种情况， func:`say()` 函数会创建发言角色。

  **what**

    一行发言内容的字符串。字符串里带百分号(%)的部分会被替换(substitution)。

  **interact**

    若为True，Ren'Py显示对话并等待用户输入。若为False，Ren'Py显示对话，但不执行互动行为。(互动行为会以关键词入参传入相应的处理函数。)

  这个函数极少直接使用，因为下面三行语句是完全等效的。

  ::

      e "Hello, world."
      $ renpy.say(e, "Hello, world.")
      $ e("Hello, world.")

选项菜单
============

menu语句有一个等效的Python函数。

.. function:: menu(items, interact=True, screen="choice")

  这个函数向用户显示一个菜单。 *item* 应该是一个二元元组列表。在每个元组中，第一个元素是一个文本标签(label)，第二个参数是该元素被选中时的返回值。如果返回值是None，第一个元素会用作整个菜单的标题。

  该函数使用多个入参，这份文档中只列出了其中一部分。除了 *items* 之外，所有都是关键字入参。

  **interact**

    若为False，显示菜单，但不执行任何互动行为。

  **screen**

    显示菜单的界面名。

.. function:: renpy.display_menu(items, interact=True, screen="choice")

  这个函数向用户显示一个菜单。 *item* 应该是一个二元元组列表。在每个元组中，第一个元素是一个文本标签(label)，第二个参数是该元素被选中时的返回值。如果返回值是None，第一个元素会用作整个菜单的标题。

  该函数使用多个入参，这份文档中只列出了其中一部分。除了 *items* 之外，所有都是关键字入参。

  **interact**

    若为False，显示菜单，但不执行任何互动行为。

  **screen**

    显示菜单的界面名。


显示图像
=================

image、scene、show和hide语句都一个等效的Python函数。

.. function:: renpy.get_at_list(name, layer=None)

  将图层 *layer* 上图像标签名为 *tag* 的图像所应用的变换(transform)，以列表形式返回。如果没有使用任何变换(transform)则返回一个空列表，如果图像不显示则返回None。

  如果 *layer* 为None，就是用给定图像标签(tag)所在的默认图层。

.. function:: renpy.hide(name, layer=None)

  从某个图层中隐藏某个图像。hide语句的等效Python语句。

  **name**

    需要隐藏的图像名称。只是用图像标签(tag)，所有带相同标签的图像都将被隐藏(图像全名不重要)。

  **layer**

    该函数操作的图层名。若为None，使用图像标签(tag)关联的默认图层。

.. function:: renpy.image(name, d)

  定义一个图像。该函数是image语句的等效Python语句。

  **name**

    需要显示的图像名称，是一个字符串。

  **d**

    与图像名关联的可视组件。

  这个函数可能仅能在init语句块(block)中运行。游戏开始后运行这个函数会触发一个报错。

.. function:: renpy.scene(layer='master')

  从图层 *layer* 移动所有可视组件。当scene语句没有指定一个需要显示的图像时，这是scene语句的等效Python语句。

  一个完整的scene语句等效于调用renpy.scene之后再调用 :func:`renpy.show()` 。举例：

  ::

      scene bg beach

  等效于：

  ::

      $ renpy.scene()
      $ renpy.show("bg beach")

.. function:: renpy.show(name, at_list=, []layer='master', what=None, zorder=0, tag=None, behind=[])

  在某个图层上显示某个图像。这是show语句的等效Python语句。

  **name**

    需要显示的图像名称，是一个字符串。

  **at_list**

    应用于图像的变换(transform)列表。等效于 ``at`` 特性(property)。

  **layer**

    一个字符串，表示图像显示使用的图层名。等效于 ``onlayer`` 特性(property)。若为None，使用图像标签(tag)关联的默认图层。

  **what**

    若非None，这是一个代替图像的可视组件。(等效于show表达式语句。)当给定了一个 *what* 参数时， *name* 可以用于将图像与标签(tag)关联。

  **zorder**

    一个整数，等效于 ``zorder`` 特性(property)。若为None，zorder会保留之前的值，否则设置为0。

  **tag**

    一个字符串，用于指定显示图像的标签(tag)。等效于 ``as`` 特性(property)。

  **behind**

    一个字符串列表，表示需要显示的图像在哪些图像标签(tag)后面。等效于 ``behind`` 特性(property)。

.. function:: renpy.show_layer_at(at_list, layer='master', reset=True)

  ``show layer`` *layer* ``at`` *at_list* 语句的等效Python语句。

  **reset**

    若为True，当图层显示时，变换(transform)状态会重置为开始状态。若为False，变换状态会保持，允许新的变换更新状态。

转场
===========

with语句的等效是renpy.with_statement函数。

.. function:: renpy.with_statement(trans, always=False)

  触发一个转场(transition)。这是with语句的Python等效语句。

  **trans**

    转场(transition)名。

  **always**

    若为True，在用户禁用转场的情况下依然显示转场效果。

  当用户中断转场时该函数返回True，其他情况返回False。

跳转
====

jump语句的Python等效是renpy.jump函数。

.. function:: renpy.jump(label)

  结束当前语句，并让主控流程跳转到给定的脚本标签(label)。

Call
====

call语句的Python等效是renpy.call函数。

.. function:: renpy.call(label, *args, **kwargs)

  结束当前Ren'Py语句，并跳转到 *label* 处。当jump返回后，主控流程会返回到之前的语句。

  **from_current**

    若为True，主控流程会返回到当前语句，而不是当前语句的下一句。(这会导致当前语句运行两次。这项必须作为关键词入参传入。)

.. function:: renpy.return_statement()

  触发Ren'Py从当前Ren'Py级别的调用返回。
