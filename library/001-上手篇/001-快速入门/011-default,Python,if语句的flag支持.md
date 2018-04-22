## default, Python, if语句的flag支持
以上语句制作完成的游戏也好，其他游戏也好，都需要数据的存、取功能。比如说，用户选择了选项后，让系统记住选项，在后面的进程中作出相应的反应。这是Ren'py支持python的其中一个原因。    

在这里，我们演示一下如何将flag存储在变量中。为了初始化flag，在label start之前用default语句定义。
```python
# True if the player has decided to compare a VN to a book.
default book = False

label start:

  s "Hi there! How was class?"
```
book flag 在初始情况被设定为`False`(在Ren'py中，大小写是敏感的)。在我们进行到book label时，可以用以下python命令将其变为True。  
```python
label book:

  $ book = True

  m "It's like an interactive book that you can read on a computer or a console."

  jump marry
```  
以美元符号（$）为开头的语句会转义为python语句。这里我们赋给变量一个参数。Ren'py同时也支持像Python一样的多行语句以及它的功能，我们将在其他章节讲解。    

这里进行flag的检查，我们使用if语句。    
```python
if book:

    "Our first game is based on one of Sylvie's ideas, but afterwards I get to come up with stories of my own, too."

```
如果条件为真（True），冒号后面的语句将会被执行。if条件语句判断如果是假（False），可以用else子句来执行条件为假的结果。    
```python
if book:

    "Our first game is based on one of Sylvie's ideas, but afterwards I get to come up with stories of my own, too."

else:

    "Sylvie helped with the script on our first video game."
```
当然 python 的变量不一定是简单的True/False值。它们可以是任意的 python 所支持的数据。 它们可以用来存储玩家的名字，或是存储分数，或是用于其他任何的用途。 自从 Ren'Py 拥有了使用完全版本的 Python 语言的能力后，许多大胆的设想都可以实现了。
