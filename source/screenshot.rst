.. _screenshots:

截图
===========

Ren'Py内置了游戏截图功能，并可以使用截图用作可视组件。
将截图用作可视组件后，可以在“纸娃娃”系统中将截图保存，以备后续使用，例如创建虚拟形象。

Ren'Py使用截图功能后，无论是整个界面还是单个可视组件的截图，都会根据窗口缩放和DPI改变调整绘制尺寸。
核心在于实际观感，而不是截图资源的原生尺寸。

默认的截图快捷键是键盘的“S”。

下列是截图相关的行为和界面函数。

* :class:`Screenshot`
* :class:`FileScreenshot`
* :class:`FileTakeScreenshot`

.. _screenshots-functions:

相关函数
---------

下列函数也可以用于截图：

.. function:: renpy.render_to_file(d, filename, width=None, height=None, st=0.0, at=None, resize=False)

    渲染某个可视组件或Render对象，然后将渲染结果保存为一个文件。此次渲染会使用Ren'Py的显示系统，因此窗口缩放会影响渲染结果。

    `d`
        需要渲染的可视组件或Render对象。若该项是一个Render对象，忽略 `width`、`height`、`st` 和 `at` 参数。

    `filename`
        一个字符串，指定需要保存的文件名。文件路径默认为游戏基目录。扩展名比为是 .png。

    `width`
        `d` 的宽度，虚拟像素值。若为None，使用 :var:`config.screen_width` 的值。

    `height`
        `d` 的高度，虚拟像素值。若为None，使用 :var:`config.screen_height` 的值。

    `st`
        显示时间轴的渲染时间点。

    `at`
        动画时间轴的渲染时间点。若为None，则使用 `st` 的值。

    `resize`
        若为True，图像尺寸会调整，与可视组件或Render对象的虚拟像素值保持一致。
        但这样做可能会降低截图结果的图像质量。

    该函数只能在Ren'Py的显示系统启动后才能调用，不能在初始化阶段或首次交互行为之前调用。

    Ren'Py在游戏运行时不会重新扫描图片资源文件，因此不能直接将截图文件作为游戏运行时的必备资源。

.. function:: render_to_surface(d, width=None, height=None, st=0.0, at=None, resize=False)

    该函数渲染某个可视组件或Render对象，返回一个pygame_sdl2表面纹理(surface)。
    此次渲染会使用Ren'Py的显示系统，因此窗口缩放会影响渲染结果。

    `d`
        需要渲染的可视组件或Render对象。若该项是一个Render对象，忽略 `width`、`height`、`st` 和 `at` 参数。

    `filename`
        一个字符串，指定需要保存的文件名。文件路径默认为游戏基目录。扩展名比为是 .png。

    `width`
        `d` 的宽度，虚拟像素值。若为None，使用 :var:`config.screen_width` 的值。

    `height`
        `d` 的高度，虚拟像素值。若为None，使用 :var:`config.screen_height` 的值。

    `st`
        显示时间轴的渲染时间点。

    `at`
        动画时间轴的渲染时间点。若为None，则使用 `st` 的值。

    `resize`
        若为True，图像尺寸会调整，与可视组件或Render对象的虚拟像素值保持一致。
        但这样做可能会降低截图结果的图像质量。

    该函数只能在Ren'Py的显示系统启动后才能调用，不能在初始化阶段或首次交互行为之前调用。

.. function:: renpy.screenshot(filename)

    将截图保存为 `filename`。

    如果截图保存成功就返回True。如果由于某些原因保存失败就返回False。

    :var:`config.screenshot_pattern` 和 :var:`_screenshot_pattern` 两项可以控制截图文件名。


.. function:: renpy.screenshot_to_bytes(size)

    将截图以bytes对象形式返回，可以作为参数传入 :func:`im.Data` 。该二进制对象将是png格式，例如：

    ::

        $ data = renpy.screenshot_to_bytes((640, 360))
        show expression im.Data(data, "screenshot.png"):
            align (0, 0)

    将显示一个截图。bytes对象可以存储到存档文件和持久化数据中。不过这个对象可能很大，注意不要存储太多类似的对象。

    `size`
        截图后重新缩放的目标尺寸。若为None，截屏将按用户窗口的尺寸进行调整，不包含窗口的标题栏。

    该函数运行可能比较慢，通常用在类似存档的截屏需求中，而不应该用在需要实时生效的功能中。
