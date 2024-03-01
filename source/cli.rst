.. highlight:: text

.. _command-line-interface:

======================
命令行交互界面
======================

Ren'Py包含一个命令行交互界面(CLI)，可用于自动处理某些开发任务，允许持续集成和脚本打包。
但对于大多数需求，都不必用到CLI——Ren'Py启动器就可以完成大部分任务。

本页文档中的例子，都假设创作者在Ren'Py SDK目录下运行CLI(即包含renpy.py、renpy.sh和renpy.exe的目录)。
同时也假设运行的操作系统为Linux或macOS。在Windows操作系统上，需要将执行命令中的 ``./renpy.sh`` 替换为 ``lib\\py3-windows-x86_64\\python.exe renpy.py``。

CLI目前还不稳定。不同版本Ren'Py的CLI可能会有很大差异。

.. describe:: <base>

    在后续的命令中，<base>表示项目根目录。

.. _build-commands:

生成命令
==============

.. note::

    作为生成流程的一部分，Ren'Py会创建包含游戏加载信息的 .rpyc 文件。
    一个持续集成系统应该在生成完成后保留这些 .rpyc 文件，在下个生成中直接应用这些文件，或移动到old-game目录里。
    不这样做可能会导致游戏无法读档。

.. _android-build:

生成安卓版本
-------------

::

    ./renpy.sh launcher android_build <base> [ options... ]

以上命令会生成一个游戏的安卓版本。前提是启动器已经安装了安卓SDK，生成了密钥并合理配置过整个项目。

.. option:: --destination <directory>

    输出目录。默认目录为当前目录下名为 “`name`-`version`-dists” 的子目录。
    版本号version从 :var:`build.name` 和 :var:`build.version` 获取。

.. option:: --bundle

    使用该选项后，Ren'Py会生成一个 .aab 包。如果不使用该选项，Ren'Py会生成 .apk 文件。

.. option:: --install

    使用该选项后，Ren'Py会在连接设备上直接安装 .apk 或 .aab 文件。

.. option:: --launch

    使用该选项后，Ren'Py会在连接设备上运行游戏。该选项会与 ``--install`` 一起使用。

.. _add-from-to-call:

在call语句结尾追加from从句
---------------------------

::

    ./renpy.sh <base> add_from

该命令会在遍历每个不包含 ``from`` 从句的 ``call`` 语句，并自动添加一个 ``from`` 从句。
一般情况下，这步应该在生成正式版(release版)之前完成。这会修改游戏程序，以帮助Ren'Py准确定位到每个call语句的返回点。

.. note::

    该命令不会修改创作者写的游戏脚本文件，仅在游戏程序层面有变化。

.. _check-script:

使用Lint检查脚本
-------------------

::

    ./renpy.sh <base> lint [ filename ] [ options... ]

该命令会使用lint检查游戏。与启动器中的“使用Lint检查脚本”按钮效果相同。


.. option:: filename

    指定输出文件名。lint会将报告输出至该文件，而不是打印为标准输出。

lint可能会用到很多选项，且各个版本的lint会有一些差异。需要查看各选项的实际用途，请运行：

::

    ./renpy.sh <base> lint --help


.. _compile:

编译
-------

::

    ./renpy.sh <base> compile [ --keep-orphan-rpyc ]

该命令会根据 .rpy 文件创建 .rpyc 文件，编译整个游戏。
与Ren'Py启动器的“强制重新编译”按钮效果相同。

.. option:: --keep-orphan-rpyc

    默认情况下，Ren'Py会遍历 .rpyc 文件。如果某些文件不存在同名的 .rpy 或 _ren.py 文件，则会删除对应的 .rpyc 文件。
    如果启用该选项，Ren'Py会保留所有 .rpyc 文件。

.. _distribute:

构建
----------

::

    ./renpy.sh launcher distribute <base> [ options... ]

该命令会构建游戏在不同操作系统的发行版。该命令能使用的选项如下：

.. option:: --destination <directory>

    指定构建目录。默认目录为当前所在目录下，名为“`name`-`version`-dists”的子目录。
    版本号version从 :var:`build.name` 和 :var:`build.version` 获取。

.. option:: --no-update

    如果使用该选项，Ren'Py不会生成更新用文件。

.. option:: --package <package>

    指定打包类型，package参数可以是“pc”、“mac”或“markets”。该选项可以有多个参数，依次生成不同类型的打包文件。
    默认则会生成所有类型的打包文件。

(还有一些其他选项，但主要是用来生成Ren'Py自身的。)

.. _ios-create:

生成iOS版本
------------

::

    ./renpy.sh launcher ios_create <base> <destination>

该命令会创建一个Xcode项目。此Xcode项目可以用来生成游戏的iOS版本。此命令执行前需要在启动器上安装iOS的相关支持。

.. option:: destination

    指定Xcode项目放置的目录。

.. _ios-populate:

iOS迁移
------------

::

    ./renpy.sh launcher ios_populate <base> <destination>

该命令会将游戏复制到某个使用 :command:`ios_create` 生成的Xcode项目。
在使用相同Ren'Py版本的前提下，该命令可用于项目更新。


.. option:: destination

    指定待更新的项目目录。

.. _update-old-game:

更新老游戏
---------------

::

    ./renpy.sh launcher update_old_game <base>

该命令会将 <base>/game 目录下的 .cpyc 文件复制到 <base>/old-game 目录。

.. _web-build:

生成Web版本
-------------

::

    ./renpy.sh launcher web_build <base> [ options... ]

该命令会生成一个游戏的Web发布版。
此命令执行前需要在启动器上安装web的相关支持，并且所有配置文件(例如 ``progressive_download.txt``)都已放在合适位置。

.. option:: --destination <directory>

    指定Web版根目录位置。

.. _launcher-commands:

启动器命令
=================

这些命令可用于在CLI中控制Ren'Py启动器。

.. _set-projects-directory:

设置项目目录
----------------------

::

    ./renpy.sh launcher set_projects_directory <directory>

该命令用于设置Ren'Py启动器存储项目的目录。
It's intended for use on minimal systems where none of the options for selecting
a projects directory are available.

只有未运行启动器时，此命令才会生效。

.. _set-project:

设置项目
-----------

::

    ./renpy.sh launcher set_project <base>

将当前项目设置为指定项目。该命令会项目目录改为启动器当前选中的目录。

只有未运行启动器时，此命令才会生效。