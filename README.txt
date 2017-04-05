/**
*
* [info]
* 本demo构建了基本结构, 具有如下功能
* ATS/国际化/自定义TabBar/转场动画/等
* 本demo目前采用的是设置2次rootVC, launch/guide/advert为1st-bootVC, navigationVC为2sec
* 因为没有用navigationVC内的navigationBar, 所以将navigationVC作为了window.rootVC, 而tabBarVC作为了navigationBarVC.rootVC. 看到的navigationBar, 是单独在VC上加的.
*
* [开发环境]
* MacBook Air (13-inch, Early 2014)
* 1.4 GHz Intel Core i5
* 4GB 1600MHz DDR3
*
* macOS: Sierra 10.12
* Xcode: 8.0 (8A218a)
* iOS  : 8.0 and later
* pod  : 1.0.1
* ruby : 2.0.0p648
* gem  : 2.0.14.1
* bash : 3.2.57(1)
*
* [目录说明]
* AppDelegate          与AppDelegate相关, 分享, 通知等
* Vendors              第三方库framework、SDK
* General              组件
* Helper               工具类
* Controllers          所有controller
* Views                所有view
* Models               所有model
* Macro                宏
* Resources            媒体资源
* Storyboard
* Xib
*
* [函数]
* custom 自定义
* batXXX               区别系统的
* batInitSubViews      初始化子视图    私有
* batLayoutSubViews    布局子视图      私有
* batCreate = batInit + batLayout  私有共有 customXXX subViews
* setupXXX             set方法的演变   指的是间接进行set方法
*
* [命名]
* block类型             [BAT]行为描述Block (UMShareBlock)
* 枚举                  None(Unknown)值为-1, Default值为任意
* 宏                    静态数值 [_]k+描述+属性(Height, UDKey, Notification, KeyPaht, ID ...)
*                       通过函数形式表达的-小驼峰getUserDefault()
*
*
* [arm]
* armv6 设备: iPhone, iPhone2, iPhone3G, 第一代、第二代 iPod Touch
* armv7 设备: iPhone3GS, iPhone4, iPhone4S, iPad, iPad2, iPad3(The New iPad), iPad mini, iPod Touch 3G, iPod Touch4
* armv7s设备: iPhone5, iPhone5C, iPad4(iPad with Retina Display)
* arm64 设备: iPhone5S/6/6s/7 iPad Air, iPad mini2(iPad mini with Retina Display)
*
* [Q&A]
*
*
*
*
 **/



