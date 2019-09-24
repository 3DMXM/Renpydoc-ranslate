.. _cds:

创作者定义的语句
==========================

创作者定义的语句(CDS)允许创作者在Ren'Py中添加自己的语句。这个机制允许添加和使用当前Ren'Py不支持的语法。
CDS比直接使用Python代码更灵活。在大多数情况下，CDS用于某些重复使用的地方。例如，使用一个入参调用某个函数。
Ren'Py并不知道该函数的功能和执行机制，所以Ren'Py不会执行任何处理，除非遇到代码执行报错。
发生异常的情况下，使用CDS允许创作者检查语法是否正确(比如入参是否是合法的字符串)，忽略不正确的数据(对于非关键函数的报错，跳过往往比抛异常更有效)，预加载可视组件(如果函数使用可视组件)，
并使用lint检查代码时打印额外日志信息(如果runtime忽略就可以在这里生成报告)。CDS并不保证所有执行能可以成功，只要传作者编写的语句代码越优质，Ren'Py就能“理解”并实现创作者希望需要的功能。

创作者定义的语句必须在python early语句块(block)中定义。还有，包含创作者定义的语句的文件必须在使用这个语句的文件之前加载。由于Ren'Py按照unicode顺序加载文件，通常合理的做法是，在注册创作者自定义语句的文件加上前缀“01”之类一个不大的数字。

创作者定义的语句不能在定义语句的文件中使用。

创作者定义的语句使用 :func:`renpy.register_statement` 函数注册。

.. function:: renpy.register_statement(name, parse=None, lint=None, execute=None, predict=None, next=None, scry=None, block=False, init=False, translatable=False, execute_init=None, init_priority=0, label=None, warp=None, translation_strings=None, force_begin_rollback=False, post_execute=None, post_label=None, predict_all=True, predict_next=None)
  这个函数注册了一条创作者定义的语句。

  `name`
    一个空格分隔的名称列表作为语句的开头，或者空字符串定义一个新的默认语句(默认语句会替换say语句)。

  `block`
    当这项是False时，语句后面没有语句块(block)。当这项是True时，语句后面需要有语句块(block)，但是最终取决于语法分析器(lexer)如何处理。如果这项是字符串“script”，语句块(block)被认为包含一个或多个Ren'Py脚本语言语句。

  `parse`
    这是函数使用的Lexer对象。这个函数应该处理处理语句并返回一个对系那个。返回的对象作为一个参数传给所有其他函数。后面的入参都是Lexer对象的方法：

  `lint`
    调用这个函数检查语句。入参只有一个，即 *parse* 返回的对象。它调用renpy.error报错。

  `execute`
    当语句执行时，调用这个函数。入参只有一个，即 *parse* 返回的对象。

  `execute_init`
    在初始化阶段调用的函数，运行在优先级priority 0级别。

  `predict`
    预加载语句使用的图像时调用的函数。入参只有一个，即 *parse* 返回的对象。它会返回一个语句使用的可视组件列表。

  `next`
    判断下一个语句时调用的函数。

    如果 *block* 的值不是字符串“script”，这个函数的入参只有一个，即 *parse* 返回的对象。如果 *block* 的值是字符串“script”，就会多一个入参，即语句块(block)第一条语句名对应的对象。

    这个函数应该返回一个字符串，表示跳转的脚本标签(label)名，第二个入参将主控流程切换到标签对应的语句块；这个函数也可以返回None，表示继续执行下一条语句。

  `label`
    调用这个函数决定使用语句的脚本标签(label)名。如果函数返回的是字符串，字符串对应的语句标签可以被call或jump。

  `warp`
    调用这个函数决定在warp时是否执行这个语句。如果函数存在并返回True，warp时就运行这个函数，否则在warp时不执行语句。

  `scry`
    Ren'Py内部使用。

  `init`
    如果这个语句应该在初始化阶段运行，这项就是True。(如果语句没有在某个init语句块中，会被自动放置到init 0语句块里。)这项会调用execute函数，还有execute_init函数。

  `init_priority`

    一个整数，决定init语句块中初始化时的优先级。

  `translation_strings`

    当所在代码块被执行时，调用的一个函数。返回值是一个字符串列表，并后续在需要多语言支持的地方使用。

  `force_begin_rollback`

    对于想要触发快速跳过功能的语句，类似 ``menu`` 和 ``call screen`` 语句，该项应设置为True。

  `post_execute`

    本条语句执行完，下一条语句执行前，将执行这个参数的函数。(添加post_execute函数将修改RPYC文件，因此需要强制重新编译。)

  `post_label`

   调用此处的函数，决定执行完上一个语句后跳转的脚本标签(label)。如果该函数返回一个字符串，就表示需要跳转的脚本标签名，可以像其他标签一样正常调用或者跳转。该功能可以用于创建一个唯一返回节点。

  `predict_all`

   若该项为True，词条语句之后的所有语句和分支语句都将预加载。

  `predict_next`

   该项是一个脚本标签(label)，在本条语句执行后将运行对应脚本标签内的语句。

   本条语句后面的语句运行后调用该项实现后续语句的预加载，需要的返回值是一个脚本标签(label)列表或者SubParse对象。当 *predict_all* 为True时，该项不会被调用。


parse方法使用一个Lexer对象：

.. class:: Lexer

    .. method:: error(msg)

        在检测到的处理错误列表(当前位置)中添加一个 `msg` 元素。这个方法将中断当前语句的执行，但不妨碍后续语句的处理。

    .. method:: require(thing, name=None)

        尝试处理 `thing` ，如果无法完成则报一个错误。
        如果 `thing` 是一个字符串，尝试使用 :func:`match` 进行处理。
        其他情况下， `thing` 必须是一个lexer对象的其他other方法，并且该方法调用时没有入参。
        如果没有指定 `name` 的值，方法的名称将会用于报错消息(`thing`为字符串则直接使用该字符串)。
        否则，报错信息使用 `name` 。

    .. method:: eol()

        如果Lexer对象处于这行结尾则返回True。

    .. method:: expect_eol()

        如果Lexer对象不处于某一行脚本的结尾，则产生一个错误。

    .. method:: expect_noblock(stmt)

        调用该方法判断当前语句后面是否为语句块。
        如果找到语句块则产生一个错误。 `stmt` 应是一个字符串，并被添加到报错消息中。

    .. method:: expect_block(stmt)

        调用该方法判断当前语句后面是否需要一个非空语句块。
        `stmt` 应是一个字符串，并被添加到报错消息中。

    .. method:: has_block()

        当前行含有一个非空语句块时返回True。

    .. method:: match(re)

        匹配一个任意的正则表达式(regexp)字符串。

        Lexer对象中的所有语句都会使用这个方法。首先跳过空白，尝试在一行中匹配。如果匹配成功，返回匹配到的文本。否则，返回None。

    .. method:: keyword(s)

        匹配关键词 `s` 。

    .. method:: name()

        匹配一个名称。名称不会是内建的关键词。

    .. method:: word()

        匹配任何词，包括关键词。返回匹配目标词所在的整段文本。

    .. method:: image_name_component()

        匹配一个图像名组件。与word不同，图像名组件可以用数字开头。

    .. method:: string()

        匹配一个Ren'Py字符串。

    .. method:: integer()

        匹配一个整数，返回包含这个整数的字符串。

    .. method:: float()

        匹配一个浮点数，返回包含这个浮点数的字符串。

    .. method:: label_name(declare=False)

        匹配一个脚本标签(label)名，可以是绝对或关联名称。
        当 `declare` 为True时，设置为全局脚本标签名。
        (注意该方法实际上不能定义脚本标签——定义脚本标签需要使用 `label` 函数。)

    .. method:: simple_expression()

        匹配一个简单Python表达式，并将其作为字符串返回。
        常用于需要一个变量名的情况。不建议修改得到的结果。
        正确的做法是将返回结果直接用作计算。

    .. method:: delimited_python(delim)

        匹配一个以 `delim` 结尾的Python表达式，比如‘:’。
        常用于获取某个分隔符之前表达式的情况。不建议修改得到的结果。
        正确的做法是将返回结果直接用作计算。
        如果在行尾未匹配到分隔符则产生一个报错。

    .. method:: arguments()

        在使用括号内的入参列表之前必须先调用该方法。如果入参没有指定值就返回None，否则返回一个对象。
        返回对象有一个 ``evaluate`` 方法和一个可选的 `scope` 字典，返回一个元组。返回元组的第一个元素是固定位置入参的元组，第二个元素是关键字入参字典。

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

    .. method:: renpy_statement()

        调用该方法后，将当前代码行当作Ren'Py脚本语句处理，如果处理失败则生成一个错误。
        该方法返回一个不透明对象。这种不透明对象也可以从get_next()方法返回，可以传给 :func:`renpy.jump` 和 :func:`renpy.call` 函数处理。
        除非这种不透明需要作为语句处理结果的一部分，一般不进行存储。
        包含该方法的语句执行完毕后，主控流程会切换为CDS语句之后的语句。(很可能是使用post_execute创建的语句。)

    .. method:: renpy_block(empty=False)

        该方法将当前语句块中剩余的代码行都当作Ren'Py脚本处理，并返回一个SubParse对象，该对象相当于后续整个代码块的第一条语句。
        代码块中所有语句将串联起来并顺序运行，然后主控流程切换到CDS之后的那条语句。
        注意该方法只处理当前代码块。在很多情况下，我们还需要处理当前语句的子块(subblock)，正确的做法如下：
        
        ::

            def mystatement_parse(l):
                l.require(':')
                l.expect_eol()
                l.expect_block("mystatement")
                child = l.subblock_lexer().renpy_block()
                return { "child" : child }

        `empty`

            若为True，允许处理空的代码块。
            (空代码块等于一条 ``pass`` 语句。)
            若为False，空代码块将触发报错。

    .. method:: catch_error()

        该方法是一个上下文装饰器(context decorator)，与 with 语句协同使用，捕获和记录lexer上下文语句块内的报错，然后继续执行语句块后面的内容。
        这是一个样例，使用该方法并在一个子块(subblock)中记录多个错误：
        
        ::

            def mystatement_parse(l):
                l.require(':')
                l.expect_eol()
                l.expect_block("mystatement")
                strings = [ ]
                ll = l.subblock_lexer()
                while ll.advance():
                    with ll.catch_errors():
                        strings.append(ll.require(ll.string))
                        ll.expect_noblock("string inside mystatement")
                        ll.expect_eol()
                return { "strings" : strings }

.. _lint-utility-functions:

lint功能函数
----------------------

在编写lint函数时，下列函数很有用。

.. function:: renpy.check_text_tags(s)

  检查文本标签 `s` 的正确性。如果存在错误则返回错误字符串，没有错误则返回None。

.. function:: renpy.error(msg)

  将字符串 *msg* 作为错误信息报给使用者。通常作为parse或lint错误记录日志，其他情况会抛出异常。

.. function:: renpy.try_compile(where, expr, additional=None)

  尝试编译一个表达式，如果失败则将错误写入lint.txt文件。

  `where`

    一个字符串，表示表达式位置。常见的错误信息格式为“Could not evaluate *expr* in *where*”。

  `expr`

    尝试编译的表达式。

  `additional`

    添加到错误消息中的额外信息。

.. function:: renpy.try_eval(where, expr, additional=None)

  尝试计算一个表达式，如果失败则将错误写入lint.txt文件。

  `where`

    一个字符串，表示表达式位置。常见的错误信息格式为“Could not evaluate *expr* in *where*”。

  `expr`

    尝试编译的表达式。

  `additional`

    添加到错误消息中的额外信息。

.. _example:

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

使用时这样写：

::

    line e "这里的引号不会显示" 艾琳说, "也不需要反斜杠转义符。"
