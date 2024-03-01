.. _dialogue-and-narration:

对话(dialogue)和旁白(narration)
================================

文本是视觉系小说的根本，对以故事情节为主的游戏来说更是重中之重。这里说的文本可能包括使用人物名字作为标签(label)的对话，以及不存在任何主体的旁白。(为了偷懒，我们把对话和旁白统称为对话，除非某些场合下两者有重大区别。)由于对话如此重要，创作者需要能够定制化对话的某些特性使其符合制作游戏的特色。

在Ren'Py中，大多数对话使用say语句编写。通过使用角色(character)对象，对话外观可以针对每一个角色实行定制化。

.. _say-statement:

say语句
-------------

say语句被用在对话和旁白场景中。由于在Ren'Py脚本中say语句出现如此之频繁，所以在编写say语句的语法是一个最小化后的语法结构。这是一些样例::

    ###
        "这是一句旁白。"

        "艾琳" "这是一句对话，用了完整的角色名。"

        e "这是一句对话，使用了角色对象。"

        "嘭!!" with vpunch

say语句的第一种形式是一个其自身组成的整个字符串。这种形式用于陈述，陈述内容就是字符串内容。

say语句的第二种形式是由两个字符串组成。第一个字符串是发言角色的名字，第二个字符串是该角色正在说的内容。

say语句的第三种形式是一个简单表达式后接一个字符串。简单表达式应该等同于一个角色名字或者一个角色(character)对象。在后面的例子中，角色对象被用于控制对话展现。

say语句的最后一种形式是一个字符串及with分句的一个转场(transition)效果。在上面的例子中，字符串会显示为对话内容，屏幕会同步抖动。


尽管say语句所处理对话的具体细节实际是由角色(character)对象所控制，say语句的通常用处是在界面上展现一个对话，直到用户点击鼠标后取消对话，并在界面上移除对话内容。

某些字符对Ren'Py有特殊含义，所以不能用在对话字符串中。左花括号 ``{`` 开启一个文本标签(tag)，左方括号 ``[`` 开启一个替换(substitution)。若需要在对话中使用这些字符，需要连续出现两次。而转移双引号则需要使用反斜杠符号，不然字符串会在那个引号处截断。应用举例

::

    ###
        "I walked past a sign saying, \"Let's give it 100%!\""

也可以使用代理函数代替角色对象。详见 :ref:`此章节 <say-proxy>`。

.. _defining-character-objects:

定义角色(character)对象
--------------------------

通过创建一个角色对象并在say语句中使用该角色对象，你可以定制化对话窗口外观(甚至行为)。角色对象通过使用define语句，将角色(character)声明为一个变量。举例::

    define e = Character("艾琳", who_color="#c8ffc8")

完成了这步工作后，定义的角色就可以使用在say语句中。例如：

::

        e "Hello, world."

角色(Character)是一个python函数，该函数包含一大串的关键词参数。这些关键词参数控制着角色行为。

define语句会计算其自身的表达式，并声明为一个给定的变量名。若 ``define`` 语句不在 ``init`` 语句块(block)中，其会自动以与初始化相同的最高优先级(0)运行。

.. function:: Character(name, kind=adv, **args)

    创建并返回了一个角色对象，其控制了对话和旁白的观感。

    `name`
        如果该参数是一个字符串，则成为对话中角色的名字。如果 *name* 参数是 ``None`` ，名字不会显示，用于旁白。

    `kind`
        新建角色的基底角色。当使用该参数时，新建角色没有显示赋值的参数，均使用对应基底角色的属性作为默认值。这个设计常用来定义模板(template)角色，然后继承模板角色属性并修改。

    **链接图片** 与某个角色关联的图像标签(tag)名。这种设计，允许一个包含角色的say语句使用标签(tag)名来展现角色图片，也同时允许角色说话时Ren'Py自动选择并展现一个头像。

    `image`
        与角色关联的图像标签(tag)名的字符串。

    **语音标签(tag)** 若某个声音标签(tag)被指定为某个角色所有，标签下对应的声音文件将会与该角色关联，这些声音文件可以在自定义设置界面被静音或者被播放。

    `voice_tag`
        voice_tag是一个字符串，在“voice”频道内可以voice_tag可以控制关联角色声音文件的静音或者播放。

    **前缀和后缀** 这个设计允许在角色名字或者展现文本上添加前缀和后缀。前缀和后缀可以用在每一行对话的前后添加引用内容。

    `what_prefix`
        显示对话内容之前，添加的前缀字符串。

    `what_suffix`
        显示对话内容之前，添加的后缀字符串。

    `who_prefix`
        显示角色名字之前，添加的前缀字符串。

    `who_suffix`
        显示角色名字之前，添加的后缀字符串。

    **改变角色显示名** 该可选项用于控制显示角色名。

    `dynamic`
        该参数若为True，角色名 `name` 应是一个包含python表达式的字符串。该字符串会在每行对话执行前先演算，将演算结果用作角色名。

    **互动控制** 这些可选项在“对话展示、发生互动、模式输入”情况下控制显示效果。

    `condition`
        若给定，该参数应是一个包含python表达式的字符串。若表达式结果为False，对话不会发生，即say语句不会执行。

    `interact`
        若该值为True，默认情况下无论对话何时被展现，都会发生一项互动。若该值为False，则互动不会发生，而一些额外元素可以被添加到界面上。

    `advance`
        若该值为True，默认情况下用户可以快进语句执行，还有一些其他的快进方式(比如跳过skip和auto-forward mode自动前进模式)也将生效。若该值为False，用户不能跳过say语句，除非脚本中出现某些替换方法(比如跳转超链接)。

    `mode`
        该参数是一个字符串，给定了角色发言时进入的模式(mode)。详见 :ref:`模式(mode) <modes>` 章节。

    `callback`
        角色发言时，若有事件(event)发生则会被调用的函数。详见 :ref:`角色(character)回调(callback) <character-callbacks>` 章节。

    **点击继续** “点击继续”提示是在(一段内容)所有文本均已展示完的情况下，通常出现一次，提醒用户进入下一部分内容。

    `ctc`
        一个用做“点击继续”提示的可展现部件，若有其他特殊提示被使用时可能不会展现。

    `ctc_pause`
        当文本显示被{p}或{w}标签(tag)暂停时，用作“点击继续”提示的一个可视组件。

    `ctc_timedpause`
        当文本显示被{p=}或{w=}标签(tag)暂停时，用作“点击继续”提示的一个可视组件。当该值为None时，会使用 `ctc_pause` 的值作为默认值。若你想要使用 `ctc_pause` 而不是 `ctc_timedpause` ，请使用 ``Null()`` 。

    `ctc_position`
        该参数控制“点击继续”提示的位置。若值为 ``"nestled"`` ，该提示会作为目前展示文本的一部分出现，在最后一个字符显示后立即出现相应提示。若值为 ``"fixed"`` ，提示会被直接添加到界面上，其在界面上的位置由位置样式属性控制。

    **界面** 显示对话使用到一个 :ref:`界面 <screens>` 。该入参允许你选择界面(screen)，并传入参数。

    `screen`
        显示对话时使用的界面名。

    关键词参数以前缀 ``show_`` 开头，去掉前缀后传参给界面(screen)。例如， ``show_myflag`` 的值会改为变量 ``myflag`` 并传参给界面(screen)。(myflag变量并不是默认会用参数，但可以被一个定制对话界面使用。)

    鉴于某些历史原因，show系列变量由Ren'Py引擎处理：

    `show_layer`
        若给定了这个参数，其应该是一个字符串，这个字符串给定了展现“说话”界面所在图层的名字。

    **样式化文本和窗口** 以 ``who_`` 、 ``what_`` 和 ``window_`` 开头的关键词参数，会去掉前缀后分别用于 `样式 <styles>` 角色名、对话文本和窗口内容。

    例如，若一个角色被给定了关键词参数 ``who_color="#c8ffc8"`` ，角色名的颜色就被改变，这里的例子中会被改成绿色。 ``window_background="frame.png"`` 是把包含该角色的对话窗口背景设置为图片frame.png。

    应用于角色名、对话文本和窗口的样式化，也可以使用这种方式进行设置：分别对应使用 ``who_style`` ， ``what_style`` 和 ``window_style`` 参数。

    设置 :var:`config.character_id_prefixes` 后，就可以样式化其他可视组件了。例如，如果使用了默认的GUI配置，带有前缀 `namebox_` 的样式将会应用在发言角色名上。

.. _say-with-image-attributes:

带有图像属性(attribute)的say语句
----------------------------------

当一个角色与一个图像标签(tab)关联，包含对应角色的say语句将在角色名和第二个字符串之间就可以插入图像属性(attribute)。

在这中情况下，如果带有给定标签(tag)的某个图片需要显示，Ren'Py会定位一条包含角色标签(tag)和属性(attribute)的show命令。如果图片未显示，Ren'Py会保存属性(attribute)并用于头像，但依然不会显示图片。


举例::

    define e = Character("艾琳", image="eileen")

    label start:

        show eileen mad
        e "我对你有点失望。"

        e happy "不过这都是过去的事了。"

等价于::

    define e = Character("艾琳")

    label start:

        show eileen mad
        e "我对你有点失望。"

        show eileen happy
        e "不过这都是过去的事了。"

在上面的例子中，``mad`` 和 ``happy`` 会互相替换。
不过也可以可以直接从 ``happy`` 恢复而不用指定 ``mad`` 属性。
办法是使用减号(-)，具体请参考 :ref:`show语句 <show-statement>`。

举例：

::

    define e = Character("艾琳")

    label start:

        show eileen
        e mad "我对你有点失望。"

        e happy "虽然还挺有趣的。"

        e -happy "我不清楚现在该怎么看了。"

如果在图像属性前面加一个 ``@`` 符号，图像属性的改变将是临时性的，在执行完这行对话脚本后会恢复成上一个图像属性。

举例：

    define e = Character("艾琳", image="eileen")

    label start:

        show eileen mad
        e "我对你有点失望。"

        e @ happy "虽然还挺有趣的。"

        e "我不清楚现在该怎么看了。"

两种语法可以混用，在 ``@`` 符号之前表示永久改变，符号后面表示临时改变一次。

::

    e happy @ vhappy "真的！一切都改变了。"

减号也可以与 ``@`` 符号混用：

::

    e @ right -mad "我的怒火暂时得到了平息……"
    e "但是！"

使用这个方式，若需要在图片改变时触发一个转场(transition)效果的话，将config.say_attribute_transition设置为一种转场(transition)即可。
若要设置更多控制项，可以使用 :var:`config.say_attribute_transition_callback` 。

.. _example-characters:

样例角色
------------------

这是一些样例角色::

    # 角色的对话内容包含在一对圆括号中。
    define e = Character("艾琳", what_prefix='(', what_suffix=')')

    # 从一个变量中获取角色名称。
    define p = Character("player_name", dynamic=True)

.. _special-characters:

特殊角色
------------------

一些角色名是系统预定义的，并会在某些场合自动启动。有意地重定义这些角色可以改变Ren'Py引擎的行为，但意外使用的话很可能会引发问题。

``adv``
    使用角色(character)定义生成的默认角色类型。这种类型的角色在界面上同一时间只能显示一行文本。

``nvl``
    在 :doc:`nvl_mode` 下可以引发对话的角色类型。这种类型的角色可以在界面上一次显示多行文本。

``narrator``
    旁白角色，不需要角色名的say语句中使用。

``name_only``
    给定一个字符串，该字符串用作对话中显示角色名。这种角色可以被复制为一个给定名字的新角色，而新角色在显示的对话中使用同样的名字。

``centered``
    该类型角色的台词会显示在界面正中间，在所有窗口外面。

``vcentered``
    该类型角色的台词会竖直显示在界面正中间，在所有窗口外面。

.. _extend:

``extend``
    使用最近一个发言角色，在原有对话内容后追加一行台词。快速扩展对话。这可以用于界面变更后的对话内容延续。

    扩展(extend)能识别NVL模式，并正确处理该模式下的内容。
    但在NVL模式下修改语言设置，则extend内容将无法正确显示。

举例::

    # 展现对话的第一行台词，等待一个点击事件，变更角色表情，然后展示其余台词。

    show eileen concerned
    e "有时候，我会感到忧伤。"
    show eileen happy
    extend " 但是我通常很快就能恢复过来！"

    # 与上面类似，不同之处在于，当第一行台词结束后自动变更角色表情。
    # 只有当用户始终没有自己设置文本显示速度的情况下，这种设计才是合理的。


    show eileen concerned
    e "有时候，我会感到忧伤。{nw}"
    show eileen happy
    extend " 但是我通常很快就能恢复过来！"

.. _dialogue-window-management:

对话窗口管理
--------------------------

Ren'Py中包括几种语句，允许管理对话窗口。由于对话窗口在对话中一直是展现的，这些窗口控制语句在非对话互动的情况下控制窗口的出现或者消失。

``window show``
  window show语句触发窗口展现。该语句接受一个可选入参，入参为transition，用于窗口出现的转场效果。如果transition参数为空，将使用定义在  :var:`config.window_show_transition` 的值。

``window hide``
  window hide语句触发窗口隐藏。该语句接受一个可选入参，入参为transition，用于窗口隐藏的转场效果。如果transition参数为空，将使用定义在  :var:`config.window_hide_transition` 的值。

``window auto``
  window auto语句启用了窗口自动管理。在 :var:`config.window_auto_show` 中列出的语句——默认是say语句前，窗口会自动展现。在 :var:`config.window_auto_hide` 中列出的语句——默认是 ``scene`` 和 ``call screen`` 以及带标题的 ``menu`` 语句前，窗口会自动隐藏。(只有直接显式使用该语句才有效，而函数返回该语句内容相同的字符串不生效。)

``window auto`` 语句分别使用 :var:`config.window_show_transition` 和 :var:`config.window_hide_transition` 作为显示和隐藏窗口的转场效果。 ``window auto`` 启用的自动化管理可以被 ``window show`` 或者 ``window hide`` 语句关闭。

举例：

::

    window show # 使用默认转场效果显示窗口
    pause       # 在暂停中依然显示窗口
    window hide # 隐藏窗口
    pause       # 在暂停中依然隐藏窗口

    window show dissolve # 使用融化(dissolve)效果显示窗口
    pause                # 在暂停中依然显示窗口
    window hide dissolve # 使用融化(dissolve)效果隐藏窗口
    pause                # 在暂停中依然隐藏窗口


    window auto

    "The window is automatically shown before this line of dialogue."
    pause                # 在暂停中依然显示窗口

    scene bg washington  # 在场景(scene)切换前隐藏窗口
    with dissolve

对话窗口管理是
:func:`Preference` 特性构造器“show empty window”一项的主题。若“show empty window”特性被关闭，以上语句均不会产生任何效果。

.. _say-with-arguments:

带有参数的say语句
------------------

使用语句后面圆括号包含的入参值可以传给say语句。举例::

    e "Hello, world." (what_color="#8c8")

传入say语句的参数首先会被 var:`config.say_arguments_callback` 回调函数处理，前提是入参不是None。若有回调函数无法处理的参数，将会被传给角色(character)，因为这些参数会被看作定义角色所需。上面的样例会将对话显示为绿色。

特殊关键词 `_mode` 和 `_with_node` 将在本次互动中覆盖原设置的字符。

`interact` 参数是个特殊情况：当定义角色对象时就把该参数设置为False后，即使后面再次传入 ``interact=True`` 也依然不能覆盖原设置，也就是说角色依然不会对互动有反应。

注意，:var:`config.say_arguments_callback` 配置的回调函数并不会在传入参时调用，而且也并不是每条say语句执行时都被调用。
该配置项可以用来实现角色面对不同情况时的不同反应。例如：

::

    init python:
        def say_arguments_callback(char, *args, **kwargs):
            if colorblind_mode:
                kwargs["what_color"] = "#000"
            return args, kwargs

    define config.say_arguments_callback = say_arguments_callback

.. _monologue-mode:

独白模式
--------------

某些视觉小说会有大段连续的旁白，或者同一个角色的多段会话内容。这种情况下，脚本里反复写入角色名称和引号就显得很累赘。

为了应对这些情况，Ren'Py提供了独白模式。将对话内容放入成对的3个双引号中，Ren'Py会根据对话内容中的空行自动分段。
分段后的每一段内容，都会创建自身的say语句。这里的一个样例，包含3段旁白，将分为3段对话。

::

    """
    这是第一行旁白。第一行比其他两行都长，所以它将换行
    (补足字数补足字数补足字数补足字数)。

    这是第二行旁白。

    这是第三行旁白。
    """

    e """
    这是对话的第一行。第一行比其他两行都长，所以它将换行
    (补足字数补足字数补足字数补足字数)。

    这是对话的第二行。

    这是对话的第三行。
    """

say语句后面可能会有分句，并带上入参或者属性(attribute)。这些入参或者属相将在独白中分配给每一行。

如果创作者想要忽略段落之间的空行，可以在脚本文件最外层，并且第一行独白之前写一条 ``rpy monologue single`` 。
(译者注：即，不使用空行自动分段。)

如果想要禁用该设置，或者混用三重双引号与单条对话的形式，可以使用 ``rpy monologue none`` 标记独白模式的结尾位置。

.. _the-character-store:

``character`` 存储区
-----------------------

*主要内容在* :ref:`named-stores` 。

say语句会在默认存储区之前先搜索 ``character`` 命名存储区。
如果你想要默认存储区中保存一个与角色名字相同的变量，需要这样定义：

::

    define character.e = Character("Eileen")

该角色就可以在默认存储区中像一般变量一样使用了：

::

    default e = 0

    label start:

        # 这依然是一个糟糕的变量名。
        $ e = 100

        e "我们现在还有 [e] 个单位的能量。"

这在管理某个角色相关的变量信息方面很有用，不会跟say语句发生冲突。

::

    define character.naomi = Character("Naomi Nagata", who_color="#8c8")
    default naomi = PersonClass(engineering=5, max_g_force=.7) # 可以是一个对象
    define character.fred = Character("Fred Johnson", who_color="#72f")
    default fred.money = 1000 # 可以是一个自定义命名空间中的变量
    default fred.rank = "Colonel"

    label traded:
        fred "这个给你。"
        $ fred.money -= 50
        $ naomi.money += 50
        naomi "Thanks ! I knew you would value my class-[naomi.engineering] engineering skills."
        naomi "感谢！我就知道你会意识到我 [naomi.engineering] 级工程技能的价值。"

.. _alternative-presentations:

其他表现形式
------------

:doc:`nvl_mode` ：在整个屏幕显示对话内容的模式。

:doc:`bubble` ：使用台词气泡来显示对话内容，并且使用可互动的方式调整气泡位置。

.. _see-also:

其他参考
--------

:doc:`statement_equivalents` ：如何在Python中使用本章节描述的大多数功能特性，虽然有一些制约条件。

:func:`renpy.last_say` ：提供最后一条say语句的信息。
