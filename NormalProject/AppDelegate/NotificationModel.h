//
//  NotificationModel.h
//  NormalProject
//
//  Created by lf on 2016/11/28.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** 
 * 推送 model
 *  本地 和 远程
 *  不管本地还是远程, 不管是iOSx的通知, 都可以有共同的字段userInfo, 这里面的信息可以自定义
 * 很难兼容到ios8,9,10的model, 唯有userInfo是可协定的
 */
#import <Foundation/Foundation.h>
/////////////////////////////////  userInfo  //////////////////////////////
/** 推送通知的类型 未知/活动/资讯/消息/... */
typedef NS_ENUM(NSInteger, NotificationUserInfoType) {
    NotificationUserInfoTypeUnknown = 0,
    NotificationUserInfoTypeActivity,
    NotificationUserInfoTypeInformation,
    NotificationUserInfoTypeMessage,
};
/** 本地/远程可能用到的自定义扩展 */
@interface NotificationUserInfo : NSObject
// e.g.
@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *image;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, assign) NotificationUserInfoType type;
// others
@end

///////////////////////////////// 通知model基类 /////////////////////////////
/** 本地通知model 和 远程通知model 的基类 */
@class NotificationUserInfo;
@interface NotificationModel : NSObject
/** 本地通知和远程通知共有的userInfo, 其存储主要通知内容 */
@property (nonatomic, strong) NotificationUserInfo *userInfo;
@end

///////////////////////////////// 远程通知model /////////////////////////////
/** 远程通知model */
@class RemoteNotificationAps;
@interface RemoteNotificationModel : NotificationModel
@property (nonatomic, strong) RemoteNotificationAps *aps;
// 和userInfo
@end

@class RemoteNotificationApsAlert;
@interface RemoteNotificationAps : NSObject
@property (nonatomic, strong) NSNumber *badge;
@property (nonatomic, copy)   NSString *sound;
@property (nonatomic, strong) NSNumber *contentAvailable;
@property (nonatomic, copy)   NSString *category;
@property (nonatomic, copy)   NSString *threadId;
@property (nonatomic, strong) RemoteNotificationApsAlert *alert; // Dictionary or String
@end

@interface RemoteNotificationApsAlert : NSObject
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *body;
@property (nonatomic, copy)   NSString *titleLocKey;
@property (nonatomic, strong) NSArray  *titleLocArgs;
@property (nonatomic, copy)   NSString *actionLocKey;
@property (nonatomic, copy)   NSString *locKey;
@property (nonatomic, strong) NSArray  *locArgs;
@property (nonatomic, copy)   NSString *launchImage;
@end

///////////////////////////////// 本地通知model /////////////////////////////
/** 本地通知model */
@interface LocalNotificationModel : NotificationModel
@property (nonatomic, copy)   NSString       *alertAction;
@property (nonatomic, copy)   NSString       *alertBody;
@property (nonatomic, copy)   NSString       *alertLaunchImage;
@property (nonatomic, copy)   NSString       *alertTitle;
@property (nonatomic, strong) NSNumber       *applicationIconBadgeNumber;
@property (nonatomic, assign) BOOL           hasAction;
@property (nonatomic, assign) BOOL           hideAlertTitle;
// 和userInfo
@end

