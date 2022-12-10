.. _ios:

===
iOS
===

Ren'Py支持运行在iPhone和iPad设备上的iOS应用。由于创建一个iOS应用要求苹果开发程序(比如Xcode IDE)，iOS应用只能在Mac电脑上创建。

.. _ios-required-language:

语言要求
=================

部分Ren’Py在iOS平台使用的库需要通过GNU Lesser/Library General Public License的认证。你会需要遵守Ren’Py生成版的认证规则。我们相信下列包含在你app描述里的语言能够满足需求，不过最好能找个律师确认一遍。

    这个程序包括一些证书下的自由软件认证，包括GNU Lesser General Public License。完整的软件列表参见 https://www.renpy.org/l/license/.

.. _work-in-progress:

半成品
================

当前Ren'Py对iOS的支持还是个半成品。尽管已经可以用来向苹果的AppStore申请发布程序，默认的Ren'Py接口不遵循苹果的规范，将来会修改。

如果你的游戏通过了苹果的AppStore认证流程，请告诉我们。

.. _ios-platform-differences:

平台差异
====================

iOS与安卓类似，与Ren'Py支持的基于鼠标的平台不同。所有关于 :ref:`安卓平台差异 <android-platform-differences>`
的内容都适用于iOS。

iOS不支持MultiPersistent。

iOS支持的视频格式列表可以在
`这里 <https://developer.apple.com/library/ios/documentation/Miscellaneous/Conceptual/iPhoneOSTechOverview/MediaLayer/MediaLayer.html#//apple_ref/doc/uid/TP40007898-CH9-SW6>`_ 找到。

.. _ios-testing-and-emulation:

测试和模拟
=====================

处于测试需求，Ren’Py支持两种iOS模拟模式。这些都通过启动器的iOS界面接入。两种模式都模拟了触控屏，只有在鼠标按键被按下的情况下才会触发事件消息。

iPhone
    这个模式模拟一台iPhone。

Tablet
    这个模式模拟一台iPad。

这些模拟器可以用于快速测试项目，当然最好能在真实的硬件上做测试。模拟器不处理那些人为因素导致的事件，比如用户的“胖手指”。

.. _packaging:

Packaging
=========

为iOS打包Ren'Py游戏现在相比其他平台依然是件麻烦的事。我们假设创作者有一些创建iOS应用的经验，或者能遵守苹果的规则。

.. _ios-getting-started:

起步
---------------

在你打包Ren'Py游戏之前，你会需要设置你的Mac电脑，用于创建iOS应用程序。这表示在你Mac电脑上安装Xcode，注册iOS开发者，并创建让你的应用能在iOS设备上运行的自动配置文件(provisioning profile)。

由苹果官方编写的 `App Distribution Quick Start <https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppStoreDistributionTutorial/Introduction/Introduction.html>`_
指导，解释了如何配置上述内容。我们建议根据官方说明处理，甚至先打包一个模板应用，然后再打包Ren'Py游戏。

.. _creating-the-xcode-project:

创建Xcode项目
--------------------------

创建iOS应用程序的第一步是创建Xcode项目。在Ren'Py启动器的iOS菜单中选择“Create Xcode Project”。

Xcode的项目名会自动选用启动器中显示的项目名称。项目可以基于这个名称进行定制，但是那些定制化可以在Xcode中编辑。

这种方式创建的Xcode项目与特定版本的Ren'Py关联。在升级Ren'Py后，你必须为游戏创建一个新的Xcode项目，并重复项目定制化工作。

.. _building-the-project:

建立项目
--------------------

在Ren'Py中创建项目之后，在启动器中选择“Launch Xcode”就能在Xcode中打开了。Xcode打开过的项目，可以生成并安装在iOS设备上。

.. _updating-the-project:

更新项目
--------------------

选择“Update Xcode Project”，会将你最新版本的Ren'Py项目复制到Xcode项目中。这只适合你的项目文件发生变化的情况，Ren'Py本身的更新并不适用。

.. _customization:

定制化
=============

大多数定制化都在Xcode项目中实现。例如，图标、启动图片和横竖屏选项等。

.. _ios-storyboard:

启动故事板
-------------

当应用程序运行时，启动故事板(Launch Storyboard)会显示启动图片(不是在Ren'Py而是在Xcode项目中配置)，直到Ren'Py准备好显示游戏UI。

当Ren'Py完成初始化后，它会恢复当前游戏，或者运行splash界面和主菜单。

.. _generation:

生成
-----------

为了简化开发工作，现在Ren'Py可以从文件中生成iOS版本图标。

``ios-icon.png``
    若文件存在，会自动将图像缩放为合适的尺寸用作iOS版本图标。

.. _pyobjus:

Pyobjus
=======

在iOS和macOS平台，可以通过 `Pyobjus <https://pyobjus.readthedocs.io/en/latest/>`_ 调用系统库。