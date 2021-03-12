.. _translation:

===========
多语言支持
===========

(译者注：原文为“Translation”。将translation直译为“翻译”，容易引发歧义，所以文档中单独出现时一律使用“多语言支持”，“translation file”则翻译为“翻译文件”。)
Ren'Py包含了视觉系小说多语言支持的综合框架。有4类要素支持多语言：

对话
    脚本的主对话能够支持多语言，包括各行文本内容的分割、合并、删除和调整的一套规则。

菜单和接口字符串
    所有接口文本都支持多语言。

图像和文件
    选择某种语言时，可以使用对应的一系列图片和其他文件。

样式
    可以基于语言实现样式定制化，这样游戏会自动切换为对应某种语言的样式。

目前Ren'Py的多语言支持主要聚焦在标准化的多语言支持。如果实现的话，创作者就可以使用将游戏脚本直接扔给多语言解释器，或者自己创建多语言模板。目前支持的非标准化多语言支持有诸多限制。

.. _primary-and-alternate-languages:

主语言和备选语言
===============================

Ren'Py需要每一个作品都使用一种主语言编写。这种主语言无论具体是哪国的，都被称作 ``None`` 语言。(如果使用英语编写，英语就是 ``None`` 语言。)

当选择使用None语言后，Ren'Py的大多数多语言支持功能都会关闭。

备选语言在作品中出现时，推荐使用原来的Python标识符连写两次。(格式为，以字母或下划线开头，后面跟字母、数字或者下划线。)

.. _generating-translation-files:

生成翻译文件
============================

当项目脚本是正常可用的情况下，我们可以在Ren'Py启动器中选择“生成翻译文件”。启动器将提示你需要生成的语言名称，然后创建或更新翻译文件。

翻译文件是在game文件夹中一个名为“tl”的子文件夹下的同名目录中。例如，如果你为tutorial项目创建了piglatin的语言支持，对应的语言支持文件将会放在 ``tutorial/game/tl/piglatin`` 目录下。

每一个游戏脚本文件都会被创建对应的翻译文件。common.rpy文件也会被创建，其内容包含所有Ren'Py制作游戏使用的通用字符串的多语言支持。

.. _translating-dialogue:

多语言对话
====================

因为Ren'Py是一个视觉系小说引擎，我们最需要的自然就是对话的多语言支持。Ren'Py包含了一个具有可塑性的框架，允许对话内容的分割、合并、调整顺序及整段删除。

.. _translation-units:

多语言支持的单元
-----------------

一个由0个或多个可支持多语言的语句构成的语句块(block)是多语言支持的基础单元，后面可选加上一条say语句。可支持多语言的语句包括voice和nvl语句。例如下面脚本中的：

::

    label start:
        e "Thank you for taking a look at the Ren'Py translation framework."

        show eileen happy

        e "We aim to provide a comprehensive framework for translating dialogue, strings, images, and styles."

        e "Pretty much everything your game needs!"

这段脚本可以分割为多个多语言支持单元。每个单元都有对应的一个标识符用于声明该单元。标识符根据单元前的脚本标签(label)和单元内的语句来生成。(如果多个单元被声明为同一个多语言数字，从第二个单元开始会自动添加上一个自然数编号便于区分。)

在上面的样例脚本中，第一个单元生成的标识号为start_636ae3f5，包含这条语句：

::

    e "Thank you for taking a look at the Ren'Py translation framework."

第二个单元的标识号是start_bd1ad9e1m，包含这条语句：

::

    e "We aim to provide a comprehensive framework for translating dialogue, strings, images, and styles."

第三个单元的标识号是start_9e949aac，包含这条语句：

::

    e "Pretty much everything your game needs!"

当游戏脚本加载时，这些多语言支持的单元会被Ren'Py自动创建。

.. _translate-statement:

translate语句
-------------------

当你生成了对某种语言的支持时，Ren'Py会针对每一个多语言支持单元生成一条translate语句。我们再以刚才的那段脚本举例，Ren'Py生成的语句如下：

::

    # game/script.rpy:95
    translate piglatin start_636ae3f5:

        # e "Thank you for taking a look at the Ren'Py translation framework."
        e ""

    # game/script.rpy:99
    translate piglatin start_bd1ad9e1:

        # e "We aim to provide a comprehensive framework for translating dialogue, strings, images, and styles."
        e ""

    # game/script.rpy:101
    translate piglatin start_9e949aac:

        # e "Pretty much everything your game needs!"
        e ""

编辑这个文件就可以实现对piglatin语言的支持了。完成编辑后的样子如下：

::

    # game/script.rpy:95
    translate piglatin start_636ae3f5:
        # e "Thank you for taking a look at the Ren'Py translation framework."
        e "Ankthay ouyay orfay akingtay away ooklay atway ethay En'Pyray anslationtray ameworkfray."

    # game/script.rpy:99
    translate piglatin start_bd1ad9e1:

        # e "We aim to provide a comprehensive framework for translating dialogue, strings, images, and styles."
        e "Eway aimway otay ovidepray away omprehensivecay ameworkfray orfay anslatingtray ialogueday, ingsstray, imagesway, andway ylesstay."

    # game/script.rpy:101
    translate piglatin start_9e949aac:

        # e "Pretty much everything your game needs!"
        e "Ettypray uchmay everythingway ouryay amegay eedsnay!"


当引擎在主线脚本中遇到一个语句块(block)，Ren'Py就会检查是否存在对应的translate语句存在。如果存在的话，Ren'Py将会执行translate语句，并向用户显示对应语言的内容。

.. _more-complex-translations:

更复杂的多语言支持
-------------------------

translate语句中数量并不要求与原语言语句数量保持1比1。例如，一行很长的语句可以分割：

::

    # game/script.rpy:99
    translate piglatin start_bd1ad9e1:
        # e "We aim to provide a comprehensive framework for translating dialogue, strings, images, and styles."
        e "Eway aimway otay ovidepray away omprehensivecay ameworkfray..."
        e "...orfay anslatingtray ialogueday, ingsstray, imagesway, andway ylesstay."


或者某条语句可以移除，并用pass语句代替。::

    # game/script.rpy:101
    translate piglatin start_9e949aac:

         # e "Pretty much everything your game needs!"
         pass

甚至可以运行非对话型的语句，比如条件语句或者Python语句。例如，我们可以把下面这句：

::

  e "You scored [points] points!"

在其他语言中写成：

::

    # game/script.rpy:103
    translate piglatin start_36562aba:

        # e "You scored [points] points!"
        $ latin_points = to_roman_numerals(points)
        e "Ouyay oredscay [latin_points] ointspay!"

.. _tips:

小贴士
-------

在处理多语言支持的对话内容时必须非常小心，特别是某个脚本标签(label)下某个对话内容重复多次的情况。在某些时候，有必要在主语言脚本中直接声明多语言支持的标识符，像这条语句：

::

    translate None mylable_03ac197e_1:
        "..."

增加文本标签(label)也可能会导致多语言支持冲突。为了防止这种情况出现，脚本标签(label)后加上一个hide分句就可以在翻译文件生成时忽略这个标签：

::

    label ignored_by_translation hide:
        "..."

由于多语言语句块(block)中可以包含Python语句，这些Python语句不应该在超过其所处语句块(block)之外造成任何副作用。这是因为，切换语言会重启多语言支持语句块(block)，语句块内的Python语句的副作用会发生多次。

.. _string-translations:

菜单和字符串的多语言支持
============================

除了对话，Ren'Py也可以提供菜单与其他字符串内文本的多语言支持。接口的各种语言文本条数是严格1比1对应的。某个字符串被对上的话，就能被另一种语言的字符串替换。

当生成翻译文件时，Ren'Py会扫描脚本文件中的菜单和 _()函数中定义的字符串。然后它会将这些字符串内容放入一个多语言字符串语句块(block)中。例如，如果我们有如下的脚本内容：

::

  define e = Character(_("Eileen"))

  # ...

  menu:

       "Go West":
          # ...

       "Head East":
          # ...

Ren'Py会自动生成：

::

  translate piglatin strings:

      old "Eileen"
      new ""

      old "Go West"
      new ""

      old "Head East"
      new ""

完成后的多语言支持内容为：

::

  translate piglatin strings:

      old "Eileen"
      new "Eileenway"

      old "Go West"
      new "Ogay Estway"

      old "Head East"
      new "Eadhay Eastway"

字符串的多语言支持用于在对话中内插的某些字符串。那些字符串不能以对话形式支持多语言。

如果某个字符串同时用在多处，可以使用{#...}文本标签(tag)加以区别。尽管这些字符串使用同样的名字，Ren'Py把这些稍有差别的字符串看作需要多语言支持：

::

    "New"
    "New{#project}"
    "New{#game}"
    "New{#playlist}"

translate字符串语句可以用来对None语言脚本的转换。在使用非英语编写的游戏中，translate字符串语句可以用来转换Ren'Py的用户接口。::

    translate None strings:
         old "Start Game"
         new "Artstay Amegay"

.. _translating-substitutions:

多语言替换
-------------------------

!t标志用于表示多语言的字符串转换。下面这段脚本使用了原对话和多语言字符串的组合：

::

  if mood_points > 5:
      $ mood = _("great")
  else:
      $ mood = _("awful")

  "I'm feeling [mood!t]."

.. _extract-merge-translations:

提取和复用多语言字符串
------------------------------------------

多语言字符串可以从某个项目中提取，然后移植到另一个项目。完成这点需要以下步骤：

* 选取来源项目，并选择“生成翻译文件”。
* 输入需要提取的语言，并点击“导出字串翻译”。
* 回到主菜单，选取目标项目，并选择“生成翻译文件”。
* 输入需要复用的语言(通常与之前提取的语言相通)，并选择“合并字串翻译”。

这里有两个选项，控制语言的复用功能：

替换已存在的翻译
    如果选用这项，已经存在的重要翻译文件会被覆盖。默认情况下，复用过程会拒绝覆盖已经存在的重要翻译文件。

反转语言
    在复用之前反转主备语言类型。例如，使用一个原本英语为主语言俄语为备选语言的项目，复用为“俄语为主语言英语为备选语言”的项目时，就需要勾选该项。

.. _image-and-file-translations:

图片和文件的多语言支持
===========================

当让一个游戏支持多语言时，最好替换文件时带一个语言版本号。例如，某个图片包含文本，最好的办法是使用带其他文字的图片替换。而那个新的图片带一个语言版本号。

Ren'Py遇到这种情况时，会在translation文件夹里寻找对应的图片。例如，假如使用了“piglatin”语言，并加载了“library.png”图片，Ren'Py就会使用“game/tl/piglatin/library.png”图片代替“game/library.png”。

.. _style-translations:

样式的多语言支持
==================

当对某个游戏实现多语言支持时，最好变更样式(style)——特别是那些与字体相关的样式。Ren'Py使用多语言样式语句块(block)和多语言python语句块处理这类情况。这些语句块(block)可以更改语言相关的变量和样式。例如：

::

  translate piglatin style default:
      font "stonecutter.ttf"

以及等效的：

::

  translate piglatin python:
      style.default.font = "stonecutter.ttf"

当某种语言被激活——无论是游戏开始时还是中途修改语言——Ren'Py都会重设初始化环节内所有样式的内容。Ren'Py会运行所有与当前激活语言相关的translate python语句块和translate style语句块，保证文件中这些语句块被优先执行。最后，Ren'Py会重建所有样式，并使语言修改生效。

样式的多语言支持可以添加在任何.rpy文件中。

.. _default-language:

默认语言
================

使用以下方法可以选择默认语言：

* 根据设置的RENPY_LANGUAGE环境变量。
* 根据设置的 :var:`config.language` 。
* 使用之前游戏中选择的语言选项。
* 游戏第一次运行，并且 :var:`config.enable_language_autodetect` 的值是True时，Ren'Py会尝试使用 :var:`config.locale_to_language_function` 自动检测语言。
* 游戏第一次运行时，使用 :var:`config.default_language` 。(默认使用None语言。)
* 以上情况都未配置，使用None语言。

.. _translation-actions-functions-and-variables:

多语言支持的行为、函数和变量
=============================================

切换语言的主要办法是使用语言的行为函数。

.. function:: Language(language)

  将游戏语言改为  *language* 。

  `language`
    一个字符串，表示切换的目标语言命，若为None表示游戏脚本默认语言。

语言行为函数可以用于在自定义配置界面添加一个语言自定义选项。

::

    frame:
        style_prefix "pref"
        has vbox

        label _("Language")
        textbutton "English" action Language(None)
        textbutton "Igpay Atinlay" action Language("piglatin")

总共有两个与多语言支持相关的函数：

.. function:: renpy.change_language(language)

  一个字符串，表示切换的目标语言命，若为None表示游戏脚本默认语言。

.. function:: renpy.known_languages()

  返回已知语言的集。不包含默认语言None。

此外，还有3个与字符串多语言支持相关的函数：

.. function:: _(s)

   (单下划线)返回字符串s的原语言内容。Ren'Py会搜寻该函数传入的字符串，并把它们加入到多语言支持字符串列表中。这些字符串不会转换为其他语言，直到他们被显示过。

.. function:: __(s)

   (双下划线)返回字符串s转换成当前语言后的内容。该函数返回的字符串会被加入到多语言支持字符串列表中。注意字符串可以经历过双重转换。如果其匹配到一个对应的多语言字符串则显示转换后的结果。

   .. function:: _p(s)

     将一个字符串重新格式化并标记其是支持多语言的。使用文本组件显示的字符串是转换过语言的。该函数的用途是，使用表单格式(form)定义多行字符串：

   ::

       define config.about = _p("""
           These two lines will be combined together
           to form a long line.

           This line will be separate.
           """)

   重新格式化会将整段文本断行，移除每行开头和结尾的空白。整段文本末尾的空白行会被删除。段落中的空白行会被插入段落分割符。{p}文本标签(tag)可以断行，但不会增加新的空白行。

   在字符串多语言支持中的使用方式如下：

   ::

       old "These two lines will be combined together to form a long line.\n\nThis line will be separate."
       new _p("""
           These two lines will be combined together
           to form a long line. Bork bork bork.

           This line will be separate. Bork bork bork.
           """)

.. function:: renpy.translate_string(s, language=<renpy.object.Sentinel object at 0x7f6d7c3b4810>)

    将 `s` 立刻翻译为指定语言 `language` 并返回。
    如果 `language` 的值是Default，使用设置(preferences)中的语言。
    经过该函数翻译后的字符串 **不会** 被添加到可翻译字符串列表中。指定某个字符串的语言可能会导致其发生两次翻译的情况。

这里有两个语言相关的变量。一个是 :var:`config.language` ，用于改变游戏默认语言。

.. var:: _preferences.language

  当前语言名称，如果使用的是默认语言则是None。需要改变语言的话，调用 :func:`renpy.change_language` 函数。

.. _unsanctioned-translations:

非常规多语言支持
=========================

.. note::

    创建非常规多语言支持前，最好获取原游戏创作者的许可。

在没有游戏创作者原生支持的情况下，Ren'Py也有一点支持可以创建多语言支持。Ren'Py能根据游戏内所有字符串自动生成一个字符串多语言支持的文件。因为多语言字符串可以用在未转换过的对话，这个小技巧可以让游戏直接支持多语言。

想要创建一个字符串翻译文件，需要执行以下步骤：

* 设置环境变量RENPY_LANGUAGE为你想要添加的目标语言。
* 设置环境变量RENPY_UPDATE_STRINGS为一个非空值。
* 执行游戏直到看见目标文本内容。

这些操作会更新“game/tl/language/strings.rpy”文件，其中包含所有多语言字符串的一个模板。

如果某个游戏内部不支持更改语言，可以在 :var:`config.language`
中使用一个init python语句块(block)，强行切换到目标语言。

除了使用字符串的多语言支持解决对话的问题，上面描述的非常规多语言支持技巧也可以应用在图片和样式上。
