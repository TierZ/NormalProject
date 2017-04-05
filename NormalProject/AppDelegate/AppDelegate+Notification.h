//
//  AppDelegate+Notification.h
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 适用于 >= iOS8.0
 * 提供一些 "推送" 使用到的方法, 和 NSNotificationCenter 没有半毛钱关系
 * 所有关于通知的代理方法 写在这里
 * ❗️只要你的rootVC(一般tabBarVC)遵守这里的协议, 实现协议方法, 就能实现跳转了
 **/
#import "AppDelegate.h"

@interface AppDelegate (Notification) <UNUserNotificationCenterDelegate>
/** App初始finishiLaunch加载时, 注册通知服务 */
- (void)batApplication:(UIApplication *)application registAPNsWithOptions:(NSDictionary *)launchOptions;

/** App初始finishiLaunch加载时, 对[本地/远程]通知的处理 */
- (void)batApplication:(UIApplication *)application receiveNotificationWithOptions:(NSDictionary *)launchOptions;
@end

/** 推送的代理 */
@class NotificationModel;
@protocol NotificationDelegate <NSObject>
@optional
/** 点击通知栏的推送通知的代理方法 */
- (void)batApplicationDidReceiveNotification:(NotificationModel *)notiModel;
@end
