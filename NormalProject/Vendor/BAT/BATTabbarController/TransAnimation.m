//
//  TransAnimation.m
//  NormalProject
//
//  Created by lf on 2016/11/23.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "TransAnimation.h"
@interface TransAnimation()<CAAnimationDelegate>

@end
@implementation TransAnimation
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
    
    [containerView addSubview:toVC.view];
    //画两个圆路径
    CGRect centerRect = CGRectMake(fromVC.view.width/2-20, fromVC.view.height/2-20, 40, 40);
    
    UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:centerRect];
    //通过如下方法计算获取在x和y方向按钮距离边缘的最大值，然后利用勾股定理即可算出最大半径
    CGFloat x = MAX(centerRect.origin.x, containerView.frame.size.width - centerRect.origin.x);
    CGFloat y = MAX(centerRect.origin.y, containerView.frame.size.height - centerRect.origin.y);
    //勾股定理计算半径
    CGFloat radius = sqrtf(pow(x, 2)+pow(y, 2));
    //以按钮中心为圆心，按钮中心到屏幕边缘的最大距离为半径，得到转场后的path
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //设置layer的path保证动画后layer不会回弹
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    //设置淡入淡出
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.layer.mask = nil;
    [transitionContext completeTransition:YES];
    
}
@end
