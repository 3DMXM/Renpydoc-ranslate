.. _conditional-statements:

条件语句
======================

Ren'Py中包含几种语句可以基于某些表达式值改变主控流程。（多提一句， :ref:`jump <jump-statement>` 、
:ref:`call <call-statement>` 和 :ref:`return <return-statement>` 语句修改主控流程不需要前置条件。）

注意之前几页讨论过的，可以使用在Ren'Py脚本中的各类语句。Python的while、if、and语句可以内嵌在Ren'Py游戏中，但不能内嵌在Ren'Py脚本语句之中。

.. _if-statement:

if语句
------------

当if后的表达式为True时，if语句会执行后面的一个语句块(block)。if语句包含1个 ``if`` 分句，0个或多个 ``elif`` 分句，可能有1个 ``else`` 分句。

每个分句应该保持在一个逻辑行内，下面跟一个语句块(block)。 ``if`` 和 ``elif`` 关键词后面跟一个表达式。每个分句结尾都是英文冒号(:)。

举例如下：

::

    if flag:
        e "你立了一个flag!"

::

    if points >= 10:
        jump best_ending
    elif points >= 5:
        jump good_ending
    elif points >= 1:
        jump bad_ending
    else:
        jump worst_ending

if语句里的所有表达式按代码先后顺序进行换算。一旦某个表达式结果为True，其对应的语句块(block)会被立即执行，完成后主控流程将跳出if语句，开始执行if语句后面的内容。

如果if语句中所有表达式结果均为False， ``else`` 分句后的语句块会被执行，前提是存在一个 ``else`` 分句。


.. _while-statement:

while语句
---------------

当while语句中的表达式结果为True时，while分句下面的语句块会执行。举例：

::

    $ count = 10

    while count > 0:

        "T-minus [count]."

        $ count -= 1

    "发射！"

::

    $ lines = ["sounds/three.mp3", "sounds/two.mp3", "sounds/one.mp3"]
    while lines: # 只要lines列表不为空，表达式结果等效于True
        play sound lines.pop(0) # 移除lines列表第一个元素
        pause

::

    while True:

        "这是一首永远不会结束的歌。"
        "它会不断不断播放下去，我的同胞们。"

当主控流程遇到while语句时，while后的表达式会被计算一次，另外每次while下的语句块(block)执行结束后又会回到while表达式。除非while中的表达式结果为False，不然后面的语句块会反复不断运行。

Ren'Py没有continue、break和for循环语句。
使用jump语句分别跳转至while循环之前和之后的脚本标签(label)，可以替代continue和break语句的功能。
在上面的第一个while循环样例中，演示了如何使用while循环代替简单的for循环语句。
第二个样例中，演示了如何使用while循环通过列表实现迭代器功能(其他程序语言中的foreach语句)。


.. _conditional-pass-statement:

pass语句
--------------

当我们需要在脚本中根据语法要求必须出现一个语句块(block)，而又没有实际内容可以写时，可以使用pass语句。pass语句不做任何事。

举例：

::

    if points >= 10:
        "棒棒哒!"
    elif points >= 1:
        pass
    else:
        "情况看起来不妙。"

::

    # event.step()函数可能会返回True，但依然有一些事件(event)需要执行。

    while event.step():
        pass
