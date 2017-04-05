//
//  PrivacyUtil.h
//  NormalProject
//
//  Created by lf on 16/10/18.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  隐私权限 相关功能
 *
 *  相机，照片，通知，通讯录，麦克风，语言识别，日历，提醒事项，蓝牙，位置（、始终访问位置、运行期间访问位置），健康，HomeKit，媒体资料库，运动与健康，蜂窝网络，WiFi，Siri，后台刷新
 *  参考：
 *  http://www.superqq.com/blog/2015/12/01/jump-setting-per-page/
 *  在项目中的info中添加 URL types
 *  添加 URL Schemes 为 prefs的url
 */
typedef void(^PrivacyEnabledBlock)();
typedef void(^PrivacyDisabledBlock)();

typedef NS_ENUM(NSInteger, PrivacyType) { // 打开的系统设置里的功能
    PrivacyTypeSetting = 0,    // 设置
    PrivacyTypeGeneral,        // 设置->通用
    PrivacyTypeWiFi,           // 通用->无线局域网
    PrivacyTypeBluetooth,      // 通用->蓝牙
    PrivacyTypeNetwork,        // 设置->蜂窝网络
    PrivacyTypeNotification,   // 设置->通知
    PrivacyTypePrivacy,        // 设置->隐私?设置.
    PrivacyTypeLocation,       // 设置->隐私->定位服务
    PrivacyTypeMyApp,          // 设置->自己的App
};

@interface PrivacyUtil : NSObject
// part-1
+ (void)requestCamera:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;
+ (void)requestMicrophone:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;
+ (void)requestPhotoLibrary:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;
+ (void)requestAddressBook:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;

// part-2
+ (void)checkRemoteNotificationStatus:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;
+ (void)checkLocationStatus:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;
+ (void)checkCellularNetworksStatus:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable;

// part-3
/** 打开系统设置 iOS10+不管用了 */
+ (BOOL)openSystemSetting:(PrivacyType)type;
@end
