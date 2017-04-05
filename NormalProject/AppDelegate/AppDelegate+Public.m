//
//  AppDelegate+Public.m
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//
#import "AppDelegate+Public.h"
#import "BATBootupController.h"    // 设置rootVC

#define _kAppFirstInstallFlagUDKey     @"[BAT] AppFirstInstallFlag"

@implementation AppDelegate (Public)
// 对于首次安装 数据处理
- (void)settingForFirstInstallation {
    BOOL isInstall = [getUserDefault(_kAppFirstInstallFlagUDKey) boolValue];
    if (isInstall) {
        return;
    } else {
        setUserDefault(@(YES), _kAppFirstInstallFlagUDKey);
    }
    // 1 取消所有操作系统保留的通知消息
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVer < 10) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    } else {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    }
}
// 设置rootVC
- (void)setupRootViewController {
    BATBootupController *bootupVC = [[BATBootupController alloc] init];
    self.window.rootViewController = bootupVC;
    [self.window makeKeyAndVisible];
}
@end
