//
//  PresentAnimation.m
//  NormalProject
//
//  Created by lf on 2016/11/1.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "PresentAnimation.h"

@implementation PresentAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];

    toVC.view.frame = CGRectOffset(initalFrame, 0, -initalFrame.size.height);
    toVC.view.alpha = 0.6;
    // 动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toVC.view.frame = finalFrame;
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}
@end
