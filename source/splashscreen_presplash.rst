.. _splashscreen-and-presplash:

启动界面和加载等待
==========================

.. _adding-a-splashscreen:

添加启动界面
-------------

在游戏启动后进入菜单前，播放图片或视频的界面称作启动界面(Splash Screen)。通常会在这个界面显示Logo或开场动画。
“splashscreen”脚本标签会在主菜单之前自动执行。因此，可以在游戏脚本的任何地方使用这个标签使用启动界面。

如果要在游戏启动界面添加文本，可以在脚本中添加如下代码(除了splashscreen标签内部)：

::

    label splashscreen:
        scene black
        with Pause(1)

        show text "American Bishoujo Presents..." with dissolve
        with Pause(2)

        hide text with dissolve
        with Pause(1)

        return

启动界面的另一个样例，这次使用一张图片和一段音频：
::

    image splash = "splash.png"

    label splashscreen:
        scene black
        with Pause(1)

        play sound "ping.ogg"

        show splash with dissolve
        with Pause(2)

        scene black with dissolve
        with Pause(1)

        return

最后一个样例，使用一段视频：
::

    label splashscreen:

        $ renpy.movie_cutscene('movie.ogv')

        return

.. _presplash:

添加加载等待画面
------------------

加载等待(presplash)是Ren'Py在加载脚本并启动游戏过程中显示的画面。
如果需要当引擎启动后显示加载等待画面，值需要创建名为 :file:`presplash.png` 或 :file:`presplash.jpg` 的图片文件，保存到game目录下就行了。

presplash.png
    游戏加载过程中显示的图片。

该项尽在电脑平台上生效，在安卓、iOS和Web平台无效。
安卓平台需要设置 :ref:`android-presplash`，Web平台需要设置 :ref:`Web Presplash <web-presplash>`。

:var:`config.minimum_presplash_time` 配置项设置了preslash画面的最小显示时间。

.. _adding-a-progress-bar:

添加进度条
---------------------

引擎自身加载完毕后，除了静态图片，还可以显示一个加载进度条。
如果设置了加载进度条，会自动取代原来的加载等待画面。

进度条可以更换主题，要求创作者提供两张PNG或JPG格式的图片：

presplash_background.png
    进度条背景图。整个启动阶段都会显示，用作整个加载进度的背景。
    这个图往往是完全不透明的。

presplash_foreground.png
    进度条前景图。随着加载进度从左往右逐渐显示。该图用于显示实际的加载进度，可以包含一些透明度。

加载进度条的工作方式是，Ren'Py首先显示 `presplash_background.png` ，接着在背景上覆盖 `presplash_foreground.png`，并按加载进度从左往右逐步显示。

进度条的主题效果完全由创作者决定，下面两个样例仅供参考：

.. ifconfig:: renpy_figures

    .. figure:: presplash/presplash_background_1.png
        :width: 100%

        进度条背景图样例。

    .. figure:: presplash/presplash_foreground_1.png
        :width: 100%

        进度条前景图样例。

    .. figure:: presplash/presplash_background_2.png
        :width: 100%

        一个略精致的进度条背景样例。

    .. figure:: presplash/presplash_foreground_2.png
        :width: 100%

        一个略精致的进度条前景样例。

.. _transparent-presplash:

透明加载等待画面
---------------------

如果加载等待画面背景图的最左上角像素是半透明的，那么整个加载等待画面窗口都会是半透明的。
透明度检查机制只采用1bit，0表示完全透明，其他值表示完全不透明。

.. _mobile-and-web-preslash-screens:

手机端和Web平台的preslash界面
--------------------------------

安卓、iOS和Web平台拥有各自的preslash界面。
详见对应文档：

* Android :ref:`android-presplash`
* iOS :ref:`ios-storyboard`
* Web :ref:`web-presplash`