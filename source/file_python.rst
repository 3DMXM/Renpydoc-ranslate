文件读写
===========

这些Python函数允许创作者读写资源文件，包括在game目录下的文件、RPA归档和安卓资源(asset)。

.. function:: renpy.file(fn)

  接入名为 *fn* 的文件并返回一个只读的类文件对象。使用Ren'Py的标准搜索方法，我们可以进行文件读写。还可以在RPA归档文件内部进行读写操作，或者以安卓asset形式读写。

  以二进制模式打开的Python标准文件对象上的字段(field)和方法的宽泛子集都被这个对象支持。(基本上，针对一个制度文件的所有方法都是可用的。)

.. function:: renpy.list_files(common=False)

  列出game目录和归档文件下的所有文件。这个函数返回一个文件列表，使用“/”作为目录分隔符。

  **common**

    若为True，通用目录也会包含在列表中。

.. function:: renpy.loadable(filename)

  如果 *filename* 表示的文件可以加载就返回True。可以加载表示可以从磁盘上或者某个归档文件内读取。如果不能加载则返回False。


极少使用
-----------

这些函数极少使用。

.. function:: renpy.exists(filename)

  如果在搜索路径中可以找到文件 *filename* 就返回True。这个函数对磁盘上存在的物理文件有效。它不能搜索归档文件内部。

  大多数情况下，这个函数会与 :func:`renpy.loadable()` 函数一起使用。

.. function:: renpy.fsdecode(s)

  将 *s* 从文件系统(filesysteme)编码转为unicode。

.. function:: renpy.fsencode(s)

  将 *s* 从unicode转为文件系统(filesysteme)编码。

.. function:: renpy.image_size(im)

  给定一个图像操作器(manipulator)，加载并返回一个表示尺寸的 (``width``, ``height``) 元组。

  这个函数从磁盘读取图片并解压，不使用图像缓存。所以这个函数可能运行得很慢。
