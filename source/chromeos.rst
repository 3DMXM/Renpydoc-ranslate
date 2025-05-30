.. _chrome-os-chrome-browser:

Chrome OS/Chrome浏览器
==========================

共有两种方式在Chrome OS运行Ren'Py。

.. android-on-chrome-os:

安卓上的Chrome OS
--------------------

在Chrome OS上运行游戏的最简单方式，是把游戏打包成安卓的应用程序，详见 :doc:`安卓文档 <android>` 。
Ren'Py在设计之初就考虑了安卓与Chrome OS同步支持。

这个模式只支持运行游戏，而不是开发游戏。

.. _linux-on-chrome-os:

Linux上的Chrome OS
------------------

Ren'Py游戏和SDK也能安装在Chromebook上。这个功能可以让创作者在Chromebook上开发Ren'Py游戏。

安装流程如下:

1. 安装Chromebook版的Linux，详见 https://support.google.com/chromebook/answer/9145439?hl=zh-Hans

2. 启用Crosstini GPU支持。在浏览器中输入 chrome://flags/#crostini-gpu-support ，找到对应选项并修改。

3. 重启Chromebook。

4. 更新Linux。打开一个终端并运行：

::

    sudo apt update
    sudo apt dist-upgrade

5. 使用下面命令安装依赖包：

::

    sudo apt install libnss3 python3-tk

安装Ren'Py时，打开一个终端并运行:

::

    wget https://www.renpy.org/dl/8.2.0/renpy-8.2.0-sdkarm.tar.bz2
    tar xaf renpy-8.2.0-sdkarm.tar.bz2

运行Ren'Py时，打开一个终端并运行：

::

    cd ~/ab/renpy-8.2.0-sdkarm
    ./renpy.sh

注意，多个版本的Ren'Py SDK可以共存，运行时注意不同版本的不同路径。此处样例使用的是8.2.0版。

执行上以上SDK安装步骤后，就可以在原生不支持ARM的Chromebook上运行游戏了。
只要把游戏解包后放入项目目录并刷新，通过Ren'Py启动器运行游戏。(项目目录可以在设置中修改。)
