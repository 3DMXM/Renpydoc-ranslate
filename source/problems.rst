.. _dealing-with-problems:

处理故障
=====================

.. _dealing-with-display-problems:

处理显示故障
-----------------------------

.. _on-startup:

运行环境
^^^^^^^^^^

Ren'Py预设运行设备包含图形加速硬件，比如独立显卡或集成显卡。
Ren'Py会按下面描述的顺序，自动选择渲染器。

这些是Ren'Py 6.13至7.4版本使用的渲染器。
7.4及以上版本要求基于模型渲染，因此无法使用这些渲染器。

1. gl: OpenGL 2.0或更高版本。
2. angle: Windows、DirectX 9或DirectX 11。
3. gles: OpenGL ES 3.0。

Ren'Py7.4及以上版本中使用基于模型的渲染器。这些渲染器可以使用新的功能，并且在未来会成为默认渲染器。

4. gl2: OpenGL 2.0或更高版本。
5. angle2: Windows、DirectX 9或DirectX 11。
6. gles2: OpenGL ES 3.0。

更早版本的Ren'Py支持纯软件渲染，不过现在的版本已经移除这种渲染模式了。

使用硬件加速Ren'Py游戏时，有一小部分系统可能会遭遇故障。这些故障的根因通常是有bug的显卡驱动，所以用户修复故障的第一步是检查显卡驱动更新。

如果升级了显卡驱动依然不能修复故障，用户就需要考虑切换渲染器，使用下列步骤：

1. 启动Ren'Py时按住shift键，或者Ren'Py启动后马上按下shift+G。
#. 出现的“Graphics Acceleration”菜单中选择使用的渲染器(renderer)。
#. 选择“Quit”退出并重启Ren'Py。

我们推荐按顺序尝试GL和ANGLE渲染器。GLES渲染器在电脑上可能少一些功能。

.. _on-suspend-resume:

待机/恢复
^^^^^^^^^

我们收到了一些系统报告，在电脑待机并恢复后出现纹理丢失的情况。
这个问题大概率是由电脑或设备驱动导致，不过我们也在考虑游戏窗口尺寸变化或使用F键切换成全屏模式时，改为强制Ren'Py重新加载纹理。

.. _windows-encoding-problems:

Windows编码故障
-------------------------

如果Ren'Py放入一个当前系统语言中不合法的目录中，就不能在Windows中正常启动。举例，如果Ren'Py在这个目录里：

::

    C:\\ビジュアルノベル\\renpy-6.16.0-sdk\

并且系统设置为使用英语，Ren'Py就不能启动。要修复这种问题的话，进入控制面板，选择“区域和语言选项”->“高级”，并将系统语言切换为非Unicode项。

.. _os-x-10-9-mavericks:

OS X 10.9 Mavericks
-------------------

一个OS X 10.9 Mavericks的bug会在阻止Ren'Py在非主显示器中启动。在苹果修复这个bug之前，请在主显示器中启动Ren'Py。

.. _bit-linux-problems:

64-Bit Linux Problems
----------------------

Ren'Py 6.14.x和6.15.0-3没有正确编译，经常会在64位Linux电脑上出错。最好的办法是下载和运行Ren'Py 6.15.4或更新版本，使用这个命令运行游戏：

::


    /path/to/renpy-6.15.4/renpy.sh /path/to/game-with-problems
