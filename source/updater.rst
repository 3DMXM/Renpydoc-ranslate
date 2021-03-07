.. _web-updater:

web更新器
===========

Ren'Py包含一个更新器(updater)，可以从Ren'Py项目所在的网站上自动下载和安装更新。在可以用于让一个大型游戏保持更新。

Ren'Py更新器自动实施下列步骤：

#. 下载控制更新内容的索引文件。
#. 询问用户是否需要执行更新。
#. 生成一个当前磁盘文件的归档。
#. 从服务器下载一个zsync控制文件。
#. 使用zsync工具将归档文件更新到服务器版本。zsync会自动计算两份归档文件的差别，并尝试下载有差别的部分。
#. 归档文件解包，并替换原来磁盘上的文件。
#. 删除新版本中已经移除的旧版本文件。
#. 重启游戏。

Ren'Py更新器在处理过程会显示一个更新界面，提示用户处理并允许用户退出更新。

.. _server-requirements:

服务器要求
-------------------

更新器要求创作者有自己的服务主机。用户需要可以通过URL直接下载升级文件，所以创作者的服务器必须支持HTTP请求。

(这意味着需要为服务器付费。共享文件类型的网站并不支持这种更新。)

.. _building-an-update:

生成更新
------------------

生成分发版时会自动生成更新。将options.rpy中的build.include_update项设置为True，就可以生成升级包了。这样做会解锁启动器(launcher)中“生成分发版”的“生成更新”选项。勾选这项，Ren'Py就会生成更新文件。

更新文件包含下列内容：

updates.json
   可用更新和版本号的索引。

*package*.sums
   包含包(package)中每个区块(block)的校验和。

*package*.update.gz
   指定包的升级数据。

*package*.update.json
   包含每个包的文件列表，当用户下载DLC时会被更新器使用。

*package*.zsync
   zsync用于管理下载的控制文件。

创作者必须把所有这些文件都上传到web服务器的单一目录下。

.. _updater-functions:

函数
---------

要触发更新时，需要调用updater.update函数或updater.Update行为(action)。

.. function:: updater.Update(*args, **kwargs)

  这个行为调用 :func:`updater.update()` 函数。所有入参会存储并传入那个函数。

.. function:: updater.UpdateVersion(url, check_interval=21600, simulate=None, **kwargs)

  这个函数会连接 *url* 的服务器，并判断是否有可用的新版本。如果有可用更新就返回新版本号，否则返回None。

  由于连接服务器需要消耗一些时间，这个函数在后台启动一个线程，连接服务器成功后立刻返回版本号，如果连不上服务器则返回None。
  后台线程一旦连接到服务器会重启当前交互行为，会让调用更新函数的界面更新。

  对应每个连接的url都需要分配至少1个Ren'Py会话(session)，并在每个 *check_interval* 秒的周期内保持会话。如果不能连接服务器，就返回缓存数据。

  额外的关键词入参(包括 *simulate* )会如同传给 :func:`updater.update()` 一样，传给更新机制使用。

.. function:: updater.can_update(base=None)

  如果可以更新成功则返回True。如果无法完全更新(比如update目录被删除了)，就返回False。

  注意这个函数并不实际进行更新操作。实际更新需要使用函数 :func:`updater.UpdateVersion()` 。

.. function:: updater.get_installed_packages(base=None)

  返回已安装DLC的包名列表。

  `base`
    更新的基目录。默认为当前项目的基目录。

.. function:: updater.update(url, base=None, force=False, public_key=None, simulate=None, add=[], restart=True)

  将这个Ren'Py游戏更新到最新版。

  `url`
    update.json文件的URL地址。

  `base`
    更新的基目录。默认为当前游戏的基目录。(这项通常会忽略。)

  `force`
    就算版本号相同也强制更新。(用于测试。)

  `public_key`
    检查更新签名的公钥PEM文件路径。(这项通常会忽略。)

  `simulate`
    这项用于测试GUI，而不是真的实行更新。这项可能的值为：

    - None表示实行更新。
    - “available”表示有可用更新时进行测试。
    - “not_available”表示无可用更新时进行测试。
    - “error”表示测试更新报错。

  `add`
    本次更新添加的包(package)列表。DLC必须要有这个列表。

  `restart`
    更新后重启游戏。

.. _screen:

界面
------

如果要定制更新器(updater)的外观，创作者可以重写 ``update`` 界面。默认界面定义在common/00updater.rpy中。
