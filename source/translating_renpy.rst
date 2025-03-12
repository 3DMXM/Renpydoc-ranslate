.. _translating-ren-py:

==================
Ren'Py多语言支持
==================

Ren'Py自身也能实现多语言支持。一个完整的多语言支持版本翻译了GUI、各种Ren'Py信息、新工程和启动器的文本，涵盖了绝大多数游戏运行和开发场景。到目前为止，有部分报错信息还不支持多语言。

创建一种新的语言支持包含下列步骤：

1. 打开Ren'Py启动器。
2. 在设置页面，选择“打开启动器工程”。
3. 选择“生成翻译文件”。(译者注：原文为“Generate Translations”。将translation直译为“翻译”，容易引发歧义，所以文档中单独出现时一律使用“多语言支持”，“translation file”则翻译为“翻译文件”。)
4. 输入需要支持的语言名称。名称应该由小写的ACSII字符和下划线组成，所以“japanese”、“russian”和“ancient_kilingo”都是合法的语言名称。
5. 选择“生成翻译文件”。

需要更新某个翻译文件时也使用相同的流程。需要接入创建的翻译文件的话，返回到设置页面，在“语言”标签下选择刚才新建的语言。需要注意的是，默认情况下新建的翻译文件只是复制了一份英语的版本。

.. _translation-files:

翻译文件
-----------------

翻译文件存在于 :file:`launcher/game/tl/{language}/` 目录。除了 :file:`script.rpy` ，所有文件都可以包含使用 :ref:`字符串多语言支持 <string-translations>`
语法的字符串。 有些字符串的开头可能是“## ”。这些是 :file:`options.rpy` 和 :file:`gui.rpy` 文件中的注释。

翻译文件包括：

common.rpy
    这个文件包括Ren'Py向玩家展现的接口信息(字符串)。

developer.rpy
    这个文件包含的字符串面向创作者，而不是玩家。

error.rpy
    这个文件包含的字符串，会在Ren'Py出现故障时，向开发者或玩家显示。

gui.rpy
    这个文件包含默认GUI中的注释。

launcher.rpy
    这个文件包含的字符串是启动器显示的一部分。

obsolete.rpy
    这个文件里的字符串，当前Ren'Py已经不使用。

options.rpy
    这个文件里的字符串，替换默认options.rpy文件中的注释。

screens.rpy
    这个文件包含的字符串用于替换screens.rpy文件中的默认GUI和注释。

script.rpym
    创建新工程时，这个文件的内容会一字不差地复制到script.rpy。

style.rpy
    默认情况下这个文件不存在，有需要时可以创建。它配置了启动器样式(style)，及生成游戏的默认字体。

.. _language-specific-translations:

指定语言
--------

还有一种非直接替换的多语言实现方式。
"{#language name and font}" 在翻译文件中会被替换为对应语言的名称，
如果使用的是非ASCII码字符，可以选择转为启动器字体。
例如：

::

    translate french strings:

        old "{#language name and font}"
        new "{font=fonts/Roboto-Light.ttf}Français{/font}"

如果启动器语言与翻译文件中指定的语言不一致时，可以使用这种方式显示语言名称。

翻译文件中，其他以“{#in language font}”开头的内容都需要以类似方式转换。
例如：

::

    translate french strings:

        old "{#in language font}Start using Ren'Py in [lang_name]"
        new "{font=fonts/Roboto-Light.ttf}Commencez à utiliser Ren'Py en [lang_name]{/font}"

.. _changing-fonts:

修改字体
--------------

Ren'Py自带的默认字体(DejaVuSans)涵盖了大多数的西方语言，不过经常会需要用到其他字体。编辑 :file:`launcher/game/tl/language/style.rpy` 文件可以配置字体，比如添加字体：

::

    init python:
        translate_font("language", "myfont.ttf")

“language”是需要使用的语言类型(例如，“japanese”)，“myfont.ttf”是使用的字体(例如，“MTLc3m.ttf”)。字体文件应该放在 :file:`launcher/game/tl/language` 目录，这样就可以被启动器找到。

.. _changing-the-launcher-style:

修改启动器样式
---------------------------

启动器使用的样式可以配置，方法是在一个translate python语句块中设置一些变量。具体的变量名如下。变量名比较容易混淆，影响英语版本。

这些变量仅对启动器有效。

.. var:: gui.LIGHT_FONT = "Roboto-Light.ttf"

    启动器中通用文本使用字体的路径。

.. var:: gui.REGULAR_FONT = "Roboto-Regular.ttf"

    启动器中重点文本使用的字体路径。

.. var:: gui.REGULAR_BOLD = False

    若为True，重点文本加粗。

.. var:: gui.FONT_SCALE = 1.0

    启动器中应用于所有文本的缩放系数。

一个 ``translate python`` 语句块常用于设置这些变量。例如，下面的脚本修改了Ren'Py的阿拉伯语字体。::

    translate arabic python:
        gui.REGULAR_FONT = "DejaVuSans.ttf"
        gui.LIGHT_FONT = "DejaVuSans.ttf"
        gui.FONT_SCALE = .9
        gui.REGULAR_BOLD = True

.. _translation-functions:

函数
---------

下列函数用于配置启动器中的多语言支持。在init python语句块中调用这些函数。

.. function:: translate_font(language, font)

    这个函数用于设置 `language` 的字体。设置后的字体不仅用在启动器，也用于使用那种语言生成的游戏中。字体文件应该放在game/fonts目录中。

    `font`
        一个字符串，表示字体文件名。

.. function:: translate_define(language, define, value, help=None)

    这个函数在生成游戏是设置一个define。例如，可以用于修改字体的字号。

    `language`
        适用的语言。

    `define`
        define的名称。

    `value`
        一个字符串，表示define设置的值。(例如，“10”、“False”、“'Font.ttf'”。)

    `comment`
        若不是None，会在define之前生成一个注释。仅当gui.rpy中不存在那个define的情况下，才会生成注释。不需要在开头使用“## ”，生成注释时会自动添加。

    举例，下面的代码修改了对话文本的字号：
    
    ::

        translate_define("martian", "gui.text_size", 12)
