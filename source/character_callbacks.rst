.. _character-callbacks:

角色回调函数
===================

对话中的各种事件发生时，Ren'Py都有能力执行回调函数。
这是通过将 `callback` 入参传入 :func:`Character` 函数或设置 :var:`config.character_callback` 和 :var:`config.all_character_callbacks` 配置项实现的。

调用角色回调函数时传入唯一的固定位置参数，即发生的事件消息。可能的事件消息包括：

"begin"
    在某个say语句的开头。

"show"
    显示每一段对话之前。对话可以被文本标签{w}或{p}分割成多段，没有那些文本标签的对话可以理解为1段。

"show_done"
    显示每一段对话之后。

"slow_done"
    在慢速文本显示完毕后。注意，这个事件可能会发生在“end”后面，在那种情况下对话不会触发交互动作。

"end"
    在某个say语句的结尾。

调用回调函数时至少包含一个关键词入参：

`interact`
    如果对话触发了某个交互动作，则返回True。

其他的固定位置入参和额外的关键词入参值可能会在后面用到。回调函数不能理解的参数就忽略。

.. _example:

样例
-------

这个样例播放“哔-”代替角色语音，前提是慢速文本启用：::

    init python:
        def beepy_voice(event, interact=True, **kwargs):
            if not interact:
                return

            if event == "show_done":
                renpy.sound.play("beeps.ogg")
            elif event == "slow_done":
                renpy.sound.stop()

    define pike = Character("克里斯托弗·派克", callback=beepy_voice)

    label start:

        pike "So, hanging out on Talos IV, minding my own business, when..."
