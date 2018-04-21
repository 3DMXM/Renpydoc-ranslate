# 快速入门
欢迎来到Ren’Py快速入门页。本教程的目的是通过演示，来使您了解只用几个简单的步骤就可以做成一个Ren'py游戏。我们用一个简单的示例游戏《The Question》来进行演示。

## Ren'py 启动器
在开始制作游戏之前，需要先清楚Ren'py启动器是如何工作的。启动器帮助你创建、管理、编辑和运行Ren'py程序。   
__开始__ 首先你需要[下载Ren'py](https://www.renpy.org/latest.html)。
当下载完成后，请进行安装。
  * 在windows系统中，双击下载好的可执行文件。它将会将Ren'py解压到名为`renpy-<version>`的文件夹中。
    你可以进入该文件夹并运行`renpy.exe`。（当系统不显示扩展名时，renpy.exe文件可能被显示为renpy。）
  * 在MAC OS X系统中，双击下载好的镜像文件并作为硬盘挂载它。当打开该硬盘时，复制名为`renpy-<version>`的文件夹去其他本地目录。（请不要将renpy app从其本身的文件夹中移走，这将会使程序无法工作。）然后切换至`renpy-<version>`目录并执行`renpy`应用。
  * 在Linux系统中，解压压缩包，进入`renpy-<version>`目录，运行`renpy.sh`。   

在进行上面的操作后，Ren'py启动器将能运行。   

__选择和运行一个工程。__ 你将能看到一个已经完成的游戏—— The Question。运行Ren'py启动后，从工程列表中选择“The Question”。选择"启动工程"来启动 “The Question”。   

你可以用同样的方式打开教程，即选择“教程”后并“启动工程”。   

![The Main Screen of the Ren'py launcher](https://www.renpy.org/doc/html/_images/launcher.png=500- "启动器主界面") ![Naming a new project](https://www.renpy.org/doc/html/_images/project_name.png=500- "新建工程")     
![Selecting the project resolution](https://www.renpy.org/doc/html/_images/resolution.png=500- "选择工程分辨率") ![Selecting the accent and background colors for the default theme](https://www.renpy.org/doc/html/_images/color.png=500- "选择主题颜色")   
**创建一个新工程。** 请选择“创建新工程”来进行新工程的创建。   

如果这是你第一次进行工程创建，Ren'py会让你选择一个工程文件夹。新建工程都会在此目录（也叫做文件夹），同时也会扫描已经存在的工程。目录选择框可能会显示于Ren'py窗口之下，请留意。    

然后启动器将会询问工程名称。此处已经有名为“The Question”的工程名了，你可以创建一个不同的名字，例如“My Question”，然后回车确认。    

之后启动器将会让你选择工程的分辨率。默认分辨率为1280×720，这是一个在游戏容量和图片质量间的折衷分辨率。本教程选择1280×720来对应"The Question"的图片素材。然后按“继续”。    

启动器会展示并让你选择一个主题颜色，颜色将决定背景颜色及其他GUI配色。随便选一个你爱的颜色，然后点击“继续”。    
此时，Ren'py将会创建一个新工程，里面包含简单的游戏模板。此模板使用的是占位符图像和文字，不过它可以执行，并且支持像回退，载入，存储之类的功能。选择“启动工程”来运行它。
