//
//  AppDelegate+Share.m
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "AppDelegate+ThirdShare.h"
#import <UMSocialCore/UMSocialCore.h>

#define _kUMengShareAppKey           @"57b432afe0f55a9832001a0a"

#define _kTencentWeChatAppKey        @"wxdc1e388c3822c80b"
#define _kTencetnWeChatAppSecret     @"3baf1193c85774b3fd9d18447d76cab0"
#define _kTencentWeChatRedirectURL   @"http://mobile.umeng.com/social"

#define _kTencentQQAppKey            @"100424468"
#define _kTencetnQQAppSecret         @""
#define _kTencentQQRedirectURL       @"http://mobile.umeng.com/social"

#define _kSinaWeiboAppKey            @"3921700954"
#define _kSinaWeiboAppSecret         @"04b48b094faeb16683c32669824ebdad"
#define _kSinaWeiboRedirectURL       @"http://sns.whalecloud.com/sina2/callback"

@implementation AppDelegate (ThirdShare)

- (void)batApplication:(UIApplication *)application registThirdShareWithOptions:(NSDictionary *)launchOptions {
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:_kUMengShareAppKey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:_kTencentWeChatAppKey appSecret:_kTencetnWeChatAppSecret redirectURL:_kTencentWeChatRedirectURL];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:_kTencentQQAppKey  appSecret:nil redirectURL:_kTencentQQRedirectURL];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:_kSinaWeiboAppKey  appSecret:_kSinaWeiboAppSecret redirectURL:_kSinaWeiboRedirectURL];
    /*
    //支付宝的appKey
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置易信的appKey
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置点点虫（原来往）的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置领英的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    
    //设置Twitter的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    */
    // 如果不想显示平台下的某些类型，可用以下接口设置
    //    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_YixinTimeLine),@(UMSocialPlatformType_LaiWangTimeLine),@(UMSocialPlatformType_Qzone)]];
}

#define appdelegate
// (~, 9)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"open url = %@", url);
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
// [9, ~)
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"ios 9+ open url = %@", url);

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
@end
