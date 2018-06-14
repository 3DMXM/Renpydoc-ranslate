.. _gestures:

手势
========

Ren'Py包含一个手势识别器，在触控屏上可以启用。这使得原本使用键盘或鼠标实现的功能可以通过手势来代替。

手势识别器首先将手指滑动分类为8个指南针上的方向：“n”、“ne”、“e”、“se”、“s”、“sw”、“w”、“nw”。“N”(北方)表示走向屏幕上方。后续的滑动会使用下划线“_”连接。比如，用户先下滑再右滑，就会产生字符串“s_e”。

假设 :var:`config.dispatch_gesture` 配置为None，接着就是使用 :var:`config.gestures` 函数将手势映射为某个事件消息。如果找到对应事件消息，就使用 :func:`renpy.queue_event` 函数将事件加入消息队列。如果没有找到手势对应的事件消息，就忽略。

只有当 :var:`config.variants` 中出现了“touch”，也就是在触控屏设备上运行时，手势识别器才会启用。

.. var:: config.gestures = { "n_s_w_e_w_e" : "progress_screen" }

    手势与手势激活的事件消息的映射。

.. var:: config.dispatch_gesture = None

    配置了相应手势的函数。手势字符串的裸数据(raw)会传入配置的这个函数。如果返回的不是None，交互动作结束。如果这个配置项是None，就是用默认的处理函数。


.. function:: renpy.cancel_gesture()

  取消当前手势，阻止手势的识别。某些具有类似手势行为的可视组件需要调用这个函数。
