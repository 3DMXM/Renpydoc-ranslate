.. _incompatible-changes:

不兼容的变更
====================

这里列出了脚本格式或者创作者开发环境变更后，需要调整的内容。我们旨在所有的变更都不会影响已存在的脚本内容。

只需要注意，设置 :var:`config.script_version` 就恢复版本变更导致的许多变化，代价是无法使用新增特性。

关于GUI方面的不兼容变更，详见 :ref:`gui-changes` 部分，只有重新生成GUI才会让这些变更生效。

.. _pending-deprecations:

待定的弃用内容
--------------

这里记载的东西可能是未来Ren'Py版本中可能会发生的。

Ren'Py 8.1发布1年后，即2024年5月，将停止对Python2和Ren'Py 7的支持。

Ren'Py 8.1发布1年后，即2024年5月，将移除原生OpenGL渲染器。
Ren'Py 8.2和7.7起将彻底禁用 :var:`config.gl2` 这个标识。GL2渲染器将用作默认渲染器，除非用户选择另一个渲染器。

2024年5月后停止对Windows 7、8和8.1的支持。这样可以使用仅能在Windows10及后续Windows上运行的高版本Python。

.. _incompatible-8.4.0:

8.4.0
-----

**显示表达式。** ``show expression`` 语句发生变化：

::

    show expression "bg washington"

等效于：

::

    show bg washington

之前的版本中，表达式自身会被用作图像标签(tag)。若表达式不是字符串，会在show expression语句中创建一个唯一的标签。
若要使用之前的功能，在脚本中添加：

::

    define config.old_show_expression = True

.. _incompatible-8.3.4:
.. _incompatible-7.8.4:


8.3.4 / 7.8.4
-------------

**不同尺寸可视组件间的dissolve效果，第二部分** 如果ImageDissolving或AlphaDissolving使用了两个不同尺寸的可视组件，
Ren'Py会将两个组件的尺寸都设置为更大的那个。若要使用之前的功能(各个轴都用更小的那个)，在脚本中添加：

::

    define config.dissolve_shrinks = True

**移除ATL中的“update”事件** 在以前的Ren'Py中，界面发生各种变化时(比如多语言切换)会广播“update”事件，让界面中的ATL都收到。
但该事件并不可靠，并且也很少有人使用，所以干脆移除了。

.. _incompatible-8.3.0:
.. _incompatible-7.8.0:

8.3.0 / 7.8.0
-------------

**box_reverse和box_align** :propref:`box_reverse` 不再会影响 :propref:`box_align` 。
若要修改box组件的对齐效果，将 :propref:`box_align` 设置为1.0，或在脚本中定义：

::

    define config.box_reverse_align = true

这样能恢复8.2版本的功能。

**长期保留的对话框气泡** 在某些情况下也会自动清除，比如其他角色的say语句、menu语句和call screen语句。
该功能由 :var:`bubble.clear_retain_statements` 控制。

若要禁用此功能，需在脚本中添加：

::

    define bubble.clear_retain_statements = [ ]

**ATL如何使用参数设置子组件** ATL变换中如何根据收到的参数修改子组件的规则有调整。
这个改动对之前的游戏不太可能有严重影响，尤其是创作者仅根据文档的规则进行开发。

- :var:`bubble.clear_retain_statements` 参数会从固定位置入参获取一个值，但不会传给子组件。此处有一个文档缺失 :ref:`atl-transitions` ：

::

    transform t(old_widget):
        ...

    t("eileen") # 不再会将子组件设置传给图像“eileen”

- 入参列表中包含 `child` 的变换会将同名参数的值或者传给子组件。
  或者入参列表中包含 `child` ，但使用时不通过关键词参数而是固定位置参数给child赋值，也会传给子组件。
  再或者入参列表中不包含 `child` 的变换，但赋值时就是有关键词参数child，也当作原变换的入参列表中包含child，并将值传给子组件。
  之前的文档描述比较模糊。

::

    transform t1(child):
        ...

    transform t2(delay=1.0):
        ...

    t1(child="eileen happy") # 当前版本会赋值给“eileen happy”的子组件，之前的版本则不会赋值。
    t2(child="eileen happy") # child被正确赋值，跟以前一样。
    t1("eileen happy")       # child被正确赋值，跟以前一样。

**角色回调函数** 的入参列表扩大，详见 :doc:`character_callbacks`。
现在角色回调函数会忽略未知的关键词入参，所以并不一定需要修改之前写的角色回调函数。

**window语句** ``window show`` 和``window hide`` 语句不会禁用``window auto`` 的标识。
如果需要恢复旧功能，可以使用新的 ``window auto False``，或者在脚本中添加：

::

    define config.window_functions_set_auto = True

当 ``window show`` 出现在 ``window hide`` 后面时，Ren'Py会寻找下一条say语句，以确认下次显示的对话窗口类型。
之前的版本中，Ren'Py会往回找，用上一条say语句的信息。若要使用之前的功能，需要在脚本中添加：

::

    define config.window_next = False

.. _munge-8.3.0:

**字符串转换** 开头有且仅有一个“__”(双下划线)的变量名，会在字符串中自动识别并转换为另一个变量名。
比如下面的例子：

::

    $ __foo = 1
    "Add one and __foo and you get [1 + __foo]."

会自动转换为：

::

    $ _m1_script__foo = 1
    "Add one and _m1_script__foo and you get [1 + _m1_script__foo]."

若要禁用该功能，在game目录下找到一个名为01nomunge.rpy文件，在里面添加：

::

    define config.munge_in_strings = False

**可视组件包围框外的部分将被裁减** 把可视组件放在一个比它大的box组件中后再裁减，结果会有一些变化。
在当前版本中，传给 :func:`Crop`，:tpref:`crop`，:tpref:`corner1` 和 :tpref:`corner2` 的值不再受到可视组件自身的原始包围框大小限制。

Ren'Py 8.2.x和7.7.x版本中，裁减行为固定从可视组件右侧和底部开始，保留左侧和顶部。
若要使用旧功能，需要在脚本中添加：

::

    define config.limit_transform_crop = True

在8.2和7.7版本之前，只有当剪裁的值是浮点数时，才会从右侧和底部开始剪裁。
若要保留旧功能，需要在脚本中添加：

::

    define config.limit_transform_crop = "only_float"

.. _incompatible-8.2.2:
.. _incompatible-7.7.2:

8.2.2 / 7.7.2
-------------

**fill和frame组件** 8.2.1或更早版本中，某些情况下 :propref:`xfill` 和 :propref:`yfill` 特性会导致frame、window和按钮组件的尺寸缩小。
现在统一使用expansion。若要使用旧功能，需要在脚本中添加：

::

    define config.fill_shrinks_frame = True

.. _incompatible-8.2.1:
.. _incompatible-7.7.1:

8.2.1 / 7.7.1
--------------

**垂直文本** 使用hardbuzz文字引擎提升了垂直文本，并能在正确的位置渲染文字了。
使用新版本可能会导致垂直文本的位置发生变化。由于之前的版本中一直有问题，所以这次就没有考虑兼容。

.. _incompatible-8.2.0:
.. _incompatible-7.7.0:

8.2.0 / 7.7.0
-------------

**字符串化注解以及停止PEP 563的后续特性** 从Ren'Py 8.0.2起，Ren'Py8编译时直接添加 ``from __future__ import annotations``，
创作者不可能取消这条编译命令。

这此的修改可能会无法使用Python未来版本实现的变化。

若要保留字符串化注解，可以在文件开头添加一句：

::

    rpy python annotations

**文本的变化** Ren'Py使用Harfbuzz文本引擎。Harfbuzz引擎产生的字形可能与原生字体的字形有所差异，还可能会改变文本所占空间大小。
垂直文本的坐标机制也随着Harfbuzz渲染的更新而发生了变化。

若不需要此变化，脚本内添加如下内容：

::

    style default:
        shaper "freetype"

Ren'Py在必要时会自动使用Emoji字体。若要禁用该功能：

::

    style default:
        emoji_font None

**文本内插的变化** 字符串里的文本内插(interpolation)部分被当作Python表达式处理。
这次变化基本不会对之前的用法有影响，除非对应的表达式以被其他东西占用。例如：

::

    # Previously
    e "[player[money]]" #=> player['money']
    # But now
    e "[player[money]]" #=> player[money]

若不需要此变化，脚本内添加如下内容：

::

    define config.interpolate_exprs = False

为了帮助某些开发人员从旧版迁移到新版，还存在一个fallback模式。此模式会先尝试新版文本内插，失败后再回退到旧版文本内插。
若需要启用fallback模式，添加：

::

    define config.interpolate_exprs = "fallback"

**极坐标系的变化** Ren'Py会强制转换 :tpref:`angle` 和 :tpref:`anchorangle` 的角度值，转换后的值会在0到360度之间，包含0度不包含360度。
之前的版本中，超过该范围的角度值可能导致未定义的表现。
角度变化360度将不再能触发圆周运动，因为角度变化会被看作是0。

在ATL中对 :tpref:`angle` 和 :tpref:`anchorangle` 做动效时，
如果没有指定旋转方向，则将使用劣弧(shortest arc)，尽管这样旋转过程中可能会遇到0度。

极坐标系的变化没有兼容性选项，实际上也基本不会影响视觉效果。

**禁止空的ATL语句块** 之前版本的Ren'Py允许空的ATL语句块。现在遇到空ATL语句块时，会报错提示需要一个语句块。
如果以前的脚本有类似下面的ATL：

::

    show eileen happy:
    "..."

要改成：

::

    show eileen happy
    "..."

**Box Reverse** 样式特性 :propref:`box_reverse` 有两方面的变化：

* 可视组件的间隔空间按照界面中可视组件定义的顺序挨个添加。
  之前的版本中，如果启用了 :propref:`box_reverse`，则会以相反顺序添加间隔空间，可能会改变某些组件的尺寸。
* 设置了 :propref:`box_wrap` hbox组件会从上往下wrap。设置了 :propref:`box_wrap` 的vbox组件会从左往右wrap。

这些改变的目标是，让box_reverse适配从右往左书写的语言文字。若要回退这项改变：

::

    define config.simple_box_reverse = True

**build.itch_channels** 该变量在文档中写着是个字典，但实际实现确实一个元组的列表。
现在已经真的改成一个字典了。如果原本的脚本中就把该变量作为列表处理，并且不想再改代码的话：

::

    # formerly
    $ build.itch_channels.append(("pattern", "channel"))
    $ build.itch_channels.extend([("pattern", "channel")])
    define build.itch_channels += [("pattern", "channel")]

    # now
    $ build.itch_channels["pattern"] = "channel"
    $ build.itch_channels.update({"pattern": "channel"})
    define build.itch_channels["pattern"] = "channel"
    define build.itch_channels |= {"pattern": "channel"}

**新的位置类型** 在 :term:`position` 的类型列表中新增类型 :func:`position` 。
:func:`renpy.get_placement` 函数的返回结果就可能是这种新类型。

若不要这个变化，在游戏中添加如下代码：
::

    define config.mixed_position = False

**拖拽组的变化** 将一个可视组件添加至某个拖拽组 :class:`DragGroup` 对象后，
该可视组件将会盖在组内其他组件上面，而之前的版本是被其他所有组件盖在下面。

若要回退这项变化，在游戏中添加如下代码：

::

    define config.drag_group_add_top = False

**translate语句和config.statement_callbacks** (包括Ren'Py内部自动生成的)translate语句不再会调用 :var:`config.statement_callbacks` 。

**转场使用子组件的位置** 如果某个转场的子组件提供了位置信息，该位置信息将用于整个转场。
只有在使用ATL转场(transition)，并且新旧两个子组件的位置相同时，这样用才是合理的。

若要禁用该变化，在游戏中添加如下代码：

::

    define config.transitions_use_child_placement = False

**容器允许变换事件穿透**

容器类组件(包括fixed、hbox、vbox、side、grid、viewport和vpgrid)可以允许变换事件(transform events)穿透自身抵达自组件。
也就是说各个子组件可以独立拥有针对这些事件的变换效果。

若要禁用该变化，在游戏中添加如下代码：

::

    define config.containers_pass_transform_events = set()

**say界面新增replace事件** say界面可以对“replace”事件(而不是“show”事件)作出响应，暂停指定时间(单位为秒)。

若要禁用该变化，在游戏中添加如下代码：

::

    define config.say_replace_event = False

**某个界面从隐藏状态再次显示不会取消hide事件** 之前的版本中，某个界面隐藏后再次显示时，响应该界面hide和replace事件的变换会被取消，
导致界面会突然出现。现在会让hide和replace事件的响应变换运行完。

若要禁用该变化，在游戏中添加如下代码：

::

    define config.screens_never_cancel_hide = False

.. _incompatible-8.1.2:
.. _incompatible-7.6.2:

8.1.2 / 7.6.2
-------------

**不同尺寸可视组件间的dissolve效果** 两个不同尺寸的可视组件使用dissolve效果替换时，Ren'Py会将两个组件的尺寸都设置为更大的那个。
若要使用之前的功能，在脚本中添加：

::

    define config.dissolve_shrinks = True

.. _incompatible-8.1.1:
.. _incompatible-7.6.1:

8.1.1 / 7.6.1
-------------

.. _android-key-migration:

**安卓密钥迁移** 我们收到了一些报告，表示一些游戏由于使用了不同的密钥而被Google Play商店拒绝包含APK的Bundle上架申请。
该现象是由某个老版本的Ren'Py造成的，该版本可以使用APK密钥生成Bundle。在控制台中可能会受到如下错误信息：

::

    You uploaded an APK that is not signed with the upload certificate. You must use
    the same certificate. The upload certificate has fingerprint:

        SHA1: ...

    and the certificate used to sign the APK you uploaded has fingerprint:

        SHA1: ...

这种报错可能是由其他问题引发的(比如只是使用了完全错误的密钥)。一种可能的解决方案如下：

1. 游戏根目录中的 ``bundle.keystore`` 文件重命名为 ``bundle.keystore.bak``。
2. 将 ``android.keystore`` 复制到游戏根目录，并改名为 ``bundle.keystore``。

最后尝试生成并上传Bundle。

.. _incompatible-8.1.0:
.. _incompatible-7.6.0:

8.1.0 / 7.6.0
-------------

**互相冲突的特性** 使用原生的input界面时，可能会在游戏中引入一些互相冲突的样式特性。
修复方法如下：

.. code-block:: diff

    +define config.check_conflicting_properties = True

     screen input(prompt):
         style_prefix "input"
         window:

             vbox:
    -            xalign gui.dialogue_text_xalign
    +            xanchor gui.dialogue_text_xalign
                 xpos gui.dialogue_xpos
                 xsize gui.dialogue_width
                 ypos gui.dialogue_ypos
                 text prompt style "input_prompt"
                 input id "input"

**气泡式台词** 在之前的游戏项目中添加气泡式台词的支持前，需要添加一些文件和脚本内容。
详见 :doc:`bubble` 部分。

**Live2D** 当前版本Ren'Py对Live2D Cubism 4 SDK版本的要求为Native R6_2或之后的版本。
使用旧版本可能会被Ren'Py拒绝。

**纹理内存** 当前版本Ren'Py计算纹理缓存时更精确。
总体来说，大概提升了 :var:`config.image_cache_size_mb` 容量的33%，以及等量的内存。

**音频淡出** 停止音频播放或使用 ``play`` 语句更改播放内容后，默认有0.016秒的淡出效果，防止爆音问题。
可以通过配置项 :var:`config.fadeout_audio` 修改淡出时间。如果要禁用默认淡出效果：

::

    define config.fadeout_audio = 0.0


淡出的音量值以对数形式递减，能让音频更顺滑，符合人类耳朵的听觉习惯。
之前则是线性递减。如果要切换为以前的淡出算法：

::

    define config.linear_fades = True

**Translate None** Ren'Py在遇到显式的 ``translate None`` 语句用以标注不进行语言转换的字符串、样式和Python代码时将报错。
这种情况很少见。推荐修改下列代码：

::

    translate None start_abcd1234:
        e "This is a test"

改为：

::

    e "This is a test" id start_abcd1234

也可以直接设置配置项：

::

    define config.check_translate_none = False

**按键映射** :doc:`按键映射 <keymap>` 文档部分大量修改。因此游戏做修改时使用默认的按键映射方案不是个好主意。
不然就要更新或处理原来没有的按键事件。

**文件搜索** 当前版本Ren'Py只会在game/images目录中搜索图片文件，而不管其他类型文件。
如果要在game/images目录中存放其他类型文件，需要设置：

::

    define config.search_prefixes += [ "images/" ]

搜索文件时选用的路径主要考虑文件的用途，而不是文件类型和扩展名。
因此，``renpy.loadable("dlc.jpg")`` 不会搜索game/images/dlc.jpg文件。
如果想要寻找该文件，需要写 ``renpy.loadable("images/dlc.jpg")``。
如果要同时在game和game/images两个路径搜索文件，需要写 ``renpy.loadable("dlc.jpg", "images")``

**安卓** 安卓中需要用到的 ``android.keystore`` 和 ``bundle.keystore`` 文件需要放在项目根目录中，而不再是rapt目录。
这项修改是为了构建不同版本时能使用不同的密钥(key)，或者在不同的安卓版本中使用同一个密钥。

如果想要使用自己拥有的密钥，需要编辑 ``android.json``，把update_keystore设置为False。
然后再编辑 ``rapt/project`` 中的 ``local.properties`` 和 ``bundle.properties``，指向自己的密钥。

安卓配置文件从 ``.android.json`` 改名为 ``android.json``。在旧文件存在的情况下，Ren'Py会自动创建新的文件。

**对话历史** 当前正在显示的对话将进入历史列表(和history界面)。之前的版本中，只有对话完全显示后才会进入历史列表。
正在显示的对话类型会被标记为“current”。

在少数情况下，游戏需要使用旧版本的表现形式，可以修改配置项：

::

    define config.history_current_dialogue = False

**Steam appid** 没有设置 :var:`config.steam_appid` 的情况下，Ren'Py会删除game目录下所有存在的 ``steam_appid.txt`` 文件。
这可以防止使用错误的appid。

**粘滞图层** 新版本引入了粘滞图层的概念，可以根据图像标签(tag)设置显示的图层，而不再是图像定义的默认图层。
在少数情况下，游戏可能要求相同图像标签(tag)的内容同时显示在多个不同的图层上。这种需求是无法实现的。

若要完全禁用粘滞图层，可以修改配置项：

::

    define config.sticky_layers = [ ]

此外，还可以在定义图层时就声明 ``sticky=False``：

::

    init python:
        renpy.add_layer("ptfe", sticky=False)


**方头凹形括号表示Ruby文本**
此版本的Ren'Py引入方头凹形括号表示Ruby文本的语法。
如果原来的游戏中有左方头凹形括号(【)，需要改为连续两个括号转义“【【”后才能正确显示。
(严格来说，只有一对方头凹形括号中出现全角竖条“｜”符号时才必须转义，不过统一语法总是更好。)

若要取消这种Ruby文本语法，在脚本中添加：

::

    define config.lenticular_bracket_ruby = False

**常量存储区** 此版本的Ren'Py引入了 :ref:`常量存储区 <constant-stores>`，并把某些内建的存储常量化了。
常量存储在初始化阶段后不会再改变。以下为存储的常量：

    _errorhandling
    _gamepad
    _renpysteam
    _warper
    audio
    achievement
    build
    director
    iap
    layeredimage
    updater

如果游戏中需要修改存储的某些变量值，(举例来说)可以将对应的变量设置：

::

    define audio._constant = False

**混音器音量** 必须使用新的格式，0.0表示-40dB(电平)，1.0表示0dB(电平)。
若要使用旧版格式：

::

    define config.quadratic_volumes = True

同时，还要将 :var:`config.default_music_volume`、:var:`config.default_sfx_volume` 和 :var:`config.default_voice_volume`
都修改。如果任何一个的值为0.0或1.0，都没效果。

**at transform和全局变量** 在at transform语句块中使用的全局变量不会在变量发生改变时重新计算。
该情况适用于界面中没有用到的ATL。

The recommended fix is to capture the global variable into a local, by changing
推荐的修复方法是，新增一个本地变量，从全局变量赋值。
原脚本：

::

    screen test():
        test "Test":
            at transform:
                xpos global_xpos

需要修改为：

::

    screen test():
        $ local_xpos = global_xpos

        test "Test":
            at transform:
                xpos local_xpos

若要使用原本的设计，需要修改配置项：

::

    define config.at_transform_compare_full_context = True


.. _incompatible-8.0.2:
.. _incompatible-7.5.2:

8.0.2 / 7.5.2
-------------

模态界面会屏蔽 ``pause`` 语句和 :func:`renpy.pause`` 效果，直接终止暂停。
原本是这样的设计，但某些情况下没效果。
若要恢复旧版：

::

    define config.modal_blocks_pause = False

历史记录默认不再使用Ruby/Furigana文本标签。
若要恢复旧版，需要修改screens.rpy文件中的 :var:`gui.history_allow_tags` 配置项：

::

    define gui.history_allow_tags = { "alt", "noalt", "rt", "rb", "art" }

仅在游戏中使用Ruby/Furigana文本标签时才需要注意。

8.0.0 / 7.5.0
-------------

构建分发包时，“Windows, Mac, and Linux for Markets”类型的包不会在添加目录名称和版本号作为zip文件前缀。
若要恢复旧特性，可以在游戏脚本中添加：

::

    init python:
        build.package("market", "zip", "windows linux mac renpy all", "Windows, Mac, Linux for Markets")

对于历史记录中的noalt文本标签，需要编辑 screens.rpy 文件，确保 :var:`gui.history_allow_tags` 中包含“noalt”。
其默认值是：

::

    define gui.history_allow_tags = { "alt", "noalt" }

(该变更在7.4版本中就已添加，只是文档没更新。)

Ren'Py的7.4系列版本中有一些功能反复变更，比如读档后回滚的结果，在 ``after_load`` 脚本标签的变化，
以及 :var:`config.after_load_callbacks` 配置项。
如果你的游戏需要读档后做数据迁移，推荐调用 :func:`renpy.block_rollback` 防止数据变化后的回滚问题。

:var:`config.narrator_menu` 配置项默认值改为True。最近的几个版本中，screen.rpy文件设置的默认值就已经是True了。
若需要改为旧版本：

::

    define config.narrator_menu = False

音效和语音的音频通道将在返回主菜单后自动停止播放。
如果需要回到旧版(返回主菜单后只有movie通道停止)，在游戏脚本中添加：

::

    define config.main_menu_stop_channels = [ "movie" ]

使用 ``call screen`` 调用的界面，默认不再支持前向滚动。
详见 :ref:`变更日志 <call-screen-roll-forward>` 中关于可能引发问题的内容。
前向滚动可以通过所有界面的 `roll_forward` 特性启用：

::

    define config.call_screen_roll_forward = True

用在vbox和hbox中的key和timer语句，不再占据空间。
showif语句中的子组件隐藏式，也同样不占空间。
若需要恢复旧版：

::

    define config.box_skip = False

拖拽组件的 :propref:`focus_mask` 样式特性默认值改为None。
这项改动提升了性能表现，副作用是可视组件的透明像素部分也可以被用于拖动了。
若要恢复旧版功能，将单个拖拽组件的focus_mask特性值设置为True，或者修改全局设置：

::

    style drag:
        focus_mask True

不过两种做法都会降低性能。

样式特性 :propref:`outline_scaling` 的默认值改为“linear”。
窗口缩放系数直接乘以轮廓线大小的值，然后取整。
这可能会导致同心的相近粗细轮廓线可能会混在一起看不清。
若要恢复旧版，将单个文本元素的 outline_scaling 特性设置为“step”，或者修改全局设置：

::

    style default:
        outline_scaling "step"

变换特性 :tpref:`crop_relative` 的默认值改为True，原来为False。
裁剪是若需要指定像素数，需要使用int型数值或 ``absolute`` 数值。
若要恢复旧版的功能，把浮点数转换为整数：

::

    define config.crop_relative_default = False

不过，需要警惕本页文档中的其他内容可能会与上一项引发的冲突，有些部分不能与其他新功能特性同时使用。
比如使用 :tpref:`crop` 特性对 :tpref:`crop_relative` 有用，现在还对 :tpref:`corner1` 和 :tpref:`corner2` 产生影响。

lib/ 目录中针对不同平台的子目录名称发生变化。
``lib/windows-x86_64`` 目录改为 ``lib/py2-windows-x86_64``。
这项改动主要是为了使用Python 3的Ren'py 8版本。
具体的目录名称没有在文档中记录，并且不同的Ren'Py可能会有不同。
我们可以确定的是 ``sys.executable`` 是设置好的。

vpgrid不再能装载超过单元格数量的元素，将 ``allow_underfull`` 特性或 :var:`config.allow_underfull_grids` 配置项设置为True后，只能装在小于单元格数量的元素。

:doc:`层叠式图像 <layeredimage>` 中放置子组件和调整子组件尺寸的方式发生改变。
不再以层叠式图像显示占据的区域，而是以整个界面尺寸，计算子组件的大小和位置，
除非显式指定 :tpref:`xsize`、:tpref:`ysize` 或 :tpref:`xysize` 的值。
若要恢复旧版：

::

    define config.layeredimage_offer_screen = False

或者可以指定层叠式图像的 ``offer_screen`` 特性值为False。

ATL中的 ``function`` 语句仅在运行超过一次之后才限制其运行。
若要恢复旧版，ATL中始终限制function语句：

::

    define config.atl_function_always_blocks = True

7.4.11
------

当前版本Ren'Py将在焦点发生改变，例如界面显示或隐藏时，依然运行某个按钮的unhovered特性。
若要恢复旧版表现：

::

    define config.always_unfocus = False


.. _incompatible-7.4.9:

7.4.9
-----

当前版本Ren'Py在遇到浮点型数值的 :tpref:`xsize` 和 :tpref:`ysize` 时，认为这两个特性表示可用区域的某个比例。
若要恢复回去：

::

    define config.relative_transform_size = False

启用自动语音时，图层、界面和可视组件的阅读顺序发生改变，按与用户的距离从近到远依次朗读。
若要恢复旧的顺序：

::

    define config.tts_front_to_back = False

.. _incompatible-7.4.7:

7.4.7
-----

:propref:`xminimum` 和 :propref:`xmaximum` 都为浮点型数值时，这两个最小值会当作可用区域的一个比例值。
这表示 :propref:`xsize` 也需要调整以达到需要的结果。
这项变更可能会导致某些可视组件的尺寸发生变化。
若要恢复回去：

::

    define config.adjust_minimums = False

ATL可视组件会在其自身首次显示是开始计算动画时间，而不是其所在界面显示时开始计时。
若要恢复回去：

::

    define config.atl_start_on_show = False

输入光标默认闪烁。若要修改：

::

    define config.input_caret_blink = False

.. _incompatible-7-4-6:

7.4.6
-----

7.4.5中对图层清理规则的修改已发生反转。新的 ``camera`` 语句符合新的规则，而 ``show layer`` 语句适用旧规则。

.. _incompatible-7.4.5:

7.4.5
------

当前版本的游戏开发默认使用基于模型的渲染器。若要禁用该渲染器，修改配置项：

::

    define config.gl2 = False

**7.4.6版本已反转**
``scene`` 语句不再清理列表中的图层(layer)。若需要清理图层，使用：

::

    show layer master

“master”是需要清理的图层名称。若要修复旧特性，修改配置项：

::

    define config.scene_clears_layer_at_list = True


.. _incompatible-7.4.3:

7.4.3
-----

当前版本允许用户使用点击(鼠标)忽略使用 :func:`renpy.transition` 转场效果，
使其与使用 ``with`` 的say语句和 ``call screen`` 语句保持一致。
如果要保持原有特性，修改配置项：

::

    define dismiss_blocking_transitions = False


.. _incompatible-7.4.1:

7.4.1
-----

当前版本的暂停效果使用 :func:`renpy.pause` 而不是 ``with Pause(...)`` 。
这意味着用户需要多次点击(鼠标)才能跳过多个暂停。
如果要恢复原来的设置，修改配置项：

::

    define config.pause_with_transition = True

.. _incompatible-7.4:

7.4
---

移动平台仅限于软解解码，可以使用硬件解码播放视频。如果要回归原来的设置：
::

    define config.hw_video = True

当前版本Ren'Py只在图像标签(tag)中至少包含一个属性(attribute)的情况下才会显示侧边栏头像(side image)。禁用该设置：

::

    define config.side_image_requires_attributes = False


7.4版本起，将不再支持初始化阶段以外的场景修改配置项，比如 :var:`config.mouse` 。
请考虑使用 :var:`default_mouse` 配置项设置自定义的鼠标光标。

.. _incompatible-7.3.3:

7.3.3
-----

在配置项 :var:`config.start_callbacks` 中注册的回调功能，任何情况下都会在 ``default`` 语句之后运行。
如果要恢复原来的行为模式(即回调在 ``default`` 语句之前运行)：
::

    define config.early_start_store = True

当视口或vpgrid带有滚动条时，将自动关联minimum、xminimum和yminimum变长特性到对应边的滚动条上，而不仅仅是视口自身的特性。

要绕开这个不兼容点，要么使用 ``viewport_minimum``，``viewport_xminimum`` 和 ``viewport_yminimum``，要么修改配置项：

::

    define config.compat_viewport_minimum = True

.. _incompatible-7.3.0:

7.3.0
-----

界面语言方面，在遇到类似下面的代码时会出现错误提示“a non-constant keyword argument ...
is not allowed after a python block.” ：

::

    screen test():

        default a = 0

        button:
            $ a = 1
            action Return(a)

            text "Test"

原因是，`action` 特性会在Python变量声明之前运行，所以运行结果会返回0而不是1。
如果要禁用这个错误提示功能，请在游戏的game目录下名为 01compat.rpy 的文件中添加一行：

::

    define config.keyword_after_python = True

``side`` 布局的所有子对象的绘制顺序，现在由控制字符串决定。如果要改为原来的固定顺序，请使用：

::

    define config.keep_side_render_order = False

:var:`config.say_attribute_transition_callback` 配置项的接口发生不兼容的改变。
改变后允许使用新旧标签(tag)的集合。
如果要恢复成旧的接口，请使用：

::

    define config.say_attribute_transition_callback_attrs = False

模式参数也有一些改变，当 ``permanent`` 和 ``temporary`` 属性转场都起效时，将返回 ``both`` 。

.. _incompatible-7.2.2:

7.2.2
-----

:var:`config.say_attribute_transition_callback` 配置项已变更，接受一个新的入参，表示显示的图像。

.. _incompatible-7.1.1:

7.1.1
-----

Ren'Py的window auto功能现在会自动判断对话或标题是否带menu语句，并会在合适的时机自动隐藏或显示对话窗口。
启用这项特性需要使用“强制重新编译”。考虑到较老游戏的兼容性问题，这项特性可以通过如下配置关闭：

::

    define config.menu_showed_window = True
    define config.window_auto_show = [ "say" ]
    define config.window_auto_hide = [ "scene", "call screen" ]

由于这并非严格意义上的不兼容变更，对于历史界面(screen)来说，推荐做一点修改。
详见 :ref:`变更日志入口 <history-7.1.1>` 中如何更新游戏的部分。

.. _incompatible-7.1:

7.1
---

当某个图像不正处于显示时，带属性(attribute)的say语句会决定一个头像(side image)，而不是使用之前某个给定的属性。
如果要禁用这项特性，在配置中添加：

::

    define config.say_attributes_use_side_image = False

.. _incompatible-7.0:

7.0
---

Ren'Py现在将自动图像(automatic images)的优先级定义为 init 0，而不是原来那样一个非常低的init级别。
如果需要恢复到以前的情况，需要在游戏脚本中这样写：

::

    init -1:
        define config.late_images_scan = True

现在 :func:`Dissolve` ， :func:`ImageDissolve` 和 :func:`AlphaDissolve` 转场默认使用原可视组件的alpha通道值，就像指定了 ``alpha=True`` 。
如果不使用这个特性，需要在配置中添加：

::

    define config.dissolve_force_alpha = False

已经显示的某个影片精灵(movie sprite)再次使用show命令时，现在会重播该影片。
如果不使用这个特性，需要在配置中添加：

::

    define config.replay_movie_sprites = False


.. _incompatible-6.99-13:

6.99.13
-------

超链接的字体大小继承邻近文本。禁用这个特性，需要在配置中添加：

::

    define config.hyperlink_inherit_size = False

文本标签 {nw} 现在会等待语音和自动语音结束，然后实现文本消失的效果。
如果想禁用这个特性，需要在配置中添加：

::

    define config.nw_voice = False

现在ATL变换(transform)在遇到某个pause语句或者interpolation语句时，会显示至少一帧。
如果游戏中不希望出现这种情况，而是显示为一些快速略过的帧，需要这样配置：

::

    define config.atl_one_frame = False

现在某个语句内显示的图层(layer)，将保持变换(transform)的状态，就跟其他ATL变换一样。
这个特性会导致一些行为表现的变化，例如，语句中多个图层显示的偏移量会保持一致。
如果想禁用这个特性，需要在配置中添加：

::

    define config.keep_show_layer_state = False


如果并非不兼容性变更导致， :func:`renpy.list_files` 会以标准顺序将变更排序。
这会触发Ren'Py对存在歧义的行为进行定，并产生确定的唯一结果。
例如，images目录下有多个同名文件，Ren'Py会随机选取其中之一。(在不同的系统上，选取的文件可能不同。)
现在，Ren'Py运行时总是会选择同一个文件。

.. _incompatible-6.99-12.3:

6.99.12.3
---------

开发者模式下，Ren'Py不再搜索系统已安装的字体文件。
如果游戏使用系统已安装的字体，字体文件应该被复制到game目录下。(但是请确保这个行为符合字体文件的使用许可。)

.. _incompatible-6.99-11:

6.99.11
-------

``style`` 和``translate`` 语句的执行顺序已经改变，详见文档 `the changelog <https://www.renpy.org/doc/html/changelog.html#ren-py-6-99-11>`_ 。
如果不使用这个特性，需要在配置中添加：

::

    define config.new_translate_order = False

注意，不使用这个变更会让新版本的GUI也无法生效。

配置项 :var:`config.quit_action` 的默认值已经变更，改为“游戏中”上下文(context)时退出才会给提示。
如果不使用这个特性，需要在配置中添加：

::

    define config.quit_action = ui.gamemenus("_quit_prompt")


现在Ren'Py增大了按钮和窗口所允许的最大尺寸。
如果不使用这个特性，需要在配置中添加：

::

    define config.enforce_window_max_size = False

.. _incompatible-6.99-9:

6.99.9
------

现在Ren'Py在名为“audio”的通道上播放接口音效，并且支持同时播放多个音效。
该通道的设置未必与定制化的音效通道相同。audio通道可以通过调整配置项 :var:`config.auto_channels` 的值来改变。
或者添加如下代码使用sound通道。

::

    define config.play_channel = "sound"

.. _incompatible-6.99-2:

6.99.2
------

现在Ren'Py会自动扫描图片目录(game目录下名为images的子目录)并搜索图片文件，并基于图片文件名自动定义图像(image)。
如果不使用这个特性，需要在配置中添加：

::

    init python:
        config.image_directory = None


.. _incompatible-6.18:

6.18
----

现在 ``show screen`` 和 ``call screen`` 语句将在界面预处理进程中计算使用的入参。
如果计算结果对某个界面可能会产生副作用， ``show screen`` 和 ``call screen`` 后面就需要使用新增的 ``nopredict`` 分句，这样就不进行预处理。

界面(screen)现在可以接受转场(transition)——转场效果可以让界面从旧的状态转变到新的状态。
如果不使用这个特性，需要将配置项 :var:`config.transition_screens` 设置为false。

同名tag的界面互相替换时，Ren'Py不在使用等式赋值方式转换界面状态。
现在的方法是， :ref:`use语句 <sl-use>` 现在支持 ``id`` 特性，这个特性可以用于显式转换界面状态。

.. _incompatible-6.16:

6.16
----

如果需要使用原来的特性，需要将 `loop` 和 `single_track` 同时设置为true。

.. _incompatible-6.15.7:

6.15.7
------

Ren'Py在 :func:`Preference` 函数中加入了“auto-forward”，可用于控制自动前进模式。
如果需要使用自动前进模式滑动条，就将配置将 :var:`config.default_afm_enable` 设置为None。

.. _incompatible-6.14:

6.14
----

以前的版本中，Ren'Py会将归档文件放入archived目录。当运行游戏或生成归档时，Ren'Py会自动搜索该目录。
现在有了一键打包功能，就没有必要执行这步操作，所有原来在archived目录里的文件都应该移到game目录下。

:func:`MoveTransition` 修改了接口。
如果创作者不想使用重写代码，可以使用OldMoveTransition实现旧版本MoveTransition的功能。
(新旧版本的变化，仅跟使用MoveTransition实现的效果有关。)

:func:`Transform` 修改了特性，可以实现图片的非对称缩放和旋转。这与旧版的使用方法不同。


.. _incompatible-6.13.8:

6.13.8
------

旧式的字符串替换重新默认为启用状态。
如果创作者写的代码(使用6.13和6.13.7之间的版本)，在say语句或menu语句中使用了 % ，可以直接替换为 %% ，或者添加如下代码：

::

    init python:
        config.old_substitutions = False

.. _incompatible-6.13:

6.13
----

关于文本特性的许多变化会对游戏开发产生多种影响。
最大的变化是，引入了新式的(方括号)文本替换，并淘汰了旧式的(使用百分号)文本替换方案。
如果需要恢复旧式特性，需要使用以下配置：

::

    init python:
        config.old_substitutions = True
        config.new_substitutions = False

将两项都设置为True后，就可以在同一个游戏里混用新式和旧式文本替换。

Ren'Py还修改了默认的线性传送(line-wrapping)特性。新的特性不会再增加某个段落中的的行数，它可能会修改每行内单词。
如果需要使用旧特性，可以添加如下代码：

::

    init python:
        style.default.layout = "greedy"
        style.default.language = "western"

行间距为负数的bug已经修复。这个修复能导致语句块中显示文本高度会有一点缩进。
如果需要使用旧版特性，使用如下配置：

::

    init python:
        config.broken_line_spacing = True

最后，新的文本代码可能会在显示慢速文本时需要手工调整，特别是在负值的行间距情况下。
可以考虑调整 :propref:`line_overlap_split` 的值来修正。

.. _incompatible-6.12.1:

6.12.1
------

图像的名称，已经从静态名改为基于属性的命名方式。这个特性可能会导致原先唯一的图像名称变成同名图像。
如果需要禁用基础属性的图像命名，将配置项 :var:`config.image_attributes` 设置为False。

不显式提供一个变换(transform)或ATL语句块(block)的情况下显示某个图像，将保持那个图像前一个使用的变换(transform)。
这意味着，某个移动中的图像将保持移动状态。如果需要使用旧的特性，可以将配置项 :var:`config.keep_running_transform` 设置为False。

:func:`Character` 的 `image` 入参含义发生变化。
旧版本的含义在基于界面环境下不能被支持。
出于兼容性的考量，将配置项 :var:`config.new_character_image_argument` 设置为False可以使用恢复旧版的含义。

.. _incompatible-6.12.0:

6.12.0
------

:ref:`choice-screen` 和 ``nvl_choice`` 界面内的 `items` 参数定义已改变。
``nvl_choice`` 界面不再作为 :ref:`nvl-screen` 的代替。

为了允许预加载图像，可以在任意时刻唤起界面，除非预加载特性(property)的值是False。
当预加载特性的值不为False时，从最初的显示开始，界面就不应该导致任何副作用。

由于某些性能原因，Ren'Py现在忽略ImageReference的位置特性(property)。
这意味着style.image_placement类型的位置特性都会被忽略。如果需要恢复旧版本的特性，将配置项 :var:`config.imagereference_respects_position` 设置为True。

.. _incompatible-6.11.1:

6.11.1
------

:func:`MoveTransition` 已修改为适应移动可视组件的xoffset和yoffset参数。
用于移动的功能函数现在使用 `xoffset` 和 `yoffset` 作为入参。内建的移动功能函数使用这些参数可以正常运行。
用户自定义功能函数需要升级，正确使用或者忽略这些新增入参。


.. _incompatible-6.11.0:

6.11.0
------

* 通过配置项 :var:`config.default_transform` 指定的变换(transform)用于初始化show和hide语句中图像的变换特性(property)。该变换的默认值将 :propref:`xpos` 和 :propref:`xanchor` 设置为0.5， :propref:`ypos` 和 :propref:`yanchor` 设置为1.0。

  这个特性防止风格特性的默认值发生改变。在之前的版本中，风格特性未被初始化的情况下，默认值均为0.

  在ATL变换中包含 :var:`reset` ，所有这些特性都可以被重新设置回0。因此，创作者可以停用默认变化，并恢复到老版本的特性，使用如下配置：

  ::

    init python:
        style.image_placement.xpos = 0.5
        style.image_placement.ypos = 1.0
        style.image_placement.xanchor = 0.5
        style.image_placement.yanchor = 1.0

        config.default_transform = None

* 如果某个变换没有定义全部的位置(position)特性，包括 :propref:`xpos`， :propref:`ypos`， :propref:`xanchor` 和 :propref:`yanchor` ，就会尝试从该变化的子组件或子特性中获取对应特性的值，前提是其子组件或子特性中定义了对应特性的值。

  这个特性允许某个变换控制可视组件的水平运动，而另一个变换控制可视组件的垂直运动。不过这个特性与之前的不兼容。
  可以修改配置项 :var:`config.transform_uses_child_position` 禁用新特性。

  ::

    init python:
        config.transform_uses_child_position = False

.. _incompatible-6.10.1:

6.10.0
------

* 几个默认的位置名称(left，right，center，truecenter，offscreenleft和offscreenright)，现在已定义为ATL变换(transform)。这意味着在某个位置显示图像后，图像的位置会被记录。如果不需要使用这个特性，要重定义所有位置，添加如下代码：

::

    define left = Position(xalign=0.0)
    define center = Position(xalign=0.5)
    define truecenter = Position(xalign=0.5, yalign=0.5)
    define right = Position(xalign=1.0)
    define offscreenleft = Position(xpos=0.0, xanchor=1.0)
    define offscreenright = Position(xpos=1.0, xanchor=0.0)

.. _incompatible-6.9.2:

6.9.2
-----

* 如果要将你的游戏从Ren'Py 6.9.2或更低版本迁移到高版本，将包含游戏的目录复制到工程目录中。创作者可以点击启动器中的“设置”、再进入“工程目录”，即可选中一个需要的工程。详见 `Ren'Py 6.9.2 发布说明 <http://www.renpy.org/wiki/renpy/releases/6.9.2>`_ 查看更低版本的迁移方法。

