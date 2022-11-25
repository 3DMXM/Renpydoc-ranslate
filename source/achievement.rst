.. _achievements:

成就
============

成就(Achievement)模块允许开发者让用户解锁成就，清除成就，以及判断某个成就是否已经解锁。也允许根据根据进度获得成就。

默认情况下，成就在持久化文件中存储信息。如果Steam平台支持可用并且被启用，成就信息会自动与Steam同步。



.. function:: achievement.Sync()

  调用achievement.sync()函数的行为。只有当成就未同步的情况下才可用。

.. function:: achievement.clear(name)

  清除名为 *name* 的成就。

.. function:: achievement.clear_all()

  清除所有成就。

.. function:: achievement.get_progress(name)

  根据成就名返回成就完成进度。如果没有任何注册进度或成就未知时，将返回0。

.. function:: achievement.grant(name)

  解锁名为 *name* 的成就，前提是该成就尚未解锁。

.. function:: achievement.has(name)

  如果用户已经解锁成就 *name* 就返回True。

.. function:: achievement.progress(name, complete)

  报告成就 *name* 的完成进度，前提是该成就未解锁。成就 *name* 必须先定义各完成度。

  `name`
    成就名，而不是成就的stat。

  `complete`
    一个整数，给定了达成成就的单元数量。

.. function:: achievement.register(name, **kwargs)

  注册一个成就。成就并不强制需要注册，但这样做可以将成就信息传给后端。

  `name`
    注册的成就名。

  下列关键词参数是可选的。

  `steam`
    在Steam上使用的成就名。如果没有指定，默认与 *name* 相同。

  `stat_max`
    解锁成就的stat整数值。

  `stat_modulo`
    如果使用 *stat_max* 对进度取模结果为0，就向用户显示进度。例如，如果stat_modula是10，当进度为10、20、30时分别会想用户显示进度信息。如果未给出该值，默认为0。

.. function:: achievement.sync()

  同步本地存储和其他后端(例如，Steam)的注册成就。

控制成就的配置项包括：

.. var:: achievement.steam_position = None

    若值不是None，该配置项设置steam弹出通知的位置。该值必须是一个字符串，可使用的内容包括“top left”，“top right”，“bottom left”和“bottom right”。

.. var:: config.steam_appid = None

    若非None，该项应是Steam appid。Ren'Py会在启动时自动设置此appid。需要使用define语句设置该项。

    ::

        define config.steam_appid = 12345

Steamworks API
===============

当Steam可用时，基于ctypes库的Steamworks API绑定也将可用，并暴露为 `achievement.steamapi` 。这些绑定是steamapi模块的一个实例，将C++版本的Steamworks API通过机器转换为Python版本。