.. _building-distributions:

生成分发版
======================

Ren'Py包含了对生成游戏分发版的支持。在启动器(laucher)选择“生成分发版”，Ren'Py会扫描自身和项目，决定分发版中包含哪些文件，并创建需要的归档文件，以及生成包(package)和升级文件。

不需要额外设置，Ren'Py就可以生成下列类型的包(package)：

PC: Windows and Linux
    一个运行在Windows x86、Linux x86和Linux x86_64平台的zip文件。

Linux x86/x86_64
    一个运行在Linux x86和Linux x86_64平台的tar.bz2文件。

Macintosh x86_64
    一个运行在使用Intel处理器Macintosh OS X系统的zip文件，文件中包含一个Macintosh可执行文件。游戏数据可以包含在可执行文件中，在用户看来只有一个文件。

Windows x86
   一个运行在Windows x86平台的zip文件。

Windows, Mac, and Linux for Markets
   包含软件市场(比如itch.io和Steam)必要信息的分发版。这个版本不用于直接运行(可能在Mac上根本无法启动)，而用于上传到app商店。

.. warning::

  Ren'Py生成的zip和tar.bz2文件包含Ren'Py在Linux和Macintosh平台运行的授权信息。在Windows平台解包zip并重新打包，不能在Linux和Macintosh平台运行。

.. _basic-configuration:

基本配置
-------------------

通过在build命名空间中设置变量和调用函数，可以对生成过程进行配置。这些工作必须在 ``init python`` 语句块(block)中进行。
这些配置项默认都设置在 ``options.rpy`` 中。

有一些基本变量和函数在很多游戏中都会使用。

.. var:: build.name = "..."

    这个变量用于自动生成build.directory_name和build.executable_name，前提是那两项都没有设置。这个变量不包含空格、冒号或分号。

.. var:: build.directory_name = "..."

   这个变量用于在归档文件中创建的目录名称。例如，如果这个变量设置为“mygame-1.0”，项目的Linux版本解包后就是“mygame-1.0-linux”。

   这个变量也用于决定包(package)文件中的目录名称。例如，如果将build.directory_name设置为“mygame-1.0”，最终归档文件里就会在基目录里放一个“mygame-1.0-dists”目录。

   这个变量不能包含特殊字符，比如空格、冒号或分号。如果没有配置，这个变量默认使用 :var:`build.name`
   和 :var:`config.version`。

.. var:: build.executable_name = "..."

   这个变量控制用于点击并启动游戏的可执行程序名称。

   这个变量不能包含特殊字符，比如空格、冒号或分号。如果没有配置，这个变量默认使用 :var:`build.name`。

   例如，如果把变量设置为“mygame”，用户在Windows平台运行mygame.exe，在Macintosh上运行mygame.app，在Linux平台运行mygame.sh。

.. _special-files:

特殊文件
-------------

有两个在游戏基目录下的文件，可以用于定制化生成过程。

icon.ico
    Windows平台使用的图标。

icon.icns
    Macintosh使用的图标。

这些图标文件必须使用特殊格式。你可能需要使用一个程序或网络服务 (比如 http://iconverticons.com/ ) 转换图片。

.. _classifying-and-ignoring-files:

归类和省略文件
------------------------------

生成过程的第一步，是将Ren'Py分发版和你游戏中的文件分类并添加至各个文件列表。这些文件列表会添加为包(package)文件。

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
    这些文件会包含在所有包(package)中，生成安卓版本。
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
archive
    这些文件会包含在archive.rpa归档文件中。

不在任何分类下的文件都会放入“all”文件列表中。

如果要在分发版中排除某些文件，就将文件归类为None或空字符串。

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

在Ren'Py生成过程中添加新类型的包(package)也是可行的。调用build.package函数可以实现这点。调用时传入一个包名、类型和一个包含的文件列表。

假设我们想要生成一个游戏的普通版本，以及一个包含奖励材料的版本。我们可以将奖励文件归类到“bonus”文件列表中，然后使用如下语句定义一个“all-premuim”包(package)：::

    build.package("all-premium", "zip", "windows mac linux all bonus")

支持生成的包类型包括“zip”和“tar.bz2”格式，以及用于装文件的目录“direcroty”。

.. _archives:

归档文件
--------

Ren'Py支持将多个文件合并为单个归档格式的文件。这个机制能保护文件免于被临时复制。

默认情况下，所有归类为“archive”的文件都会放入归档文件archive.rpa中，这个归档文件包含所有“archive”列表中的文件。

调用build.archive函数，可以定义一个新的归档文件，以及这个归档文件中包含的文件列表。(虽然，很少指明具体文件而是包含所有文件列表。)需要归档文件时，就将目标文件名分类到归档的列表中。

例如，下面脚本将所有图片归档到image.rpa，游戏脚本归档到scripts.rpa：::

    # 定义两个归档文件。
    build.archive("scripts", "all")
    build.archive("images", "all")

    # 将脚本放入scripts归档。
    build.classify("game/**.rpy", "scripts")
    build.classify("game/**.rpyc", "scripts")

    # 将图片放入images归档。
    build.classify("game/**.jpg", "images")
    build.classify("game/**.png", "images")

如果某个归档文件为空，就不会生成。

关于游戏归档的问题，请三思。使用开放文件可能有助于后人在未来的平台上运行你的游戏——那些你离开这个世界之后才出现的平台。

.. _requirements:

运行环境要求
------------

一些网上商店会询问Ren'Py程序的运行环境要求。虽然各个游戏的实际要求并不相同，这里还是给出了运行大多数视觉小说的最基础配置。

**Windows**

* 版本：Windows XP或以高。
* 处理器：2.0 GHz Core 2 Duo
* 内存：2.0 GB
* 显卡支持：OpenGL 2.0或DirectX 9.0c

**macOS**

* 版本：10.6+
* 处理器：2.0 GHz Core 2 Duo (只支持64位版本)
* 内存：2.0 GB
* 显卡支持：OpenGL 2.0

**Linux**

* 版本：Ubuntu 12.04+
* 处理器：2.0 GHz Core 2 Duo
* 内存：2.0 GB
* 显卡支持：OpenGL 2.0

对磁盘空闲空间的大小则完全取决于游戏自身，并且对处理器和内存的要求可能会不同。

.. _build-functions:

生成(build)函数
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

    空字符串则不生成任何格式的包(package)。(这个机制可以实现DLC需求。)

  `file_lists`

    包含在包(package)中的文件列表。

  `description`

    生成包(package)的可选项描述。

  `update`

    若为True并且生成了更新，就会为这个包(package)生成更新文件。

  `dlc`

    若为True，会在独立的DLC模式下生成zip或tar.bz2文件，而不是update目录下生成。

  `hidden`

    若为True，会在启动器(launcher)的包(package)列表中隐藏这个包。

.. _advanced-configuration:

高级配置项
----------------------

下列配置变量提供了对生成过程的更多控制项：

.. var:: build.exclude_empty_directories = True

    若为True，空目录(包括文件归档后残留的空目录)会从生成的包(package)中移除。若为False，则会包含空目录。

.. var:: build.destination = "{directory_name}-dists"

    指定了生成的归档文件放的目录路径。可以是绝对路径也可以是相对路径。相对路径将项目(project)目录作为当前位置。

    下列值会使用Python的str.format函数进行替换。

    ``{directory_name}``
        build.directory_name的值。

    ``{executable_name}``
        build.executable_name的值。

    ``{version}``
        build.version的值。

.. var:: build.allow_integrated_gpu = True

    在同时包含集成显卡和独立显卡的平台上，允许Ren'Py运行在集成显卡上。目前，这个功能仅在Mac OS X上支持。

.. var:: build.include_old_themes = True

    当这项为True时，文件需要在Ren'Py 6.99.9版本之前支持的主题文件会包含在生成的包中。当这项是False时，不会包含这类文件。

    调用 :func:`gui.init` 时，这项会被设置为False。

.. var:: build.itch_project = None

    配置了这项后，就允许Ren'Py启动器将项目上传感到itch.io。这项应该设置为在itch上注册的项目名。(例如，“renpytom/the-question”。)

    一旦设置了这项，你可以点击“生成分发版”，然后选择“上传到itch.io”，将生成的版本上传。
