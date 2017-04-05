//
//  AppDelegate+ThirdLogin.h
//  NormalProject
//
//  Created by lf on 2016/12/9.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 提供一些 第三方登录 使用到的方法
 * 一些分析的代理方法，写到这里
 * 本demo 仅包含 微信 QQ 新浪微博 登录
 * 友盟分享 SDK v6.1.0
 * [最好先在相关开放平台注册好应用信息]
 **/
#import "AppDelegate.h"

@interface AppDelegate (ThirdLogin)

- (void)batApplication:(UIApplication *)application registThirdLoginWithOptions:(NSDictionary *)launchOptions;

@end
