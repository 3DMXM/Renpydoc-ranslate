==========
文本输入
==========

Ren'Py可以提示用户输入一小段文本，但有一些限制条件。renpy.input函数完成提示，并返回输入的文本，允许将其保存在某个变量或者其他进程中。

在Linux平台上，文本输入不需要输入法(IME)支持。大部分西方语言都能正常工作，但中文、日文和韩文则不行。

renpy.input函数定义如下：

.. function:: renpy.input(prompt, default='', allow=None, exclude='{}', length=None, with_none=None, pixel_width=None)

  调用这个函数会弹出一个窗口，要求用户输入文本。函数返回用户输入的文本。

  **prompt**

    向用户显示的提示字符串。

  **default**

    允许用户编辑部分的初始化文本字符串。

  **allow**

    若非None，这是允许输入文本使用的字符列表。

  **exclude**

    若非None，这是不允许输入文本使用的字符列表。

  **length**

    若非None，这项必须是一个整数，给定了输入字符串的最大长度。

  **pixel_width**

    若非None，输入被限制在给定的像素宽度。

使用renpy.inpu通常还需要在后面处理输入结果，可以使用标准的Python字符串操作函数。例如，下面的脚本会询问用户使用的名字并移除开头和结尾的空白。如果输入的名字为空，会自动替换为一个默认的名字。最后向用户显示。 ::

    define pov = Character("[povname]")

    python:
        povname = renpy.input("What is your name?")
        povname = povname.strip()

        if not povname:
             povname = "Pat Smith"

    pov "My name is [povname]!"
