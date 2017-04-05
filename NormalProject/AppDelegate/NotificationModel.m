//
//  NotificationModel.m
//  NormalProject
//
//  Created by lf on 2016/11/28.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationUserInfo

@end

@implementation NotificationModel

@end

@implementation RemoteNotificationModel

@end

@implementation RemoteNotificationAps
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"contentAvailable" : @"content-available",
             @"threadId"         : @"thread-id",
             };
}
@end

@implementation RemoteNotificationApsAlert
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"titleLocKey"  : @"title-loc-key",
        @"titleLocArgs" : @"title-loc-krgs",
        @"actionLocKey" : @"action-loc-key",
        @"locKey"       : @"loc-key",
        @"locArgs"      : @"loc-args",
        @"launchImage"  : @"launch-image",
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"titleLocArgs" : [NSString class],
        @"locArgs"      : [NSString class],
    };
}
@end

@implementation LocalNotificationModel

@end
