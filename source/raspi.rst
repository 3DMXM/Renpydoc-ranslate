.. _raspberry-pi:

树莓派
============

Ren'Py提供了对树莓派的有限支持。目前已经验证可以在树莓派3B上运行，其他机型上可能也可以运行。

重点是，需要认识到树莓派是一个十分受限的系统，甚至与iOS和安卓手机相比也显得很孱弱。因此，并不是每一个Ren'Py游戏都可以顺畅运行，甚至根本不能运行在树莓派上。还有，当游戏需要的RAM超过系统可用总量时会导致Ren'Py挂掉。

当正确配置好树莓派时，Ren'Py应该使用设备的硬件OpenGL ES运行。这跟安卓和iOS平台有同样的限制，focus_mask不能使用。

.. _configuring-the-raspberry-pi:

配置树莓派
----------------------------

在使用Ren'Py之前，先需要使用raspi-config工具配置树莓派。这些设置都在高级选项(advanced options)中。

* 内存: 256 MB
* 分辨率: 1280x720 或更小。
* GL 驱动: GL (Fake KMS)

修改完这些设置后，重启树莓派。

.. _configuring-ren-py:

配置Ren'Py
------------------

在树莓派上运行Ren'Py需要ARM-Linux SDK。
当前版本的Ren'Py支持所有平台，也可以在Ren'Py 7.5以上版本的下载界面找到下载链接。

下载了ARM-Linux SDK后，使用untar命令解压，并放在新创建的目录中。

由于树莓派原生无法支持Ren'Py，所以需要下载两个文件。第一个文件是SDK的Linux版本，第二个文件是树莓派支持文件。

.. _running-a-game:

运行
--------------

由于树莓派是一个资源受限平台，我们推荐避免使用Ren'Py启动器。我们建议直接使用renpy.sh脚本直接启动项目，使用的命令如下：

::

    ./renpy.sh /path/to/project

这个步骤也可以用于处理在树莓派上无法运行的Ren'Py游戏。