//
//  PopAnimation.m
//  NormalProject
//
//  Created by lf on 2016/10/28.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "PopAnimation.h"
#import <UIKit/UIKit.h>

@implementation PopAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    NSLog(@"pop fromVC:%@    toVC:%@", fromVC, toVC);
    UIView *containerView = [transitionContext containerView];
    // 最终显示在屏幕上的controller的frame
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    // 获取动画前相应VC的frame
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
//    NSLog(@"pop finalFrame = %@, initialFrame = %@", NSStringFromCGRect(finalFrame), NSStringFromCGRect(initialFrame));
    CGRect beginFrame = CGRectOffset(initalFrame, -initalFrame.size.width, 0);
    fromVC.view.frame = finalFrame;
    // 加阴影就是卡
//    fromVC.view.layer.shadowOffset = CGSizeMake(-4, 2);
    fromVC.view.layer.shadowOpacity = 0.3;
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:fromVC.view.bounds];
//    fromVC.view.layer.shadowPath = shadowPath.CGPath;

//    toVC.view.frame = beginFrame;
//    NSLog(@"pop conteview count %d", containerView.subviews.count);
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    /**
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            fromVC.view.alpha = 0.5;
                            toVC.view.frame = initialFrame;
                        } completion:^(BOOL finished) {
                            fromVC.view.alpha = 1.0;
                            [transitionContext completeTransition:finished];
                        }];
    */
}
@end
