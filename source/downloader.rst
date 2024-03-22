.. _downloader-for-large-games-on-mobile:

手机端下载大容量游戏
====================================

安卓和iOS平台应用商店提供下载的应用程序有容量限制。
为了支持容量更大的游戏，Ren'Py提供了下载器(downloader)，能以一个小容量的程序下载主体游戏。

.. _downloader-requirements:

前置条件
------------

要让下载器能跑，创作者首先需要一台可用的Web服务器主机。mega之类的网盘或itch.io之类的游戏分享平台，都是不行的。
下载器已经在Digital Ocean droplet服务器和Cloudflare R2服务器上安装Nginx服务后测试通过，以上两个云服务平台都可以提供最高10GB的免费存储。

重要的是，Web服务器需要支持文件下载，并且最好能支持多并发请求。

.. _how-it-works:

运行机制
------------

如果想使用下载，创作者需要生成两个游戏包。第一个是带下载器的游戏，包含Ren'Py引擎和下载器程序。
这个游戏是玩家能安装到自己手机上的应用程序。

第二个则是主体游戏，玩家们实际游玩的视觉小说。
主体游戏会通过下载器，下载到对应设备上并安装。

两个游戏程序需要使用相同版本的Ren'Py生成打包。
如果版本不匹配，下载器会更新主体游戏，并通过主体游戏更新自身。

下载器程序启动后，会检查主体游戏是否已安装。如果已安装并且版本正确，主体游戏将直接启动。
否则，下载器会提示玩家下载主体游戏。

.. _building-and-uploading-the-main-game:

生成和上传主体游戏
------------------

在主体游戏的脚本中唯一需求添加的修改只有一条：

::

    define build.game_only_update = True

游戏生成完成后，就得到了所有必需的成果。
把``updates.json``，``updates.ecdsa`` 和 ``rpu`` 目录下的所有东西都上传到Web服务器上。
(当然，要确保rpu目录跟两个省级文件在同一层目录，并且 ``rpy`` 目录中存在 .rpu 文件。)

.. _making-a-downloader-game:

制作带下载器的游戏
------------------------

带下载器的游戏依然是一个Ren'Py游戏，但大小不会超过100MB。
创作者可以在这样一个大小的游戏中做任何需要的内容——添加一个开场动画，播放音乐，等等。
以上内容需要独立于主体游戏，并按照通用技巧生成安卓或iOS的包。

同时，带下载器的游戏应该能询问玩家是否想下载，以及提示内容付费和非Wifi环境等情况，并最终下载主体游戏。

这里是一个带下载器游戏的脚本样例，使用了一些“教程”的资源：

::

    # 此url指向创作者Web服务器上的updates.json。
    define URL = "https://www.domain.com/game-updates/updates.json"

    # 带下载器的游戏禁用存档
    define config.save = False

    define e = Character("Eileen", image="eileen")

    label splashscreen:

        scene bg washington
        show eileen happy at left

        $ downloader = updater.start_game_download(URL)

        e "Welcome to the downloader game."
        e "欢迎使用带下载器的游戏。"

        e "本游戏会在把主体游戏下载到你手机上，然后你就可以玩了。"

        if downloader.download_total:
            $ download_mb = int(round(downloader.download_total / 1024 / 1024, 0))

            e "如果想要运行主体游戏，你需要下载 [download_mb] MB的数据。如果你此时不是使用WiFi，请注意移动流量消耗。点击屏幕将开始下载。"

        else:

            e "如果想要运行主体游戏，你需要下载一些数据。如果你此时不是使用WiFi，请注意移动流量消耗。点击屏幕将开始下载。"

        $ update.continue_game_download()

这是一个十分简单的脚本，依然有一些东西值得说明。
首先是将 :var:`config.save` 设置为False。这点很重要，禁用存档和读档功能后，下载器就不会影响主体游戏。

其次，脚本主要内容都在splashscreen中，不会进入游戏菜单界面。

在脚本开头就调用 :func:`updater.start_game_download` 收集下载信息。
接着，为了消耗一些时间便于后台计算下载容量，让艾琳随便说点什么。

当玩家点击了几次屏幕后，下载器可能会算出待下载的容量，也可能还没算出来。
所以我们用一个条件语句检查下载容量。如果下载数值是已知的，则转换为MB并显示。
如果下载数值是未知的，则显示笼统的文本。(也可以写死代码，显示一个估算的下载数据量。)

最后，调用 :func:`updater.continue_game_download` 启动下载流程。显示现在界面时，玩家不能操作什么。
但音乐和各种ATL动效都会持续运行。

下载完毕后，主体游戏会自动启动。如果下载失败，下载器会重启并提供玩家再次尝试下载。

.. _downloader-screen:

下载器界面
-----------------

下载器界面会显示一个下载进度条。
默认的下载器界面定义在文件 :file:`renpy/common/00updater.rpy` 中。
创作者可以复制到自己的game目录里并定制化。

默认的下载器界面如下：

::

    screen downloader(u):

        style_prefix "downloader"

        frame:

            has vbox

            if u.state == u.CHECKING or u.state == u.PREPARING:
                text _("Preparing to download the game data.")
            elif u.state == u.DOWNLOADING or u.state == u.UNPACKING:
                text _("Downloading the game data.")
            elif u.state == u.FINISHING or u.state == u.DONE:
                text _("The game data has been downloaded.")
            else: # An error or unknown state.
                text _("An error occured when trying to download game data:")

                if u.message is not None:
                    text "[u.message!q]"

                text _("This game cannot be run until the game data has been downloaded.")

            if u.progress is not None:
                null height gui._scale(10)
                bar value (u.progress or 0.0) range 1.0

            if u.can_proceed:
                textbutton _("Retry") action u.proceed

    style downloader_frame:
        xalign 0.5
        xsize 0.5
        xpadding gui._scale(20)

        ypos .25
        ypadding gui._scale(20)

    style downloader_vbox:
        xfill True
        spacing gui._scale(10)

    style downloader_text:
        xalign 0.5
        text_align 0.5
        layout "subtitle"

    style downloader_label:
        xalign 0.5

    style downloader_button:
        xalign 0.5


Downloader Functions
--------------------

.. function:: updater.continue_game_download(screen='downloader')

    继续下载游戏数据。该函数会不断循环直到下载完毕，或者用户退出游戏。

.. function:: updater.start_game_download(url, **kwargs)

    从 *url* 开始下载游戏数据。该函数会确定下载哪些东西，并返回一个Update对象。

