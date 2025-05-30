.. _movie:

影片
=====

Ren'Py可以使用FFmpeg解码器(已内置)播放以下视频编码格式的影片：

* AV1
* VP9
* VP8
* Theora
* MPEG-4 part 2 (包括Xvid和DivX)
* MPEG-2
* MPEG-1

及以下编码格式的音频：

* OPUS
* Vorbis
* MP3
* MP2
* FLAC
* PCM

还支持以下容器格式：

* WebM
* Matroska
* Ogg
* Avi
* 多种MPEG编码流。

(注意某些格式可能需要专利许可证书。没有把握的情况下，我们推荐使用AV1、VP9、VP8或者Theora、Opus、Vorbis，以及WebM、Matroska或者Ogg。)

影片可以全屏播放，也可以在一个可视组件内播放。全屏播放更省事。
YUV444不能使用硬件加速，需要使用YUV420或YUV422。

Ren'Py的视频解码器不支持alpha通道，但使用可视组件 :func:`Movie` 的 `side_mask` 参数可以实现同样效果。
下面的例子展示了如何利用ffmpeg库，使用带alpha通道的mov文件创建webm文件的四边对齐(side-by-side)mask。

::

    ffmpeg -i original.mov -filter:v alphaextract mask.mov
    ffmpeg -i original.mov -i mask.mov -filter_complex "hstack" -codec:v vp8 -crf 10 output.webm

(译者注，ffmpeg命令用于在操作系统shell或命令行模式中运行，对视频文件重编码。而不是用于Ren'Py脚本中。)

WebP平台可以播放影片，但各个浏览器支持的编码格式会有差别。最常见的跨浏览器兼容的组合是用H.264编码视频用MP3(或AAC)编码音频封装在MP4中。
不过，Ren'Py不支持H.264(或AAC)编码，所以不能使用该组合。

.. _fullscreen-movies:

全屏播放影片
-----------------

全屏播放影片最简单有效的办法是，使用 :func:`renpy.movie_cutscene` 函数。该函数会全屏播放影片直到影片结尾。用户也可以点击直接跳过播放。

::

    $ renpy.movie_cutscene("On_Your_Mark.webm")

在移动端平台，例如安卓和iOS，默认情况下配置项 :var:`config.hw_video` 设为True，此时会启用硬件视频解码。硬件视频解码效率更高，但具体支持的影片格式需要视具体平台而定。
这里可以查看 `安卓支持的媒体格式 <https://developer.android.com/guide/topics/media/media-formats>`_。
一个快速测试的办法是，直接把视频文件复制到手机上，然后使用默认的视频播放器看看能否播放。

Web平台不支持播放影片。

.. _movie-displayables-and-movie-sprites:

影片组件和影片精灵(sprite)
------------------------------------

任何可展示可视组件的地方，Ren'Py都可以使用影片组件实现影片的播放。例如，可以在菜单界面播放一个影片作为背景。

影片组件也能用于定义一个影片精灵(sprite)。影片精灵(sprite)由两段影片组成。主影片提供精灵(sprite)的各种颜色信息。次影片是一个遮罩影片，提供alpha通道信息，白色表示完全不透明而黑色表示完全透明。

使用影片组件会自动循环播放。

影片组件有两个参数：

`play`
    该值是一个字符串，给定了需要播放的影片文件名。

    必须提供的这个值。

`mask`
    该值是一个字符串，给定了alpha遮罩影片文件名。它需要与 `play` 原影片的大小，时长，帧率相同。

这里有一个定义影片精灵(sprite)的样例：

::

    image eileen movie = Movie(play="eileen_movie.webm", side_mask=True)

影片精灵可以使用show语句显示，并自动启动影片播放。如果可视组件被隐藏时，影片播放会自动停止。

::

    show eileen movie

    e "我感觉自己今天很活跃。"

    hide eileen

    e "不过在我不出现的时候没必要浪费力气。"

影片组件也能被用作某个界面的一部分，在初始化阶段定义即可(然后就可作为某个image语句的一部分)。

::


    image main_menu = Movie(play="main_menu.ogv")

    screen main_menu:
        add "main_menu"
        textbutton "Start" action Start() xalign 0.5 yalign 0.5

在同一个界面的同一时间可以显示多个影片组件或影片精灵(sprite)。受到系统性能限制，多个影片播放时使用相同的帧率。Ren'Py中没有定义过使用不同帧率播放影片的行为，很可能会导致很严重的掉帧。

.. _movie-python-functions:

python函数
----------------

.. function:: renpy.movie_cutscene(filename, delay=None, loops=0, stop_music=True)

    该函数播放一个MPEG-1格式的过场。用户可以使用点击跳过该过场。顶层元素overlay和底层元素underlay在过场中依然显示。

    `filename`
        含有MPEG-1影片的文件名。

    `delay`
        过场结束前等待(用户交互行为)的时间，单位为秒。通常就是影片长度，以秒计。若该值为None，delay值会被自动计算，使用循环总次数(即入参loop+1)乘以影片总时长。若该值为-1，则会一直等待用户点击。

    `loops`
        该值表示，除了首次播放之外，额外循环播放的次数。若值为-1表示始终循环播放。

    若影片播放被用户停止则返回True，若在delay定义的预计时间内由于其他原因中断播放则返回False。

.. class:: Movie(*, size=None, channel='movie', play=None, side_mask=False, mask=None, mask_channel=None, start_image=None, image=None, play_callback=None, loop=True, group=None, **properties)

    该类是一个可视组件，用于显示影片。

    `size`
        该参数有两种情况：指定一个包含指定影片宽度和高度的元组，或空值(None)自适应影片原尺寸。
        (如果这里设置为None，可视组件在不播放影片时的值就是(0, 0)。)

    `channel`
        与播放影片相关联的音频通道名。当某个影片在该通道上播放时，就会在对应的影片组件上显示。
        如果该参数为默认值“movie”，并且 `play` 参数提供了播放文件名的情况下，
        会根据 :var:`config.single_movie_channel` 和 var:`config.auto_movie_channel` 自动选择可用的通道名。

    `play`
        若给定入参play，其应该是某个影片文件的路径。显示影片时，入参channel通道上的影片文件将会自动播放。当影片被隐藏时，影片文件会自动停止播放。

    `side_mask`
        若为True，Ren'Py会将该Movie对象设置为水平并排(side-by-side)mask模式。
        Movie对象将被对等分割为两部分。左半为颜色信息，右半为alpha通道信息。对应的可视组件宽度也为该视频文件的一半。
        
        尽可能使用 `mask` 而不是 `side_mask` ，除非有帧同步问题。

    `mask`
        若给定入参mask，其应是某个影片文件的路径，而这个影片用作可视组件的alpha通道。影片被显示时，在mask_channel通道上的影片文件将会自动播放。当影片被隐藏时，影片文件会自动停止播放。

    `mask_channel`
        alpha遮罩视频播放使用的通道。若未给定，默认会在入参channel后面加上 ``_mask`` 后缀，注册一个新的通道。(例如，若入参channel名为“sprite”，那么自动生成的mask_channel值就是“sprite_mask”。)

    `start_image`
        当影片开始播放，但第一帧画面还未解码时，会使用此图像顶替。

    `image`
        若给定了参数play的值，但文件可能并不存在或不能播放的情况下，则会显示入参image给定的图片文件。(例如，这个功能可以用于创建一个精简的移动版本，其不包含影片精灵。)当用户遇到系统负荷过重时，也能在特性中选择降低为显示图片而不是播放影片。

    `play_callback`
        若不是None，这个函数用于启动影片的播放。(函数的工作可能是将一个转场加入到各个sprite之间。)调用函数时使用下列入参：

        `old`
            旧的Movie对象，如果没有播放影片则为None。

        `new`
            新的Movie对象。

        Movie对象中的 `play` 参数值如果为 ``_play`` ，则 ``channel``、``loop``、``mask`` 和 ``mask_channel`` 字段则与同名参数一一对应。

        如果想要使用 :func:`renpy.music.play()` 在指定的通道启动影片播放的话，带上synchro_start=True。最小化实现代码如下：

        ::

            def play_callback(old, new):

                renpy.music.play(new._play, channel=new.channel, loop=new.loop, synchro_start=True)

                if new.mask:
                    renpy.music.play(new.mask, channel=new.mask_channel, loop=new.loop, synchro_start=True)

    `loop`
        若为False，不会循环播放影片。如果 `image` 已定义，影片播放结束后将显示对应图片。否则，影片播放结束后将变成透明画面。

    `group`
        若不是None，此入参应该是一个字符串。当某个影片还未开始播放时，
        如果前一帧同组的其他影片还处于播放状态，那就会把前一帧的画面作为当前影片的初始画面。
        该功能用于避免影片切换时导致的透明闪烁。

    `keep_last_frame`
        若为True，在影片播放结束后，将显示最后一帧画面，而不是隐藏影片。前提需要把 `loop` 设置为False。
        (`group` 设置为非None值后也能生效。)
