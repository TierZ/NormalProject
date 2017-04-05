//
//  AppDelegate.h
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>   // iOS10后新的通知SDK

@protocol NotificationDelegate;
@class    NotificationModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *_Nonnull window;

/** 初始launch待处理的推送通知model */
@property (nonatomic, strong) NotificationModel *_Nullable pendingNotification;

/** 点击通知栏通知的代理 */
@property (nonatomic, weak) id<NotificationDelegate>  _Nullable notificationDelegate;
@end
