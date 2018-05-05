## Python
当然`layeredimage`语句也有相对应的Python等价语句。group语句没有——group 作用于 attribute，自动功能由 renpy.list_images()实现。

### ==Attribute== (group, attribute, image=None, default=False, **kwargs )    
attribute 用来表示LayeredImage的一层，并且被attribute控制。 单个属性可以控制多个层，在这种情况下，将显示与该属性对应的所有层。

__group__     
给与组的一串字符，attribute属于该组的一部分。其值也可能是None，在这种情况下，创建与属性相同名称的组。    

__attribute__    
一串给与属性的字符。   

__image__     
如果不为None,这是一个可显示对象，当属性出现的时候会被显示。    

__default__     
如果为True， 并没有组里的其他属性被选择时，这个属性默认显示。

以下关键字也同样适用：   
__at__     
将一个变换或一组变换作用于图像。    

__if_all__    
一串或一系列字符串组成的属性名。如果申明了此特性，此可显示对象只在所有属性名被声明时才显示。    

__if_any__        
一串或一系列字符串组成的属性名。如果申明了此特性，此可显示对象在任何其中之一的属性名被声明时才显示。     

__if_not__    
一串或一系列字符串组成的属性名。如果申明了此特性，此可显示对象在任何其中之一的属性名都不被声明时才显示。

其他关键字参数被转义成变换特性（transform properties）。如果任意一个特性出现，将创建一个包裹图像的变换。  
（比如说，pos=(100,200)可以用来设定图片的偏移量为水平方向100像素，垂直方向200像素。）   

如果 *image* 参数省略或为None，LayeredImage会被给予 *image_format* 参数，image_format 用来产生图像文件名。    

### ==Condition== (condition,image, **kwargs)
Condition被用来表示LayeredImage当中的一层，此层会被条件控制。当条件为真时，此层将会显示。其他情况下不会显示任何东西。    

__condition__    
这是一串给出Python条件的字符串，将决定图层是否显示。    

__image__    
如果不为None，将会显示一个条件为真时的可显示对象。     

__if_all__    
一串或一系列字符串组成的属性名。如果申明了此特性，所有属性名被声明时该条件才会判断。    

__if_any__        
一串或一系列字符串组成的属性名。如果申明了此特性，任何其中之一的属性名被声明时给条件会进行判断。     

__if_not__    
一串或一系列字符串组成的属性名。如果申明了此特性，任何其中之一的属性名都不被声明时条件才会被判断。    

__at__     
将一个变换或一组变换作用于图像。   

其他关键字参数被转义成变换特性（transform properties）。如果任意一个特性出现，将创建一个包裹图像的变换。  
（比如说，pos=(100,200)可以用来设定图片的偏移量为水平方向100像素，垂直方向200像素。）    

### ==LayeredImage==(attributes,at[],name=None, image_format=None, format_funtion=None, attribute_function=None,**kwargs)
这是一个类图像对象，当带有一组正确的属性时，显示一个由组合与这些属性相关联的可显示对象创建的可显示对象。   

__attribute__         
必须为一组属性对象。各属性对象反应到一个可显示对象，作为或不作为图像的一部分显示。所有的属性项按从后到前的顺序，即第一项离用户最远，最后一项离用户最近。    

__at__         
将一个变换或一组变换作用于带有参数的可显示对象。    

__name__    
属性图像的名字。它是构成图像名的一部分。    

__image_format__       
当图像是一串字符串，图像名会被转义成 *image_format* 来创建一个图片文件。比如，"sprites/eileen/{image}.png"将会寻找sprites子文件夹下的图像。（image_format不会被自动组（auto group）使用，自动组寻找图像而不是图像文件。    

__format_function__    
一个用来替换*layeredimage.format_funtion* 的功能，格式化图像信息来产生一个可显示对象。    

__attribute_function__      
如果不为None，它用一组提供给图像的属性调用的函数，并返回用于选择层的一组属性。在要选择显示的图层时被调用，当属性自身被选择时。它可以表示复杂的属性以来关系，或者随机选择属性。   

其他关键字传递给一个固定层，创建固定层是为了存放图层。除非特别声明，xfit和yfit在固定层中设为true，意味着它将自适应成能存放所有分层图片的最小尺寸。    

LayeredImage不是一个可显示对象，可显示对象能使用的场景它不一定可以使用。因为它需要一个图像名（一般包含图像属性）。所以它将通过scene或show语句显示，或者一个图像名称字符串命名的可显示对象。   

Layeredimage.format_function 是一个用来格式化属性和可显示对象为图像文件的功能. 你能在文档中看到它是如何工作的，当然它也接受参数，你可以使用你自己的 format_function来代替他。

### ==Layeredimage.format_function==（what,name,group,variant,attribute,image,image_format,**kwargs）    
当Layeredimage.format_funtion 被调用的时，会用来格式化有关属性或条件的信息来形成可显示对象。它可以被替换，不过新功能应该忽略已知的kwargs。    

__what__    
一串用来描述格式化的字符串，可以使报错信息更清晰。     

__name__        
属性图像的名称。     

__group__    
属性的组, 没有提供或为条件的一部分时为None。    

__variant__    
组的变种参数，如果没有提供则为None。    

__attribute__    
属性本身。    

__image__
一个字符串或可显示对象。    

__image_format__
 LayeredImage的image_format参数。    
 如果image为None, 则 name, group (如果不为 None), variant (如果不为 None), attribute 将会被下划线组合形成一个图像, 然后会成为一个字符串。    

如果图像是一个字符串，并且image_format不为None，图像会被格式化为字符串来形成最终的可显示对象。    

如果name是"eileen"，group是"expression"，attribute是"happy"，图像将会被设为"eileen_expression_happy"。如果image_format是“image/{image}.png”，最终Ren'py搜寻的图像是“images/eileen_expression_happy.png”。不过注意Ren'py也会在没有声明格式的情况下找到相同的图像。
