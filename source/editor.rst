.. _text-editor-integration:

=======================
集成文本编辑器
=======================

Ren'Py允许用户从启动器(launcher)加载一个文本编辑器编辑游戏脚本，同时也使用这个文本编辑器向用户汇报错误。
必要的话用户可以定制自己的文本编辑器。

通过在.edit.py文件中创建一个Editor类，就可以定制编辑器了。这个类包含了管理文本编辑的方法。

直接运行时，Ren'Py首先根据环境变量RENPY_EDIT_PY找到使用的.edit.py文件。
如果成功找到.edit.py文件，Ren'Py就使用文件中定义的Editor类。如果没有找到那个文件，Ren'Py会使用一个内建的editor类，以系统指定方式启动编辑器。

当Ren'Py的启动器运行时，它会扫描项目目录的子目录和Ren'Py目录以寻找格式为 `name`.edit.py的文件。 (例如，它会找到launcher/jEdit.edit.py和myeditor/MyEditor.edit.py。)带有给定 `name` 的最后一个编辑器，会作为启动器的一部分展现给创作者。 启动器也设置环境变量RENPY_EDIT_PY来选择文件，这样使用启动器启动的游戏也会使用选用的编辑器。

.. _writing-an-edit-py-file:

编写.edit.py文件
------------------------

.edit.py文件是一个Python(而不是Ren'Py)文件，文件中必须定义唯一的类，名为Editor。Ren'Py调用这个类的方法实现对文本的编辑。

编辑器事务(transaction)将相关操作分组，编辑器通过事务(transaction)进行编辑。例如，如果某个编辑器事务申请一个新窗口，那个事务中的所有文件都应该在同一个新窗口中打开。编辑器事务通过调用begin方法启动，可以包含一个或多个对operation方法的调用，通过调用end方法结束。

edit.py文件应导入renpy.editor，Editor类应继承renpy.editor.Editor。额外的关键词入参传入类的方法时，你定义的方法应忽略那些未知参数。由于假设你需要自定义Editor类，我们就在所有方法中都添加了 `self` 参数。

.. class:: Editor

  .. method:: begin(self, new_window=False, **kwargs)

    启动一个编辑器事务(transaction)。

    如果 `new_window` 为True，编辑器会尝试打开一个新窗口。否则，编辑器尝试在已存在的编辑器窗口中执行事务。

  .. method:: end(self, **kwargs)

    结束一个事务。

  .. method:: open(self,  filename, line=None, **kwargs)

    在编辑器中打开名为 `filename` 的文件。

    如果 `line` 不是None，尝试将编辑游标定位到第 `line` 行。
