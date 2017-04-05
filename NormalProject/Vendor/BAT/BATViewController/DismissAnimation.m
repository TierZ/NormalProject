//
//  DismissAnimation.m
//  NormalProject
//
//  Created by lf on 2016/11/1.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "DismissAnimation.h"

@implementation DismissAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    [containerView bringSubviewToFront:fromVC.view];
    
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    fromVC.view.frame = initalFrame;
    
    // 动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromVC.view.frame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
        fromVC.view.alpha = 0.4;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}
@end
