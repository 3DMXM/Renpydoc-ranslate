.. _side-images:

头像
===========

许多视觉小说会在角色发言时，在对话内容旁边显示一张该角色的头像。Ren'Py把这个头像称作头像(side image)，并支持自动选择和显示对话的头像。

使用头像的前提是，定义 :func:`Character` 时使用一个关联的图像标签(tag)：

::

    define e = Character("艾琳", image="eileen")

当某个带有关联图像标签的角色发言时，Ren'Py会创建一个图像属性(attribute)池。关联图像标签会被添加到这个池，当前图像属性与那个图像标签关联。

根据图像标签选择关联的头像时，Ren'Py会尝试在图像属性池中找到带有标签“side”且带有尽可能大的属性值的图片。如果没有找到符合条件的图片，或者找到多个带有相同属性值的图像，就显示 :class:`Null` 。

除了tag标签，在属性池中至少需要有一项属性。如果没有，头像不会显示。

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

.. _config-and-store-variables:

配置和存储区变量
--------------------------

有一些头像的属性由配置项控制。

.. var:: _side_image_tag = None
.. var:: config.side_image_tag = None

    若非None，头像会追踪给定的图像标签(tag)，而不是追踪当前发言角色的关联图像。例如：

    ::

        define e = Character("艾琳", image="eileen")

        define config.side_image_tag = "eileen"

    会让头像追踪图像标签“eileen”。这个标签与角色 ``e`` 关联。

.. var:: config.side_image_only_not_showing = False

    当设置为True时，只在带这个标签的某个图像还没有显示在界面上，才会显示头像。

.. var:: _side_image_prefix_tag = None
.. var:: config.side_image_prefix_tag = 'side'

    若 _side_image_prefix_tag不是None，其使用  config.side_image_prefix_tag 的设置。
    前缀用于搜索搜索头像。

.. var:: config.side_image_null = Null()

    不显示头像时，显示空的可视组件。空的头像也可以改变，只不过变为其他的空可视组件。
    一个这样做的原因是，设置了空组件的边界后(例如，Null(width=200, height=150))，能够防止dissolve效果被中途割裂。

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


当 :func:`SideImage` 缩小时，最好启用 :func:`Dissolve` 的mipmap功能。

::

    transform same_transform(old, new):
        old
        new with Dissolve(0.2, alpha=True, mipmap=True)

    define config.side_image_same_transform = same_transform

.. _side-image-function:

相关函数
----------

.. function:: renpy.get_side_image(prefix_tag, image_tag=None, not_showing=True, layer='master')

    这个函数尝试找到图像显示为头像。

    由某个图像属性(attribute)的集合决定启用哪个头像。如果给出了 `image_tag` ，函数从这个图像标签(tag)得到图像属性(attribute)。否则，函数从当前显示的角色获取图像属性。

    然后函数会根据标签 `prefix_tag` 和其他一些属性寻找合适的图像，并返回找到的图像。

    如果 `not_showing` 的值为True，这个函数将只返回一个头像，前提是图像使用的属性(attribute)不存在于当前界面上。
    如果 `not_showing` 的值为None，则根据 :var:`config.side_image_only_not_showing` 的配置决定。

    如果 `layer` 的值是None，当前显示的图像标签使用默认图层。

.. function:: renpy.set_tag_attributes(name, layer=None)

    当对应标签的图像不在显示时，该函数会将图像属性(attribute)与标签进行关联。
    该函数的主要用途是，直接设置头像所使用的图像属性。

    例如：

    ::

        $ renpy.set_tag_attributes("lucy mad")
        $ renpy.say(l, "I'm rather cross.")

    和

    ::

        l mad "I'm rather cross."

    是等效的。

