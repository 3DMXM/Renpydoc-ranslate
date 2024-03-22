.. _https-http-fetch:

fetch形式的HTTPS/HTTP请求
===========================

Ren'Py支持fetch形式的HTTP/HTTPS请求，使用 renpy.fetch 函数。该函数：

* 支持Get、Post和Put请求。
* 支持以Post和Put形式将数据或json发送到服务端。
* Can return the result as bytes, a string, or a json object.
* 可以Byte、字符串或Json对象作为结果返回。

在游戏启动之后，fetch函数也可以用在Ren'Py主线程中。
其可以在各个平台使用，包括电脑、手机和Web平台。在Web平台使用时，从其他服务器上fetch数据需要自身服务器支持
`CORS <https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS>`_ 。

下面是个非常简单的例子，从服务器获取新闻资讯：

::

    $ news = renpy.fetch("https://example.com/news.txt", result="text")
    "新闻如下: [news]"

这个例子向服务端发送Json，并得到返回的Json：

::

    $ result = renpy.fetch("https://example.com/api", json={"name": "Ren'Py"}, result="json")

任何带网络通信的程序都需要考虑安全问题，尤其使用 renpy.fetch 函数获取多媒体资源时。
(Ren'Py自身基本没有抵御恶意图片、视频和音频文件的能力。)

.. function:: renpy.fetch(url, method=None, data=None, json=None, content_type=None, timeout=5, result="bytes", params=None)

    该函数向指定URL发送一个HTTP(或HTTPS)请求，并返回请求的内容。
    若请求失败，则抛出FetchError异常。异常中包含了失败的描述文本。(但该异常可能并不适合向用户展示。)

    `url`
        fetch的目标URL。

    `method`
        请求方式。通常是“GET”、“POST”和“PUT”中某一种，但也有可能是其他HTTP请求方式。
        若 `data` 或 `json` 的值不是None，默认使用“POST”方式。其他情况则默认使用“GET”方式。

    `data`
        若非None，请求时，将该值以二进制字符串数据形式发送。

    `json`
        若非None，请求是，将该值以Json对象形式发送。该参数的优先级高于 `data` 。

    `content_type`
        内容数据类型。在未指定的情况下，若 `json` 不是None则默认为“application/json”，否则则默认为“application/octet-stream”。
        该参数仅在POST和PUT请求时才会用到。

    `timeout`
        请求的超时等待时间。

    `result`
        返回结果处理方式。若是“bytes”，返回请求结果的裸数据(raw bytes)。
        若是“text”，将返回结果以UTF-8解码并返回Unicode字符串。
        若是“json”，将结果解码并返回为Json对象。(结果过程中可能会产生其他异常。)

    该函数可以在某次交互行为内调用，也可以在交互之外调用。

    * 交互之外调用时，当请求超过 `timeout` 超时时间依然未得到返回结果，将会反复调用 :func:`renpy.pause`\ (0)，因此Ren'Py不会上锁(lock up)。
      最好展示一个界面，让用户了解情况。
    * 交互行为内调用时(例如某个行为Action)，调用该函数会阻塞后续内容展示，直到网络请求完成或超时。
      但该函数会保持音频系统依然运行，保持播放。

    该函数可以在所有平台运行。但在Web平台上，非本地的网络请求需要通过CORS的允许。

.. _fetch-requests:

网络请求
--------

在电脑和手机端，Ren'Py包含了 `Requests <https://requests.readthedocs.io/>`_ 库。
requests库功能更强大，但未良好集成 renpy.fetch 。
(例如，Ren'Py会调用 :func:`renpy.pause` 等待返回数据，而requests库会阻塞进程，导致音频功能也停止。)