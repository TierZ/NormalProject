//
//  AppDelegate+Notification.m
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//
#import "AppDelegate+Notification.h"
#import "NotificationModel.h"      // 通知model

@implementation AppDelegate (Notification)
/**
 * 初始加载, 申请'通知服务', 使必要时弹出服务申请的 aletr
 * 注册已写好, 适配了 iOS [8, ~)
 **/
- (void)batApplication:(UIApplication *)application registAPNsWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"[BAT] [0_0] [初始加载app] 申请 [通知服务] 权限.");

    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVer >= 10.0) {
        // [10, ~)
        NSLog(@"[BAT] [0_1] [初始加载app] iOS[10, ~) 申请 [通知服务] 权限 开始...");
        UNUserNotificationCenter *notiCenter = [UNUserNotificationCenter currentNotificationCenter];
        notiCenter.delegate = self;
        [notiCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"[BAT] [0_2] [初始加载app] iOS[10, ~) 用户 [已同意] 本App对通知服务的使用权限");
//                [notiCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//                    NSLog(@"[BAT] [0_4] [初始加载app] iOS[10, ~) notiSetting: %@", settings);
//                }];
            } else {
                NSLog(@"[BAT] [0_2] [初始加载app] iOS[10, ~) 用户 [未同意] 本App对通知服务的使用权限");
            }
            // 不管允许与否, 都向APNs申请注册, 因为用户使用中可能会重新打开权限, 以便可以接收到通知
            NSLog(@"[BAT] [0_3] [初始加载app] iOS[8, ~) [忽略通知权限] 准备向APNs提交注册申请...");
            [application registerForRemoteNotifications];
        }];
    } else if (iOSVer >= 8.0 && iOSVer < 10.0) {
        // [8, 10)
        NSLog(@"[BAT] [0_1] [初始加载app] iOS[8, 10) 申请 [通知服务] 权限 开始...");
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // 7及之前 就不进行适配了
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIUserNotificationTypeSound];
    }
}
/**
 * 初始加载时需要调用该方法
 * 处理通过 [通知栏] 打开App 对[本地/远程]通知信息的处理
 * 仅针对iOS[8, 10)的, iOS10之后会走代理方法
 *
 * 通过桌面icon打开app时, 是不带有通知信息的
 * 通过通知栏打开app时, 是带有通知信息的
 **/
- (void)batApplication:(UIApplication *)application receiveNotificationWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"[BAT] [1_0] [初始加载app] 准备处理 [本地/远程通知]");
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    // 本地通知的info 转 model 本身是[UIConcreteLocalNotification]
    id localNotify = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSData *localNotiData = [localNotify modelToJSONData];
    LocalNotificationModel *localNotiModel = [LocalNotificationModel modelWithJSON:localNotiData];
    // 远程通知的info 转 model
    id remoteNotify = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSData *remoteNotiData = [remoteNotify modelToJSONData];
    RemoteNotificationModel *remoteNotiModel = [RemoteNotificationModel modelWithJSON:remoteNotiData];
    // 取得要处理的notiModel
    NotificationModel *notiModel = localNotiModel?localNotiModel:remoteNotiModel;
    if (notiModel) {
        // 若通过通知栏开启App
        if (iOSVer < 10.0) {
            NSLog(@"[BAT] [1_1] [初始加载app] iOS [8, 10) 通过 [通知栏] 开启app [带有] 通知信息 [%p][%p]", localNotify, remoteNotify);
            // TODO: 保存待处理的通知内容, 不用跳转, 处理跳转的地方会加载保存的这个通知
            [self saveOrJumpWithNotification:notiModel];
        } else {
            // iOS [10, ~) 会由UN代理处理
        }
    } else {
        // 只是普通的通过桌面icon开启App
        NSLog(@"[BAT] [1_1] [初始加载app] iOS [8, ~) 通过 [桌面icon] 开启app [不带有] 通知信息");
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"launch notification <%p><%@>", localNotify, remoteNotify] message:[NSString stringWithFormat:@"%@", notiModel.userInfo] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - iOS [8, ~) delete
/**
 * iOS [8, ~)
 * APNs注册成功, 并返回deviceToken, 移动端再转发给自己的后台服务器
 * 调用 [application registerForRemoteNotifications] 方法后, 此代理方法才会在注册APNs成功后被调用
 **/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *tmpToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *token = [tmpToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"[代理] [7_0] [初始加载app] iOS[8, ~) APNs 返回[成功], 准备发送 [deviceToken] 给后台服务器 [%@]", token);
    // TODO: 发送deviceToken给后台服务器
}
/** 
 * iOS [8, ~)
 * 向APNs注册远程通知失败 
 **/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[代理] [7_0] [初始加载app] iOS[8, ~) APNs 返回[失败]: %@",error);
}
#pragma mark - iOS[8, 10) delegate
/**
 * iOS [8, 10)
 * 由 [application registerUserNotificationSettings:settings] 触发
 * app 新安装完成后, 打开app, 在通知权限提示框中点击了"好"后, 会调用本方法, 走else
 * app 新安装完成后, 打开app, 在通知权限提示框中点击了"不允许"后, 会调用本方法, 走if
 * 非新安装, 打开app, 会调用本方法
 **/
// 这个函数存在的意义在于: 当用户在设置中关闭了通知时, 程序启动时会调用此函数, 我们可以获取用户的设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        NSLog(@"[代理] [3_0] iOS[8, 10) 用户 [未同意] 本App对通知服务的使用权限");
    } else {
        NSLog(@"[代理] [3_0] iOS[8, 10) 用户 [已同意] 本App对通知服务的使用权限: [%zd]", notificationSettings.types);
    }
    // 不管允许与否, 都向APNs申请注册, 因为用户使用中可能会重新打开权限, 以便可以接收到通知
    NSLog(@"[代理] [3_1] iOS[8, 10) [忽略通知权限] 准备向APNs提交注册申请...");
    [application registerForRemoteNotifications];
}
/**
 * iOS [8, 10)
 * app已经是打开的:
 * app在前台时, 收到'本地通知', 调用本代理方法, 状态为Active, 未弹出通知提醒, 但通知栏有通知
 * app在前台时, 打开通知栏的通知, 调用本代理方法, 状态为Inactive
 * app在后台时, 打开通知栏的通知进入到前台, 调用本代理方法, 状态为Inactive
 * app在后台时, 通过桌面icon或后台任务进入到前台, 不调用此方法
 *
 * app关闭到打开的: 不调用本代理
 *
 * 这里的notification.userInfo 是固有的dic
 **/
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"[代理] [4_0] iOS[8, 10) receive [本地通知] 内容: \n %@, %zd", notification.userInfo, notification.applicationIconBadgeNumber);
    NSData *localNotiData = [notification modelToJSONData];
    LocalNotificationModel *localNotiModel = [LocalNotificationModel modelWithJSON:localNotiData];

    switch (application.applicationState) {
        case UIApplicationStateActive: {
            // 前台时收到通知消息, 通知栏会有新通知, 但是屏幕顶部不弹通知框(iOS10+可以选择弹框), 根据情况写操作内容, 比如写个假的弹窗
            NSLog(@"[代理] [4_1] iOS[8, 10) 当前状态: [前台] 收到 [本地通知] 消息, [不做处理]");
            break;
        }
        case UIApplicationStateInactive: {
            // 前台时, 通过通知栏打开通知消息, 会有可能在没显示到主视图(tabBarController)时就点击了通知
            // 后台时, 通过通知栏打开通知消息, 使app进入到前台
            NSLog(@"[代理] [4_1] iOS[8, 10) 当前状态: 通过 [通知栏] 打开 [本地通知] 消息, 跳转到相应页面, [跳转中] ...");
            // TODO: 这里写本地通知的跳转
            [self saveOrJumpWithNotification:localNotiModel];
            break;
        }
        case UIApplicationStateBackground: {
            // 后台时, 通过桌面icon(后台任务), 使App由后台进入前台, 不用写任何操作, 因为根本不走本函数
            NSLog(@"[代理] [4_1] iOS[8, 10) [本地通知] [ERR!!!]");
            break;
        }
        default:
            break;
    }
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"DelegateFor本地通知 <%p>", notification] message:[NSString stringWithFormat:@"%@", notification.userInfo] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
     */
}
/**
 * iOS [8, 10)
 * app已经是打开的:
 * app在前台时, 收到'远程通知', 调用本代理方法, 状态为Active, 未弹出通知提醒, 但通知栏有通知
 * app在前台时, 打开通知栏的通知, 调用本代理方法, 状态为Inactive
 * app在后台时, 打开通知栏的通知进入到前台, 调用本代理方法, 状态为Inactive
 * app在后台时, 通过桌面icon或后台任务进入到前台, 不调用此方法
 *
 * app关闭到打开的: 不调用本代理
 *
 * 这里的userInfo 有[aps] 和 自定义的 userInfo dic
 **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[代理] [5_0] iOS[8, 10) receive [远程通知] 内容: %@", userInfo);
    if (userInfo) {
        // 有通知内容
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        // 没有通知内容
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    RemoteNotificationModel *remoteModel = [RemoteNotificationModel modelWithDictionary:userInfo];

    switch (application.applicationState) {
        case UIApplicationStateActive: {
            // 前台时收到通知消息, 通知栏会有新通知, 但是屏幕顶部不弹通知框(iOS10+可以选择弹框), 根据情况写操作内容, 比如写个假的弹窗
            NSLog(@"[代理] [5_1] iOS[8, 10) 当前状态: [前台] 收到 [远程通知] 消息, [不做处理]");
            break;
        }
        case UIApplicationStateInactive: {
            // 前台时, 通过通知栏打开通知消息
            // 后台时, 通过通知栏打开通知消息, 使app进入到前台
            NSLog(@"[代理] [5_1] iOS[8, 10) 当前状态: 通过 [通知栏] 打开 [远程通知] 消息, 跳转到相应页面, [跳转中] ...");
            // TODO: 这里写从通知栏打开远程通知后的跳转
            [self saveOrJumpWithNotification:remoteModel];
            break;
        }
        case UIApplicationStateBackground: {
            // 后台时, 通过桌面icon(后台任务), 使App由后台进入前台, 不用写任何操作, 因为根本不走本函数
            NSLog(@"[代理] [5_1] iOS[8, 10) [远程通知] [WARNING!!!]");
            break;
        }
        default:
            break;
    }
}
#pragma mark - iOS [10, ~) delegate
/**
 * iOS [10, ~)
 * 当App处于前台时, 调用, 只进行弹窗|声音
 * 本地:
 *     bd
 * 远程:
 *     yc
 **/
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"[代理] [6_0] iOS[10, ~) 当前状态: [前台] 收到 [远程/本地通知], [弹框|声音]");
    // 显示弹框, 通知栏才有这一条
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
}
/**
 * iOS [10, ~)
 * 当从通知栏打开[远程/本地]通知消息(不管前台还是后台还是开启app)
 * 前台时: 
 *   直接跳转
 * 由后台->前台时:
 *   直接跳转
 * 由关闭->打开时:
 *   设置将要有跳转操作的rootVC
 **/
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    UNNotification *noti = response.notification;
    UNNotificationRequest *request = noti.request;
    UNNotificationContent *content = request.content; // 这里面就有通知的所有内容
    NSDictionary *_userInfo = content.userInfo; // 远程/本地:userInfo为通知信息内固有字段
    NSLog(@"[代理] [6_0] iOS[10, ~) about [远程/本地]通知 内容: %@", _userInfo);
    NSData *notiData = [content modelToJSONData];
    NotificationModel *notiModel = [NotificationModel modelWithJSON:notiData];
    UIApplication *application = [UIApplication sharedApplication];
    switch (application.applicationState) {
        case UIApplicationStateActive: { // 0
            // 前台时, 通过通知栏打开通知消息
            NSLog(@"[代理] [6_1] iOS[10, ~) 当前状态: 通过 [通知栏] [前台打开消息] 处理 [远程/本地通知], 跳转到相应页面, [跳转中] ...");
            // 写直接跳转
            [self saveOrJumpWithNotification:notiModel];
            break;
        }
        case UIApplicationStateInactive: { // 1
            // 后台时, 通过通知栏打开通知消息
            // app关闭时, 通过通知栏打开通知消息, 打开app
            // TODO: 这里写通知的跳转
            NSLog(@"[代理] [6_1] iOS[10, ~) 当前状态: 通过 [通知栏] [后台打开消息/开启app] 处理 [远程/本地通知], 跳转到相应页面, [跳转中] ...");
            [self saveOrJumpWithNotification:notiModel];
            break;
        }
        case UIApplicationStateBackground: { // 2
            // 暂未发现出现这种状态
            NSLog(@"[代理] [6_1] iOS[10, ~) [推送通知] [WARNING!!!]");
            break;
        }
        default: {
            break;
        }
    }
    completionHandler();
}
// 既能保存 又能跳转
- (void)saveOrJumpWithNotification:(NotificationModel *)notiModel {
    if (!notiModel) {
        return;
    }
    // 若是在launchVC时就点击了通知, 以便进入到tabBarVC后仍能跳转
    self.pendingNotification = notiModel;
    // 由代理处理 本demo这里为tabBarVC作为代理了
    if (self.notificationDelegate && [self.notificationDelegate respondsToSelector:@selector(batApplicationDidReceiveNotification:)]) {
        [self.notificationDelegate performSelector:@selector(batApplicationDidReceiveNotification:) withObject:notiModel];
    }
}
#pragma mark - 3rd delegate

@end
