//
//  AppDelegate+ThirdShare.h
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 提供一些 "分享" 使用到的方法
 * 一些分析的代理方法，写到这里
 * 本demo SDK 仅包含 新浪微博 微信/朋友圈 QQ/QQ空间/腾讯微博
 * 友盟分享 SDK v6.1.0
 * [最好先在相关开放平台注册好应用信息]
 **/
#import "AppDelegate.h"

@interface AppDelegate (ThirdShare)
- (void)batApplication:(UIApplication *)application registThirdShareWithOptions:(NSDictionary *)launchOptions;

@end
