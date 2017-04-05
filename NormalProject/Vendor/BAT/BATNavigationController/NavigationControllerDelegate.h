//
//  NavigationControllerDelegate.h
//  NormalProject
//
//  Created by lf on 2016/11/2.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * UINavigationController的代理，
 */

#import <Foundation/Foundation.h>

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>
/** 初始化 */
- (instancetype)initWithNavigationController:(UINavigationController *)naviVC;

/** pop交互手势的action */
- (void)handlePopInteractiveTransition:(UIPanGestureRecognizer *)recognizer;
@end

