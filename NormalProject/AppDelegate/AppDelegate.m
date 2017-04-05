//
//  AppDelegate.m
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Public.h"
#import "AppDelegate+Notification.h"
#import "AppDelegate+ThirdShare.h"
#import "AppDelegate+ThirdLogin.h"
#import "AppDelegate+ThirdPay.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
/** App 加载完成 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"app for launch begin ...");
    // 首次安装设置
    [self settingForFirstInstallation];
    
    // 通知相关, 有先后
    [self batApplication:application registAPNsWithOptions:launchOptions];
    [self batApplication:application receiveNotificationWithOptions:launchOptions];
    
    // 第三方分享相关
    [self batApplication:application registThirdShareWithOptions:launchOptions];
    
    // 第三方登录相关
    [self batApplication:application registThirdLoginWithOptions:launchOptions];
    
    // 第三方支付相关
    [self batApplication:application registThirdPayWithOptions:launchOptions];
    
    // rootVC
    [self setupRootViewController];

    NSLog(@"app for launch end ...");
    return YES;
}
/** App 将要取消活跃状态 */
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"app will resignActive | app 将要取消活跃状态");
}
/** App 已经进入到后台 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"app did enter background | app 已经进入到后台");
}
/** App 将要进入前台 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"app will enter forground | app 将要进入到前台");
}
/** App 已经成为活跃状态 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"app did become active | app 已经成为活跃状态");
}
/** App 将要关闭 */
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"app will terminate | app 即将关闭");
}

/*
 1 首次打开App
 -[AppDelegate application:didFinishLaunchingWithOptions:], App已经完成加载
 -[AppDelegate applicationDidBecomeActive:], App已经成为活动状态
 2 前台进入后台
 -[AppDelegate applicationWillResignActive:], App将要取消活动状态
 -[AppDelegate applicationDidEnterBackground:], App已经进入后台
 3 后台返回前台
 -[AppDelegate applicationWillEnterForeground:], App将要进入前台
 -[AppDelegate applicationDidBecomeActive:], App已经成为活动状态
 4 退出
 -[AppDelegate applicationWillResignActive:], App将要取消活动状态
 -[AppDelegate applicationDidEnterBackground:], App已经进入后台
 -[AppDelegate applicationWillTerminate:], App将要退出
 */
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}
@end
