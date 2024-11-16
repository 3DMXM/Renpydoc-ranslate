.. _achievements:

成就
============

成就(Achievement)模块允许开发者让用户解锁成就，清除成就，以及判断某个成就是否已经解锁。也允许根据根据进度获得成就。

默认情况下，成就在持久化文件中存储信息。如果Steam平台支持可用并且被启用，成就信息会自动与Steam同步。

.. function:: achievement.Sync()

    调用achievement.sync()函数的行为。只有当成就未同步的情况下才可用。

.. function:: achievement.clear(name)

    清除名为 `name` 的成就。

.. function:: achievement.clear_all()

    清除所有成就。

.. function:: achievement.get_progress(name)

    根据成就名返回成就完成进度。如果没有任何注册进度或成就未知时，将返回0。

.. function:: achievement.grant(name)

    解锁名为 *name* 的成就，前提是该成就尚未解锁。

.. function:: achievement.has(name)

    如果用户已经解锁成就 `name` 就返回True。

.. function:: achievement.progress(name, complete)

    报告成就 *name* 的完成进度，前提是该成就未解锁。成就 *name* 必须先定义各完成度。

    `name`
        成就名，而不是成就的stat。

    `complete`
        一个整数，给定了达成成就的单位数量。

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

.. var:: config.automatic_steam_timeline = True

    若为True，从Steam中运行游戏时，将自动更新Steam的运行信息。

    运行信息包括：

    * 如果设置类 :var:`save_name`，将更新状态描述信息。
    * 用户进入菜单后，更改Steam中状态为“正在游玩”。


Steamworks API
===============

当Steam可用时，基于ctypes库的Steamworks API绑定也将可用，并对外表现为为 `achievement.steamapi` 。
这些绑定是steamapi模块的一个实例，将C++版本的Steamworks API通过机器转换为Python版本，具体内容可以看
`这里 <https://github.com/renpy/renpy-build/blob/master/steamapi/steamapi.py>`_。

此外，仅当Steamworks API可用时，我们才能访问achievement.steam对象中的一大堆函数。

.. var:: achievement.steam

    Steam初始化成功后，该项标识高级(high-level)Steam方法所在的命名空间。
    如果Steam未完成初始化，该项的值为None。
    在调用任意Steam方法前，最好先检查该项是否为None。


Steam Apps
^^^^^^^^^^

.. function:: achievement.steam.dlc_installed(appid)

    已安装 `dlc` 就返回True，否则返回False。

.. function:: achievement.steam.dlc_progress(appid)

    表示DLC下载进度。

.. function:: achievement.steam.get_app_build_id()

    返回已安装游戏版本号的Build ID。

.. function:: achievement.steam.get_current_beta_name()

    如果当前有可用的beta版则返回名称，否则返回None。

.. function:: achievement.steam.get_current_game_language()

    返回用户选择语言名。

.. function:: achievement.steam.get_steam_ui_language()

    返回用户正在使用的Steam UI名。

.. function:: achievement.steam.install_dlc(appid)

    安装 `appid` 对应的DLC。

.. function:: achievement.steam.is_subscribed_app(appid)

    若用户已拥有 `appid` 对应的应用就返回True，否咋返回False。

.. function:: achievement.steam.uninstall_dlc(appid)

    卸载 `appid` 对应的DLC。

Steam Overlay
^^^^^^^^^^^^^

.. function:: achievement.steam.activate_overlay(dialog)

    激活Steam社区叠加界面。

    `dialog`
        需要打开的叠加界面名称。可以是以下界面之一：
        "Friends"、"Community"、"Players"、"Settings"、"OfficialGameGroup"、"Stats"、"Achievements"
        (分别对应好友、社区、玩家、设置、官方游戏组、状态、成就)。
        
.. function:: achievement.steam.activate_overlay_to_store(appid, flag=None)

    以叠加界面形式打开Steam商店。

    `appid`
        商店中该游戏的appid。

    `flag`
        achievement.steam.STORE_NONE、.STORE_ADD_TO_CART 或 .STORE_ADD_TO_CART_AND_SHOW 三项中的某一项的值。

.. function:: achievement.steam.activate_overlay_to_web_page(url)

    激活Steam社区叠加界面。并直接打开网页 `url` 。


.. function:: achievement.steam.is_overlay_enabled()

    若Steam已启用叠加界面，返回True。(游戏启动后可能需要等一小段时间后才会返回True。)

.. function:: achievement.steam.overlay_needs_present()

    若Steam已启用叠加界面，返回True。(游戏启动后可能需要等一小段时间后才会返回True。)

.. function:: achievement.steam.set_overlay_notification_position(position)

    设置Steam叠加界面的位置。`position` 应是4种枚举值achievement.steam.POSITION_TOP_LEFT、achievement.steam.POSITION_TOP_RIGHT、achievement.steam.POSITION_BOTTOM_LEFT、achievement.steam.POSITION_BOTTOM_RIGHT其中之一。

Steam Stats
^^^^^^^^^^^

.. function:: achievement.steam.clear_achievement(name)

    清除名为 `name` 的成就。之后调用 :func:`_renpysteam.store_stats` 可以将更改同步到服务器端。

.. function:: achievement.steam.get_achievement(name)

    获取名为 `name` 的成就状态。如果成就已达成就返回True，否则返回False。如果没有同名成就或发生错误会返回None。

.. function:: achievement.steam.get_float_stat(name)

    返回名为 `name` 的成就相关数值。如果没有同名成就会返回None。

.. function:: achievement.steam.get_int_stat(name)

    返回名为 `name` 的成就相关数值。如果没有同名成就会返回None。

.. function:: achievement.steam.grant_achievement(name)

    解锁名为 `name` 的成就。之后调用 :func:`_renpysteam.store_stats` 可以将更改同步到服务器端。

.. function:: achievement.steam.indicate_achievement_progress(name, cur_progress, max_progress)

    向用户展示成就进度，但 *不会* 解锁成就。

.. function:: achievement.steam.list_achievements()

    返回所有成就名的列表。

.. function:: achievement.steam.retrieve_stats()

    从Steam服务器端同步所有成就和统计数据。

.. function:: achievement.steam.set_float_stat(name, value)

    将名为 `name` 的成就相关数值设置为 `value`，注意 `value` 必须是浮点型数值。之后调用 :func:`_renpysteam.store_stats` 可以将更改同步到服务器端。

.. function:: achievement.steam.set_int_stat(name, value)

    将名为 `name` 的成就相关数值设置为 `value`，注意 `value` 必须是整型数值。之后调用 :func:`_renpysteam.store_stats` 可以将更改同步到服务器端。

.. function:: achievement.steam.store_stats()

    将所有统计数据和成就同步到Steam服务器端/

Steam Timeline
^^^^^^^^^^^^^^

.. function:: achievement.steam.add_timeline_event(icon, title, description, priority=0, start_offset=0.0, duration=0.0, possible_clip=None)

    Adds an event to the timeline.
    向游戏时间中添加一个事件(event)。

    `icon`
        该事件显示的图标。该项应该是一个字符串，表示基础的Steam图标名，或者玩家上传到Steam的图标名。

    `title`
        事件的标题。

    `description`
        事件的描述。

    `priority`
        事件的优先级，用于解决事件冲突。该项应该是一个0到1000之间的整数。

    `start_offset`
        从事件开始到现在的时间差，单位为秒。

    `duration`
        事件持续时长，单位为秒。

    `possible_clip`
        表示该事件是否可以被clip。该项应该是achievement.steam.CLIP_PRIORITY中的枚举值，包括CLIP_PRIORITY_NONE、CLIP_PRIORITY_STANDARD和CLIP_PRIORITY_FEATURED。

.. function:: achievement.steam.clear_timeline_state_description(time_delta)

    清除游戏时间线上当前状态的所有描述。

.. function:: achievement.steam.set_timeline_state_description(description, time_delta=0.0)

    设置游戏时间线上当前状态的描述。

    `description`
        一个描述当前状态的字符串。

    `time_delta`
        上次状态更改的时间，与当前时间的差值。

Steam User
^^^^^^^^^^

.. function:: achievement.steam.cancel_ticket()

    取消 :func:`achievement.steam.get_session_ticket` 返回的ticket结果。

.. function:: achievement.steam.get_account_id()

    返回用户的帐号ID。

.. function:: achievement.steam.get_csteam_id()

    返回用户的完整CSteamID。该值是一个64bit位的数字。

.. function:: achievement.steam.get_game_badge_level(series, foil)

    获取用户的Steam徽章(badge)等级，并用于该游戏中。
    
.. function:: achievement.steam.get_persona_name()

    返回用户公开可见的玩家名。

.. function:: achievement.steam.get_session_ticket()

    获取一个ticket，可以发送到服务器端实现用户验证。

Steam Workshop
^^^^^^^^^^^^^^

.. function:: achievement.steam.get_subscribed_item_path(item_id)

    如果安装了用户制作游戏内容的某个道具(item)，则返回安装路径。
    如果没有安装该道具，则返回None。

    `item_id`
        道具(item)ID。

