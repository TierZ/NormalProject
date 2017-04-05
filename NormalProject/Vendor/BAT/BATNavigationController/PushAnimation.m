//
//  PushAnimation.m
//  NormalProject
//
//  Created by lf on 2016/10/28.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "PushAnimation.h"
#import <UIKit/UIKit.h>

@implementation PushAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    NSLog(@"push fromVC:%@    toVC:%@", fromVC, toVC);
    UIView *containerView = [transitionContext containerView];
    /*
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:NSSelectorFromString(@"viewForKey:")]) {
        // 通过这种方法获取到view不一定是对应controller.view
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    } else {
        toView = toVC.view;
        fromView = fromVC.view;
    }
     */
    // 最终显示在屏幕上的controller的frame
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    // 获取动画前相应VC的frame
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
//    NSLog(@"push finalFrame = %@, initialFrame = %@", NSStringFromCGRect(finalFrame), NSStringFromCGRect(initialFrame));
    CGRect beginFrame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
//    fromVC.view.frame = finalFrame;
    toVC.view.frame = beginFrame;
//    NSLog(@"push conteview count %d", containerView.subviews.count);
    [containerView addSubview:toVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
//                         fromVC.view.frame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);
                         toVC.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
//                         fromVC.view.frame = initialFrame;
                         [transitionContext completeTransition:finished];
                     }];
    /** 弹簧效果
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.05
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            fromVC.view.alpha = 0.8;
                            toVC.view.frame = finalFrame;
                        } completion:^(BOOL finished) {
                            fromVC.view.alpha = 1.0;
                            [transitionContext completeTransition:finished];
                        }];
    */
}
@end
