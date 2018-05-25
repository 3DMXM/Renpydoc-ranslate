成就
============

成就(Achievement)模块允许开发者让用户解锁成就，清除成就，以及判断某个成就是否已经解锁。也允许根据根据进度获得成就。

默认情况下，成就在持久化文件中存储信息。如果Steam平台支持可用并且被启用，成就信息会自动与Steam同步。



.. function:: achievement.Sync()

  调用achievement.sync()函数的动作。只有当成就未同步的情况下才可用。

.. function:: achievement.clear(name)

  清除名为 *name* 的成就。

.. function:: achievement.clear_all()

  清除所有成就。

.. function:: achievement.grant(name)

  解锁名为 *name* 的成就，前提是该成就尚未解锁。

.. function:: achievement.has(name)

  如果用户已经解锁成就 *name* 就返回True。

.. function:: achievement.progress(name, complete)

  报告成就 *name* 的完成进度，前提是该成就未解锁。成就 *name* 必须先定义各完成度。

  **name**

    成就名，而不是成就的stat。

  **complete**

    一个整数，给定了达成成就的单元数量。

.. function:: achievement.register(name, **kwargs)

  注册一个成就。成就并不强制需要注册，但这样做可以将成就信息传给后端。

  **name**

    注册的成就名。

  下列关键词参数是可选的。

  **steam**

    在Steam上使用的成就名。如果没有指定，默认与 *name* 相同。

  **stat_max**

    解锁成就的stat整数值。
    The integer value of the stat at which the achievement unlocks.

  **stat_modulo**

    如果使用 *stat_max* 对进度取模结果为0，就向用户显示进度。例如，如果stat_modula是10，当进度为10、20、30时分别会想用户显示进度信息。如果未给出该值，默认为0。

.. function:: achievement.sync()

  同步本地存储和其他后端(例如，Steam)的注册成就。
