.. _renpy-files:

=================================
\_ren.py 文件——Python中的Ren'Py
=================================

在复杂的游戏中，可能某些文件大多数内容都是Python代码，只有一小部分是Ren'Py语句，比如 ``init python`` 把Python代码引入Ren'Py。
Ren'Py还有其他方法，专门用于这种偏重Python的文件。文件名以 ``_ren.py`` 结尾的文件，可以使用纯Python语法编写，并转换为Ren'Py脚本再处理。

采用这种机制的原因有两个：

* \_ren.py 类文件中的Python代码可以少一层缩进。
* 编辑器可以打开 \_ren.py 类文件时将语言类型设置为Python，然后启用代码分析和重构操作。
  Ren'Py中的Python则无法使用Python语言工具。

Python中的Ren'Py文件名以 \_ren.py 结尾，比如 ``actions_ren.py``。
这类文件的处理流程与其他 .rpy 文件相同，都是按Unicode编码的顺序处理。
因此，``actions_ren.py`` 文件的处理时机与 ``actions.rpy`` 相同。
如果两个文件的文件名去掉 \_ren.py 或 .rpy 后完全相同，Ren'Py将会报错。
例如，同一个目录下同时存在 ``actions.rpy`` 和 ``actions_ren.py`` 两个文件就会报错。

.. _syntax-and-transformation:

语法和格式转换
-------------------------

Python中的Ren'Py文件包含三类内容：

* 文件开头的部分直接会忽略。一般是Python中模块引用或其他构造代码，用于编辑器或插件的功能，但在Ren'Py中不会执行。

* 一段或多段Ren'Py代码，通常包含Ren'Py语法的脚本。
  Ren'Py语法的脚本通常用于引入Python代码，也用于设置Python代码的缩进。

  Ren'Py语法的代码以 ``"""renpy`` 开头，以 ``"""`` 结尾。
  开头和结尾的两个特殊语义符号都要放在那行开头，不使用任何缩进。
  如果开头和结尾中任何一行有缩进，该文件就无法被正确处理。

* 一行或多行Python代码。Python代码一般放在Ren'Py代码后面，并比前一段非空白非注释的Ren'Py代码多一级缩进。
  如果Python代码行尾是冒号 (:)，则下一段代码多缩进4个空格。

这种格式转换用户在内存中创建等效的 .rpy 文件，并以通用方式编译该文件。
注意，Python中的Ren'Py依然使用Ren'Py存储空间(而不是在一个模拟模块中)，并且Python代码遵循以上格式转换规则，
以实现回滚和存档/读档功能，详见 :doc:`python` 和 :ref:`rollback` 章节。

.. _renpy-py-example:

样例
-------

下面是一个 \_ren.py 文件的样例：

::
 
    # 游戏中不会使用这行代码。这里的代码仅让编辑器知道strength变量的类型。
    strength = 100

    """renpy
    init python:
    """

    class BoostStrength(Action):
        """
        玩家控制角色的力量值(strength)增加10点。
        """

        def __call__(self):
            global strength
            strength += 10
            renpy.restart_interaction()

格式转换后的文件会变成(某些空行被删除)：

::

    init python:

        class BoostStrength(Action):
            """
            玩家控制角色的力量值(strength)增加10点。
            """

            def __call__(self):
                global strength
                strength += 10
                renpy.restart_interaction()