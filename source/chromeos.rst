Chrome OS/Chrome浏览器
==========================

Ren'Py支持在Chrome OS运行以及在Chrome浏览器中作为一个应用程序运行。这包括了在Chrome的安卓运行时(ARC)环境下运行Ren'Py安卓应用的能力。


将一个Ren'Py的应用移植到Chrome上，需要经过下列步骤：

1. 从Chrome网络商店下载ARC插件：
   https://chrome.google.com/webstore/detail/arc-welder/emfinbmielocnlhgmfkkmkngdoccbadn

2. 打包游戏的安卓版本，详见 :ref:`安卓文档 <android>`.

3. 从Chrome的应用菜单启动ARC Welder。

4. 找到包含你app程序的.apk文件。

5. 选择下列可选项。

   * Orientation: Landscape
   * Form factor: Tablet
   * Resize: Disabled
   * Clipboard access: unchecked

   调整尺寸(resize)目前无法工作，最好将这项禁用。


6. 选择“Test”。游戏就会在Chrome浏览器里加载和运行了。

7. 选择“Download Zip”。Chrome会生成一个zip文件，适用于上传到Chrome网络商店。
