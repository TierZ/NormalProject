//
//  Macro.h
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** 常用的基本宏定义 */
#ifndef Macro_h
#define Macro_h

#define DEBUG_LOG                 1   // 是否显示日志

/** 系统视图静态数值 */
#define kStatusBarHeight          20.0
#define kNavigationBarHeight      64.0
#define kTabBarHeight             49.0
#define kBarShadowHeight           0.5

/** 系统通知消息 */
#define kKeyboardWillShowNotification     UIKeyboardWillShowNotification
#define kKeyboardDidShowNotification      UIKeyboardDidShowNotification
#define kKeyboardWillHideNotification     UIKeyboardWillHideNotification
#define kKeyboardDidHideNotification      UIKeyboardDidHideNotification

/** NSUserDefault */
#define initUserDefault(...)       NSUserDefaults *(__VA_ARGS__) = [NSUserDefaults standardUserDefaults]
#define setUserDefault(value,key) {\
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults]; \
    [ud setObject:value forKey:key]; \
    [ud synchronize];\
}
#define getUserDefault(key)       [[NSUserDefaults standardUserDefaults] valueForKey:(key)]
// NSUserDefault KEY
#define kAppLastVersionUDKey      @"[BAT] AppLastVersion"  // 本地上一个版本号
#define kAppMaxVersionUDKey       @"[BAT] AppMaxVersion"   // 线上最大版本号

/** 获取app信息 */
#define kAppId                    @"a1d2234ea3f0329343ed3f9223001"

#define getAppBundleId()          ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])
#define getAppBundleVersion()     ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

/** 获取drvice信息 */
#define getDeviceModel()          ([[UIDevice currentDevice] model]) // iPhone/iPad
#define getDeviceLanguage()       ([NSLocale preferredLanguages][0]) // zh-Hant-US

/** iOS版本 return NSString */
// version float   9.2???
#define iOS_VERSION_VALUE         ([[[UIDevice currentDevice] systemVersion] floatValue])
// version string  @"9.2.1"
#define iOS_VERSION               ([[UIDevice currentDevice] systemVersion])
// ==
#define iOS_VERSION_EQUAL_TO(v)   ([iOS_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
// >
#define iOS_VERSION_GTEAT_THAN(v) ([iOS_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
// >=
#define iOS_VERSION_GTEAT_THAN_OR_EQUAL_TO(v) ([iOS_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
// <
#define iOS_VERSION_LESS_THAN(v)  ([iOS_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
// <=
#define iOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)  ([iOS_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

/** iOS版本Foundation return double */
#define iOS_NS_VERSION        NSFoundationVersionNumber
#define iOS_NS_VERSION_7_0    NSFoundationVersionNumber_iOS_7_0
#define iOS_NS_VERSION_8_0    NSFoundationVersionNumber_iOS_8_0
#define iOS_NS_VERSION_8_Max  NSFoundationVersionNumber_iOS_8_x_Max
#define iOS_NS_VERSION_9_0    NSFoundationVersionNumber_iOS_9_0
#define iOS_NS_VERSION_9_Max  NSFoundationVersionNumber_iOS_9_x_Max

/** NSLog */
#if DEBUG_LOG
#undef  NSLog
#define NSLog(FORMAT, ...) fprintf(stderr,"%s [%-s\t] [%.4d] : %s\n\n", [[NSDate date] stringWithFormat:@"HH:mm:ss.SSS"].UTF8String, [[NSString stringWithUTF8String:__FILE__] lastPathComponent].UTF8String, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#undef  NSLog
#define NSLog(...) do{}while(0)
#endif

#endif /* Macro_h */
