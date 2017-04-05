//
//  NavigationControllerDelegate.m
//  NormalProject
//
//  Created by lf on 2016/11/2.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "PushAnimation.h"
#import "PopAnimation.h"

@interface NavigationControllerDelegate()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, weak)   UINavigationController *navigationController;
@end

@implementation NavigationControllerDelegate
- (instancetype)initWithNavigationController:(UINavigationController *)naviVC
{
    self = [super init];
    if (self) {
//        _maxWidth = CGFLOAT_MAX;
        _navigationController = naviVC;
        naviVC.delegate = self;
    }
    return self;
}
#pragma mark - navigationDelegate
// 返回自定的push、pop动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [PushAnimation new];
    } else if (operation == UINavigationControllerOperationPop) {
        return [PopAnimation new];
    } else {
        
    }
    return nil;
}
// 返回用户交互
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ([animationController isKindOfClass:[PopAnimation class]] || ![animationController isKindOfClass:[PushAnimation class]]) {
        return self.interactiveTransition;
    }
    return nil;
}
#pragma mark - pop手势
// pop交互手势的action
- (void)handlePopInteractiveTransition:(UIPanGestureRecognizer *)recognizer {
//    CGPoint velocity = [recognizer velocityInView:recognizer.view]; // 相对变化
    CGPoint location = [recognizer locationInView:recognizer.view]; // 绝对位置
    CGFloat progress = [recognizer translationInView:recognizer.view].x / (recognizer.view.bounds.size.width);
    progress = MIN(1.0, MAX(0, progress));
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [_interactiveTransition updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            
        }
        case UIGestureRecognizerStateEnded: {
            if (progress > 0.35) {
                [_interactiveTransition finishInteractiveTransition];
            } else {
                [_interactiveTransition cancelInteractiveTransition];
            }
            _interactiveTransition = nil;
            break;
        }
        default:
            break;
    }
    
}
@end
