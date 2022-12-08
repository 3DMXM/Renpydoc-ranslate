.. _transforms-and-transitions-in-python:

===========================================
Python中的变换(transform)和转场(transition)
===========================================

可以使用Python创建新的变换(transform)和转场(transition)，并应用在Ren'Py脚本中。

.. _python-transforms:

变换(transform)
------------------

*主要内容：* :doc:`transforms` * 和 * :doc:`atl`

变换(transform)是一个Python的可调用组件。当使用一个可视组件调用变换时，变换会返回另一个可视组件。

举例：

::

    init python:

         # 这是一个使用right和left两个默认变换的自定义变换。
         def right_or_left(d):
             if switch:
                 return right(d)
             else:
                 return left(d)

ATL变换在Python中等效于一个Transform对象。

.. class:: Transform(child=None, function=None, **properties)

    一个Transform对象会将各种操作应用到其子组件，操作包括：剪裁、旋转、缩放和alpha混合等。一个Transform对象的字段一一对应 :ref:`变换特性 <transform-properties>` ，并应用到子组件。

    `child`
        变换应用的子组件。

    `function`
        若不是None，这是渲染变换效果时调用的函数。调用这个函数使用3个入参：

        * Transform对象。
        * 显示时间轴，单位为秒。
        * 动画时间轴，单位为秒。

        函数会返回一个延迟时间，单位为秒。在延迟时间之后这个函数会被再次调用。如果延迟时间是None，则会在下次互动之后立刻调用。

        该函数除了第一个入参的变换对象之外不应有其他副作用，并且要求可以在任何时间点使用任何值调用以启用预加载。

    其他关键词入参都会作为对应变换特性的值。
    绘制变换效果时，对应的变换特性都会根据入参设置值，但在变换对象创建后不再更改。
    使用 ``function`` 参数传入的函数或调用 :meth:`update` 方法，可以改变对应的变换特性。
    
    其他参数被视为设置变换特性的值。

    .. attribute:: hide_request

        当function函数被调用时，这项会被设置为True，标识变换效果被隐藏。

    .. attribute:: hide_response

        如果hide_request为True，这项会被设置为False，防止变换效果被隐藏。

    .. method:: set_child(child)

        使用一个新的 `child` 调用这个方法，`child` 成为变换的子组件。

    .. method:: update()

        当变换特性(property)字段在 `function` 参数指定的回调方法之外被更新时，这个方法会被调用，确保修改生效。

.. _transitions-python:

转场(transitions)
----------------------

*主要内容：* :doc:`transitions`
*其他参考* :ref:`atl-transitions`

一个转场(transition)是一个Python的可调用组件。使用两个关键词入参调用，返回一个表现转场效果的可视组件。这两个关键词入参是：

`old_widget`
    一个表示旧界面的可视组件。

`new_widget`
    一个表示新界面的可视组件。

返回的可视组件应该有一个 ``delay`` 字段(field)，域中的值表示转场效果运行的时间，单位为秒。

举例：

::

    init python:

        def dissolve_or_pixellate(old_widget=None, new_widget=None):
            if persistent.want_pixellate:
                return pixellate(old_widget=old_widget, new_widget=new_widget)
            else:
                return dissolve(old_widget=old_widget, new_widget=new_widget)
