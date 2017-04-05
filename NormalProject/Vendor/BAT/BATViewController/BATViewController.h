//
//  BATViewController.h
//  NormalProject
//
//  Created by lf on 2016/10/31.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * (不全)结合了batTabBarController batTabBar batNavigationController batNavigationBar
 * 只提供方法 不初始添加任何子视图
 */
#import <UIKit/UIKit.h>
#import "BATTabBarController.h"
#import "BATNavigationController.h"
#import "BATNavigationBar.h"

typedef void(^BATNavigationBarItemActionBlock)();

@interface BATViewController : UIViewController

/** 状态栏样式 默认UIStatusBarStyleDefault 页面显示出来后设置无效 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/** 是否隐藏状态栏 默认NO 如需使用 页面显示出来后设置无效 */
@property (nonatomic, assign) BOOL statusBarHidden;

/** 设置自定义model转场是否有效 默认为NO */
@property (nonatomic, assign) BOOL customModelTransitionAnimationEnable;

/** 设置状态栏颜色风格 iOS9以前可用 */
//- (void)setupStatusBarStyle:(UIStatusBarStyle)style;

/** 是否隐藏状态栏 iOS9前可用 */
//- (void)setupStatusBarHidden:(BOOL)hidden;
@end

@interface UIViewController (BATXXXController)
/** 若self.navigationController 是bat的，则返回它，否则返回 nil */
@property (nonatomic, strong, readonly) BATNavigationController *batNavigationContrller;
/** 若self.tabBarController 是bat的，则返回它，否则返回 nil */
@property (nonatomic, strong, readonly) BATTabBarController *batTabBarContrller;
@end

@interface BATViewController (BATNavigationBar)
/** 返回add之后的batNavigationBar */
@property (nonatomic, readonly) BATNavigationBar *batNavigationBar;

/** 添加显示自定义的 batNavigationBar 不调用则不创建 */
- (void)addBatNavigationBar;

/** 设置batNavigationBar主题风格 自己设置去 默认就是系统原生的 */
- (void)setupBatNavigationBarTheme:(BATNavigationBarTheme)theme;

/** 添加back item */
- (void)addNavigationBarBackItem:(BATNavigationBarBackType)type title:(NSString *)title actionBlock:(BATNavigationBarItemActionBlock)block;

/** 移除back item */
- (void)removeNavigationBarBackItem;

/** 添加一个leftItem */
- (void)addNavigationBarLeftItem:(NSString *)title image:(UIImage *)image actionBlock:(BATNavigationBarItemActionBlock)block;

/** 移除一个leltItem */
- (void)removeNavigationBarLeftItemAtIndex:(NSInteger)index;

/** 添加一个rightItem */
- (void)addNavigationBarRightItem:(NSString *)title image:(UIImage *)image actionBlock:(BATNavigationBarItemActionBlock)block;

/** 移除一个rightItem */
- (void)removeNavigationBarRightItemAtIndex:(NSInteger)index;
@end
