.. _skins:

=====
皮肤
=====

Ren'Py支持启动器更换皮肤——修改启动器外观。实现这点需要完成下列步骤：

皮肤只对指定版本的Ren'Py生效，不前向或后向兼容。

1. 进入“设置”界面，选择打开启动器工程。(译者注：当前最新版本中无法从启动器工程创建脚本文件，请直接进入Ren'Py安装目录下的launcher/game。)

2. 创建skin.rpy脚本文件。

3. 将下列内容复制到skin.rpy文件中：

::

    init -2 python:
        # 非交互文本颜色。
        custom_text = "#545454"

        # 各种状态的按钮颜色。
        custom_idle = "#42637b"
        custom_hover = "#d86b45"
        custom_disable = "#808080"

        # 反向文本按钮颜色（已选中选项）。
        custom_reverse_idle = "#78a5c5"
        reverse_hover = "#d86b45"
        custom_reverse_text = "#ffffff"

        # 滑块颜色。
        custom_scrollbar_idle = "#dfdfdf"
        custom_scrollbar_hover = "#d86b45"
        # 用作分割符图像文件。
        custom_pattern = "images/pattern.png"

        # 用作背景的可视组件
        custom_background = "images/background.png"

        # 用作项目列表背景。
        custom_projects_window = Null()

        # 用作各种信息框的背景。
        custom_info_window = "#f9f9f9c0"

        # 消息框的标题颜色。
        custom_error_color = "#d15353"
        custom_info_color = "#545454"
        custom_interaction_color = "#d19753"
        custom_question_color = "#d19753"

        # 输入文本的颜色。
        custom_imput_color = "#d86b45"

        # 命令窗口、设置窗口和导航窗口的背景。
        custom_window = Frame(Fixed(Solid(custom_reverse_idle, xsize=4, xalign=0), Solid(custom_info_window, xsize=794, xalign=1.0), xsize=800, ysize=600), 0, 0, tile=True)

4. 修改 skin.rpy 文件给启动器换皮肤。将用到的图片文件放入启动器的game目录。
   背景图片的推荐尺寸是800×600。

5. Select Custom theme in preferences.
5. 选用“设置->主题->自定义主题”。

错误的skin.rpy文件内容可能ui导致启动器无法正常运行。
可以尝试删除启动器目录中的 skin.rpy 和 skin.rpyc 文件，重启启动器，然后再恢复前两个文件。


