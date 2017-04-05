//
//  AppDelegate+ThirdPay.h
//  NormalProject
//
//  Created by lf on 2016/12/19.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 提供一些 第三方支付 使用到的方法
 * 一些分析的代理方法，写到这里
 * 本demo 仅包含 微信支付 支付宝支付
 **/
#import "AppDelegate.h"

@interface AppDelegate (ThirdPay)

- (void)batApplication:(UIApplication *)application registThirdPayWithOptions:(NSDictionary *)launchOptions;

@end
