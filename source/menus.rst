.. _menus:
.. _menu-statement:

=============
游戏内菜单
=============

在许多视觉系小说中，用户会在被要求为故事情节的走向做出选择。Ren'Py脚本语言中包含了menu语句，使得向用户展现选项十分容易。

这里有个menu语句的样例：

::

    menu:
         "我应该干嘛？"

         "喝咖啡":
             "我喝了咖啡，每一口都非常棒。"

         "喝茶":
             $ drank_tea = True

             "我喝了茶，并努力使讲话不像发表政治声明。"

         "跪拜礼":
             jump genuflect_ending

    label after_menu:

         "喝完饮料后，开始继续我的晨间时光。"

menu语句以关键词 ``menu`` 开头。后面可能跟着一个脚本标签(label)名，该文本标签(label)下的语句块可以被预处理为菜单选项。举例如下：

::

    menu drink_menu:
        ...

menu语句后面跟着一个缩进的语句块(block)。该语句块(block)可能包含一条 :ref:`say语句 <say-statement>`，且必须包含至少一个菜单选项。若存在那条say语句，发言内容与菜单选项会同时在界面上显示。

**菜单选项。**
菜单选项是用户在游戏内菜单中的可选项。菜单选项以一个字符串开头。该字符串后面可能跟一个if分句。这个if分句增加了不同情况下的选项是否出现的功能。菜单选项以英文冒号结束，下面必须跟着一个Ren'Py语句块。

当某个选项被选中，该选项下对应的语句块(block)就会执行。执行到那个语句块结尾时，会跳转到menu语句结尾并执行之后的脚本。

if分句包含关键词 ``if`` ，后面跟着一个python表达式。只有当表达式为True时，该菜单选项才会显示。例如下面的菜单中：

::

    menu:
        "向左":
            ...
        "向右":
            ...
        "向前看" if drank_tea:
            ...

只有在“the drank_tea”变量为True时才显示第三个选项。(不过，如果配置项 :var:`config.menu_include_disabled` 被设置为True的话，这个选项会显示为一个不可用的按钮。)

如果所有菜单选项的条件判断都没有成立，将直接跳过该菜单，并执行后面的语句。

.. _menu-set:

菜单集(menu set)
----------------

menu语句后面可以使用一个set从句。set从句单独占一行。
当menu后面存在set从句时，只有菜单集(menuset)中没有的选项标题才会单独显示。
当某个选项被选中后，对应标题就可以添加到菜单集中。

带if从句时，如果整个菜单中没有任何一个可用的选项，就直接进入menu语句后面的脚本。

基于某些历史原因，菜单集可以是一个set对象或者一个列表。

::

    default menuset = set()

    menu chapter_1_places:

        set menuset
        "我该去哪里呢？"

        "去上课。":
            jump go_to_class

        "去酒吧。":
            jump go_to_bar

        "去监狱。":
            jump go_to_jail

    label chapter_1_after_places:

        "这个周二真特么操蛋！"

.. _menu-arguments:

菜单入参
--------------

可以将入参传给整个菜单，或者菜单内的某些选项。若要将入参传给菜单，可以直接添加在menu语句中。
按顺序传入自定义的入参，使用逗号分隔。若要将入参传给某个菜单选项，在 ``if`` 关键词或者冒号前面加入参内容。

::

    menu ("jfk", screen="airport"):

        "伊利诺伊州，芝加哥" (200):
            jump chicago_trip

        "德克萨斯州，达拉斯" (150, sale=True):
            jump dallas_trip

        "阿肯色州，温泉城" (300) if secret_unlocked:
            jump hot_springs_trip

除了 `screen` 入参选择对应界面，`nvl` 入参选择 :ref:`NVL模式菜单 <nvl-mode-menu>`，其他传入菜单的入参会应用在界面上。
传给菜单选项的入参会应用在菜单界面的所有元素。

详见 :ref:`选项界面 <choice-screen>` 和 :var:`config.menu_arguments_callback`。
