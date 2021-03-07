.. _in-app-purchasing:

=================
程序内购
=================

Ren'Py中包含一个高级的程序内购框架。这个框架目前只支持解锁型内购项目，支持的应用市场包括苹果的AppStore、Google Play和亚马逊AppStore。

使用这个框架相当简单，只需要按照下列步骤使用几个函数

* 在游戏的初始化阶段，使用
  :func:`iap.register` 函数注册内购项目。
* 游戏启动后，使用 :func:`iap.has_purchased` 函数检查是否有购买过的内购项目。
* 使用 :func:`iap.purchase` 函数或 :func:`iap.Purchase` 行为(action)允许用户购买某个道具。
* 使用
  :func:`iap.restore` 函数或 :func:`iap.Restore` 行为(action)允许用户同步在其他设备上购买的内容。

提供的程序内购项目，购买内容(包括价格等)必须在对应的应用市场上进行设置。生成安卓版本时，Ren'Py会询问配置哪个应用市场。

Apple App Store
    苹果AppStore基于打包名称上架，不需要特殊配置。

Google Play
    在使用Google Play之前，你必须在项目中添加一个Google Play密钥(key)和一个盐值(salt)。详见 :ref:`扩展APK <expansion-apk>`
    章节内容。

Amazon App Store
    亚马逊AppStore基于打包名称商家，不需要特殊配置。

.. _iap-functions:

IAP函数
-------------

.. function:: iap.get_price(product)

  返回一个字符串，表示用户本地货币的 *product* 价格。如果价格未知则返回None——这也表示 *product* 不能购买。

.. function:: iap.get_store_name()

  返回程序内购启用的商店名称。目前返回的结果可能是下列情况之一：“amazon”表示亚马逊AppStore，“play”表示Google Play，“ios”表示苹果AppStore，None表示没有可用的商店。

.. function:: iap.has_purchased(product)

  如果用户已经买过 *product* 就返回True，否则返回False。

.. function:: iap.is_deferred(product)

  当用户需要购买 *product* 时返回True。不过这个请求必须被第三方认证，比如家长或监护人。

.. function:: iap.purchase(product, interact=True)

  这个函数请求购买 *product* 。

  如果购买成功就返回True，如果购买失败就返回False。如果 *product* 注册为消耗品，在调用返回前内购产品就会被使用。

.. function:: iap.register(product, identifier=None, amazon=None, google=None, ios=None, consumable=False)

  使用程序内购系统注册一个商品。

  `product`
    一个字符串，表示商品的高级(high-level)名称。这个字符串也会传入 :func:`iap.purchase()` 、 :func:`iap.Purchase()` 和 :func:`iap.has_purchased()` 函数，表示对应的商品。

  `identifier`
    一个字符串，用于商品的内部标识。一旦用于表示某个商品，就不能再修改。这些字符串的格式类似于“com.domain.game.product”。

    如果为None，默认值为 *product* 。

  `amazon`
    一个字符串，表示亚马逊AppStore的商品标识号。如果没有给定，默认值为 *identifier* 。

  `google`
    一个字符串，表示Google Play商店的商品标识号。如果没有给定，默认值为 *identifier* 。

  `ios`
    一个字符串，表示苹果iOS版AppStore的商品标识号。如果没有给定，默认值为 *identifier* 。

  `consumable`
    如果是消耗品内购则返回True。到目前为止，只有iOS平台支持消耗品内购。

.. function:: iap.restore(interact=True)

  连接应用商店，并恢复(restore)所有丢失的内购。

  `interact`
    若为True，调用renpy.pause等待应用商店的响应。

.. _iap-actions:

IAP 行为
-----------

.. function:: iap.Purchase(product, success=None)

  这个行为尝试购买 *product* 。仅当 *product* 是可购买状态时(启用了应用商店并且没有购买过这个产品)，这个行为才是可用的。

  `success`
    若非None，这是一个行为或者行为列表，当内购成功后执行这些行为。

.. function:: iap.Restore()

  一个行为，连接应用商店并恢复(restore)所有丢失的内购。
