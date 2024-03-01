.. _environment-variables:

环境变量
=====================

Ren'Py受一些环境变量的影响。在不同版本的Ren'Py中，这些环境变量可能会消失或者修改。

下列环境变量控制Ren'Py的行为表现：

``RENPY_DISABLE_JOYSTICK``
    如果设置了该项，禁用手柄检测。如果出现一个有问题的手柄导致Ren'Py出现误操作的情况下就使用该项。

``RENPY_DISABLE_FULLSCREEN``
    如果设置了该项，Ren'Py会拒绝进入全屏模式。

``RENPY_DISABLE_SOUND``
    该项阻止播放声音。如果变量中包含“pss”，禁用声音播放功能。

``RENPY_DRAWABLE_RESOLUTION_TEXT``
    如果该项设为0，Ren'Py不会使用屏幕分辨率绘制文本。

``RENPY_EDIT_PY``
    配置一个.edit.py文件路径，告诉Ren'Py如何唤起一个文本编辑器。详见 :doc:`editor` 。

``RENPY_GL_ENVIRON``
    设置OpenGL纹理环境。

``RENPY_GL_RTT``
    设置OpenGL纹理渲染方法。

``RENPY_GL_VSYNC``
    该项决定了Ren'Py是否尝试与显示器的刷新率同步。(这样设置可以用尽可能低的帧率防止画面撕裂。)该项设置为“0”禁用同步，设置为“1”同步每一次刷新。

``RENPY_LANGUAGE``
    如果设置了该项，表示Ren'Py使用的语言。

``RENPY_LESS_MEMORY``
    该项让Ren'Py减少内存消耗，代价是降低运行速度。

``RENPY_LESS_MOUSE``
    该项让Ren'Py始终禁用鼠标。

``RENPY_LESS_PAUSES``
    该项让Ren'Py禁用文本标签(tag){p}和{w}创建的暂停。

``RENPY_LESS_UPDATES``
    该项让Ren'Py减少界面更新时界面的数量。

``RENPY_MULTIPERSISTENT``
    Ren'Py多重持久化数据保存的目录路径。

``RENPY_NO_STEAM``
    如果在环境中设置了该项，则Ren'Py不会进行Steam相关的初始化。

``RENPY_OPEN_FILE_ENCODING``
    :func:`renpy.open_file` 函数使用的默认编码。
    主要用于Ren'Py基于不同Python版本的文件编码转换问题。如果某些基于Python2的游戏需要运载在Python3上，可以尝试把该项设置为“utf-8”或“latin-1”。
    (记得开发新版本的游戏要把这项改回去。)

``RENPY_PATH_TO_SAVES``
    Ren'Py保存存档的目录路径。实际存档是在该路径下各不同游戏的子目录中。

``RENPY_SCREENSHOT_PATTERN``
    用于创建截屏文件名的正则表达式。它应该含有一个%d的替换。例如，该项设为“screenshot%04d.jpg”就能让Ren'Py将截屏保存为jpg文件，而不是常用的png文件。

``RENPY_SEARCHPATH``
    设置该项后，使用双斜杠 (\:\:) 分割的额外路径列表将会被添加到 :var:`config.searchpath` 。

``RENPY_SIMPLE_EXCEPTIONS``
    设置该项后，禁用Ren'Py的图形异常处理。

``RENPY_SKIP_MAIN_MENU``
    设置该项后，跳过主菜单。

``RENPY_SKIP_SPLASHSCREEN``
    设置该项后，跳过splash画面。

``RENPY_SOUND_BUFSIZE``
    该项控制声音缓存大小。超过默认值(2048)可以防止由于跳过(skip)而不能播放声音的情况，代价是播放声音时存在更大的时延。

``RENPY_TIMEWARP``
    该项可以将运行时间加快或减慢。例如，将timewarp设置0.5就能半速运行，而将timewarp设置为2.0就能2倍速运行。

``RENPY_USE_DRAWABLE_RESOLUTION``
    如果该项设为0，Ren'Py使用游戏的虚拟分辨率而不用屏幕原生分辨率执行绘制操作(包括dissolve变换和文本渲染等)。

``RENPY_VARIANT``
    该项应该设置为Ren'Py希望使用的界面变种列表，列表内元素用空格分隔。

由于Ren'Py使用SDL，所以也受SDL环境变量的控制。

启动时，Ren'Py会在Ren'Py目录(包含renpy.exe或renpy.py文件的目录)中寻找文件 :file:`environment.txt`。如果找到了那个文件，Ren'Py会将文件以python文件行为解读，并将文件配置用作环境变量的默认值。
