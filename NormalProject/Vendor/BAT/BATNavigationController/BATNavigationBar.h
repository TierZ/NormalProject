//
//  BATNavigationBar.h
//  NormalProject
//
//  Created by lf on 2016/10/27.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** 
 * 自定义的tabBar，但没有新增自己的东西, 完全可以提出来当个category, 继承了UITabBar，还要使用一些原始的方法和布局
 *
 *  可以提供一些特定的主题
 *  暂无法实现从颜色间的渐变功能，将颜色转换成image->backgroundImage好吗？
 */
#import <UIKit/UIKit.h>

#define _kBATNaviBarHeight        kNavigationBarHeight
#define _kBATNaviBarShadowHeight  kBarShadowHeight

/** 主题风格(指的是title item 和 背景color)自己设置自己改 */
typedef NS_ENUM(NSInteger, BATNavigationBarTheme) {
    BATNavigationBarThemeOriginal = 0,    // 原生带半透明效果的
    BATNavigationBarThemeRed,             // 红底白字不透
    BATNavigationBarThemeRedTranslucent,  // 红底白字带透
    BATNavigationBarThemeWhite,           // 白底黑字不透
    BATNavigationBarThemeWhiteTranslucent,// 白底黑字带透
    BATNavigationBarThemeClear,           // 纯透明的，无任何颜色
    BATNavigationBarThemeDefault  = BATNavigationBarThemeOriginal
};
/** backItem样式 */
typedef NS_ENUM(NSInteger, BATNavigationBarBackType) {
    BATNavigationBarBackTypeNone = -1,    // 无返回图片
    BATNavigationBarBackTypeReturn = 0,   // 返回箭头样式
    BATNavigationBarBackTypeClose,        // 关闭样式
    BATNavigationBarBackTypeDefault = BATNavigationBarBackTypeReturn,
};
@interface BATNavigationBar : UINavigationBar
/** 自定义一些主题样式 */
@property (nonatomic, assign) BATNavigationBarTheme batNavigationBarTheme;

/** navigationBar最底层视图 这只是个get方法 */
@property (nonatomic, readonly) UIView *batBackgroundView;
/** navigationBar那层模糊视图 */
@property (nonatomic, readonly) UIView *batBackdropView;
/** navigationBar的shadow */
@property (nonatomic, readonly) UIView *batShadowView;

/** 是否隐藏navigationBar底部的线 */
- (void)setupShadowHidden:(BOOL)hidden;
@end
