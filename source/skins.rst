.. _skins:

=====
皮肤
=====

Ren'Py支持启动器换皮——修改启动器外观。实现这点需要完成下列步骤：

皮肤需要指定使用的Ren'Py，不前向或后向兼容。

1. 进入“设置”界面，选择打开启动器工程。(译者注：当前最新版本中无法从启动器工程创建脚本文件，请直接进入Ren'Py安装目录下的launcher/game。)

2. 创建skin.rpy脚本文件。

3. 将下列内容复制到skin.rpy里：

::

    init python:

        # 非交互文本颜色。
        TEXT = "#545454"

        # 各种状态的按钮颜色。
        IDLE = "#42637b"
        HOVER = "#d86b45"
        DISABLED = "#808080"

        # 反向文本按钮颜色（已选中选项）。
        REVERSE_IDLE = "#78a5c5"
        REVERSE_HOVER = "#d86b45"
        REVERSE_TEXT = "#ffffff"

        # 滑块颜色。
        SCROLLBAR_IDLE = "#dfdfdf"
        SCROLLBAR_HOVER = "#d86b45"

        # 用来做分割的图像文件。
        PATTERN = "images/pattern.png"

        # 一个用来做所有背景的可视组件。
        BACKGROUND = "images/background.png"

        # 一个用来做窗口背景的可视组件。
        # 包含命令，外观选项和导航信息。
        WINDOW = Frame("images/window.png", 0, 0, tile=True)

        # 一个用来做工程列表背景的可视组件。
        PROJECTS_WINDOW = Null()

        # 一个用来做消息框背景的可视组件。
        INFO_WINDOW = "#f9f9f9"

        # 消息框的标题颜色。
        ERROR_COLOR = "#d15353"
        INFO_COLOR = "#545454"
        INTERACTION_COLOR = "#d19753"
        QUESTION_COLOR = "#d19753"

        # 输入文本的颜色。
        INPUT_COLOR = "#d86b45"

4) 根据需要修改skin.py的内容就能给启动器换皮了。还可以将你自己的图片文件放入launcher的game目录中。

如果skin.rpy文件有问题将不能正常运行启动器(launcher)。修复这种问题时，需要从launcher的game目录中移除skin.rpy和skin.rpyc文件，运行启动器。
