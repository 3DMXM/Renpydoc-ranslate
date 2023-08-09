.. _android:

==============
安卓(Android)
==============

Ren'Py支持运行安卓操作系统的设备，比如智能手机和平板电脑。由于这些设备并不100%支持Ren'Py的所有函数，在那些设备运行的包会做最小化修改。

与Ren'Py引擎分开下载的RAPT程序——Ren'Py安卓打包工具，可以创建安卓的测试版和正式版打包文件。

Ren'Py可以在安卓5.0或更高版本的系统上，更老的设备可能会缺少运行游戏的足够资源。

.. _required-language:

语言要求
=================

部分Ren'Py在安卓平台使用的库需要通过GNU Lesser/Library General Public License的认证。创作者会需要遵守Ren'Py生成版的认证规则。我们相信下列包含在app描述里的语言能够满足需求，不过最好能找个律师确认一遍。(译者注：建议把中英文都写上。)

    This program contains free software licensed under a number of licenses,
    including the GNU Lesser General Public License. A complete list of
    software is available at https://www.renpy.org/l/license/.

    这个程序包括一些证书下的自由软件认证，包括GNU Lesser General Public License。完整的软件列表参见 https://www.renpy.org/l/license/.


.. _user-instructions:

用户指南
=================

在安卓上启动一个Ren'Py游戏时，会执行下列按键绑定：

`Home`
     返回到安卓home界面，Ren'Py游戏进程挂起。作为挂起过程的一部分，Ren'Py会自动存档。如果需要的话，用户回到游戏时还可以自动读档。

`Menu`
     唤起一个游戏内菜单，并返回游戏。

`Back`
     回滚。

`Volume Up`, `Volume Down`
     控制安卓的媒体音量。


.. _android-platform-differences:

平台差异
====================

在Ren'Py支持的，基于触屏的安卓平台和基于鼠标的平台之间还是有很多重要的差异。几个重要的安卓软硬件差别在于：

* 触屏被看作是有一个鼠标的设备。只不过，只有在用户点击屏幕时才会产生鼠标事件消息。

* 播放视频只支持全屏模式，并且只能使用安卓设备支持的媒体格式。请参阅
  `这个页面 <http://developer.android.com/guide/appendix/media-formats.html>`_
  查看所有支持的视频格式列表。

* 文本输入模块(比如 :func:`renpy.input` )将受到输入法的限制，不能完全正常工作(西方语言应该可以，其他语言可能存在问题)。

除此之外，还有一些由于人为因素导致的差异。

* 由于安卓智能手机可能比电脑显示器小，需要增大字体。

* 由于触控输入不如鼠标输入精确，所以基于触屏的按钮需要比基于鼠标的按钮更大。

为了帮助创作者适应这些差异，Ren'Py会给予设备屏幕尺寸和性能，针对安卓自动选择界面变化。详见 :ref:`界面变种 <screen-variants>` 。


.. _testing-and-emulation:

测试和模拟
=====================

处于测试需求，Ren'Py支持三种安卓模拟模式。这些都通过启动器的安卓界面接入。

Phone
    这个模式模拟一台安卓手机。触控模式通过鼠标实现，但是不过仅在鼠标左键按下的情况下有效。Esc键映射为menu按键，PageUp键映射为back按键。

Tablet
    这个模式模拟一台安卓平板。触控模式通过鼠标实现，但是不过仅在鼠标左键按下的情况下有效。Esc键映射为menu按键，PageUp键映射为back按键。

Television
    这个模式模拟一台基于电视的安卓设备终端。按键映射为远程或控制器输入，方向键提供了导航功能。select键是回车，Esc键是菜单，PageUp键是back。

    这个模式会在“电视机盲区”区域显示一个轮廓。所有“电视机盲区”区域的画面在所有电视上都不能显示。

这些模拟器可以用于快速测试项目，当然最好能在真实的硬件上做测试。模拟器不处理那些人为因素导致的事件，比如用户的“胖手指”。

.. highlight:: none

.. _android-building:

生成安卓应用程序
=============================


Ren'Py包含一些工具能帮助创作者以包(package)为中心进行安卓游戏开发。在这个过程中，创作者会使用一台电脑生成一个安卓的包(package)并上传到创作者自己的设备上。创作者可以像其他安卓应用程序一样运行这个游戏。如果运行无误，就可以把这个包上传到Google Play等app商店了。

生成一个安卓应用程序包含4个步骤：

1. 下载和安装Java Development Kit和安卓USB驱动(下载链接在后面)。

2. 使用启动器(launcher)安装安卓SDK。

3. 使用启动器(launcher)创建密钥(key)。

4. 使用启动器进行安卓生成配置。

5. 使用启动器生成安卓应用程序。

一旦你完成了这些步骤，就能得到一个可以运行的安卓包。当你修改了某个游戏的配置或者完整配置一个新游戏时，只需要执行步骤3；如果你要重新生成一个包，通常只需要执行步骤4。


.. _step-1-installing-the-dependencies:

步骤1：安装依赖组件
-----------------------------------

在你生成包(package)之前，总共有3种东西需要手工下载和安装

**Java Development Kit.**
Java开发工具包（Java Development Kit （JDK）） 包含一些RAPT需要的工具。
RAPT需要使用这些工具，包括用于生成密钥(key)和签名包的工具。JDK的下载地址为：

    https://adoptopenjdk.net/releases.html?variant=openjdk8&jvmVariant=hotspot

需要下载的是版本为8的JDK。

请注意，关注开发者的JDK与关注用户的JRE是不同的。而创作者需要JDK创建安卓包。


**安卓设备**
创作者在开发时需要对设备进行配置。首先需要启用设备的开发者模式，并且为电脑配置安卓开发环境。如何设置电脑的说明可以查看下面的连接：

    https://developer.android.com/studio/run/device

也可以使用app的x86_64版本镜像，在安卓模拟器上运行程序(注意，模拟器不支持x86版本的镜像)。关于配置模拟器的内容超出了此文档的范围。

.. _step-2-set-up-the-android-sdk-and-development-environment:

步骤2：配置安卓SDK和开发环境
----------------------------------------------------------

下一步是配置安卓SDK和你开发环境的部分。这步包括：

* 检查JDK是否正确安装。
* 安装安卓SDK。
* 使用安卓SDK安装合适的开发工具包。

这步需要接入互联网。

执行这个步骤时，选择Ren'Py启动器中安卓界面的“安装SDK”。
RAPT会实时报告它正在做的工作。它还会将各类许可证信息。

如果不想每次都下载SDK，可以创建一个名为“sdk.txt”的文件，把已安装的SDK路径写在该文件中。

.. _step-3-generate-keys:

完成以上步骤后，点击“生成密钥”，以生成对应的安卓和Bundle需要的密钥(key)。

.. warning::

    RAPT生成的密钥使用一个标准密码创建。你需要确保自己拥有这些文件的权限。
   
    你应该将android.keystore和bundle.keystore文件保存在一个安全的地方。
    你还应该将保存这个密钥的备份，因为没有这个密钥的话，你就不能上传生成的应用程序。


创建安卓密钥时，Ren'Py会把密钥文件备份在脚本文件的相同备份目录下。避免你每次都自己额外备份。

如果你想要使用自己的密钥，配置游戏时，编辑 ``android.json`` 文件，将update_keystores设置为false。
然后编辑 ``rapt/project`` 中的 ``local.properties`` 和 ``bundle.properties``，指向你自己的对应文件。

.. _step-4-configure-your-game:

步骤4：配置游戏
---------------------------

生成一个包(package)之前，你必须向Ren'Py提供一些关于游戏安卓版本的信息。在Ren'Py启动器的安卓界面，选择“配置”。

如果你需要修改这些信息——例如，你做了一个游戏的新版本——你可以重新运行配置命令。之前你配置的选项已经被记住了。

.. _step-5-build-and-install-the-package:

步骤5：生成应用包并安装
-------------------------------------

最后，你可以生成应用包并安装了。
你可以在下面两种模式中任选其一：

Play Bundle
    Play Bundle发布包会以Android App Bundle(AAB)格式发布，适合直接上传到Google Play商店。
    也可以在启用了Google Play套件的安卓设备上直接安装。

    Play Bundle的最大文件大小为2GB，并会分割为4个最大500MB的包文件。
    不过4个包文件分割本身可能也是问题，不能把某个游戏分割为5个300MB的包，而必须分割为4个。

Universal APK
    Universal APK发布包适合直接在安卓设备上安装，无论是通过Ren'Py、ADB、其他安卓应用商店或直接从网上下载。

    Universal APK发布包可以直接使用最大2GB的文件。对内容没有其他限制。

有三种命令可以让你在多种性能组合下生成安装包，直接安装到设备上，或测试运行。

如果要在不同的release模式之间切换，需要卸载app。

.. _icon-and-presplash-images:

图标和presplash图片
=========================

.. _icon:

图标
------

Ren'Py使用游戏基目录中的两个文件生成app图标。

android-icon_foreground.png
    图标的前景层。这应该是一个带透明度的432×432像素图片。

android-icon_background.png
    图标的背景层。这应该是一个完全不透明的432×432像素图片。

安卓的自适应图标机制是这样工作的，将两个图标放在至少132×132像素的区域中并中央对齐，然后将前景层盖在背景层上。
有可能在这个区域之外的图像也会显示，但也可能会被遮挡住。最好在安全区域之外还预留一些出血位(bleeding)。
当拖拽图标时，两个图层可能会保持相对位置有一点移动。

关于自适应图标的更多信息，请查看：

    https://medium.com/google-design/designing-adaptive-icons-515af294c783

注意那里的1dp实际上对应屏幕上4个实际像素。

当生成应用程序时，Ren'Py会将这些文件转换为不同设备的适用尺寸，并为那些支持自适应图标的设备生成静态图标。

.. _android-presplash:

预启动画面
-----------

预启动画面(presplash)是在Ren'Py完全加载之前显示的画面，比主启动界面(splashscreen)更早显示。
在安卓设备上，预启动画面特别重要，尤其是Ren'Py首次运行时需要较长时间解包运行使用的支持文件。

android-presplash.jpg
    当app加载时使用的图片。该图片应该有1像素的单色边缘。
    显示该图片时，图片将保持宽高比缩放到近可能大的程度，如果无法覆盖整个显示屏幕则用边缘的单色填充。

android-downloading.jpg
    Google Play Asset下载资源时使用的图片。该图片应该有1像素的单色边缘。
    显示该图片时，图片将保持宽高比缩放到近可能大的程度，如果无法覆盖整个显示屏幕则用边缘的单色填充。

    距离底部、左侧和右侧各20像素的位置将显示一个20像素高的进度条，展示下载进度。

.. _pyjnius:

Pyjnius
=======

运行在安卓设备上时，可以使用 `Pyjnius <https://pyjnius.readthedocs.io/en/stable/>`__ 库。
这个库允许高阶开发者调用安卓的库。

使用时首先需要启用一个main的实例。方法可以在 org.renpy.android.PythonSDLActivity 类的mActivity字段中找到。
例如：

::

    init python:
        if renpy.android:
            import jinus
            mActivity = jnius.autoclass("org.renpy.android.PythonSDLActivity").mActivity
        else:
            mActivity = None


.. _android-permissions:

权限许可
===========

Ren'Py自身不要求额外的运行权限，但如果创作者的游戏要使用Pyjnius调用安卓，就需要申请权限许可。
Ren'Py包含一个变量和两个函数，用于与安卓选线系统交互。

.. var:: build.android_permissions = [ ]

    这是一个字符串列表，其中每个字符串都指定了某项安卓许可权限。例如，“android.permission.WRITE_EXTERNAL_STORAGE”。
    这样直接声明了应用程序需要那些权限。接着就需要使用 renpy.check_permission 和 renpy.request_permission 行数申请具体的权限。

.. function:: check_permission(permission)

    检查安卓是否已授予该应用程序某个权限。

    `permission`
        表示具体权限许可名称的字符串，例如“android.permission.WRITE_EXTERNAL_STORAGE”。

    如果已授权则返回True，如果未授权或运行平台并非安卓则返回False.

.. function:: request_permission(permission)

    向安卓申请向该应用程序授予权限。用户可能会受到弹窗提示授权。

    `permission`
        表示具体权限许可名称的字符串，例如“android.permission.WRITE_EXTERNAL_STORAGE”。

    如果已授权则返回True，如果未授权或运行平台并非安卓则返回False.
