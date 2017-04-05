//
//  ViewControllerDelegate.m
//  NormalProject
//
//  Created by lf on 2016/11/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "ViewControllerDelegate.h"
#import "PresentAnimation.h"   
#import "DismissAnimation.h"
@implementation ViewControllerDelegate
// present动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentAnimation alloc] init];
}
// dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissAnimation alloc] init];
}
// present 交互
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}
// dismiss 交互
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}
@end
