.. _side-images:

头像
===========

许多视觉小说会在角色发言时，在对话内容旁边显示一张该角色的头像。Ren'Py把这个头像称作头像(side image)，并支持自动选择和显示对话的头像。

使用头像的前提是，定义 :func:`Character` 时使用一个关联的图像标签(tag)：

::

    define e = Character("艾琳", image="eileen")

当某个带有关联图像标签的角色发言时，Ren'Py会创建一个图像属性(attribute)池。关联图像标签会被添加到这个池，当前图像属性与那个图像标签关联。

根据图像标签选择关联的头像时，Ren'Py会尝试在图像属性池中找到带有标签“side”且带有尽可能大的属性值的图片。如果没有找到符合条件的图片，或者找到多个带有相同属性值的图像，就显示 :class:`Null` 。

例如，假设我们有如下脚本：

::

    define e = Character("艾琳", image="eileen")

    image eileen happy = "eileen_happy.png"
    image eileen concerned = "eileen_concerned.png"

    image side eileen happy = "side_eileen_happy.png"
    image side eileen = "side_eileen.png"

    label start:

        show eileen happy

        e "我们把线段的这端称作点A。"

        e concerned "线段的另一端称作点B。"

在point A，角色 ``e`` 正在发言，关联的图像标签是“eileen”。当“eileen happy”图像显示时，图像属性池的标签里有“eileen”和“happy”。我们寻找带有“side”图像标签的图像，以及尽可能多的属性——我们就能匹配到“side eileen happy”，最终显示为头像。

在point B，显示的图像是“eileen concerned”。当前属性池里是“eileen”和“concerned”。唯一匹配的图像是“side eileen”，这也是Ren'Py最终选用的图像。如果存在一个“side concerned”图像，由于其命名不清晰，Ren'Py不会显示它。

.. _invisible-characters:

不可视角色
--------------------

另一个头像的用处，是当用户角色的对话内容，显示一个头像。做法是将某个图像与角色关联，然后使用带图形结构的say语句选择显示的头像。

举例：

::

    define p = Character("Player", image="player")

    image side player happy = "side_player_happy.png"
    image side player concerned = "side_player_concerned.png"

    label start:

        p happy "这里会显示 'side player happy' 图像。"

        p "这里会显示 'side player happy' 。"

        p concerned "这里会显示 'side player concerned' 。"

.. _variations:

变种
----------

头像有一些变换，分别由一些配置项控制。

.. var:: config.side_image_tag = None

    若非None，头像会追踪给定的图像标签(tag)，而不是追踪当前发言角色的关联图像。例如：

    ::

        define e = Character("艾琳", image="eileen")

        init python:
             config.side_image_tag = "eileen"

    会让头像追踪图像标签“eileen”。这个标签与角色 ``e`` 关联。

.. var:: config.side_image_only_not_showing = False

    当设置为True时，只在带这个标签的某个图像还没有显示在界面上，才会显示头像。

.. var:: config.side_image_prefix_tag = 'side'

    搜索头像使用的前缀。

.. var:: config.side_image_null = Null()

    不显示头像时，显示空的可视组件。空的头像也可以改变，只不过变为其他的空可视组件。一个这样做的原因是，设置了空组件的边界后(例如，Null(width=200, height=150))，能够防止dissolve效果被中途割裂。

.. var:: config.side_image_same_transform = None

    若非None，当新的头像与前一个头像共享同一个图像标签时，这个transform就会使用。

.. var:: config.side_image_change_transform = None

    若非None，当新的头像与前一个头像不共享图像标签(或新旧头像之一不存在)时，这个transform就会使用。

.. _transforms-and-transitions:

变换和转场
--------------------------

:var:`config.side_image_same_transform` 和
:var:`config.side_image_change_transform` 使用两个参数——新旧两个头像可视组件——调用时，每次显示的图像。可以是让头像运行或者使用转场效果。

下面是一个例子，当关联图像改变时，让头像滑入和滑出：

::

    transform change_transform(old, new):
        contains:
            old
            yalign 1.0
            xpos 0.0 xanchor 0.0
            linear 0.2 xanchor 1.0
        contains:
            new
            yalign 1.0
            xpos 0.0 xanchor 1.0
            linear 0.2 xanchor 0.0

    define config.side_image_change_transform = change_transform

角色不变的情况下，新旧头像的转场使用dissolve效果。(例如，角色改变情绪时。)为了让Dissolve效果正常工作，两个头像必须有相同的尺寸。

::

    transform same_transform(old, new):
        old
        new with Dissolve(0.2, alpha=True)

    define config.side_image_same_transform = same_transform

.. _leaving-room-customization:

预留空间 / 定制化
----------------------------

默认情况下，对话文本区域的宽度与整个界面宽度相同。如果尝试直接显示头像，图像会覆盖在文本上面。要修复这个问题的话，我们需要在文本窗口内划出一块合适的区域使用头像。

::

    style window:
        left_padding 150

通过定制 ``say`` 和 ``nvl`` 界面可以改变头像的位置。两种界面都需要包含这样一行：

::

    add SideImage() xalign 0.0 yalign 1.0

通过修改xalign和yalign特性(property)，我们可以控制界面上头像的显示位置。

最后， :func:`SideImage` 会返回一个可视组件，也就是当前的头像。这可以用在高级界面定制化中。
