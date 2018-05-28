创作者定义语句
==========================

创作者定义的语句允许创作者在Ren'Py中添加自己的语句。这个机制允许添加当前Ren'Py不支持的语法。

创作者定义的语句必须在python early语句块(block)中定义。还有，包含创作者定义的语句的文件必须在使用这个语句的文件之前加载。由于Ren'Py按照unicode顺序加载文件，通常合理的做法是，在注册创作者自定义语句的文件加上前缀“01”之类一个不大的数字。

创作者定义的语句不能在定义语句的文件中使用。

创作者定义的语句使用renpy.register_statement函数注册。

.. function:: renpy.register_statement(name, parse=None, lint=None, execute=None, predict=None, next=None, scry=None, block=False, init=False, translatable=False, execute_init=None, label=None, warp=None)

  这个函数注册了一条创作者定义的语句。

  **name**

    一个空格分隔的名称列表作为语句的开头，或者空字符串定义一个新的默认语句(默认语句会替换say语句)。

  **block**

    当这项是False时，语句后面没有语句块(block)。当这项是True时，语句后面需要有语句块(block)，但是最终取决于语法分析器(lexer)如何处理。如果这项是字符串“script”，语句块(block)被认为包含一个或多个Ren'Py脚本语言语句。

  **parse**

    这是函数使用的Lexer对象。这个函数应该处理处理语句并返回一个对系那个。返回的对象作为一个参数传给所有其他函数。后面的入参都是Lexer对象的方法：

  **lint**

    调用这个函数检查语句。入参只有一个，即 *parse* 返回的对象。它调用renpy.error报错。

  **execute**

    当语句执行时，调用这个函数。入参只有一个，即 *parse* 返回的对象。

  **execute_init**

    在初始化阶段调用的函数，运行在优先级priority 0级别。

  **predict**

    预加载语句使用的图像时调用的函数。入参只有一个，即 *parse* 返回的对象。它会返回一个语句使用的可视组件列表。

  **next**

    判断下一个语句时调用的函数。

    如果 *block* 的值不是字符串“script”，这个函数的入参只有一个，即 *parse* 返回的对象。如果 *block* 的值是字符串“script”，就会多一个入参，即语句块(block)第一条语句名对应的对象。

    这个函数应该返回一个字符串，表示跳转的脚本标签(label)名，第二个入参将主控流程切换到标签对应的语句块；这个函数也可以返回None，表示继续执行下一条语句。

  **label**

    调用这个函数决定使用语句的脚本标签(label)名。如果函数返回的是字符串，字符串对应的语句标签可以被call或jump。

  **warp**

    调用这个函数决定在warp时是否执行这个语句。如果函数存在并返回True，warp时就运行这个函数，否则在warp时不执行语句。

  **scry**

    Ren'Py内部使用。

  **init**

    如果这个语句应该在初始化阶段运行，这项就是True。(如果语句没有在某个init语句块中，会被自动放置到init 0语句块里。)这项会调用execute函数，还有execute_init函数。

parse方法使用一个Lexer对象：

.. class:: Lexer

    .. method:: eol()

        如果Lexer对象处于这行结尾则返回True。

    .. method:: match(re)

        匹配一个任意的正则表达式(regexp)字符串。

        Lexer对象中的所有语句都会使用这个方法。首先跳过空白，尝试在一行中匹配。如果匹配成功，返回匹配到的文本。否则，返回None。

    .. method:: keyword(s)

        匹配关键词 `s` 。

    .. method:: name()

        匹配一个名称。名称不会是内建的关键词。

    .. method:: word()

        匹配任何词，包括关键词。返回匹配目标词所在的整段文本。

    .. method:: string()

        匹配一个Ren'Py字符串。

    .. method:: integer()

        匹配一个整数，返回包含这个整数的字符串。

    .. method:: float()

        匹配一个浮点数，返回包含这个浮点数的字符串。

    .. method:: simple_expression()

        匹配一个简单Python表达式，并将其作为字符串返回。

    .. method:: rest()

        跳过空白，返回一行的其他内容。

    .. method:: checkpoint()

        返回一个不透明对象，这个对方表现出Lexer当前状态。

    .. method:: revert(o)

        当 `o` 是一个checkpoint()返回的对象时，将Lexer恢复为调用checkpoint()时的状态。(用于回溯。)

    .. method:: subblock_lexer()

        返回一个Lexer对象，用于当前行相关联的语句块(block)。

    .. method:: advance()

        在一个子块(subblock)Lexer中，前进到下一行。在第一行之前必须调用这个方法，这样第一行才会被处理。


lint功能函数
----------------------

在编写lint函数时，下列函数很有用。

.. function:: renpy.check_text_tags(s)


  检查文本标签 `s` 的正确性。如果存在错误则返回错误字符串，没有错误则返回None。

样例
-------

这里创建了一种新的语句“line”。“line”语句允许不带引号的文本行。 ::

    python early:

        def parse_smartline(lex):
            who = lex.simple_expression()
            what = lex.rest()
            return (who, what)

        def execute_smartline(o):
            who, what = o
            renpy.say(eval(who), what)

        def lint_smartline(o):
            who, what = o
            try:
                eval(who)
            except:
                renpy.error("Character not defined: %s" % who)

            tte = renpy.check_text_tags(what)
            if tte:
                renpy.error(tte)

        renpy.register_statement("line", parse=parse_smartline, execute=execute_smartline, lint=lint_smartline)

使用时这样写：::

    line e "These quotes will show up," Eileen said, "and don't need to be backslashed."
