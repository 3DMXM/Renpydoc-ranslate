.. _history:

对话历史
================

Ren'Py包含一个对话历史系统，存放着每一行向用户显示过的对话文本。存储的对话可以恢复或者再次向用户显示。

对话历史系统由两个变量控制。变量
:var:`config.history_length` 控制存储的对话历史最大层(entry)数，必须设置才能启用对话历史功能。变量 :var:`_history` 可以用于禁用或重新启用对话历史的存储功能。

最后，变量 :var:`_history_list` 将实际的历史记录存储为一个HistoryEntry对象的列表。HistoryEntry对象的字段(field)内包含下面的数据。

.. class:: HistoryEntry

    .. attribute:: kind

        创建这段对话历史的角色类型。Ren'Py中会先将当前正在显示对话的该属性设置为“current”，之后再改为“adv”或“nvl”。

    .. attribute:: who

        一个字符串，表示发言角色名，如果不存在的话就是None。

    .. attribute:: what

        一个字符串，表示对话文本。

    .. attribute:: who_args

        一个字典，表示原来显示时who文本组件应用的特性(property)。

    .. attribute:: what_args

        一个字典，表示原来显示时what文本组件应用的特性(property)。

    .. attribute:: window_args

        一个字典，表示原来显示时对话窗口应用的特性(property)。

    .. attribute:: show_args

        一个字典，表示原来显示时say界面应用的特性(property)。

    .. attribute:: image_tag

        用于 :func:`Character` 的图像标签(tag)，若没有则是None。

    .. attribute:: voice

        函数 :func:`_get_voice_info` 返回的对象，存储播放的语音信息。

    .. attribute:: rollback_identifier

        这是一个标识符，可以传入 :func:`RollbackToIdentifier` ，可以导致生成的这个历史层回滚到对应的那行脚本。如果位置依然在脚本日中时回滚才会发生，否则这个行为(action)是无效的。


一旦创建了一个HistoryEntry对象，就会传给 :var:`config.history_callbacks` 中配置的每一个回调函数，那些回调函数允许创作者写的代码添加新的字段(field)。
