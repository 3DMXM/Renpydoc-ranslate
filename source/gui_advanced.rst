.. _gui-advanced:

============
高级GUI
============

这个章节有一些关于GUI高级用法的细节。

.. _python-functions:

Python函数
================

一些支持GUI的Python函数。

.. function:: gui.button_properties(kind)

    给定按钮的 *kind* 类型，返回那个按钮对应的标准样式特性的字典数据。字典中包括：

    :propref:`background`
        详见后面的内容。

    :propref:`padding`
        用于gui.kind_borders.padding(前提是这项存在)。

    :propref:`xsize`
        用于gui.kind_width(前提是这项存在)。

    :propref:`ysize`
        用于gui.kind_height(前提是这项存在)。

    (需要注意，如果 *kind* 的值是字符串“nvl_button”，就会寻找gui.nvl_button_background配置项的值。)

    background是一个frame，使用以下第一个能匹配到的文件作为其背景图：

    - gui/button/kind\_[prefix\_].background.png
    - gui/button/[prefix\_].background.png

    如果某个GUI变量名为gui.kind_borders存在就使用。否则，使用 :var:`gui.button_borders` 。如果gui.kind_tile存在，他决定边界是否使用tile风格， :var:`gui.button_tile` 项控制tile。

    [prefix\_]代表的意思，详见 :ref:`样式前缀搜索 <style-prefix-search>` 。

.. function:: gui.init(width, height)

    初始化GUI。

    `width`
        默认窗口宽度。

    `height`
        默认窗口高度。

    `fov`
        3D舞台的视野(field of view)。

.. function:: gui.rebuild()

    重建GUI。

    .. note: 这个函数运行很慢。

.. function:: gui.text_properties(kind=None, accent=False)

    给定按钮的 `kind` 类型，返回那个按钮对应的标准样式特性的字典数据。字典中包括：

    :propref:`font`
        用于gui.kind_text_font，前提是它存在。

    :propref:`size`
        用于gui.kind_text_size，前提是它存在。

    :propref:`xalign`
        用于gui.kind_text_xalign，前提是它存在。

    :propref:`text_align`
        用于gui.kind_text_xalign，前提是它存在。

    :propref:`layout`
        用于“subtitle”，前提是gui.kind_text_xalign大于0小于1。

    还有一些变量设置文本的 ``color`` 样式特性(property)。

    **color**
        用于gui.kind_text_color，前提是它存在。如果变量没有设置，那么 *accent* 的值是True，将文本颜色设置为默认的强调(accent)色。

    **insensitive_color**
        用于gui.kind_text_insensitive_color，前提是它存在。

    **idle_color**
        用于gui.kind_text_idle_color，前提是它存在。

    **hover_color**
        用于gui.kind_text_hover_color，前提是它存在。

    **selected_color**
        用于gui.kind_text_selected_color，前提是它存在。

    也可以使用所有其他 :ref:`文本样式特性 <text-style-properties>` 。
    若 `kind` 不为None，还可以使用 :ref:`位置样式特性 <position-style-properties>` 。
    例如，使用gui.kind_text_outlines设置outlines样式特性，使用gui.kind_text_kerning设置行距，等等

.. function:: variant(f, variant=None)

    函数装饰器，在GUI初始化或重建GUI时调用。使用方法如下：

    ::

        @gui.variant
        def small():
            gui.text_size = 30
            # ...

    指定variant名称后，可以使用 `f` (一个函数) 和 `variant` (一个字符串)调用该函数。

.. function:: gui.button_text_properties(kind=None, accent=False)

    :func:`gui.text_properties` 的一个已过时(obsolete)异名。

.. _more-on-gui-rebuild:

更多关于gui.rebuild的内容
-------------------------

gui.rebuild函数是一个非常慢的函数，更新整套GUI以适应Ren'Py当前的状态。它的处理的内容包括：

* 重新运行所有在gui命名空间(namespace)中定义变量的 ``define`` 语句。
* 重新运行所有针对当前语言的多语言支持 ``translate python`` 语句块(block)。
* 重新运行所有 ``style`` 语句。
* 重建系统内所有样式。

注意， ``gui.rebuild`` 中 ``init python`` 语句块不会重新运行。使用这种方式定义：

::

    define gui.text_size = persistent.text_size

跟使用这种方式定义：

::

    init python:
        gui.text_size = persistent.text_size

在调用gui.rebuild后得到的结果不同。

.. _the-default-statement-the-gui-namespace-and-gui-rebuild:

default语句、gui命名空间和gui.rebuild
---------------------------------------------------------

应用于 ``gui`` 命名空间时， ``default`` 语句会改变语义。default语句与define语句穿插运行，调用 :func:`gui.rebuild` 函数时default语句不会重新运行。

这表示，如果我们有如下语句：

::

    default gui.accent_color = "#c04040"
    define gui.hover_color = gui.accent_color

游戏首次运行时，会设置accent_color，并且将hover_color设为与accent_color相同。

另外，如果我们的脚本中还有这样一段：

::

    $ gui.accent_color = "#4040c0"
    $ gui.rebuild()

Ren'Py值会重新运行define语句，所以它会将hover_color设置为accent_color，并更新样式。这个机制就能让部分gui随着游戏进度一起改变。

.. _gui-preferences:

GUI环境设定设置
===============

Ren'Py也支持GUI环境设定设置(preference)系统，包括一个函数和一系列行为(action)。

.. function:: gui.SetPreference(name, value, rebuild=True)

  这个行为(action)将名为 *name* 的环境设定设置项的值设置为 *value* 。

  `rebuild`
    若为True，也就是默认值，调用 :func:`gui.rebuild()` 会让修改生效。这项应该始终为True，除了存在多个gui.SetPreference行为的情况。那种情况除了最后一个设置为True其他都设置为False。

  这是一个非常慢的行为，所以不适合在按钮处于指针悬垂(hover)状态时使用。

.. function:: gui.TogglePreference(name, a, b, rebuild=True)

  这个行为切换gui中名为 *name* 的环境设定设置在值 *a* 和 *b* 之间切换。当这个值等于 *a* 时表示该项被选中。

  `rebuild`
    若为True，也就是默认值，调用 :func:`gui.rebuild()` 会让修改生效。这项应该始终为True，除了存在多个gui.SetPreference行为的情况，那种情况除了最后一个设置为True其他都设置为False。

  这是一个非常慢的行为，所以不适合在按钮处于指针悬垂(hover)状态时使用。

.. function:: gui.preference(name, default=<renpy.python.RevertableObject object at 0x7f77abf8a6d0>)

  这个函数返回gui中名为 *name* 的环境设定设置的值。

  `default`
    若存在，这个值会成为gui环境设定设置 *name* 的默认值。第一次使用环境设定设置就需要用到默认值。

.. _gui-advanced-example:

样例
-------

当通过调用 :func:`gui.preference` 函数，使用环境设定设置名称和默认值定义变量后，就能使用GUI环境设定设置系统了。例如，我们可以环境设定配置文本字体和字号：

::

    define gui.text_font = gui.preference("font", "DejaVuSans.ttf")
    define gui.text_size = gui.preference("size", 22)

使用 :func:`gui.SetPreference` 和 :func:`gui.TogglePreference` 行为可以添加和修改环境设定配置的值。这是添加到环境设定配置界面的样例：

::

    vbox:
        style_prefix "check"
        label _("Options")
        textbutton _("OpenDyslexic") action gui.TogglePreference("font", "OpenDyslexic-Regular.otf", "DejaVuSans.ttf")

    vbox:
        style_prefix "radio"
        label _("Text Size")
        textbutton _("Small") action gui.SetPreference("size", 20)
        textbutton _("Medium") action gui.SetPreference("size", 22)
        textbutton _("Big") action gui.SetPreference("size", 24)
