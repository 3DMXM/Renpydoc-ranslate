.. _http-https-updater:

HTTPS/HTTP更新器
================

Ren'Py包含一个更新器(updater)，可以从Ren'Py项目所在的web服务器上自动下载和安装更新。
更新器只能在Windows和Linux平台运行，不支持macOS、安卓和iOS。

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

目前有两种更新文件格式。最新的格式为 rpu ，在Ren'Py 8.2中引入。
更早的版本格式为zsync，已经标记为过期(obsolete)，可以在更早的Ren'Py版本中使用。

.. _server-requirements:

服务器要求
-------------------

更新器要求创作者有自己的服务主机。用户需要可以通过URL直接下载升级文件，所以创作者的服务器必须支持HTTP请求。

https不能用于补丁升级，但可以用于全量更新。

(这意味着需要为服务器付费。共享文件类型的网站并不支持这种更新。)

如果 `patch` 参数设置为False，或者指定了https的url链接，
更新器不会尝试给游戏打补丁，而是下载完整归档文件，解包并更新。
由于完整归档一般都比较大，需要更多Web服务器提供下载。

.. _building-an-update:

生成更新
------------------

生成分发版时会自动生成更新。
构建更新器前，将 :file:`options.rpy` 文件中的 :var:`build.include_update` 设置为True。
这样能解锁启动器(launcher)中“生成分发版”的“生成更新”选项。勾选这项后，Ren'Py就可以生成更新文件了。

更新文件包含下列内容：

updates.json
    可用更新和版本号的索引。

updates.ecdsa
   updates.json文件签名，用于验证是否已经在本地缓存。

rpu/
    rpu目录内包含更新其的元数据和数据。


创作者必须把所有这些文件都上传到web服务器的同一目录下。

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

.. function:: updater.update(url, base=None, force=False, public_key=None, simulate=None, add=[], restart=True, confirm=True, patch=True, prefer_rpu=True, allow_empty=False, done_pause=True, allow_cancel=True, screen='updater')

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

    `confirm`
        Ren'Py是否提示用户确认此次升级。若为False，此次升级将不需要用户确认。

    `patch`
        若为True，Ren'Py会以补丁形式更新游戏，只下载变更的数据。
        若为False，Ren'Py会全量更新游戏，下载整个游戏。
        更新url不以“http”开头时，该项自动设置为False.

    `prefer_rpu`
        若为True，当两种更新格式都存在时，Ren'Py优先使用RPU格式更新。

    `allow_empty`
        若为True，Ren'Py可以在根目录没有任何更新信息的情况下执行更新。(需要使用 `add` 设置更新目录。)

    `done_pause`
        若为True，更新下载完成后游戏会暂停。
        若为False，游戏会立刻执行更新(重启或退出)。

    `allow_cancel`
        若为True，用户可以主动取消更新。
        若为False，用户无法取消更新。

    `screen`
        更新时显示的界面名。


.. _screen:

界面
------

如果要定制更新器(updater)的外观，创作者可以重写 ``update`` 界面。默认界面定义在common/00updater.rpy中。

::

    screen updater(u=None):

        add "#000"

        frame:
            style_group ""

            has side "t c b":
                spacing gui._scale(10)

            label _("Updater")

            fixed:

                vbox:

                    if u.state == u.ERROR:
                        text _("发生了一个错误：")
                    elif u.state == u.CHECKING:
                        text _("正在检查更新。")
                    elif u.state == u.UPDATE_NOT_AVAILABLE:
                        text _("当前程序已是最新的。")
                    elif u.state == u.UPDATE_AVAILABLE:
                        text _("[u.version] 已经准备好。你想要安装吗？")
                    elif u.state == u.PREPARING:
                        text _("正在准备下载更新。")
                    elif u.state == u.DOWNLOADING:
                        text _("更新下载中。")
                    elif u.state == u.UNPACKING:
                        text _("更新解压中。")
                    elif u.state == u.FINISHING:
                        text _("更新完成。")
                    elif u.state == u.DONE:
                        text _("已安装更新。程序将重启。")
                    elif u.state == u.DONE_NO_RESTART:
                        text _("已安装更新。")
                    elif u.state == u.CANCELLED:
                        text _("更新已被取消。")

                    if u.message is not None:
                        null height gui._scale(10)
                        text "[u.message!q]"

                    if u.progress is not None:
                        null height gui._scale(10)
                        bar value (u.progress or 0.0) range 1.0 style "_bar"

                hbox:

                    spacing gui._scale(25)

                    if u.can_proceed:
                        textbutton _("执行") action u.proceed

                    if u.can_cancel:
                        textbutton _("取消") action u.cancel

更新界面可以有一个入参，即一个Update类对象，参数名必须为 `u`。
Update对象包含下列字段，可用于界面定制化：

.. class:: updater.Updater

    .. attribute:: state

        更新器当前状态。各种可能的状态值和含义可参考上列的界面定义。这些状态值是Updater对象中的常量。

    .. attribute:: message

        若不是None，该项是向用户显示的信息。

    .. attribute:: progress

        若不是None，表示当前操作进度，一个介于0.0和1.0之间的浮点数。

    .. attribute:: can_proceed

        若为True，会弹出一个带按钮的界面，提供用户点击并更新。

    .. attribute:: proceed

        若 can_proceed 为True，该项是一个行为(action)。当用户点击“执行”按钮后将调用该行为。

    .. attribute:: can_cancel

        若为True，会弹出一个带按钮的界面，允许用户点击并取消更新。

    .. attribute:: cancel

        若 can_cancel 为True，该项是一个行为(action)。当用户点击“取消”按钮后将调用该行为。

    .. attribute:: old_disk_total

        若不是None，这是一个整数，表示更新前游戏占用存储空间的字长(Byte)数。

    .. attribute:: new_disk_total

        若不是None，这是一个整数，表示更新后游戏占用存储空间的字长(Byte)数。

    .. attribute:: download_total

        若不是None，这是一个整数，表示待更新下载数据的总字长(Byte)数。

    .. attribute:: download_done

        若不是None，这是一个整数，表示更新中已下载数据的总字长(Byte)数。

    .. attribute:: write_total

        若不是None，这是一个整数，表示更新后将写入存储数据的字长(Byte)数。

    .. attribute:: write_done

        若不是None，这是一个整数，表示更新中已写入存储数据的字长(Byte)数。

