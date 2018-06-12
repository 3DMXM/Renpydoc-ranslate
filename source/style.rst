.. _styles:

===========
样式(style)
===========

样式(style)允许可显示组的外观被定制化。修改可视组件样式特性(property)的值可以实现这一点。例如，改变 :propref:`background` 特性，就可以实现窗口或者按钮之类背景图的定制化。

样式特性名由两部分构成，前缀部分指定了特性的使用场景，后半部分是特性本身。例如，按钮的 ``hover_background`` 特性的使用场景是按钮得到焦点(未被按下)，而按钮的 ``idle_background`` 特性的使用场景是按钮未得到焦点。(设置 ``background`` 特性会同时修改 ``idle_background`` 和 ``hover_background`` 等background类特性。)

由于Ren'Py拥有超过100中的样式特性，本节内容只涉及其中很小一部分。除了 ``background`` 之外，我们还会使用 ``color`` 、 ``font`` 、 ``outlines`` 和 ``size`` 等样式特性。需要完整的样式特性列表的话，可以查看 :ref:`样式特性 <style-properties>`
文档。

.. _using-styles-and-style-inheritance:

使用样式和样式继承
==================================

每个可视组件都有内建的一个样式。无论是直接创建还是使用界面系统，某个可视组件被创建后就可以在组件上应用样式特性，并且样式生效后更新可视组件的外观。在下面的样例中：

::

    image big hello world = Text("Hello, World", size=40)

:propref:`size` 特性将应用于一个文本组件，允许我们修改文本的字号。如此定制化之后的文本组件会显示40像素高度的文本。

类似的，当使用screen语言时，每个用户接口语句都使用相关的样式特性：

::

    screen big_hello_world:
        text "Hello, World" size 40

Ren'Py支持样式继承，每一种样式都有一个唯一的父类。如果某个样式特性在样式中未定义，样式的值会从亲缘最近的父类、祖父类或者其他元祖类继承。

每个可视组件都使用一个名为 ``style`` 的特性，该特性给定了这个可视组件样式的父类。

::

    image big hello world = Text("Hello World", style="big")

    screen hello_world:
        text "Hello, World" style "big"

当没有给定 ``style`` 特性的情况下，父类会基于可视组件的应用类型进行选择。父类的选择可以被  :ref:`style_prefix <style-prefix>` 影响，样式前缀出现在界面语言用户接口语句的样式特性中。

当某个样式被定义位没有指定父类，就会指定一个默认的父类。如果该样式名中包含一个下划线(_)，父类就是把下划线之前的内容移除后的结果。例如，某个样式名为 ``my_button`` 就继承自 ``button`` 。继承关系可以使用style语句或者调用某个style对象方法改变。当某种不存在的样式被使用时，并且样式名中包含一个下划线，Ren'Py会使用默认的父类创建一种样式。

以下划线开头的样式名是预留给Ren'Py使用的。

Ren'Py在起始阶段建立的各类样式，除了style语句或者初始化语句块(block)之外就不应该再修改已命名的样式。

.. _style-inspector:

样式检查器
===============

当 :var:`config.developer` 的值为true时，样式检查器可用于查看某个可视组件使用的样式名。

若要启用样式检查器，将鼠标移动到某个可视组件上，按下键盘的shift+I。Ren'Py会在鼠标位置展现一个可视组件列表，列表中的组件按照在界面被绘制的先后顺序排列。(这表示，最后一个可视组件是在绘制在其他组件上层的。)

点击样式名可以展示可视组件继承的父辈类，以及每种父辈类贡献给最终组件的每一种样式特性。

.. _defining-styles-style-statement:

定义样式：style语句
================================

更好的定义样式方法是使用style语句：

::

    style my_text is text:
        size 40
        font "gentium.ttf"

如果某种样式名不存在，style语句就会创建那种样式。相反，style语句会修改已存在的样式。

style语句一关键词 ``style`` 开头，后接需要定义的样式名。style语句第一行后面可以跟0个或多个分句，以及一个可选用的英文冒号(:)。

如果出现了英文冒号，下面必然有一个语句块(block)。语句块中每一行都包含一个或多个分句。如果style语句第一行没有冒号，整个语句就是完整的。

style语句接受使用以下分句：

`style-property` `simple-expression`
    声明的简单表达式的值，会赋值给样式特性。

``is`` `parent`
    设置该样式的父类。 *parent* 是一个样式名。

``clear``
    在style语句运行前，移除声明的样式所有特性。这个功能对继承自父类的特性值无效。

``take`` `style-name`
    在style语句运行前，移除声明的样式所有特性，并替换为 *style-name* 样式的特性。这个功能不会修改样式的父类。

``variant`` `simple-expression`
    计算 *simple-expression* 这个简单表达式，生成一个字符串或者字符串列表，详见 :ref:`界面变种 <screen-variants>`。 如果给定的界面变形之一是激活状态，style语句会执行，否则会被忽略。

``properties`` `simple-expression`
    计算 *simple-expression* 这个简单表达式，得到一个字典型数据。该字段能用于将样式特性名映射到具体的值，而这些值被声明为向style语句提供特性值。

style语句的样例如下：

::

    # 创建一个新的样式，使用默认(default)继承。
    style big_red:
        size 40

    # 更新样式。
    style big_red color "#f00"

    # 名为label_text的样式使用big_red的特性，
    # 前提是我们使用触控(touch)系统。

    style label_text:
        variant "touch"
        take big_red

style语句通常都在初始化阶段运行。如果某个style语句没有放在初始化语句块中，其被会自动移动被初始化init 0语句块中。

.. _defining-styles-python:

定义样式：Python语句
=======================

在全局 ``style`` 对象中作为作用域存在着一些命名过的样式。需要创建一种新样式时，就创建一个Style类的实例，并在 ``style`` 对象的某个作用域中声明该样式。

::

    init python:
         style.big_red = Style(style.default)

样式特性可以通过在Style对象类似于作用域的特性中声明。

::

    init python:
         style.big_red.color = "#f00"
         style.big_red.size = 42

.. class:: Style(parent)

    创建一个新样式对象。样式特性可以在这个对象的作用域中声明。

    `parent`
        样式父类。可以是另一个样式对象，或者一个字符串。

    .. method:: clear()

        该函数移除样式对象的所有样式特性。对象父辈继承的值不会变。

    .. method:: set_parent(parent)

        将样式对象的父类设置为 ``parent`` 。

    .. method:: take(other)

        使用 ``other`` 的所有样式特性。 ``other`` 必须是一个样式对象。

.. _indexed-styles:

索引化的样式
-----------------

索引化的样式是一些轻量级样式，可基于可视组件的数据定制化组件的外观。通过使用一个字符串或者整数为某个样式对象提供索引，可以创建索引化的样式。如果某个索引化样式不存在，索引系统会创建一个。

::

    init python:
        style.button['Foo'].background = "#f00"
        style.button['Bar'].background = "#00f"

索引化样式向某个可视组件提供样式的样例：

::

    screen indexed_style_test:
        vbox:
            textbutton "Foo" style style.button["Foo"]
            textbutton "Bar" style style.button["Bar"]

.. _style-preferences:

样式个性化设置
-----------------

.. note::

    :ref:`gui-preferences` ( GUI的个性化设置 )可能是实现同样目标的更高方式，因为GUI个性化可以改变某一个参数并用到多个样式上。

用户总是有自己调整用于界面各种特性的需求，在样式方面尤其突出。例如，创作者可能想要让游戏用户能自己调整文本的文本外观、颜色及字体大小。样式个性化允许这样的定制化操作。

样式个性化可以控制一个或者多个样式的特性(property)。样式个性化拥有一个名字及一个或多个可选项。被选中的选项会保存在持久化数据中，第一个可选项会注册为样式特性的默认项。

一个可选项会有一个或多个关联样式、特性和变量值，并保证选中的选项和给定的特性值会被应用于样式。Ren'Py首次初始化就会实现这点，并在任何新选项被选中时都会生效。

创作者应该确认每个选项作用于相同的样式特性集。否则，某些样式中没有声明的变量，会导致不可预料的结果。

样式个性化函数如下：

.. function:: StylePreference(preference, alternative)

  给定样式特性，将 ``alternative`` 设置为被选择的选项。

  `preference`
    给定样式个性化名称的字符串。

  `alternative`
    给定选项名称的字符串。

.. function:: renpy.get_style_preference(preference)

  通过给定了个性化名称返回对应被选中的选项名称字符串。

  `preference`
    给定样式个性化名称的字符串。

.. function:: renpy.register_style_preference(preference, alternative, style, property, value)

  注册某个选项对应的样式个性化信息。

  `preference`
    样式个性化名称字符串。

  `alternative`
    选项名称字符串。

  `style`
    待更新的样式名。可以是样式对象，或者样式名称的字符串。

  `property`
    待更新样式特性名称的字符串。

  `value`
    赋值给样式特性的值。

.. function:: renpy.set_style_preference(preference, alternative)

  将选中的选项设置为样式个性化。

  `preference`
    样式个性化名称的字符串。

  `alternative`
    选项名称的字符串。

以下是一个样例，注册了一个样式特性，允许用户在大号简单文本和小号带轮廓线文本之间自由选择。

::

    init python:
        renpy.register_style_preference("text", "decorated", style.say_dialogue, "outlines", [ (1, "#000", 0, 0) ])
        renpy.register_style_preference("text", "decorated", style.say_dialogue, "size", 22)

        renpy.register_style_preference("text", "large", style.say_dialogue, "outlines", [ ])
        renpy.register_style_preference("text", "large", style.say_dialogue, "size", 24)

下面这段代码允许用户使用按钮进行选择：

::

    textbutton "Decorated" action StylePreference("text", "decorated")
    textbutton "Large" action StylePreference("text", "large")

.. _other-style-functions:

其他样式函数
---------------------

.. function:: style.rebuild()

   该函数触发已命名的样式重建，允许初始化阶段之后的样式变更。

   .. warning::

      已命名的样式不会作为游戏存档的一部分被保存。这意味着存档和读档过程的数据不能保持一致。
