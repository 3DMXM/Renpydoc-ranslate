.. _multiple-character-dialogue:

多角色对话
===========================

Ren'Py支持同时显示多个角色的对话。多角色对话使用每行对话结尾的multiple入参唤起。举例：::

    e "Ren'Py supports displaying multiple lines of dialogue simultaneously." (multiple=2)
    l "About bloody time! I've been waiting for this for years." (multiple=2)

多角色对话会根据对话后面的 `multiple`入参数值决定将多个对话行合并。(如果我们设置multiple=3，就将三个对话块合并。)

多角色对话的运行机制是，使用不同的样式多次显示say界面。每个say界面分别对应某一个角色的对话内容。

关于多角色对话有几条限制：

* 显示多角色对话时，能触发文本暂停的文本标签(tag)，比如{p}和{w}会无效。这是因为每个界面只显示一次，那些标签(tag)需要界面显示多次才能产生效果。

* 自动前进模式仅在文本的最后一块生效。大部分情况下自动前进都能表现正常，在最后一块文本比其他部分都短的情况下可能会导致问题，比如自动前进过早发生。

* extend分句不会生效。(除非用在最后一块文本。)

样式
------

总之，多人对话的运行机制是，使用不同可视组件系统的样式多次显示say界面。使用的样式会根据其对应的对话块(block)编号和对话块总数按顺序重命名。

多角色对话使用的风格名格式是
block`n`_multiple`m`_\`style`，其中  `n`是从1开始的对话块(block)编号， `m` 是同时显示的对话块总数。

在上面的例子中，对话中每个块对应的窗口样式名如下：

* block1_multiple2_say_window
* block2_multiple2_say_window

这些命名主题用于对话、角色名和角色名框，以及窗口。此处使用了样式的继承功能。我们可以使用的窗口样式有：

say_window
    这个样式用作单个角色对话窗口的通常情况，提供对话窗口的基础功能。

multiple2_say_window
    这个样式可以用于两个对话窗口的common特性(property)，像修改背景和减少边缘(margin)和填充(padding)。

block1_multiple2_say_window
    这个样式可以用于两个对话窗口中第一个窗口的位置，比如使用xalign为0.0将窗口靠左对齐。

block2_multiple2_say_window
    类似的，这个样式可以用于第二个窗口的位置，比如xalign设置为1.0将窗口靠右对齐。

多角色say界面
-----------------------

为了控制更多要素，还存在 multiple\_say 界面。当
multiple\_say界面存在时，会代替普通的say界面。它多了第三个入参， `multiple`元组。元组的第一个元素是对话块(block)编号，第二个元素是界面的总数。


NVL-Mode
--------

默认情况下，NVL模式从上到下显示多角色文本块(block)。通过修改 :ref:`nvl界面 <nvl-screen>`可以定制化这个显示方式。NVL界面使用一个带多个可以组织和展现的入参对象列表。
