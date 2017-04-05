//
//  TabBarControllerDelegate.m
//  NormalProject
//
//  Created by lf on 2016/11/23.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "TabBarControllerDelegate.h"
#import "TransAnimation.h"
@implementation TabBarControllerDelegate
// 动画
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [TransAnimation new];
}
// 交互
- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return nil;
}
@end
