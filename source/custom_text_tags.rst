.. _custom-text-tags:

================
定制文本标签
================

Ren'Py支持定义你自己的文本标签(tag)。文本标签系统可以操作文本和定义的标签，包括添加和移除文本或其他文本标签。

可以在 :var:`config.custom_text_tags` 或 :var:`config.self_closing_custom_tags` 字典中，通过声明一个文本标签函数的入口(entry)，创建定制文本标签。

.. var:: config.custom_text_tags

    将文本标签名映射到文本标签函数。

.. var:: config.self_closing_custom_text_tags

    将文本标签名映射到自闭合文本标签函数，而文本标签内部不含有其他文本。

一个文本标签函数有3个入参：标签(tag)自身，标签使用的参数，以及一个内容元组的列表。例如：下面这段文本：::

    "{big=2}Hello, {b}World{/b}{/big}"

标签(tag)是“big”，标签使用的参数是字符串“2”，内容元组的列表就会是：::

    [
        (renpy.TEXT_TEXT, "Hello, "),
        (renpy.TEXT_TAG, "b"),
        (renpy.TEXT_TEXT, "World"),
        (renpy.TEXT_TAG, "/b"),
    ]

文本标签函数会替换内容中的文本标签，并返回一个新的内容元组列表。

内容元组由两部分组成。第一部分是下列面出的常量之一。第二部分根据第一部分的内容发生变化，下面会详细说明。

**renpy.TEXT_TEXT**
  第二部分是向用户显示的文本。

**renpy.TEXT_TAG**
  第二部分是某个文本标签的内容，不带闭合花括号。

**renpy.TEXT_DISPLAYABLE**
  第二部分是一个嵌入文本中的可视组件。

**renpy.TEXT_PARAGRAPH**
  这表示两段文本之间的断行。第二部分未定义(但必须存在)。

自闭合文本标签函数类似，差别在于没有第三个入参。

.. _caveats:

附加说明
---------

对话文本标签{p}、{w}、{nw}和{fast}在定制文本标签之前优先处理，所以不应该被包含在一个定制文本标签里面，也不应该与定制文本标签互相穿透。

.. _examples:

样例
--------

样例中的 ``big`` 文本标签使用效果类似于{size}文本标签，不过会对入参使用相乘(multiply)。::

    init python:

        def big_tag(tag, argument, contents):

            size = int(argument) * 20

            return [
                    (renpy.TEXT_TAG, u"size={}".format(size)),
                ] + contents + [
                    (renpy.TEXT_TAG, u"/size"),
                ]

        config.custom_text_tags["big"] = big_tag


    "这个字就是 {big=3}大!{/big}"

样例 ``rot13`` 文本标签将rot13变换(transform)应用于文本。注意，rot26——应用两次rot13——就是普通的文本。 ::

    init python:

        def rot13_transform(s):

            ROT13 = { }

            for i, j in zip("ABCDEFGHIJKLM", "NOPQRSTUVWXYZ"):
                 ROT13[i] = j
                 ROT13[j] = i

                 i = i.lower()
                 j = j.lower()

                 ROT13[i] = j
                 ROT13[j] = i

            return "".join(ROT13.get(i, i) for i in s)

        def rot13_tag(tag, argument, contents):
            rv = [ ]

            for kind, text in contents:

                if kind == renpy.TEXT_TEXT:
                    text = text.encode("rot13")

                rv.append((kind, text))

            return rv

        config.custom_text_tags["rot13"] = rot13_tag

    "Rot0. {rot13}Rot13. {rot13}Rot26. {/rot13}Rot13. {/rot13}Rot0."

文本标签 ``bang`` 的功能是在文本中插入一个指定图像，并且不需要对应的闭合标签。

::

    init python:
        def bang_tag(tag, argument):
            return [ ( renpy.TEXT_TAG, "size=40"), (renpy.TEXT_TEXT, "!"), (renpy.TEXT_TAG, "/size") ]

        config.self_closing_custom_text_tags["bang"] = bang_tag

    "This is awesome{bang}"