//
//  BATTabBarController.h
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTabBar.h"

@class NotificationModel ;           // 推送通知模型
@class AdvertisementModel;           // 广告模型

@interface BATTabBarController : UITabBarController
/** 底部的tabBar */
@property (nonatomic, readonly) BATTabBar        *batTabBar;

/** 待跳转的推送消息 */
@property (nonatomic, strong) NotificationModel  *pendingNotification;

/** 待跳转的广告 */
@property (nonatomic, strong) AdvertisementModel *pendingAdvertisement;

/** 设置item的badge */
- (void)setupItemBadgeValue:(NSString *)badge index:(NSInteger)index;
@end
