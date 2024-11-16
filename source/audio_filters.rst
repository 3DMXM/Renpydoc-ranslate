.. _audio-filters:

音频滤波器
==============

音频滤波器可以在游戏中更改音频通道上的声音。常用于给声音添加效果，包括混响、延迟/回声、高通/低通滤波等。

音频滤波器位于 renpy.audio.filter 模块。
不是严格要求，只是推荐引用该模块时使用一个简短的别名，比如 ``af``：

::

    define af = renpy.audio.filter

可以调用 :func:`renpy.music.set_audio_filter` 函数设置想用的音频滤波器：

::

    $ renpy.music.set_audio_filter("music", af.Reverb(0.5))

默认情况下，音频滤波器设置之后会在下一个播放的音频文件时生效。
如果想要立刻生效，可以使用 `replace` 参数：

::

    $ renpy.music.set_audio_filter("music", af.Lowpass(440), replace=True)

这样就能让音频尽可能快地应用新的滤波器。

最后，创作者可以传入None来清除所有滤波器效果：

::

    $ renpy.music.set_audio_filter("music", None)

(也可以使用None搭配 `replace` 来立刻清除所有滤波器效果。)

.. _filter-reuse:

滤波器复用
------------

在某个音频通道设置滤波器后，在该通道播放的所有音频都会受到滤波器的影响。
特别是梳状滤波器(comb filter)、延迟滤波器和混响滤波器，会根据旧音频产生一些输出结果，
对新播放的音频产生影响。

Ren'Py会在滤波器对象中保留一些音频信息。因此，在不同音频通道间共用滤波器不是个好主意。
在单个音频通道里多次使用同一个滤波器对象也不行。

.. _silence-padding:

静音衔接
---------

当启用音频滤波器后，对应音频通道切换播放的音频内容时，Ren'Py会在该通道添加2秒的静音，
以确保延迟、混响等滤波器能完整播放。

如果需要更久的静音，可以在播放队列中设置：

::

    queue sound "<silence 10">

.. _a-audio-filters:

多个音频滤波器
--------------

除了使用单个滤波器，我们还可以使用一个滤波器列表，即一个 :class:`renpy.audio.filter.Sequence` 对象：

::

    renpy.music.set_audio_filter("music", [af.Reverb(0.5), af.Lowpass(440)])

也等效于：

::

    renpy.music.set_audio_filter("music",
        af.Sequence([
            af.Reverb(0.5),
            af.Lowpass(440),
            ]))

除此之外，也可以用多个音频滤波器组成下列类的对象。
出于性能考虑，现在不能自定义滤波器类。

.. function:: renpy.audio.filter.Allpass(frequency=350, q=1.0)

    全通滤波器，可以允许所有频率通过，但会更改各频率间的相位关系。

    `frequency`
        相位变化的中心频率。

    `q`
        控制相位移动(phase shift)的形状。该数值越大，相位移动的形状约尖锐。

.. function:: renpy.audio.filter.Bandpass(frequency=350, q=1.0)

    带通滤波器。

    `frequency`
        中心频率。

    `q`
        该值控制频带宽度。当q的值减少后，频带会变窄。

.. class:: renpy.audio.filter.Comb(delay, filter=None, multiplier=1.0, wet=True)

    梳状滤波器类。梳状滤波器由一些多次延迟效果叠加并混合输出，并将输出进一步反馈回延迟，最终会叠加多次。

    (译者注：中文互联网上大多数关于梳状滤波器的说明都是扯淡。
    “梳状”来源于该滤波器的 *频域* 特性曲线有明显的周期性峰谷，类似梳子，可以产生回声效果。
    其他几种滤波器，比如“高通”、“低通”、“带通”、“全通”都指滤波器的 *频域* 特性。)

    `delay`
        延迟时间，单位为秒。如果该参数是一个列表，则各个子通道的延迟分别对应列表中具有相同索引的元素。
        延迟时间最小为0.01秒。
        

    `filter`
        对延迟之后的信号应用的滤波器。若为None，则使用Null滤波器。

    `multiplier`
        对滤波之后信号的乘数。
        
    `wet`
        若为True，滤波器输出结果包含，输入信号、滤波后信号和计算乘数后的信号。
        若为False，滤波器输出结果仅包含，滤波后信号和计算乘数后的信号。

.. class:: renpy.audio.filter.Delay(delay)

    该滤波器实现了一度时间的延迟输出。从输入端采样得到的结果，会在延迟 `delay` 秒之后再输出。

    `delay`
        延迟时间，单位为秒。如果该参数是一个列表，则各个子通道的延迟分别对应列表中具有相同索引的元素。
        延迟时间最小为0.01秒。

.. function:: renpy.audio.filter.Highpass(frequency=350, q=1.0)

    高通滤波器。低于阈值的频率每低一个八度(频率减半)就会有12/dB的衰减。

    `frequency`
        阈值频率。

    `q`
        以分贝形式控制结果的峰值。在该类滤波器中，q值并非传统的Q值(品质参数)，而是一个转化为分贝的共振结果。

.. function:: renpy.audio.filter.Highshelf(frequency=350, gain=0)

    highshelf滤波器，可以让所有频率通过，但会增强高于某个频率的部分。
    
    (译者注：未找到high-shelf滤波器通用的中文译名。)

    `frequency`
        频率阈值。

    `gain`
        大于阈值的频率会获得的增益强度，单位为分贝。

.. function:: renpy.audio.filter.Lowpass(frequency=350, q=1.0)

    低通滤波器。高于阈值的频率每高一个八度(频率加倍)就会有12/dB的衰减。

    `frequency`
        阈值频率。

    `q`
        以分贝形式控制结果的峰值。在该类滤波器中，q值并非传统的Q值(品质参数)，而是一个转化为分贝的共振结果。

.. function:: renpy.audio.filter.Lowshelf(frequency=350, gain=0)

    highshelf滤波器，可以让所有频率通过，但会增强低于某个频率的部分。
    
    (译者注：未找到low-shelf滤波器通用的中文译名。)

    `frequency`
        频率阈值。

    `gain`
        小于阈值的频率会获得的增益强度，单位为分贝。

.. class:: renpy.audio.filter.Mix(*filters)

    该音频过滤器会将自身输入切分为多个音频流，各音频流应用不同的过滤器，最终将各音频流相加作为输出。

    例如：

    ::

        init python:

            import renpy.audio.filter as af

            # 此效果将信号延迟0.3秒后与原输入信号混合。
            $ echo = af.Mix(af.Null(), af.Delay(.3))

.. class:: renpy.audio.filter.Multiply(multiplier)

    该音频过滤器直接将输入与 `multiplier` 相乘并输出。

.. function:: renpy.audio.filter.Notch(frequency=350, q=1.0)

    陷波滤波器，与带通滤波器相反，`frequency` 两边一定范围内的信号被屏蔽，范围外的则可以通过。

    `frequency`
        中心频率。

    `q`
        控制陷波滤波器的作用频带宽度。当q的值增加时，作用频带会变窄。

.. class:: renpy.audio.filter.Null

    输入与输出完全一样的音频滤波器。

.. function:: renpy.audio.filter.Peaking(frequency=350, q=1.0, gain=0)

    峰化滤波器可以让所有频率通过，但会增强 `frequency` 两边一定范围内的信号。

    `frequency`
        中心频率。

    `q`
        控制峰值形状。q值越大，峰值越尖锐。

    `gain`
        中心频率两边一定范围内的信号的增益强度，单位为分贝。

.. function:: renpy.audio.filter.Reverb(resonance=.5, dampening=880, wet=1.0, dry=1.0, delay_multiplier=1.0, delay_times=[0.0253, 0.0269, 0.029, 0.0307, 0.0322, 0.0338, 0.0353, 0.0367], delay_subchannel=0.001, allpass_frequences=[225, 556, 441, 341])

    来自Freeverb库，带瑕疵的混响滤波器，用于模拟在房间内或者大厅中的声音。

    `resonance`
        混响的反馈值。该值应介于0到1之间，值越大则混响的持续越久。该值过大可能会让混响效果失控。

    `dampening`
        该参数使用了一个低通滤波器，在每次混响时都会应用。模拟了声音通过空气传播时会丢失部分高频信号的现象。

    `wet`
        该参数会与混音信号相乘并输出最终结果。

    `dry`
        该参数会与原始输入信号相乘。若该值为0.0则最终只有混音结果，而没有原始声音。

    `delay_multiplier`
        该参数会与 `delay_times` 相乘，用于调整各混音频段的长度。

    `delay_times`
        延迟时间列表，单位为秒。用于创建前期回响，类似于梳状滤波器。

    `delay_subchannel`
        子通道延迟时间，单位为秒。可以用于营造立体声效果。

    `allpass_frequences`
        一个频率列表，单位为赫兹(Hz)。用于创建全通滤波器，模拟后期回响。

.. class:: renpy.audio.filter.Sequence

    该音频滤波器会依次应用一个滤波器队列的所有滤波器效果。通常内部使用，很少直接用。

.. class:: renpy.audio.filter.WetDry(filter, wet=1.0, dry=1.0)

    该滤波器会将输入与经过另一个滤波器的输出混合。

    `filter`
        应用到输入信号上的滤波器。

    `wet`
        该参数是一个介于0.0到1.0之间的值，与 `filter` 输出结果相乘，用作最终输出的一部分。

    `dry`
        该参数是一个介于0.0到1.0之间的值，与输入结果相乘，用作最终输出的一部分。

