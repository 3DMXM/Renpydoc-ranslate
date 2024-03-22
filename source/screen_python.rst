.. _screens-and-python:

==================
界面与Python
==================

下列函数支持对界面的各种操作。

.. _screen-function:

界面函数
================

下定函数支持定义、显示和隐藏界面。

.. function:: renpy.call_screen(_screen_name, *args, _with_none=True, _mode='screen', **kwargs)

    在程序上等效于call screen语句。

    该函数将显示界面 `_screen_name` ，并触发某个互动行为。互动结束后界面隐藏，并返回互动结果。

    不以下划线“_”开头的关键词入参都会传入界面的作用域。

    如果关键词入参 `_with_none` 的值是False，互动结束后结尾的“with None”分句不会运行。

    如果传入了参数 `_mode` ，就会用作交互模式。默认交互模式为“screen”。

.. function:: renpy.define_screen(name, function, modal="False", zorder="0", tag=None, variant=None)

    定义一个名为 `name` 的界面。

    `function`
        调用该函数可以显示界面。调用该函数时，使用界面作用域(scope)作为需要的关键词入参。它会忽略其他的关键词入参。

        这个函数需要调用ui函数将组件添加到界面上。

    `modal`
        一个字符串，根据计算后的值决定创建的界面是否模态(modal)。一个模态(modal)界面会防止它的子界面接受输入事件消息。

    `zorder`
        一个字符串，最终计算后的值应该是一个整数。这个整数控制界面显示顺序。zorder值大的界面显示在zorder值小的界面上方。

    `tag`
        界面关联的图像标签(tag)。显示界面时，所有带有同样标签的其他界面都会被替换。标签默认与界面名相同。

    `predict`
        若为True，界面启用图像预加载。若为False，不使用预加载。默认值是Trues,

    `variant`
        字符串。表示使用的界面变种(variant)。

.. function:: renpy.current_screen()

    当前正在更新、渲染或处理的界面信息。

    返回对象各字段含义参见 :func:`get_screen` 。

.. function:: renpy.get_adjustment(bar_value)

    指定一个 :class:`BarValue` 类的对象 `bar_value`，返回其 :func:`ui.adjustment` 方法执行结果。
    adjustment对象有以下属性：

    .. attribute:: value

        条(bar)的当前值。

    .. attribute:: range

        条(bar)值的范围。

.. function:: get_displayable(screen, id, layer=None, base=False)

    在 `layer` 图层的 `screen` 界面中，寻找名为 `id` 的可视组件并返回可视组件对象。
    对应名称的界面或组件不存在时，返回None。

.. function:: get_displayable_properties(id, screen=None, layer=None)

    在 `layer` 图层的 `screen` 界面中，寻找名为 `id` 的可视组件并返回可视组件的特性(property)。
    如果 `screen` 为None，则返回当前界面的特性。该函数可以用作某个界面内的Python或特性相关代码。

    注意，返回结果是一个组件特性的字典。若要获取某个特定特性，需要读取该字典。

.. function:: renpy.get_screen(name, layer=None)

    返回在图层 `layer` 上名为 `name` 的界面可视组件。`name` 首先被看作是一个图像标签(tag)名，其次是一个界面名。如果那个界面不被显示，就返回None。

    根据 *name* 可能得到一个界面名的列表，第一正在显示的界面作为最终结果返回。

    该函数可以用于检查某个界面是否正在显示：

    ::

        if renpy.get_screen("say"):
            text "The say screen is showing."
        else:
            text "The say screen is hidden."

    该函数的返回结果包含下列字段：

    .. attribute:: layer

        显示界面的图层。

    .. attribute:: name

        界面名称。

    .. attribute:: zorder

        界面显示的zorder.

    .. warning::

        与其他类似函数一样，该函数返回对象仅是调用函数后短期的状态信息。不推荐在存档或回滚时时间这些信息。

.. function:: renpy.get_screen_variable(name, *, screen=None, layer=None)

    返回某个界面作用域的某个变量的值。

    `name`
        带返回的变量名。

    `screen`
        目标变量所属的界面。若该参数为None，则使用当前界面。(当前界面是指调用此函数时正在更新的界面，或者包含此函数调用的界面。)

    `layer`
        界面所属的图层，前提是 `screen` 的值不是None。

.. function:: renpy.get_widget(screen, id, layer=None)

    返回图层 `layer` 上的界面 `screen` 中带有 `id` 的组件(widget)。如果界面不存在或界面中不存在带有那个id的组件，则返回None。

.. function:: renpy.get_widget_properties(id, screen=None, layer=None)

    返回图层 `layer` 上的界面 `screen` 中带有 `id` 的组件(widget)的特性(property)。如果 `screen` 为None，返回当前界面的特性(property)。该函数可以用在某个界面的Python或特性(property)代码中。

    需要注意的是，这个函数返回结果是组件特性的字典。想要得到单个特性的值，就要进入字典取值。

.. function:: renpy.hide_screen(tag, layer=None)

    等效于“hide screen”语句。

    隐藏图层 `layer` 上带图像标签 `tag` 的界面。

.. function:: renpy.set_focus(screen, id, layer=u'screens')

    该函数会将界面 `screen` 中指定 `id` 的可视组件指定为获得焦点。
    如果可视组件未找到，或整个窗口没有获得焦点或其他强制无法更改焦点的情况下，该函数将不会有实际效果。

    对该函数的调用结束后，轻微的鼠标移动就可能会改变焦点，

.. function:: renpy.set_screen_variable(name, value, *, screen=None, layer=None)

    设置某个界面作用域的某个变量的值。注意，该函数不会立刻更新变量的值，需要调用 :func:`renpy.restart_interaction` 更新界面。

    `name`
        待设置的变量名。此处的变量通过 :ref:`sl-default` 语句定义。其他方式定义的变量可能会优化而无法通过这个方式访问。

    `value`
        目标变量值。

    `screen`
        变量所属界面名。若为None，使用当前界面。(当前界面是指调用此函数时正在更新的界面，或者包含此函数调用的界面。)

    `layer`
        界面所属的图层。前提是 `screen` 不为None。


.. function:: renpy.show_screen(_screen_name, *args, _layer=None, _zorder=None, _tag=None, _widget_properties={}, _transient=False, **kwargs)

    等效于show screen语句。

    显示指定界面。该函数使用下列关键词入参：

    `_screen_name`
        想要显示的界面的名称。

    `_layer`
        界面显示使用的图层名。等效于 :ref:`show-screen-statement` 语句的 ``onlayer`` 从句。

    `_zorder`
        界面显示的zorder值。未赋值情况下，zorder值与关联界面相同。默认值是0。

    `_tag`
        界面显示使用的图像标签(tag)。如果没有指定，就使用界面的图像标签关联的默认标签。如果那也没有指定，默认使用界面的名称做为标签名。
        等效于 :ref:`show-screen-statement` 语句的 ``as`` 从句。

    `_widget_properties`
        从组件(widget)的id到某个“特性名->特性值”映射的映射关系。当带那个id的组件(widget)在界面上显示时，就能为其添加指定的特性(property)。

    `_transient`
        若为True，界面会在当前互动结束后自动隐藏。

    不以下划线(_)开头的关键词入参用于初始化界面的作用域。

.. function:: renpy.start_predict_screen(_screen_name, *args, **kwargs)

    让Ren'Py开始缓存名为 `_screen_name` 的界面，那个界面之后会使用给定的入参显示该函数会替换之前 `_screen_name` 的缓存。需要停止缓存某个界面的话，调用 :func:`renpy.stop_predict_screen()` 。

    正常游戏过程中不会缓存。若需要等待缓存结束，可以使用 :func:`renpy.pause` 并添加 `predict` 入参。

.. function:: renpy.stop_predict_screen(name)

    让Ren'Py停止缓存名为 `name` 的界面。

.. function:: renpy.variant(name)

    如果 `name` 是Ren'Py中可用的某个界面变种(variant)，就返回True。详见 :ref:`界面变种 <screen-variants>`。这个函数可以用做条件表达式，在Python的if语句中根据界面变种选择使用对应的样式(style)。

    `name` 也可以是一个界面变种列表，只要列表中任何变种被选择就返回True。

.. class:: ui.adjustment(range=1, value=0, step=None, page=None, changed=None, adjustable=None, ranged=None, force_step=False)

    adjustment对象表示可以通过某个条(bar)或视口(viewport)调整的值。Adjustment对象包括值的信息，值的范围，以及修改这个对象使用的最小步长和最大页面(page)。

    下列参数分别对应Adjustment对象的字段(field)或者特性(property)。

    `range`
        调整范围，一个数值。

    `value`
        调整为这个值，一个数值。

    `step`
        调整的步长，一个数值。若为None，默认值是一个页面(page)的1/10大小，前提是设置了页面大小。否则默认为 *range* 大小的1/20。

        使用鼠标滚轮滚动一个视口(viewport)时会用到这个值。

    `page`
        Adjustment对象的页面(page)大小。若为None，会通过视口(viewport)自动设置。如果没有设置，默认值是 *range* 大小的1/10。

        当点击一个滚动条(scrollbar)时，这项值会被用到。

    下列参数控制Adjustment对象的行为。

    `adjustable`
        若为True，条(bar)可以修改Adjustment对象。若为False，则不能修改。

        如果指定 `changed` 函数或者Adjustment对象有一个关联的视口(viewport)，那这项的默认值是True。否则默认值是False。

    `changed`
        当Adjustment的值发生改变时，会用新的值调用这个函数。

    `ranged`
        当通过一个视口(viewport)设置了Adjustment的范围时，会用Adjustment对象调用这个函数。

    `force_step`
        若为True且该adjustment函数用于视口中的拖拽组件或条(bar)时，数值将是离散的，且只能分步修改。
        释放拖拽组件或条的滑块时，最终结果会调整为最接近的某个步进值。
        若为False，adjustment函数会忽略步进值，直接使用拖拽后的结果。

.. function:: ui.interact(*, roll_forward=None, mouse='default')

    触发某个与用户的交互动作，并返回交互的结果。这个函数让Ren'Py重绘界面并开始处理输入事件。当某个可视组件对应某个事件返回了一个值，那个值会从ui.interact返回，然后互动结束。

    这个函数极少被直接调用。通常会被Ren'Py的其他部分调用，包括say语句、menu语句、with语句、pause语句、call screen语句、 :func:`renpy.input()` 等等。不过，必要的时候也可以直接调用。

    当某个互动结束，transient图层和所有“transient=True”的界面都会从场景(scene)列表中清除。

    下列入参有文档说明。其他没有文档说明的入参属于Ren'Py内部使用。请都用关键词入参。

    `roll_forward`
        当前向滚动发生时，这个函数会返回相应的信息。(若为None，前向滚动会被忽略。)这项应该总是传入 :func:`renpy.roll_forward_info()` 函数的结果。

    `mouse`
        这个函数中鼠标指针使用的样式。

.. _sp-actions:

行为(action)
=============

界面语言创建的许多可视组件都使用行为(action)作为入参。一个行为(action)是以下三种情况之一：

* 一个可以被调用的Python对象(比如函数或绑定方法)，不使用入参。
* 父类为Action类的某个类的一个对象。
* Action对象列表。

继承Action类对象的好处是，允许你重写类的方法(method)，比如确认某个按钮什么情况下被选中的方法，以及判断按钮何时可用。

.. class:: Action

    要定义一个新的action，需要从这个类继承。 重写此类中的方法以更改action的行为。

    .. method:: __call__(self)

        当行为激活状态下，这个方法会被调用。在很多情况下，行为会返回一个非None值，并让当前的互动结束。

        继承后的类必须重写这个方法，使用默认方法会报“未实现(NotImplemented)”错误(并被Ren'Py阻止直接报出这个错误)。

    .. method:: get_sensitive(self)

        调用这个方法判断使用这个行为的按钮是否可用。如果按钮可用，则返回True。

        注意，在这个方法返回False的情况下， __call__ 依然可以被调用。

        默认的实现会返回True。

    .. method:: get_selected(self)

        如果按钮渲染为被选中的按钮就返回True，否则返回False。

        默认的实现会返回False。

    .. method:: get_tooltip(self)

        没有指定提示框(tooltip)的情况下，将为按钮获取一个默认的提示框。返回值是提示框的值，或者提示框未知的情况下返回None。

        默认返回None。

    .. method:: periodic(self, st)

        在每次互动的开头这个方法都会被调用一次，之后周期性调用。如果方法返回一个数值，就会在这个数值(单位为秒)的时间后再次调用，但其间也可以被很快直接调用。

        这个方法的主要用途是调用
        :func:`renpy.restart_interaction` ，前提是需要改变get_selected或get_sensitive的值。

        方法使用一个入参：

        `st`
            这个行为关联的界面或可视组件首次显示后经过的时间(单位为秒)。

    .. method:: unhovered(self):

        如果某个按钮(或类似对象)处于鼠标悬垂(hovered)状态下，当对象失去焦点时会调用这个方法。

    .. attribute:: alt

        如果按钮没有设置 :propref:`alt` 特性，则该行为会将该属性(attribute)用于文本转语音(TTS)。
        该属性可以是定义类时的一个字符串类型的属性，还可以在构造器中初始化，也可以是一段能返回字符串的Python代码。

想要在Python代码中运行某个行为(action)，需要使用 :func:`renpy.run`。

.. function:: renpy.is_selected(action)

    执行提供的行为或行为列表，返回执行结果。selected状态返回True，否则返回False。

.. function:: renpy.is_sensitive(action)

    执行提供的行为或行为列表，返回执行结果。sensitive状态返回True，否则返回False。

.. function:: renpy.run(action)

    运行一个行为或者行为列表。单个行为调用时不带入参，行为列表按表内顺序执行，None则忽略。

    行为列表中最后一个行为执行结果作为函数的返回值。

.. _barvalues:

条值(barvalue)
===============

当创建一个bar、vbar或hotbar时，可以使用一个BarValue对象作为条(bar)的值特性(property)。调用BarValue对象的方法可以调整数值和样式。


.. class:: BarValue

    定义一个新的BarValue时，可以继承这个类并重写一些方法。

    .. method:: get_adjustment(self)

        调用这个方法可以获得一个针对条(bar)的adjustment对象。这个方法使用
        :func:`ui.adjustment` 创建Adjustment对象，并返回创建的对象。

        继承后的类必须重写这个方法，使用默认方法会报“未实现(NotImplemented)”错误(并被Ren'Py阻止直接报出这个错误)。

    .. method:: get_style(self)

        这个方法用于判断条(bar)使用的样式。返回的是一个二元的元组，元素类型为样式名称或Style对象。第一个元素用于bar，第二个元素用于vbar。

        默认值是("bar", "vbar")。

    .. method:: get_tooltip(self)

        没有指定提示框(tooltip)的情况下，将为按钮获取一个默认的提示框。返回值是提示框的值，或者提示框未知的情况下返回None。

        默认返回None。

    .. method:: replaces(self, other)

        当某个界面更新，需要更换一个BarValue时，调用这个方法。它可以用于更新BarValue。调用顺序在get_adjustment之前。

        注意， `other` 不需要与 `self` 的类型相同。

    .. method:: periodic(self, st)

        在每次互动的开头这个方法都会被调用一次，之后周期性调用。如果方法返回一个数值，就会在这个数值(单位为秒)的时间后再次调用，但其间也可以被很快直接调用。调用顺序在get_adjustment之后。

        它可以用于在某段时间内更新条(bar)的值，就像 :func:`AnimatedValue` 一样。
        为了实现这点，get_adjustment应该存储Adjustment对象，并周期性调用Adjustment的修改方法。

    .. attribute:: alt

        如果按钮没有设置 :propref:`alt` 特性，则该行为会将该属性(attribute)用于文本转语音(TTS)。
        该属性可以是定义类时的一个字符串类型的属性，还可以在构造器中初始化，也可以是一段能返回字符串的Python代码。

.. _inputvalue:

输入值(inputvalue)
====================

当创建一项输入时，一个InputValue对象可以用作输入的
`value` 特性(property)。调用InputValue对象的方法可以实现：获取和设置文本，判断输入是否可编辑，以及回车键按下后的处理。

.. class:: InputValue

    继承这个类，并定义一个新的InputValue，需要重写部分或全部方法，并设置默认字段(field)的值。

    .. attribute: editable

        若不为True，文本输入区始终是不可编辑的。

    .. attribute:: default

        若为True，默认输入是可以编辑的。(当其在界面上显示时，可能会带有插入记号。)

    .. method:: get_text(self)

        返回输入的默认文本。这个方法必须实现。

    .. method:: set_text(self, s)

        当输入文本改变时，调用这个方法修改为新的文本。这个方法必须实现。

    .. method:: enter(self)

        当用户按下回车键时调用。如果其返回一个非None值，那个值会返回给交互行为。其也可以使用 :exc:`renpy.IgnoreEvent` 忽略回车键的按下。否则，回车键按下的消息会广播给其他可视组件。

    下列行为也是InputValue对象的可用方法：

    .. method:: Enable()

        返回一个行为，启用输入的文本编辑。

    .. method:: Disable()

        返回一个行为，禁用输入的文本编辑。

    .. method:: Toggle()

        返回一个行为，切换文本的可编辑状态。


.. _creator-defined-sl:

创作者定义的界面语言语句
=========================

Ren'Py支持定义定制化界面语言语句。创作者定义的界面语言语句本质上是变相使用了界面语言中的 :ref:`use语句 <sl-use>` 。固定位置入参不变，特性(property)变成了关键词参数。如果自定义的语句后面有一个语句块(block)，use语句也支持。例如，下面的定制化界面语言语句：

::

    titledwindow "Test Window":
        icon "icon.png"

        text "This is a test."

可以变成：

::

    use titledwindow("Test Window", icon="icon.png"):
        text "This is a test."

创作者定义的界面语言语句必须在 ``python early`` 语句块(block)中注册。还有，包含创作者定义的界面语言语句的文件必须在使用这个语句的文件之前加载。由于Ren'Py按照unicode顺序加载文件，通常合理的做法是，在注册创作者自定义语句的文件加上前缀“01”之类一个不大的数字。

创作者定义的界面语言语句使用renpy.register_sl_statement函数进行注册：

.. class:: renpy.register_sl_displayable(name, displayable, style, nchildren=0, scope=False, *, replaces=False, default_keywords={}, default_properties=True, unique=False)

    注册一个界面语言语句，用于创建一个可视组件。

    `name`
        注册的界面语言语句名称，一个包含自定义Ren'Py关键词的字符串。这个关键词用于标识脚本此处为新的语句。

    `displayable`
        这是一个函数，被调用后返回一个可视组件对象。所有固定位置入参、特性(property)和样式特性都可以作为入参传入这个函数。其他关键词入参请看后面部分。

        这个函数的返回值必须是一个可视组件。如果它返回了多个可视组件，最外层可视组件的“_main”属性(attribute)应该被设置成那个“主”可视组件——子组件添加在“主”组件上。

    `style`
        可视组件样式的基础名称。如果风格特性(property)没有指定，这项会添加风格前缀。处理后的样式名会以 ``style`` 关键词传入可视组件的处理函数。

    `nchildren`
        可视组件的子组件数量。可能是：

        0
            没有子组件。

        1
            有1个子组件。如果多于1个，则所有子组件放在一个固定布局(Fixed)中。

        "many"
            有多个子组件。

    `unique`
        如果该函数返回的可视组件对象具有唯一引用，则应把此参数设置为True。


    下列入参应该使用作为关键词入参传入：

    `replaces`
        若为True，且需要该可视组件替换之前的可视组件，就把新的可视组件作为参数传入。

    `default_keywords`
        可视组件的关键词入参默认集合。

    `default_properties`
        若为True，添加ui和position特性时会使用默认值。

    返回一个对象，并可以通过调用下列方法为这个对象添加固定位置入参和特性(property)。每个方法都会把结果返回给调用自己的对象，并允许方法链接起来用。

    .. method:: add_positional(name)

        添加一个名为 `name` 的固定位置入参。

    .. method:: add_property(name)

        添加一个名为 `name` 的特性(property)。特性会作为关键词入参传入。

    .. method:: add_style_property(name)

        添加一个特性的族(family)，以 `name` 结尾，沿用样式特性的前缀。例如，调用时使用("size")，这个方法就定了size、idle_size、hover_size等。

    .. method:: add_prefix_style_property(prefix, name)

        添加一个特性的族(family)，名字由 *prefix* (样式特性前缀)和 *name* 构成。例如，调用时使用了前缀 *text_* 和名称 *size* ，这个方法就创建了text_size、text_idle_size、text_hover_size等。

    .. method:: add_property_group(group, prefix='')

        添加一组特性，前缀为 *prefix* 。 *group* 可能是下列字符串之一：

        - "bar"
        - "box"
        - "button"
        - "position"
        - "text"
        - "window"

        这些分别对应 :ref:`样式特性 <style-properties>` 中的各个组。组名也可以是"ui"，添加的就是 :ref:`通用UI特性 <common-properties>` 。

.. class:: renpy.register_sl_statement(name, children='many', screen=None)

    使用Ren'Py注册一个定制化界面语言语句。

    `name`
        这项必须是一个word型数据。它是定制化界面语言语句的名称。

    `children`
        界面使用的子组件。如果没有指定，默认为 `name` 。

    `screen`
        使用的界面名。如果没有指定，默认是 `name` 。

    返回的对象可以添加指定的固定位置入参和特性(property)。该对象有一个与 :func:`renpy.register_sl_displayable` 返回对象相同的“.add_”方法。

下面一个创作者定义界面语言语句的例子，即 ``titledwindow`` 语句的实现。首先，在早期加载的文件——像名为“01custom.rpy”就加载足够早——中 ``python early`` 语句块中注册定制化语句。注册的脚本如下：

::


    python early:
        renpy.register_sl_statement("titledwindow", children=1).add_positional("title").add_property("icon").add_property("pos")

然后，我们定义一个实现了定制化语句的界面。这个界面可以在任何文件中定义。比如：

::

    screen titledwindow(title, icon=None, pos=(0, 0)):
        drag:
            pos pos

            frame:
                background "#00000080"

                has vbox

                hbox:
                    if icon is not None:
                        add icon

                    text title

                null height 15

                transclude

需要大量传递特性(property)值时，更合理的方法是使用 \*\*properties 参数，例如：

::

    screen titledwindow(title, icon=None, **properties):
        frame:
            # 如果properties参数中不包含background，则会使用默认值。
            background "#00000080"

            properties properties

            has vbox

            hbox:
                if icon is not None:
                    add icon

                text title

            null height 15

            transclude
