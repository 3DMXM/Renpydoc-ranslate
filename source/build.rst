.. _building-distributions:

构建发行版
======================

Ren'Py包含了对构建游戏发行版的支持。在启动器(laucher)选择“构建发行版”，Ren'Py会扫描自身和项目，决定发行版中包含哪些文件，并创建需要的归档文件，以及构建包(package)和升级文件。

不需要额外设置，Ren'Py就可以构建下列类型的包(package)：

PC: Windows and Linux
    一个运行在Windows x86_64和Linux x86_64平台的zip文件。

Linux
    一个运行在Linux x86_64平台的tar.bz2文件。
    包括32位和64位的ARM版本。(如果装了sdkarm的Ren'Py包)

Macintosh
    一个运行在使用Intel或苹果Silicon处理器Macintosh OS X系统的zip文件，文件中包含一个Macintosh可执行文件。
    游戏数据可以包含在可执行文件中，在用户看来只有一个文件。
    更新器对这个包没用。

Windows
   一个运行在Windows x86_64平台的zip文件。

Windows, Mac, and Linux for Markets
   包含软件市场(比如itch.io和Steam)必要信息的发行版。这个版本不用于直接运行(可能在Mac上根本无法启动)，而用于上传到app商店。

.. warning::

  Ren'Py生成的zip和tar.bz2文件包含Ren'Py在Linux和Macintosh平台运行的授权信息。在Windows平台解包zip并重新打包，不能在Linux和Macintosh平台运行。

.. _basic-configuration:

基本配置
-------------------

通过在build命名空间中设置变量和调用函数，可以对构建过程进行配置。这些工作必须在 ``init python`` 语句块(block)中进行。
这些配置项默认都设置在 :file:`options.rpy` 中。

有一些基本变量和函数在很多游戏中都会使用。

.. var:: build.name = "..."

    这个变量用于自动生成build.directory_name和build.executable_name，前提是那两项都没有设置。这个变量不包含空格、冒号或分号。

.. var:: build.directory_name = "..."

   这个变量用于在归档文件中创建的目录名称。例如，如果这个变量设置为“mygame-1.0”，项目的Linux版本解包后就是“mygame-1.0-linux”。

   这个变量也用于决定包(package)文件中的目录名称。例如，如果将build.directory_name设置为“mygame-1.0”，最终归档文件里就会在基目录里放一个“mygame-1.0-dists”目录。

   这个变量不能包含特殊字符，比如空格、冒号或分号。如果没有配置，这个变量默认使用 :var:`build.name` 加英文连接符“-”，再加上 :var:`config.version`。
   和 :var:`config.version`。

.. var:: build.executable_name = "..."

   这个变量控制用于点击并启动游戏的可执行程序名称。

   这个变量不能包含特殊字符，比如空格、冒号或分号。如果没有配置，这个变量默认使用 :var:`build.name`。

   例如，如果把变量设置为“mygame”，用户在Windows平台运行mygame.exe，在Macintosh上运行mygame.app，在Linux平台运行mygame.sh。

.. _special-files:

特殊文件
-------------

有两个在游戏基目录下的文件，可以用于定制化构建过程。

:file:`icon.ico`
    Windows平台使用的图标。

:file:`icon.icns`
    Macintosh使用的图标。

这些图标文件必须使用特殊格式。
你可能需要使用一个程序或网络服务 (比如 https://anyconv.com/png-to-ico-converter/ 和  https://anyconv.com/png-to-icns-converter/) 转换图片。

.. _classifying-and-ignoring-files:

归类和省略文件
------------------------------

构建过程的第一步，是将Ren'Py发行版和你游戏中的文件分类并添加至各个文件列表。这些文件列表会添加为包(package)文件。

文件分类通过build.classify函数实现。这个函数使用一个正则表达式和空格分隔的文件名列表。正则表达式会从头到尾对文件名进行匹配，第一个匹配到的对象优先处理(尽管后面可能有个比较级正则表达式)。正则表达式可以匹配开头的 “/” 符号。正则表达式包含下列特殊字符：

/
   目录分隔符。
\*
   匹配所有字符，除了目录分隔符。
\*\*
   匹配所有字符。

举例：

\*\*.txt
    匹配所有txt文件。

game/\*.txt
    匹配game目录下的txt文件。

默认总共有7个文件列表用于文件的分类。(Ren'Py将自身文件放入前6个。)

all
    这些文件会包含在所有包(package)中，构建安卓版本。
linux
    这些文件会包含在Linux平台的包(package)中。
mac
    这些文件会包含在Mactintosh平台的包(package)中。
windows
    这些文件会包含在Windows平台的包(package)中。
renpy
    需要Ren'Py引擎文件的包(package)内文件。(Linux、Macintosh和Windows平台。)
android
    这些文件会包含在安卓版本中。

可以使用 :func:`build.classify` 函数的 ``file_list`` 参数扩展这个合法文件集。

文件也可以使用传统的归档方式。“archive”规定的定义如下：

archive
    这些文件会包含在archive.rpa归档文件中。

归档文件集也可以使用 :func:`build.archive` 函数扩展。

不在任何分类下的文件都会放入“all”文件列表中。

如果要在发行版中排除某些文件，就将文件归类为None或空字符串。
使用时，文件名表达式通配符中的 \* 和 \*\* 必须至少能匹配到一个字符。

举例：::

     # 包含README.txt。
     build.classify("README.txt", "all")

     # 排除所有其他txt文件。
     build.classify("**.txt", None)

     # 将game目录下的所有png和jpg文件放入归档中。
     build.classify("game/**.png", "archive")
     build.classify("game/**.jpg", "archive")

.. _documentation:

文档
-------------

使用正则表达式调用build.documentation函数可以把匹配到的文件标记为文档。在Macntosh版本里包含两份文档文件——程序里一份，程序外一份。

例如，将所有基目录的txt和html文件标记为文档：::

    build.documentation("*.txt")
    build.documentation("*.html")

.. _packages:

Packages
--------

在Ren'Py构建过程中添加新类型的包(package)也是可行的。调用build.package函数可以实现这点。调用时传入一个包名、类型和一个包含的文件列表。

假设我们想要构建一个游戏的普通版本，以及一个包含奖励材料的版本。我们可以将奖励文件归类到“bonus”文件列表中，然后使用如下语句定义一个“all-premuim”包(package)：::

    # 在“bonus”文件列表中定义一个新的归档。
    build.archive("bonus_archive", "bonus")

    # 将bonux文件放入新归档中。
    build.classify("game/bonus/**", "bonus_archive")

    # 定义包文件。
    build.package("all-premium", "zip", "windows mac linux renpy all bonus")

支持构建的包类型包括“zip”和“tar.bz2”格式，以及用于装文件的目录“direcroty”。

.. _archives:

归档文件
--------

Ren'Py支持将多个文件合并为单个归档格式的文件。这个机制能保护文件免于被临时复制。

默认情况下，所有归类为“archive”的文件都会放入归档文件archive.rpa中，这个归档文件包含所有“archive”列表中的文件。

调用build.archive函数，可以定义一个新的归档文件，以及这个归档文件中包含的文件列表。(虽然，很少指明具体文件而是包含所有文件列表。)需要归档文件时，就将目标文件名分类到归档的列表中。

例如，下面脚本将所有图片归档到 :file:`images.rpa`，游戏脚本归档到 :file:`scripts.rpa`：

::

    # 定义两个归档文件。
    build.archive("scripts", "all")
    build.archive("images", "all")

    # 将脚本放入scripts归档。
    build.classify("game/**.rpy", "scripts")
    build.classify("game/**.rpyc", "scripts")

    # 将图片放入images归档。
    build.classify("game/**.jpg", "images")
    build.classify("game/**.png", "images")

如果某个归档文件为空，就不会构建。

关于游戏归档的问题，请三思。使用开放文件可能有助于后人在未来的平台上运行你的游戏——那些你离开这个世界之后才出现的平台。

.. _old-game:

old-game目录
----------------------

构建多个游戏版本，比如早期公测或Patreon平台版本时，有必要保留旧版本的.rpyc文件。
.rpyc文件中包含的信息可用来确认存档是否可以继承，如果忽略这些信息查可能会引起各种问题。

同时，当game目录下的文件改变后，Ren'Py会更新对应的.rpyc文件，导致文件无法适用版本控制的要求。

为了解决这个问题，Ren'Py允许创作者将前一个版本的.rpyc文件放入 :file:`old-game/` 目录中，该目录与 :file:`game/` 目录平行。
old-game的目录结构会与game目录保持一致，比如 :file:`game/scripts/day1.rpyc` 文件移动后会成为 :file:`old-game/scripts/day1.rpyc`。
非.rpyc文件将会忽略。

使用old-game的优势是，Ren'Py总是会根据已知的代码改动在old-game生成.rpyc文件。
对个人开发者来说可能没什么用，对大一些的多人开发游戏项目则会有帮助。

关于在游戏变更后，如何使用.rpyc文件帮助实现存档继承的信息，可以查看下面的链接:

* `Under the hood: .rpyc files <https://www.patreon.com/posts/under-hood-rpyc-23035810>`_
* `Ren'Py developer update: February 2021 <https://www.patreon.com/posts/renpy-developer-48146908>`_

.. _requirements:

运行环境要求
------------

一些网上商店会询问Ren'Py程序的运行环境要求。虽然各个游戏的实际要求并不相同，这里还是给出了运行大多数视觉小说的最基础配置。

**Windows**

* 版本：Windows 7或以高。
* 处理器：2.0 GHz Core 2 Duo
* 内存：2.0 GB
* 显卡支持：OpenGL 3.0或DirectX 11

**macOS**

* 版本：10.6+
* CPU: 2.0 Ghz 64-bit Intel-compatible (Apple silicon supported through Rosetta 2)
* 处理器：2.0 GHz 64位英特尔兼容(苹果silicon系列使用Rosetta 2支持)
* 内存：2.0 GB
* 显卡支持：OpenGL 3.0

**Linux**

* 版本：Ubuntu 16.04+
* 处理器：2.0 GHz 64位英特尔兼容
* 内存：2.0 GB
* 显卡支持：OpenGL 3.0

对磁盘空闲空间的大小则完全取决于游戏自身，并且对处理器和内存的要求可能会不同。
Ren'Py可以运行在OpenGL 2，以便使用某些扩展。

.. _build-functions:

构建(build)函数
---------------

.. function:: build.archive(name, file_list=u'all')

  声明某个归档文件。如果一个或多个文件归类为 *name* ，就会生成一个 *name*\ .rpa 归档文件。归档包含对应名称的列表中的文件。

.. function:: build.classify(pattern, file_list)

  将匹配 *pattern* 的文件归类为 *file_list* 。

.. function:: build.clear()

  清空用于文件分类的正则表达式列表。

.. function:: build.documentation(pattern)

  定义正则表达式 *pattern* 用于匹配文档类文件。在生成mac版本app时，匹配文档正则表达式的文件会存储两份——app包内一份，app包外另一份。

.. function:: build.executable(pattern)

  添加将文件标识为支持平台(Linux和Macintosh)可执行程序的正则表达式。

.. function:: build.package(name, format, file_lists, description=None, update=True, dlc=False, hidden=False)

  定义一个包(package)，这个包由打包工具生成。

    `name`
        包(package)名称。

    `format`
        包的格式。这是一个由空格分隔的字符串，由下列要素组成：

        zip
          zip文件。

        tar.bz2
          tar.bz2文件。

        directory
          包含文件的目录。

        dmg
          包含文件的Macintosh平台DMG文件。

        app-zip
          包含Macintosh应用程序的zip文件。

        app-directory
          包含mac应用程序的目录。

        app-dmg
          包含dmg文件的macintosh镜像。(仅限Mac平台。)

        空字符串则不构建任何格式的包(package)。(这个机制可以实现DLC需求。)

    `file_lists`
        包含在包(package)中的文件列表。

    `description`
        构建包(package)的可选项描述。

    `update`
        若为True并且构建了更新，就会为这个包(package)构建更新文件。

    `dlc`
        若为True，会在独立的DLC模式下构建zip或tar.bz2文件，而不是update目录下构建。

    `hidden`
        若为True，会在启动器(launcher)的包(package)列表中隐藏这个包。

.. _build-info:

构建信息
----------

有两个变量会用作提供构建信息。这些信息会用于生成game/cache/build_info.json文件，并在Ren'Py启动时加载。

.. var:: build.time = None

    该变量默认值为None。一旦生成游戏包，会变为一个时间戳，即从1970年1月1日开始计算的秒数。

.. var:: build.info = { }

    该变量可以在构建游戏时将创作者设置的信息存储在game/cache/build_info.json文件中。
    游戏启动时，game/cache/build_info.json会被加载，并将信息放入同名变量。

    总体上，创作者只需要检查文件是否存在，并使用setdefault方法获取对应信息。

    例如，下面的代码可以在在build_info.json文件中存储构建游戏包的计算机名：
    
    ::

        python hide:
            import socket
            build.info.setdefault("build_host", socket.gethostname())

    该变量能存储的信息自身必须是JSON文件能保存的类型。(包括None、布尔型、字符串、数值、列表和字典)

.. _advanced-configuration:

高级配置项
----------------------

下列配置变量提供了对构建过程的更多控制项：

.. var:: build.allow_integrated_gpu = True

    在同时包含集成显卡和独立显卡的平台上，允许Ren'Py运行在集成显卡上。目前，这个功能仅在Mac OS X上支持。

.. var:: build.destination = "{directory_name}-dists"

    指定了构建的归档文件放的目录路径。可以是绝对路径也可以是相对路径。相对路径将项目(project)目录作为当前位置。

    下列值会使用Python的str.format函数进行替换。

    ``{directory_name}``
        build.directory_name的值。

    ``{executable_name}``
        build.executable_name的值。

    ``{version}``
        build.version的值。

.. var:: build.change_icon_i686 = True

    若为True并且 icon.ico 文件存在，32位Windows可执行程序的图标可以被修改。
    若为False，图标不能修改。将该值设置为False可以防止某些杀毒软件对游戏文件更改导致的问题。

.. var:: build.exclude_empty_directories = True

    若为True，空目录(包括文件归档后残留的空目录)会从构建的包(package)中移除。若为False，则会包含空目录。

.. var:: build.include_i686 = True

    若为True，构建Linux和Mac版本时，将包含在32位x86处理器平台运行时需要的文件。
    若为False，将不包含那些文件。

.. var:: build.include_old_themes = True

    当这项为True时，文件需要在Ren'Py 6.99.9版本之前支持的主题文件会包含在构建的包中。当这项是False时，不会包含这类文件。

    调用 :func:`gui.init` 时，这项会被设置为False。

.. var:: build.include_update = False

    若为True，Ren'Py会根据 :doc:`updater <updater>` 的设置构建文件。

.. var:: build.itch_project = None

    配置了这项后，就允许Ren'Py启动器将项目上传到itch.io。这项应该设置为在itch上注册的项目名。(例如，“renpytom/the-question”。)

    一旦设置了这项，你可以点击“构建发行版”，然后选择“上传到itch.io”，将构建的版本上传。

.. var:: build.itch_channels = { ... }

    该项将一个文件名通配表达式(比如 \*-win.zip)映射为一个字符串，对应 itch 平台对应的上传通道。
    默认值如下：
    
    ::

        {
            "*-all.zip" : "win-osx-linux",
            "*-market.zip" : "win-osx-linux",
            "*-pc.zip" : "win-linux",
            "*-win.zip" : "win",
            "*-mac.zip" : "osx",
            "*-linux.tar.bz2" : "linux",
            "*-release.apk" : "android",
        }

.. var:: build.mac_info_plist = { }

    该配置项是一个字典型数据，键和值都是字符串。用于添加或覆盖mac中的Info.plist文件。

.. var:: build.update_formats = [ "rpu" ]

    更新器支持的格式列表。默认值为“rpu”，在Ren'Py 7.7和8.2以上版本支持。
    若需要支持更早基于zsync的更新，则在列表中添加“zsync”。

.. var:: build.game_only_update = False

    If true, :var:`build.include_update` is enabled, and
    the "Game-Only Update for Mobile" package becomes available.
    若为True，启用 :var:`build.include_update` ，并设置为“Game-Only Update for Mobile”。
