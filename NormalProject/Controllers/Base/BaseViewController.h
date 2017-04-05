//
//  BaseViewController.h
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 *  base的baseVC，基类, 基于bat
 *  Base类 只提供基本方法 最最基本绘图
 */
#import "BATViewController.h"
@interface BaseViewController : BATViewController

/** 是否需要登录状态,默认NO. 是-若未登录则跳转到登录*/
@property (nonatomic, assign) BOOL needLogined;

@end
