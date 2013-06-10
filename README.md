###环境配置

web:
  1. django1.5
  2. sqlite3

ios:  
    没什么好说的xcode4.6就没问题了。支持ios5.0以上
    
pc: 
  1. pyqt4
  2. [markdown]('https://github.com/waylan/Python-Markdown')

android:  
  1. android Studio  
  2. 第三方httpclient库[basic-http-client]('http://code.google.com/p/basic-http-client/')  
  

==============================================================================================================================
###下一版本  
  1. ios修复
  2. 版本的同步
  3. 代码优化
  
让程序能完整的跑起来，并且代码为了后期更新，保持一定的条理性
目前的代码比较乱，版本号在程序中基本都没有标识。  
而且代码都是随意拼凑出来的效果。  下1个 


==============================================================================================================================


###version 0.3.1  
新增android支持 具体参考源码和环境配置段落  


###version 0.3   
新增pc端的支持  
代码采用pyqt:   

新增  
pc端:  
  1. 登录   
  2. 查看列表  
  3. 内容   
  4. html显示   
  5. 发表博客    

修改:
  1. web api校验
  2. 数据返回

ios版本修复下次在更新  
演示:  
![photo](http://img3.douban.com/view/photo/photo/public/p1996889954.jpg "demophoto")


==============================================================================================================================


###version 0.2  
ios 端采用第三方类库: 
    [beeFramework]('https://github.com/gavinkwoe/BeeFramework')  
    [AttributedMarkdown]('https://github.com/dreamwieber/AttributedMarkdown')  
    
增加  

1. api       
    1. 登录   
    2. 发表博客   
    3. 获取博客列表   
2. ios客户端     
   1. 登录   
   2. 查看博客列表   
   3. 查看博客-支持mardown   
   4. 增加博客   

###version 0.1  


感谢  
www.diandian.com  
模版部分是从diandian.com里面拿。然后去掉一些直接用的。 

数据库采用sqlite3  
blog支持mardown  
version1.0功能  

  1. 首页分页显示  
  2. 具体内容显示  

###下面是效果图  
![index](http://img3.douban.com/view/photo/photo/public/p1991639277.jpg "index")  
![blog detail](http://img3.douban.com/view/photo/photo/public/p1991639404.jpg "blog detail")

