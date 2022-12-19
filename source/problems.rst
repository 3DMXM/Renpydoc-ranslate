.. _dealing-with-problems:

处理故障
=====================

.. include:: display_problems.rst

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
