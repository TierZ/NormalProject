//
//  AppDelegate+Public.h
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 提供一些公共方法
 */
#import "AppDelegate.h"

@interface AppDelegate (Public)
/** 针对于初次安装的 数据 处理 */
- (void)settingForFirstInstallation;

/** 设置rootVC */
- (void)setupRootViewController;
@end
