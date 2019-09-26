.. _full-changelog:

==============
完整变更日志
==============

.. _renpy-7.3.3

7.3.3
=====

.. _audio-7-3-3:

audio
-----

当前版本Ren'Py新增 ``audio`` 目录，在 :ref:`audio命名空间 <audio-namespace>` 中自动根据文件名定义音频名。
如果有个音频文件 ``game/audio/overture.ogg`` ，可以在脚本中直接播放：

::

    play music overture

新增类 :func:`AudioData` ，可以让创作者在Ren'Py中直接使用压缩音频数据，而不再需要使用其他程序预处理。
为实现这个功能，Ren'Py引入了Python的wave和sunau模块。


单声道音频文件混音的一个问题已经修复。该问题可能会导致很多WAV文件无法播放。
(我们始终不推荐使用WAV文件。)

.. _playform-7-3-3:

平台
--------

鉴于苹果公司的条款要求，Mac版的Ren'Py重建为一个未签名的二进制程序。现在需要按住ctrl并点击renpy.app程序，然后选择“打开”才能启动Ren'Py。

对安卓的版本要求降低为Android 19(Android 4.4 KitKat)。

Ren'Py的web端口有一些变更：

* :ref:`Screen variants <screen-variants>` 可以检测配置和进行设置。
* 全屏功能提升，尽管用户可能需要点击对应选项才能启用全屏。
* 关闭web页面的动作可以被检测到，并保存持久化数据。
* 原先默认生成的‘game.zip’文件名可以修改。在index.html文件中的‘DEFAULT_GAME_FILENAME’配置项控制该项。
* 针对移动设备的HTTP请求(原生+renpyweb)：详见 https://github.com/renpy/renpyweb/blob/master/utils/asyncrequest.rpy
* 启用Python的web端口用作测试WebSocket，可以使用Python的‘socket’模块监测端口。
* HTTP缓存控制功能，允许游戏更平滑更新。
* 引入pygame.draw模块，支持Canvas绘图板。
* 提升WebGL兼容性。

.. _other-changes-7-3-3:

其他变更
-------------

在进行重写GL项目时，我们发现在7.3.0版的性能下降问题，原因在于framebuffer对象的切换。
修改了FBO的使用方法后，Ren'Py性能得到了提升。

:func:`renpy.input` 函数可以接收界面的名称，用于用户输入的提示语。

使用界面语言创建的列表、字典和集合可以正确解析。这可以让更多可视组件可以解析为常数，提升界面性能。

回滚时隐藏通知界面。

NVL模式界面默认显示对话窗口，防止 ``windows show`` 语句已生效导致的问题。

在一个多段语句(比如对话中的菜单)中，当使用 `from_current` 将 :ref:`Call` 设置为True 时，主控流程将恢复为多端语句的第一段(这样才能显示对话内容)。

更多函数使用图像标签(tag)的默认图层。

新增 :func:`renpy.is_init_phase` 函数。

当对话内容是menu语句的一部分时，自动语音功能也可以生效。

移除对GLES1的支持。(多年没用的东西了。)

:func:`SelectedIf` 和 :func:`SensitiveIf` 动作(action)可以支持将其他动作作为入参。

很多条值(BarValue)可以使用一个 `force_step` 入参，强制将某个条(bar)的值调整为最接近的某个档位(step)值。

:func:`Frame` 支持tile入参是一个整数字符串，该整数表示frame中tile图像的重复次数。

.. _translationw-7-3-3:

多语言支持
------------

韩语和西班牙语更新。

.. _renpy-7.3.2

7.3.2
=====

.. _fixes-7-3-2:

修复
-----

在上个版本中的平台变量后退问题已修复。

.. _translations-7-3-1:

多语言支持
------------

更新西班牙语的支持。

.. _renpy-7.3.1:

7.3.1
=====

.. _changes-7-3-1:

变更
-------

描述文本(descriptive text，为视力受损人群设计，在开启自动语音的情况下显示并描述场景信息)功能更新。
描述文本的角色改为使用 ``alt`` (原先的 ``sv`` 角色作为别名)。还可以使用定制角色显示描述文本，而不仅限于旁白。

当前版本Ren'Py每次都会初始化媒体播放系统，这样无声视频也可以正常模仿。

大多数可视组件中，用作选择默认获取焦点的可视组件的 `default` 特性，重命名为 `default_focus`，避免与 ``default`` 语句发生冲突。
该特性值是一个整数，值最大的可视组件获得焦点。

可视组件 :func:`Flatten` 会从入参 `child` 获取坐标。。

使用renpy.random.Random并带种子的随机数生成器支持回滚。

模拟安卓或iOS系统时，运行平台的配置变量(例如renpy.android、renpy.ios、renpy.windows和renpy.mobile)将被正确设置。

当前版本Renpyweb创建存档文件时会存储日期和时间。

.. _fixes-7-3-1:

修复
-----

当前版本修复了一个很重要的问题，该问题可能会导致界面内插(interpolate)文本不更新或更新出错。

当前版本的图像预加载规则将根据图像预加载进程运行。

修复了一个与 {clear} 文本标签相关的问题。

在很多情况下，配置项 :var:`config.end_game_transition` 无法正常运行的问题已经修复。

.. _translations-7-3-1:

多语言支持
------------

对俄语、汉语和西班牙语的支持更新。

.. _renpy-7.3.0:

7.3.0
=====

Renpyweb
--------

由于Sylvain Beucler的贡献，当前版本Ren'Py可以生成HTML网页平台版本。所有支持WebAssembly的主流web浏览器都可以运行HTML版的Ren'Py项目。
HTML网页版会下载整个游戏再运行，所以适合做一些小型项目或大型项目的演示版本。
Web版目前标记为beta测试版，web平台本身存在很多问题(最明显的就是单一线程)，所以加载较大图片时会导致音频卡顿。
所以，在其他平台运行良好的Ren'Py项目，在web端运行可能运行很糟糕。
我们将随着Web浏览器一起改进，目标是最终移除beta标志。
在Ren'Py启动器点击“Web”按钮就可以生成一个工程的Web版本。当前版本的启动器还附带一个小型Web服务器，配合Web浏览器就能进行测试。

.. _cds-7-3-0:

创作者定义语句(CDS)
--------------------------

Ren'Py中的创作者自定义语句(creator-defined statement)和使用这些语句的Lexer对象，在多处进行了扩展并提升了功能。
相关语法如下：

* 现在可以要求Lexer对象将某一行代码作为一条Ren'Py语句或一个Ren'Py的语句块处理。

* 可以要求Lexer捕获错误，便于将报错范围限定在创作者定义语句(CDS)内，而不是整个CDS。

:func:`renpy.register_statement` 函数有新的入参，对应新功能。

* 在预加载语句中使用 `predict_all` 和 `predict_next` 两个入参，可以控制预加载所有后续所有语句，亦或每次只预加载下一条可用语句。


* 新增的 `post_execute` 入参可以让我们指定下个语句(通常是CDS语句后面那句)运行时执行某个函数。
  当语句运行并执行内部的语句块时，还可以使用一个表达式，执行某些工作然后退出时执行清理。
  (举个例子，某个脚本标签接到一个消息事件并执行后，跳转回原来的调用点。)

* 新增的 `post_label` 入参可以让我们指定一个脚本标签名，并在CDS执行完跳转到对应的脚本标签，功能类似调用 ``from`` 语句。

当前版本Ren'Py会将CDS语句的处理结果缓存在 .rpyc 文件中。这样设计可以运行更加复杂的语法，执行效率也会提升。
同时这也意味着，如果修改CDS处理函数时，可能需要执行强制重新编译。

.. _screen-language-improvements-7-3-0:

界面语言提升
----------------------------

当前版本可以引用界面语言可视组件的语句中应用 ``as`` 分句。
在拖拽组件中这点非常实用，可以让界面捕获到拖拽对象并需要时调用对应方法。

``on`` 语句可以使用支持一个事件消息列表。

界面(screen)新增了 `sensitive` 特性。这个特性决定该界面是否可以发生互动。

在界面语言中，如果某个Python语句后面带有不正常的特性名时，当前版本的Ren'Py会生成一个错误。(虽然很少见，但这往往是一个语法错误。)

.. _text-improvement-7-3-0:

文本提升
-----------------

当前版本Ren'Py支持自闭合的自定义文本标签(tag)，这是不需要成对闭合标签的 :ref:`自定义文本标签 <custom-text-tags>` 。

当前版本Ren'Py支持三种新的表示，可以用于格式化文本：

* "[varname!u]" 强制文本大写。
* "[varname!l]" 强制文本小写。
* "[varname!c]" 强制首字母大写。

.. _android-ios-improvements-7-3-0:

安卓和iOS提升
----------------------------

当前版本Ren'Py会在支持的设备上使用Framebuffer对象。因此，安卓和iOS设备上运行时配置项 :propref:`focus_mask` 会生效。

当前版本Ren'Py将为安卓生成64位的arm二进制文件。这是Google Play商店将在今年晚些时候执行的强制要求。

安卓上文本输入的功能再次重写，修复了用户卡输入的问题。
Completion was eliminated, as it was the source
of the problems. While languages that require input methods will need
a larger rewrite to function, Ren'Py should now properly handle all direct
input keyboards.

.. _translations-7-3-0:

多语言支持
------------

Ren'Py启动器和样例工程已由Arda Güler翻译为土耳其语。

Ren'Py教程工程已由Moshibit翻译为西班牙语。

法语、韩语、俄语和西班牙语均有更新。

.. _other-improvements-7-3-0:

其他提升
------------------

``side`` 可视组件的子组件渲染顺序调整，将根据在控制字符串中的顺序进行渲染。

``say`` 语句、 ``menu`` 语句和 ``renpy.call_screen`` 语句新增入参 `_mode` ，可以用来指定语句执行时的运行 :ref:`模式 <modes>` 。

函数 :func:`renpy.show_screen` 和 :func:`renpy.call_screen` 可以使用入参zorder。

当前版本Ren'Py播放单声道音频文件时，音量将与双声道音频文件一致，而不再是音量减半。

新增的 :var:`config.load_failed_label` 将指定一个脚本标签(label)，当Ren'Py读取存档失败时自动跳转。因为在读档失败时不能定位到当前语句。

这个新函数可以实现游戏的自动恢复机制。

新增配置项 :var:`config.notify` ，可以拦截系统通知消息并使用自己定义的内容。

:var:`config.say_attribute_transition_callback` 的接口已做兼容处理，同时接受新旧两种标签。

.. _fixes-7-3-0:

修复
-----

Ren'Py丢失某些字符的问题，特别是阿拉伯语中设置为强调色部分，已经修复。

内部使用的OpenDyslexic字体文件已变更，解决直接复制游戏可能出现的问题。

.. _renpy-7.2.2:

7.2.2
=====

在此版本中，Ren'Py新增了一个辅助菜单，打开方式为按键盘“a”键。
该菜单面向玩家开放，让玩家可以覆盖游戏字体，修改文本大小和启用自动语音。

在此版本中，Ren'Py将允许覆盖公共game目录(/mnt/sdcard/Android/`package`/files/game)内容。
该功能出现在7.2.0版本的功能列表中，但当时还无法正常运行。

在此版本中，Ren'Py支持say语句中的临时图像属性(attribute)，应用于多语言支持(translation)。

上传到itch.io时，Ren'Py会自动下载butler模块。这表示现在上传时不需要安装独立的Itch应用程序，而之前的版本是需要的。

各种条(bar)值对象，包括 :func:`DictValue` ，:func:`FieldValue` ， :func:`VariableValue` 和 :func:`ScreenVariableValue`
都可以使用新增的 `action` 参数。该参数对应一个在值发生改变时，执行的某个动作函数(action)。

回滚系统优化，减少了GC数量。

.. _renpy-7.2.1:

7.2.1
=====

.. _ios-improvements:

iOS版提升
----------------


现在Ren'Py生成iOS版工程时，会设置iOS应用的版本字段。

从此版本起，Ren'Py将搜索ios-icon.png和ios-launchimage.png文件，使用合适的尺寸用作iOS版本的图标和启动图像。

.. _other-improvements:

其他提升
-------------------

当读档后立刻使用回滚，:func:`renpy.in_rollback` 函数将返回True。可以使用下面的脚本：

::
    python:
        if not renpy.in_rollback():
            renpy.run(ShowMenu('save'))

实现在初始化阶段就显示存档菜单，而不用等到读档或回滚。

新增配置项 :var:`config.say_attribute_transition_callback` ，可以选择say语句的基础转场效果。

新增环境变量 ``RENPY_SEARCHPATH`` ，可以覆盖启动参数 :var:`config.searchpath`。

.. _fixes-7-2-1:

修复
-----

Ren'Py自身代码经过一轮审核，确保运算符 == 和 != 匹配，无论 == 是否被重定义过。

使用 ``add`` 语句在界面中添加变换(transform)时可能出现的问题，已经得到修复。

``extend`` 语句处理入参的机制发生改变，确保较新的入参优先级高于 ``extend`` 之前的say语句中的入参。

当前版本Ren'Py在判断动态图像(dynamic image)是否相等时会考虑作用域。这个改动也修复了界面中某些动态图像不更新的问题。

macOS上 :var:`config.save_dump` 的值为True时导致崩溃的问题已经修复。

:var:`config.profile` 的值为True时导致崩溃的问题已经修复。

安卓平台显示数字键盘时，Ren'Py明确要求文本(而不是邮箱地址、密码和电话号码等)输入。

某些menu语句导致前向滚动无法运行的问题已经修复。

.. _renpy-7.2.0:
.. _renpy-7.2:
.. _renpy-7.1.4:

7.2
===

.. _menu-arguments-7-2:

菜单入参(menu arguments)
-------------------------

Ren'Py现在已支持 :ref:`菜单入参(menu arguments) <menu-arguments>`。
入参可以传给整个菜单，或者菜单内的某些选项，语法如下：

::

    menu ("jfk", screen="airport"):

        "伊利诺伊州，芝加哥" (200):
            jump chicago_trip

        "德克萨斯州，达拉斯" (150, sale=True):
            jump dallas_trip

        "阿肯色州，温泉城" (300) if secret_unlocked:
            jump hot_springs_trip


除了 `screen` 入参选择对应界面，`nvl` 入参选择NVL模式菜单，其他传入菜单的入参会应用在界面上。传给菜单选项的入参会应用在菜单界面的所有元素。

.. _temporaty-say-attributes:

临时性say语句
--------------

Ren'Py现在支持临时性say语句。用法与普通say语句相同，可与普通say语句混用。
临时性say语句中的设置的各类属性(attribute)，在语句执行完后将恢复为上一条语句的状态。
比如下面这段脚本：

::

    show eileen happy

    e "我很开心。"

    e @ vhappy "我真的很开心！"

    e "我还是很开心。"

对话中的第一行和最后一行，Eillen将使用happy表情。对话的第二行中，Eileen将使用vhappy表情。

.. _changes-7-2:

变更
-------

新增 ``window auto show`` 和 ``window auto hide`` 语句，可以在显式展示和隐藏对话窗口后，保持 :ref:`自动对话窗口管理 <dialogue-window-management>` 有效。

:func:`Preference`(“display”，“window”)` 现在可以避免创建比整个界面更大的窗口。
在 :func:`gui.init` 中配置的窗口最大尺寸就是上限。

:ref:`创作者定义的语句 <cds>` 新增了几个语法分析器方法，可以处理入参、图像命名的组件、脚本标签(label)和使用特定分隔符的Python代码。

:func:`renpy.force_autosave` 函数新增一个入参，可以防止自动存档未完成的情况下再次强制自动存档。

:ref:`点击继续界面 <ctc-screen>` 新增一些参数。

放置文本型对象时， :propref:`yanchor` 特性(property)的值可以是 renpy.BASELINE。设置为该值时，锚点就会设置为文本第一行的底线(baseline)。

新增的图像操纵器(image manipulator) :func:`im.Blur` 可以模糊图像。感谢大佬Mal Graty的贡献。


层叠式图像(layeredimage)组支持 ``multiple`` 特性(property)，允许在同一个组内同时使用多个图像属性(attribute)。
这是个很实用的功能，可以让一组自动定义的函数应用在很多不冲突的图像上。

(有多个显示设备时)当鼠标切换到不同的桌面时，Ren'Py会保持全屏。在重新最大化窗口的加载过程中不再会出现抖动现象。

:var:`config.allow_duplicate_labels` 配置项可以定义或设置一段init python代码，然后允许游戏内出现重复的脚本标签(label)。

可视组件 :func:`Movie` 可以设定循环或不循环，并在停止循环播放后显示关联的静态图像。
还可以在影片播放之前显示某个指定的图像。

.. _android-changes-7.2:

安卓平台变更
---------------

安卓SDK的下载更新。修复工具无法下载的问题。

针对键盘制定了一个显式动作函数，确保回车键(enter)正常。

当使用sideload模式安装在亚马逊的设备时，Ren'Py使用亚马逊的支付API，可以使用“双商店”APK进行支付系统测试。

Ren'Py现在可以使用公共游戏目录(/mnt/sdcard/Android/`package`/files/game)，前提是在游戏中定义好使用的目录。

.. _fixes-7-2:

修复
------

使用dissolve效果时界面底部会出现一条不透明的黑色或灰色线，这个bug已经被修复。

对imagefont字体的支持问题已修复。

从启动器导航菜单创建新文件的功能已经可以运行。

菜单集功能再次有效。

当 :func:`Function` 和其他动作函数被传入不兼容的数据类型时，Ren'Py不会挂死。

某个情况下前向滚动失败的问题已修复。

MacOS上Steam消息无法正确显示的问题已修复。

.. _renpy-7.1.3:

7.1.3
=====

这个版本是相当于7.1.2的再次发布，只修复了一个bug。那个bug是在测试版本残留的问题，会导致在初始启动阶段就设置 :var:`config.default_language` 的值。

.. _renpy-7.1.2:

7.1.2
=====

.. _7.1.2-improvements:

功能提升
------------

Ren'Py的界面语言现在支持包含匿名的ATL变换(transform)。比如现在可以这样写：

::

    screen hello_title():
        text "你好。":
            at transform:
                align (0.5, 0.5) alpha 0.0
                linear 0.5 alpha 1.0

新增的 :func:`SetLocalVariable` 和 :func:`ToggleLocalVariable` 动作函数，可以用来设置界面使用的变量。


新增的 :var:`config.menu_include_disabled` 配置项，决定菜单是否应该包含可由if分句禁用的入口(entry)。

在安卓模拟器模式中可以使用Shift类组合键(比如Shift+I和Shift+R)。

在文本标签(tag)需要一个值却没有提供的情况下，Ren'Py提升了报错信息。

新增的 :var:`_version` 配置项标识游戏在创建时的版本号。这个值仅仅存储创建时定义的版本号。后续是否更新取决于创作者的需求。

可视组件 :func:`Movie` 添加一个新的模式，让同一个文件内的色彩数据和alpha mask数据按边对齐。
这个模式防止main影片与mask影片出现不同步的问题。

:func:`FilePageNext` 和 :func:`FilePagePrevious` 函数可以通过入参控制，是否可以将玩家带入自动或快速存档页。

新增的 :var:`config.skip_sounds` 配置项决定Ren'Py是否跳过非循环播放的音频文件。

.. _7.1.2-translations:

多语言支持
------------

现在Ren'Py能够自动检测使用者系统中的地区，并设置相应的语言。
详见 :var:`config.enable_language_autodetect` 和 :ref:`多语言支持 <translation>` 部分文档。

德语部分更新。

.. _7.1.2-fixes:

修复
-----

修复了一个Windows平台的bug。这个bug仅在使用阿拉伯语和希伯来语时出现(译者注：就是说中文用户不用管，所以这也不按原文翻译了)。

如果读取某个图像(image)时，发现完全匹配图像名的图像不存在，但相同前缀(prefix)的图像存在时，现在Ren'Py会报一个错误(error)。在这次修改之前，如果图像eileen happy而要显示eileen happy unknown时，那个unknown属性(attribute)会被忽略。

Lint工具功能提升，能够处理带属性(attribute)的非同名图像，比如层叠式图像(layerd image)。

Ren'Py会生成适合手机显示的选项菜单图像。


.. _history-7.1.1:

7.1.1
======

.. _history-fixes-7.1.1:

历史记录方面的bug修复
-----------------------

这个版本解决了Ren'Py中“历史”界面的一个问题(issue)。这个问题的触发条件是，一行对话中出现不成对的方括号，比如：

::

    "I [[think] I'm having a problem."

出现这种情况时，字符串“I [think] I'm having a problem.”会添加到历史记录中。如果Ren'Py中显示这段历史记录，并尝试内插 ``think`` 变量，就会挂掉。


新版本的修复办法是，在历史界面中添加了 ``substitute False`` 的情况。这个办法只对新建的项目有效。
之前已经存在的老项目，创作者只能自己修复了。
下面是一个新的历史界面定义：

::

    screen history():

        tag menu

        ## 因为历史界面可能很大，所以不预加载界面。
        predict False

        use game_menu(_("History"), scroll=("vpgrid" if gui.history_height else "viewport"), yinitial=1.0):

            style_prefix "history"

            for h in _history_list:

                window:

                    ## 如果history_height的值是None，就使用自适应布局。
                    has fixed:
                        yfit True

                    if h.who:

                        label h.who:
                            style "history_name"
                            substitute False

                            ## 如果对应角色的文本颜色有单独设置，就获取设置的文本颜色。
                            if "color" in h.who_args:
                                text_color h.who_args["color"]

                    $ what = renpy.filter_text_tags(h.what, allow=gui.history_allow_tags)
                    text what substitute False

            if not _history_list:
                label _("The dialogue history is empty.")


新的历史界面定义中包含一行 ``substitute False`` 。创作者可以在自定义的历史界面中添加这行，避免上面提到的程序卡死问题。

.. _changelog-android-improvements:

安卓版本的提升
--------------------

现在Ren'Py分配给安卓发布工具的内存总量增大到1.5GB，也就是谷歌套件中的默认值。为了确保创作者具有发布更大游戏的能力，请确认电脑上安装了64位版本的Java 8。

Ren'Py明确要求安卓系统，将软键盘的“回车(Enter)”键作为一次输入的结束。

现在Ren'Py在安卓8(Oreo)以下版本中将剪裁和重新调整app图标(icon)的尺寸。

Ren'Py生成x86_64版本的apk时，会使用一个不同的版本号数字。这样就可以同时让适配x86_64和armeabi-v7a处理器的发布包上传到Google Play或其他应用商店里，
这样就不需要每次分别生成一个apk并手工修改名称。

.. _7.1.1-other-improvements:

其他提升
---------

现在Ren'Py会自己处理0字宽的字符绘制问题，防止不支持0字宽的字体依然会被绘制在屏幕上的情况出现。

Ren'Py支持非断行空格和0字宽非断行空格字符，防止文本中的图像空间被挤占。

Ren'Py支持 :func:`Character` 对象中 `ctc_position` 参数的一种新值“nestled-close”。
使用该值可以防止“点击继续”型标志和其他行之间出现断行。

(拖放组件中的)Drags类现在支持变换的点击事件。(桌面电脑的鼠标右键点击和触控平台的长按操作。)


.. 7.1.1-fixes

修复
-----

函数 :func:`SetVariable` 和 :func:`ToggleVariable` 入参类型已经扩展，可以接受命名空间加字段形式。
所以现在可以使用类似 ``SetVariable("hero.strength", hero.strength + 1)`` 或 ``ToggleVariable("persistent.alternate_perspective")`` 这样的写法。

对话窗口自动管理(使用 ``window auto`` 语句启用)是指，当游戏内菜单有关联的对话或标题时，会自动调整布局和尺寸。

Ren'Py生成程序时必须的fribidi内嵌版本源代码已经包含在 -source 归档中。

还有一些语音支撑方面的修复点，优化了对历史记录和语音回放功能的支持。

.. _renpy-7.1:

7.1
===

.. _7.1-android:

安卓
-------

这个版本重点重新编写的Ren'Py对安卓平台支持，以适应现在移动端的需求。
这样Ren'Py游戏可以在Google Play商店上架。某些变更可能需要创作者更新游戏内的某些文件。
特别需要注意的是，icon图标格式已经改变，所以icon图标需要重新制作。

Ren'Py运行要求的最低安卓版本号已经提升至安卓19(aka 4.4 KitKat)，最佳运行版本为安卓28(aka 9 Pie)。

(译者注：这里的安卓19和安卓28是指安卓的API级别。每个API级别对应一个安卓版本号，例如LEVEL 19对应的是安卓4.4系统，LEVEL 28对应的是安卓9.0。)

添加了x86_64结构，原有的x86已经删除。(某些x86设备可以通过二进制转义层运行arm平台版本。)

.. _changelog-monologue-mode:

独白模式
--------------

现在使用3个双引号，可以直接在脚本中写大段的对话或旁白。例如：

::

    e """
    这是一段对话。

    而这是第二段。
    """

这将创建两端对话。详见 :ref:`monologue-mode` 。

在独白中还可以使用新的文本标签(tag)——{clear}。
当{clear}标签单独占一行时，作用相当于 ``nvl clear`` 语句。详见 :ref:`NVL独白模式 <nvl-monologue-mode>` 。

.. _say-with-attribute-change:

带属性的say语句变更
-------------------------

带属性的(attribute)的say语句中，如果对应标签(tag)的图像不存在，处理机制有所变化。
以前，Ren'Py会使用名图像，并且最近带属性的say语句中的属性，以及显示那个属性对应的头像(side image)。

现在，Ren'Py会根据提供的属性和已存在的属性决定显示的头像。这个特性使得带属性的say语句以同一个工作机制实现显示或不显示图像。
当某个属性(attribute)对应的头像并非唯一时，Ren'Py会根据所有给定的属性，选用存在的属性中最有可能的图像作为头像。

这项改动主要是为了方便使用层叠式图像(layered image)作为头像，这样只需要选用不同的图像属性(attribute)就可以改变头像。

.. _updater_changes:

更新器变更
---------------

现在Ren'Py每次更新时，更新器会提示使用者选择更新渠道。这个设计意在让使用者确认每次更新使用哪个渠道，
这样就不会意外更新为某个预发布或nightly版本。

你可能会发现，有时并找不到预发布版本的更新。这是正常的——与之前的版本不同，只有存在可用的预发布版本的更新渠道才会出现。

.. _7.1-translations:

多语言支持
------------

Ren'Py启动器(launcher)、模板游戏和The Question的脚本，已经由Muhammad Nur Hidayat Yasuyoshi翻译为马来语。

韩文也已更新。

现在RAPT使用的字符串也可以翻译为非英语的其他语言了。

.. _7.1-other:

其他
-----

现在Ren'Py可以在游戏退出时使用可靠的方法自动存档。(相比之前版本要可靠，原来的自动存档可能会失败或陷入死循环。)
这个特性由配置项 :var:`_quit_slot` 控制。

文件行为函数(比如 :func:`FileSave`， :func:`FileLoad` 和 :func:`FileAction` )现在可以使用一个 slot=True 入参。
当这个入参存在时，行为函数会加载一个已命名的槽位，而不需要进入存档页面。

开发者菜单(使用快捷键Shift+D)现在会显示一个界面，能够展现已显示和已隐藏图像的相关属性。

添加了函数 :func:`renpy.transform_text` ，该函数可以将不带触控文本标签或文本内插的文本执行变换(transform)操作。

现在使用Gallery对象的make_buttons方法创建的按钮(botton)现在继承空的样式(style)，而不再是按钮样式。
这样预防了按钮样式的某些特性(property)导致的故障。

现在，点击鼠标时，结束文本显示的代码通过事件消息(event)方法调用。
这样，菜单显示状态下时就不会因为鼠标点击而结束互动行为。

处理imagebutton和image map的自动图像时，支持可视组件的前缀名。

之前的版本中，在NVL模式下如果某个NVL模式语句后面跟着另一个NVL语句，并且后面的语句中含有某个未定义的角色名，运行会出现一个错误(error)。
现在这个bug已经修复。

当两个ATL变换(transform)嵌套时，使用变换的语句会同时实现两个变换效果，而不只是嵌套在外层的变换。

Ren'Py用于window、bar和frame的动态图像(dynamic image)已更新。(以及所有由可视组件派生出的对象，比如按钮和imagemap。)

当模态框(modal)状态置为True时，Ren'Py会将某个内核资源占用100%的问题(issue)已经修复。

Ren'Py现在已经包含了一份fribidi的拷贝，而不再使用操作系统中安装的版本。

(译者注：某些语言文字的书写打印是从右往左顺序进行的，当这些文字中出现其他字符，比如阿拉伯数字、英语单词等，又需要保持从左往右的打印顺序。fribidi是针对这种双向打印需求提供的库。)

如果配置了 :propref:`box_wrap` ，就可以使用新增的配置项 :propref:`box_wrap_spacing` 控制行间距和列间距。

配置项 :propref:`adjust_spacing` 的样式特性现在可以使用“horizontal”和“vertical”这两个值了。
设置为这两个值后，就可以指定只在水平或垂直方向调整间距。

LayerdImageProxy现在可以使用内插字符串。

开始游戏或者进入一个新的上下文(context)，比如一个菜单上下文时，会调用新增的配置项 :var:`config.context_callback` 。
这个配置可以用于进入那个上下文时，停止语音和音效的播放。

可视组件  :func:`Drag` 新增  `activated` 特性。这个特性是一个回调函数，当用户首次在某个可拖拽(drag)组件时被调用(在组件移动之前)。

.. _renpy-7.0:

7.0
===

自从Ren'Py 6带来ATL语言、界面语言、OpenGL和DirectX加速等特性后，到Ren'Py 7.0对安卓和iOS平台的支持、多语言支持、外部平台接入支持(Accessbility)等新功能，Ren'Py引擎的开发已经超过了10年。

6.0版和7.0版之间的变化，可以参看变更日志的其他部分，或者在Ren'Py的网站上查看更老版本的变更日志。这一层的内容是7.0跟6.99.14.3两个版本间的差异。

.. _changelog-layered-images:

层叠式图像
--------------

 :ref:`层叠式图像 <layered-images>` 是使用在Ren'Py中的新定义图像。它设计用于精灵(sprite)，该精灵是通过Photoshop等软件制作出的一系列图层。层叠式图像系统让图像根据属性(attribute)显示不同内容，由Python条件表达式决定显示哪个图层的图像。

层叠式图像用为 :func:`composite`
和 :func:`ConditionSwitch` 的一种替代方案。它使用的语言让定义合成图像更方便。而且Ren'Py可以根据被合适命名的文件，生成对应部分的定义。相比Ren'Py的其他功能，层叠式图像也更优秀。比如属性(attribute)可以预加载，而ConditionSwith却不行。层叠式图像还可以在交互式指导器(interactive director)中使用。

.. _changelog-dict-transitions:

字典转场
----------------

:ref:`字典转场 <dict-transitions>` 可以使用with语句和某些其他函数将转场应用于一个或多个图层。Ren'Py不会在使用这些转场时暂停。字典转场使精灵进行转场的时候也同时显示对话成为可能。

.. _changes-7-0:

变更
-------

现在的Ren'Py中已经不包含旧的教程和模板。不过从旧版本的Ren'Py中复制过来也可以用。

新 :func:`Scroll` 动作可以使按钮改变视口的位置或条(bar)的值。

:func:`Dissolve`、 :func:`ImageDissolve` 和 :func:`AlphaDissolve` 转场现在可以承认源可视组件的alpha通道，就像设置了 alpha=True参数一样。由于忽略alpha通道不再是最优，这种改变允许在更多地方使用相同的转场。

自动图像定义现在可以在init level 0级别运行，而不是原来的init level必须大于999。这个改动允许 :func:`renpy.has_image` 函数能在初始化语句块(block)中使用。

交互式指导器(interactive director)现在多了一个按钮，允许创作者选择显示在界面的顶部还是底部。

:ref:`界面语言的for语句 <sl-for>` 声明现在需要一个index子句::

    for i index i.name in party:
        ...

当被提供时，它应该返回一个唯一的值，该值可以像按钮地图信息和转换状态其来源的对象。

现在有可选的上标文字，允许两种不同的上标文字同时显示。(比如翻译和注音。)

新的 :ref:`可视组件前缀 <displayable-prefix>` 系统可以定义你自己的可视组件，组件可以用字符串访问，这与图像，图像文件和solid具有的字符串形式相同。

Ren'Py现在支持创建具有单个文件的.zip文件(例如.rpa文件)大于2GB。这需要使用Zip64标准，在某些平台上可能不支持解压缩这种文件，最需要注意的是Windows XP。

新的 :func:`renpy.get_hidden_tags` 函数返回一组标签(tag)，包含隐藏属性，另一个 :func:`renpy.get_showing_tags` 函数则返回一组排列好的标签(tag)。


为了与ATL和其他动画保持一致，第二次显示视频精灵现在将重播视频。

.. _7.0-translations:

多语言支持
------------

Ren'Py 教程和The Question示例现已支持法语，感谢 Alexandre Tranchant。

对日语和俄语的支持更新。

.. _fixes-1:

修复
-----

当界面不显示时，处理hide和replace事件消息导致的界面无法恢复问题已经修复。(这种情况会在用户跳过游戏时出现。)

在交互式指导器(interactive director)中使用默认语言(英语)时，偶尔会切换为俄语的问题已经修复。

可视组件 :func:`Composite`、 :func:`Crop` 和 :func:`Tile` 分别对应各自的新名称。

接入控制台时，Ren'Py回滚位置不正确的问题已经修复。那个问题会导致控制台显示不正确的数据，不过仅限于控制台自身的数据。


.. _renpy-6.99.14.3:

6.99.14.3
=========

.. _changes-6-99-14-3:

变更
-------

可视组件 :func:`AlphaMask` 将其遮罩(mask)放入其子可视组件，与AlphaDissolve的处理方式相同。
这样改动后，允许mask参数通过使用ATL或其他变换(transform)创建。

几个过时的图像操纵器已被弃用，并从文档中删除。这些是已被 :func:`Transform` 完全取代的图像操纵器。

重命名了一些函数，删除了“Live”前缀。

* LiveComposite现在是 :func:`Composite`
* LiveCrop现在是 :func:`Crop`
* LiveTile现在是 :func:`Tile`

原有的函数名已保留作为兼容的别名。

.. _fixes-2:

修复
-----

这个版本修复了一个问题：界面内for语句的子组件不应该在界面更新循环中增加自身的数据。
这个问题出现在比较复杂的场景中，比如循环的转场(transition)或慢速文本(slow text)无效的时候。

该版本可以使用选择的颜色显示最新的存档槽位，如果有需要使用的话。
这个功能直接会应用在新创建的游戏中。旧工程可以在gui.rpy底部添加如下代码实现更新：

::

    define gui.slot_button_text_selected_idle_color = gui.selected_color
    define gui.slot_button_text_selected_hover_color = gui.hover_color

6.99.14.2引入的，在回滚之后default语句无法工作的故障，也已经修复。
这个故障仅对首次存档后的游戏有影响。

.. _renpy-6.99.14.2:

6.99.14.2
=========

.. _features-and-changes:

特性和变更
--------------------

Ren'Py现在支持Atom文本编辑器。选择了Atom文本编辑器后，Ren'Py会下载Atom，安装language-renpy、renpy-dark-syntax和renpy-light-syntax的Atom插件，并创建一个新的profile文件。
使用这些新的默认设置能让Ren'Py变成更轻松。

现在还支持在对基于图片的字体使用下划线。

当某个界面使用默认的GUI滚动设置时，PageUp和PageDown按键能直接滚动界面。(这个功能仅在新创建的工程上生效。)

可视组件 :func:`Movie` 现在使用play_callback入参。这个入参指定了一个函数，调用这个函数就能播放一段影片。
这个函数能处理的东西包括，在通常循环播放的视频前面加一个转场影片，让转场更平滑。

新的 :func:`renpy.get_say_image_tag` 函数可以重新获取(retrieve)发言角色的名字。

ATL的interpolation语句现在可以在多行的变换(transform)中同时执行，并且都不消耗时间。

向call语句添加一条from语句不再修改多语言支持(translation)的标识符。(这个标识符也用于自动语音的编号。)
由于这是一个重大改变，Ren'Py在遇到旧式的多语言支持标识符时会进行重新计算并使用。

仅当可以定位到单个可视组件时，才调用_choose_attributes方法。这个方法支持AttributeImage beta(https://github.com/renpy/ai)。

新的 :var:`gui.button_image_extension` 配置项允许按钮(button)图片使用.webps文件。

.. _changelog-self-voicing:

自动语音
------------

Ren'Py的自动语音模式，针对视觉障碍用户的功能又进行了提升：

* 选择按钮之后会在后面加上单词“selected”。
* 选择条(bar)之后会在后面加上单词“bar”。
* 一些拥有自身自动语音信息的动作在新版GUI中提升了效果。
* Ren'Py内建的ALT文本实现多语言支持(translation)。

由于改变了自动语音的输出，这个变更应该不会对已存在的支持语言生效。

.. _fixes-3:

修复
-----

在无存档游戏中存档或自动存档导致的脏数据问题，已经被修复。

Python的hide语句现在可以运行在python函数上下文(context)中。
某个结构(像生成器表达式)编辑hide语句，并能正确运行。

全局脚本标签(global label)的表现与文档描述一致。

自定义鼠标归位导致的鼠标指针乱跳问题已经修复。

显示菜单后依然显示头像的问题已经修复。

某个界面被替换后，Ren'Py不再存储原界面内不显示的可视组件的状态。
(如果第一个界面再次显示，那些可视组件会获取旧的状态，这可能会导致出现问题。)

show和replay事件消息现在总是会传送到界面内的变换(transform)。界面显示时总是需要广播那两类事件消息。之前的缓存可以阻止某些show事件的广播。

可以按住alt键输入字符了。(在某些欧洲语言中有些特殊字符必须要按住alt键才能输入。)

当安卓包生成系统重命名文件或目录失败时，会在60秒内重试，才会放弃。这段时间主要用于处理Windows平台赛门铁克杀毒软件的问题。


.. _renpy-6.99.14.1:


6.99.14.1
=========

图像预加载和缓存
----------------------------

将一个图像转换为纹理(texture)时，现在Ren'Py会搜索不透明像素的包围盒(bounding box)。
当 :var:`config.optimize_texture_bounds`
配置变量为True(也就是默认值)时，只有不透明像素会存储到图像缓存中。
这样可以明显降低某些图像的内存消耗，比如大部分都透明的图层上的图像。

现在 :var:`config.cache_surfaces` 配置项默认值是False。这使得图像缓存对内存大小的要求减半，但让使用同一图像的多个图像操纵器(manipulator)运行速度下降。

现在
:var:`config.image_cache_size_mb` 配置项控制图像缓存的大小，默认值为300MB。新的默认设置里，图像内的每个像素非透明边框占用4byte内存。

以上三点的改变是图像占用的缓存更小，也意味着Ren'Py可以存储更多预加载图像。

Ren'Py在缓存图片和界面时，现在拒绝调用那些从磁盘读取文件的函数(比如
:func:`renpy.image_size`)。那些函数的响应慢，而会引发掉帧。

:func:`ConditionSwitch` 和 :func:`ShowingSwitch` 可视组件有了一个新的“predict_all”参数。当这个参数为True时，预加载所有可视组件，而不仅仅是选中的那个。这个改动可以用于Ren'Py预加载某个精灵(sprite)的所有表情。

:func:`renpy.start_predict` 和 :func:`renpy.stop_predict` 函数现在是可以使用正则表达式通配符。例如：

::

    $ renpy.start_predict("eileen *")

预加载所有开头为标签(tag)“eileen”的图像，出现如下语句：

::

    $ renpy.start_predict("* beach*")

匹配所有带有“beach”属性的图像。

现在F4键可以显示图像加载日志了。

.. _6.99.14.1-other-improvements:

其他改进
------------------

变换(transform)现在有了一个新的 :tpref:`maxsize` 特性，能够将图像缩小到某个范围的方框里。

当Ren'Py重新加载(reload)时，会保留Python表达式缓存，相比原来每次重新加载都unmarshall缓存有明显的性能提升。

track.txt和errors.txt文件现在底部会有一个日期，更容易判断这个文件是否过期失效。

新的 :func:`renpy.list_images` 函数返回所有定义过的图像列表。

Drag组件现在新增了 `mouse_drop` 特性。若这项特性为True，使用鼠标指针坐标选择Drag组件落下的位置，而不是使用overlap最大的Drag组件。

西班牙语版本更新。

.. _other-fixes:

其他修复
-----------

修复ATL“on hide”分句无效的bug。

等待某个界面跳动(flip)时释放GIL(解释器全局锁)，让一些任务(播放音乐、预加载图像、自动存档等)在后台线程运行得更快。

(译者注：请不要纠结GIL是什么。相信我，没错的……)


.. _renpy-6.99.14:

Ren'Py 6.99.14
==============

.. _performance:

性能表现
-----------

为了提升性能，我们做了很多细碎的工作，包括在绝对性能和明显的帧率突刺方面。

当设备接通电源时，Ren'Py会尝试使用固定帧率绘制界面。当设备使用电池时，切换到5fps的帧率前将绘制几帧，确保显示缓存区完成界面的更新。

Ren'Py有一些选项控制显示性能，使用shift+G能进入选项菜单。除了上面提到的GL性能变更之外，这个设计允许用户锁定帧率并接受画面撕裂。
使用运行比较慢设备的用户可能会选择锁定30fps而不是变动的帧率。如果开发者觉得大多数用户都会使用性能慢的设备，可以使用默认语句：

::

    default preferences.gl_framerate = 30

当某一帧渲染时间过长(比如，由于一个未预加载的图像需要从硬盘读取)，Ren'Py会尝试根据设置的帧率展现转场(transition)和可视组件。
这也表示Ren'Py不得不跳帧，并且会从序列中的第一帧之前开始跳帧，而不是从第一帧和第二帧之间开始跳帧。

如果创建了足够数量的对象，Ren'Py自身会在绘制一帧后触发GC。触发GC的对象数量的值提高了。
触发的数量阈值应该已经足够高，只要游戏中没有创建环状的对象引用，就不需要主动要求GC。
(环状的对象引用是指，几个对象互相引用对方，形成一个循环。)我们修改了Ren'Py，可以排除常见的环状对象引用代码。

Ren'Py的GC管理能减少或消除GC对大多数游戏的丢帧影响。不过，也可以把 :var:`config.manage_gc` 设置为False，恢复为之前的调优方法(tune)。

默认情况下，“hide”事件句柄会触发Ren'Py移除临时界面(比如say和choice界面)和可视组件。检查这类句柄的过程系统消耗很大，还好这类句柄很少使用。
将 :var:`config.zap_transients` 设置为False可以把这个配置恢复为之前版本的状态。

现在Ren'Py第一次遇到Python表达式后会编译并缓存起来，而不是原来那样每次遇到Python表达式都重新编译。
这个改动提升了多次复用的根据条件选择显示的可视组件的运行速度。因为这个改动，所有在Ren'Py 6.99.14版本运行的游戏第一次打开时都会变慢，因为所有表达式都需要编译。

这个版本提高了回滚时保留必要信息的速度，以及减少了保留必要信息的次数。用户能体会到的是，现在Ren'Py能回滚到前面更深的地方。

此外当然还有很多性能方面的提升，实际效果都是提升了运行速度。这个版本还只是性能提升的第一战，新的性能分析框架允许Ren'Py开发者进一步提升性能。

.. _changelog-multiple-character-dialogue:

多角色对话
---------------------------

现在Ren'Py包含一个新系统，允许多个角色在同一时间发言。通过在say语句结尾添加multiple入参可以实现这点。举例：

::

    e "Ren'Py now supports multiple character dialogue." (multiple=2)
    l "About time! I've been wanting this for years!" (multiple=2)

由于显示多个角色的对话可以有好几种方式(并排？上下排列？一个还是两个文本框？)，Ren'Py尚不能提供现成的支持方案。
请参考 :ref:`多角色对话 <multiple-character-dialogue>` 章节的内容，查看哪些样式需要创作者定义。

.. _changelog-gui-preferences:

GUI环境设定
----------------

Ren'Py提供了一套新的GUI环境设定系统，替换了原来的样式环境设定系统。新的系统允许从多个样式中引用变量并应用在新的GUI环境设定中。

可以这样写脚本：

::

    define gui.text_font = gui.preference("font", "DejaVuSans.ttf")

加载环境设定，并使用下列脚本：

::

    vbox:
        style_prefix "radio"
        label _("Font")
        textbutton _("DejaVu") action gui.SetPreference("font", "DejaVuSans.ttf")
        textbutton _("Dyslexic") action gui.SetPreference("font", "OpenDyslexic-Regular.otf")

设置环境设定。详见 :ref:`GUI环境设定 <gui-preferences>`。

.. _changelog-tooltips:

Tooltips
--------

Ren'Py中增加了一个新的tooltip系统，替换了原来存在tooltip。在之前的系统中，我们需要这样写：

::

    default tt = Tooltip("No button selected.")

    textbutton "One.":
        action Return(1)
        hovered tt.Action("The loneliest number.")

    text tt.value

现在可以这样写：

::

    textbutton "One.":
        action Return(1)
        tooltip "The loneliest number."

    text GetTooltip()

这个系统意在节省代码和让界面具有更高的可读性。 详见 :ref:`tooltips` 章节。

.. _changes-6-99-14:

变更
-------

全平台支持SSL和TLS。现在允许Ren'Py游戏使用某个Python库的连接，向有安全要求的Web服务器发送请求。支持这点必须在初始化阶段导入(import)对应的Python库。

新的图像操纵器(manipulator) :func:`im.Data` 能根据压缩过的二进制数据创建一个图像(iamge)。原压缩二进制数据可能是从某个Web服务器下载的。

配置项 :var:`config.loadable_callback` 允许脚本向Ren'Py提供需要额外加载文件的信息。

遇到存档时pickle对象发生的故障，Ren'Py会尝试进行诊断，并报告引发pickle故障的对象。(性能表现不错，不过只能捕获一些常见故障。)

如果某个视口(viewport)包含滚动条(scrollbar)，Ren'Py会向其子组件在指定方向上提供一个非常大的空间。这个改动防止在视口(viewport)的可视区域之外绘制可视组件可能导致的故障。

Ren'Py现在解决了样式特性 :propref:`xpos` 和 :propref:`xalign`
之间的歧义，总是偏向于使用xpos。类似的，同一个样式有多个指定样式特性都起效的情况也都解决了。

现在带有脚本标签(label)函数的自定义语句可以返回对应语句的一个自定义脚本标签(label)。这个改动语句自定义语句也可以被jump或者call。

在屏幕使用letterbox和pillarbox显示模式时，新的 config.gl_clear_color 配置项允许创作者设置填充色。

(译者注：letterbox和pillarbox是指原生画面比例与显示设备画面比例不同时，两种处理方法。letterbox指的是16:9的原生画面显示在在4:3的屏幕上，原生画面与屏幕同宽，上下添加黑边；pillarbox正好相反，为4:3的原生画面显示在16:9的设备屏幕上，左右添加黑边。)

(拖放系统中的)drag组件现在支持bottom方法，可以将drag组件沉到drag group的最底层。

最新发布版中新增的 :var:`config.cache_surfaces` 配置项已经添加对应的文档说明。将这项配置为False可以降低Ren'Py的内存消耗，代价是多个图像操纵器(manipulator)处理同一图像的速度下降。(这个情况在现版本的Ren'Py中已经很少见。)

变量和字段(filed)的munge功能(会将开头为“__”的部分改为文件指定的值)，现在可以在字符串替换(substitution)中运行了。

视口(viewport)和vpgrid现在支持pagekeys特性，允许用户使用PageUp和PageDown按键滚动视口。arrowkey特性也包含在文档中。

RAPT现在使用源代码和目标版本1.6来编译Java代码，这使得它可以构建在最新的JDK上。

.. _fixes-4:

修复
-----

编译次数不同导致的界面显示不正确问题已经修复。这个问题仅在同时满足下列条件时出现：

* 工程中里的多个文件都定义了界面(screen)。
* 文件在不同时间编译。(release版游戏不会存在这个问题，因为所有文件都会在生成分发版时同时编译。)

升级到这个发布版的Ren'Py后，可以在启动器中选择“强制重新编译”修复这个问题。这个功能可以解决开发中的游戏的问题。Release版游戏没有必要这么做。

交互式指导器(interactive director)也做了一些提升，可以在更多场景下使用。

在安卓和iOS设备上的资源竞争可能导致Ren'Py锁定(显示空白屏幕)的问题已经修复。这个问题是在6.99.13版本中引入的。

在6.99.13版中，资源竞争会让Ren'Py以小概率完全跳过一段影片的播放。

Ren'Py现在支持AltGr按键。

(译者注：AltGr是某些非美式键盘的按键，等效于Ctrl+Alt组合键。)

Ren'Py现在限制了控制台输出日志大小，防止控制台不显示的情况下打印语句消耗过多内存。


.. _renpy-6.99.13:

Ren'Py 6.99.13
==============


Ren'Py 6.99.13 及更老版本的更新日志，请参考英文原网页：https://www.renpy.org/doc/html/changelog.html#ren-py-6-99-13
