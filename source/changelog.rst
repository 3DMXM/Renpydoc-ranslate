==============
完整变更日志
==============

.. _renpy-7.0:

7.0
===

自从Ren'Py 6带来ATL语言、界面语言、OpenGL和DirectX加速等特性后，到Ren'Py 7.0对安卓和iOS平台的支持、多语言支持、外部平台接入支持(Accessbility)等新功能，Ren'Py引擎的开发已经超过了10年。

6.0版和7.0版之间的变化，可以参看变更日志的其他部分，或者在Ren'Py的网站上查看更老版本的变更日志。这一层的内容是7.0跟6.99.14.3两个版本间的差异。

图层化图像
--------------

 :ref:`图层化图像 <layered-images>` 是使用在Ren'Py中的新定义图像。它设计用于精灵(sprite)，该精灵是通过Photoshop等软件制作出的一系列图层。图层化图像系统让图像根据属性(attribute)显示不同内容，由Python条件表达式决定显示哪个图层的图像。

图层化图像用为 :func:`composite`
和 :func:`ConditionSwitch` 的一种替代方案。它使用的语言让定义合成图像更方便。而且Ren'Py可以根据被合适命名的文件，生成对应部分的定义。相比Ren'Py的其他功能，图层化图像也更优秀。比如属性(attribute)可以预加载，而ConditionSwith却不行。图层化图像还可以在交互式指导器(interactive director)中使用。

字典转场
----------------

:ref:`Dict Transitions <dict-transitions>` 可以使用with语句和某些其他函数将转场应用于一个或多个图层。Ren'Py不会在使用这些转场时暂停。字典转场使精灵进行转场的时候也同时显示对话成为可能。

变更
-------

现在的Ren'Py中已经不包含旧的教程和模板。不过从旧版本的Ren'Py中复制过来也可以用。

新 :func:`Scroll` 动作可以使按钮改变视口的位置或条(bar)的值。

:func:`Dissolve`、 :func:`ImageDissolve`和 :func:`AlphaDissolve`转场现在可以承认源可视组件的alpha通道，就像设置了 alpha=True参数一样。由于忽略alpha通道不再是最优，这种改变允许在更多地方使用相同的转场。

自动图像定义现在可以在init level 0级别运行，而不是原来的init level必须大于999。这个改动允许 :func:`renpy.has_image` 函数能在初始化语句块(block)中使用。

交互式指导器(interactive director)现在多了一个按钮，允许创作者选择显示在界面的顶部还是底部。

:ref:`屏幕语言 <sl-for>` 声明现在需要一个索引子句::

    for i index i.name in party:
        ...

当被提供时，它应该返回一个唯一的值，该值可以像按钮地图信息和转换状态其来源的对象。

现在有可选的上标文字，允许两种不同的上标文字同时显示。（比如翻译和注音。）

新的 :ref:`可视组件前缀 <displayable-prefix>` 系统可以定义你自己的可视组件，组件可以用字符串访问，这与图像，图像文件和solid具有的字符串形式相同。

Ren'Py现在支持创建具有单个文件的.zip文件（例如.rpa文件）大于2GB。这需要使用Zip64标准，在某些平台上可能不支持解压缩这种文件，最需要注意的是Windows XP。

新的 :func:`renpy.get_hidden_tags` 函数返回一组标签（tag），包含隐藏属性，另一个 :func:`renpy.get_showing_tags`函数则返回一组排列好的标签（tag）。


为了与ATL和其他动画保持一致，第二次显示视频精灵现在将重播视频。

多语言支持
------------

Ren'Py 教程和The Question示例现已支持法语，感谢 Alexandre Tranchant。

对日语和俄语的支持更新。

修复
-----

当界面不显示时，处理hide和replace事件消息导致的界面无法恢复问题已经修复。(这种情况会在用户跳过游戏时出现。)

在交互式指导器(interactive director)中使用默认语言(英语)时，偶尔会切换为俄语的问题已经修复。

可视组件 :func:`Composite`、 :func:`Crop` 和 :func:`Tile`分别对应各自的新名称。

接入控制台时，Ren'Py回滚位置不正确的问题已经修复。那个问题会导致控制台显示不正确的数据，不过仅限于控制台自身的数据。


.. _renpy-6.99.14.3:

6.99.14.3
=========

变更
-------

可视组件 :func:`AlphaMask` 将其遮罩(mask)放入其子可视组件，与AlphaDissolve的处理方式相同。
这样改动后，允许mask参数通过使用ATL或其他变换(transform)创建。

几个过时的图像操纵器已被弃用，并从文档中删除。这些是已被 :func:`Transform`完全取代的图像操纵器。

重命名了一些函数，删除了“Live”前缀。

* LiveComposite现在是 :func:`Composite`
* LiveCrop现在是 :func:`Crop`
* LiveTile现在是 :func:`Tile`

原有的函数名已保留作为兼容的别名。


修复
-----

这个版本修复了一个问题：界面内for语句的子组件不应该在界面更新循环中增加自身的数据。
这个问题出现在比较复杂的场景中，比如循环的转场(transition)或慢速文本(slow text)无效的时候。

该版本可以使用选择的颜色显示最新的存档槽位，如果有需要使用的话。
这个功能直接会应用在新创建的游戏中。旧工程可以在gui.rpy底部添加如下代码实现更新：::

    define gui.slot_button_text_selected_idle_color = gui.selected_color
    define gui.slot_button_text_selected_hover_color = gui.hover_color

6.99.14.2引入的，在回滚之后default语句无法工作的故障，也已经修复。
这个故障仅对首次存档后的游戏有影响。

.. _renpy-6.99.14.2:

6.99.14.2
=========

特性和变更
--------------------

Ren'Py里现在支持Atom文本编辑器。选择了Atom文本编辑器后，Ren'Py会下载Atom，安装language-renpy、renpy-dark-syntax和renpy-light-syntax的Atom插件，并创建一个新的profile文件。
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

自动语音
------------

Ren'Py的自动语音模式，针对视觉障碍用户的功能又提升了：

* 选择按钮之后会在后面加上单词“selected”。
* 选择条(bar)之后会在后面加上单词“bar”。
* 一些拥有自身自动语音信息的动作在新版GUI中提升了效果。
* Ren'Py内建的ALT文本实现多语言支持(translation)。

由于改变了自动语音的输出，这个变更应该不会对已存在的支持语言生效。

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

:func:`renpy.start_predict` 和 :func:`renpy.stop_predict`函数现在是可以使用正则表达式通配符。例如：::

    $ renpy.start_predict("eileen *")

预加载所有开头为标签(tag)“eileen”的图像，出现如下语句：::

    $ renpy.start_predict("* beach*")

匹配所有带有“beach”属性的图像。

现在F4键可以显示图像加载日志了。

其他改进
------------------

变换(transform)现在有了一个新的 :tpref:`maxsize` ”特性，能够将图像缩小到某个范围的方框里。

当Ren'Py重新加载(reload)时，会保留Python表达式缓存，相比原来每次重新加载都unmarshall缓存有明显的性能提升。

track.txt和errors.txt文件现在底部会有一个日期，更容易判断这个文件是否过期失效。

新的:func:`renpy.list_images` 函数返回所有定义过的图像列表。

Drag组件现在新增了 `mouse_drop` 特性。若这项特性为True，使用鼠标指针坐标选择Drag组件落下的位置，而不是使用overlap最大的Drag组件。

西班牙语版本更新。

其他修复
-----------

修复ATL“on hide”分句无效的bug。

等待某个界面跳动(flip)时释放GIL(解释器全局锁)，让一些任务(播放音乐、预加载图像、自动存档等)在后台线程运行得更快。

(译者注：请不要纠结GIL是什么。相信我，没错的……)


.. _renpy-6.99.14:

Ren'Py 6.99.14
==============

性能表现
-----------

为了提升性能，我们做了很多细碎的工作，包括在绝对性能和明显的帧率突刺方面。

当设备接通电源时，Ren'Py会尝试使用固定帧率绘制界面。当设备使用电池时，切换到5fps的帧率前将绘制几帧，确保显示缓存区完成界面的更新。

Ren'Py有一些选项控制显示性能，使用shift+G能进入选项菜单。除了上面提到的GL性能变更之外，这个设计允许用户锁定帧率并接受画面撕裂。
使用运行比较慢设备的用户可能会选择锁定30fps而不是变动的帧率。如果开发者觉得大多数用户都会使用性能慢的设备，可以使用默认语句：::

    default preferences.gl_framerate = 30

当某一帧渲染时间过长(比如，由于一个未预加载的图像需要从硬盘读取)，Ren'Py会尝试根据设置的帧率展现转场(transition)和可视组件。
这也表示Ren'Py不得不跳帧，并且会从序列中的第一帧之前开始跳帧，而不是从第一帧和第二帧之间开始跳帧。

如果创建了足够数量的对象，Ren'Py自身会在绘制一帧后触发GC。触发GC的对象数量的值提高了。
触发的数量阈值应该已经足够高，只要游戏中没有创建环状的对象引用，就不需要主动要求GC。
(环状的对象引用是指，几个对象互相引用对方，形成一个循环。)我们修改了Ren'Py，可以排除常见的环状对象引用代码。

Ren'Py的GC管理能减少或消除GC对大多数游戏的丢帧影响。不过，也可以把 :var:`config.manage_gc`设置为False，恢复为之前的调优方法(tune)。

默认情况下，“hide”事件句柄会触发Ren'Py移除临时界面(比如say和choice界面)和可视组件。检查这类句柄的过程系统消耗很大，还好这类句柄很少使用。
将 :var:`config.zap_transients` 设置为False可以把这个配置恢复为之前版本的状态。

现在Ren'Py第一次遇到Python表达式后会编译并缓存起来，而不是原来那样每次遇到Python表达式都重新编译。
这个改动提升了多次复用的根据条件选择显示的可视组件的运行速度。因为这个改动，所有在Ren'Py 6.99.14版本运行的游戏第一次打开时都会变慢，因为所有表达式都需要编译。

这个版本提高了回滚时保留必要信息的速度，以及减少了保留必要信息的次数。用户能体会到的是，现在Ren'Py能回滚到前面更深的地方。

此外当然还有很多性能方面的提升，实际效果都是提升了运行速度。这个版本还只是性能提升的第一战，新的性能分析框架允许Ren'Py开发者进一步提升性能。


多角色对话
---------------------------

现在Ren'Py包含一个新系统，允许多个角色在同一时间发言。通过在say语句结尾添加multiple入参可以实现这点。举例：::

    e "Ren'Py now supports multiple character dialogue." (multiple=2)
    l "About time! I've been wanting this for years!" (multiple=2)

由于显示多个角色的对话可以有好几种方式(并排？上下排列？一个还是两个文本框？)，Ren'Py尚不能提供现成的支持方案。
请参考 :ref:`多角色对话 <Mmultiple-character-dialogue>`
章节的内容，查看哪些样式需要创作者定义。

GUI环境设定
----------------

Ren'Py提供了一套新的GUI环境设定系统，替换了原来的样式环境设定系统。新的系统允许从多个样式中引用变量并应用在新的GUI环境设定中。

可以这样写脚本：::

    define gui.text_font = gui.preference("font", "DejaVuSans.ttf")

加载环境设定，并使用下列脚本：::

    vbox:
        style_prefix "radio"
        label _("Font")
        textbutton _("DejaVu") action gui.SetPreference("font", "DejaVuSans.ttf")
        textbutton _("Dyslexic") action gui.SetPreference("font", "OpenDyslexic-Regular.otf")

设置环境设定。详见 :ref:`GUI环境设定 <gui-preferences>`。

Tooltips
--------

Ren'Py中增加了一个新的tooltip系统，替换了原来存在tooltip。在之前的系统中，我们需要这样写：::

    default tt = Tooltip("No button selected.")

    textbutton "One.":
        action Return(1)
        hovered tt.Action("The loneliest number.")

    text tt.value

现在可以这样写：::

    textbutton "One.":
        action Return(1)
        tooltip "The loneliest number."

    text GetTooltip()

这个系统意在节省代码和让界面具有更高的可读性。 详见 :ref:`tooltips` 章节。

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
