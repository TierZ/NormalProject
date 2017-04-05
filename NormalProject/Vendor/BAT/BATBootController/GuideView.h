//
//  GuideView.h
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * app新版首次安装使用引导图
 * 可以滑动的引导图
 */
#import <UIKit/UIKit.h>

// 点击"开始体验"的回调block
typedef void(^GuideViewFinishiedBlock)();

@interface GuideView : UIView
/** 点击进入app的回调 */
@property (nonatomic, copy)   GuideViewFinishiedBlock actionBlock;
@end
