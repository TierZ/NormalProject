//
//  UIView+Public.m
//  demo10_ category
//
//  Created by xxx on 16/8/5.
//  Copyright © 2016年 XXX. All rights reserved.
//

#import "UIView+Public.h"

@implementation UIView (Public)

- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left {
    self.frame = CGRectMake(left, self.top, self.width, self.height);
}
- (CGFloat)right {
    return self.left + self.width;
}
- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.top, self.width, self.height);
}
- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top {
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}
- (CGFloat)bottom {
    return self.top + self.height;
}
- (void)setBottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.left, bottom - self.height, self.width, self.height);
}
- (CGPoint)leftTop {
    return CGPointMake(self.left, self.top);
}
- (void)setLeftTop:(CGPoint)leftTop {
    self.left = leftTop.x;
    self.top = leftTop.y;
}
- (CGPoint)leftBottom {
    return CGPointMake(self.left, self.bottom);
}
- (void)setLeftBottom:(CGPoint)leftBottom {
    self.left = leftBottom.x;
    self.bottom = leftBottom.y;
}
- (CGPoint)rightTop {
    return CGPointMake(self.right, self.top);
}
- (void)setRightTop:(CGPoint)rightTop {
    self.right = rightTop.x;
    self.top = rightTop.y;
}
- (CGPoint)rightBottom {
    return CGPointMake(self.right, self.bottom);
}
- (void)setRightBottom:(CGPoint)rightBottom {
    self.right = rightBottom.x;
    self.bottom = rightBottom.y;
}
- (CGPoint)boundsCenter {
    return CGPointMake(self.width / 2, self.height / 2);
}
- (CGPoint)topCenter {
    return CGPointMake(self.centerX, self.top);
}
- (void)setTopCenter:(CGPoint)topCenter {
    self.left = topCenter.x - self.width / 2;
    self.top = topCenter.y;
}
- (CGPoint)bottomCenter {
    return CGPointMake(self.centerX, self.bottom);
}
- (void)setBottomCenter:(CGPoint)bottomCenter {
    self.left = bottomCenter.x - self.width / 2;
    self.bottom = bottomCenter.y;
}
- (CGPoint)leftCenter {
    return CGPointMake(self.left, self.centerY);
}
- (void)setLeftCenter:(CGPoint)leftCenter {
    self.left = leftCenter.x;
    self.top = leftCenter.y - self.height / 2;
}
- (CGPoint)rightCenter {
    return CGPointMake(self.right, self.centerY);
}
- (void)setRightCenter:(CGPoint)rightCenter {
    self.right = rightCenter.x;
    self.top = rightCenter.y - self.height / 2;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    self.left = centerX - self.width / 2;
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    self.top = centerY - self.height / 2;
}
- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}
- (CGFloat)originX {
    return self.frame.origin.x;
}
- (void)setOriginX:(CGFloat)originX {
    self.frame = CGRectMake(originX, self.top, self.width, self.height);
}
- (CGFloat)originY {
    return self.frame.origin.y;
}
- (void)setOriginY:(CGFloat)originY {
    self.frame = CGRectMake(self.left, originY, self.width, self.height);
}
#pragma mark - other
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (UIViewController *)topViewController {
    UIViewController *vc = self.viewController;
    UIViewController *parentVC = vc.parentViewController;
    while (parentVC) {
        vc = parentVC;
        parentVC = parentVC.parentViewController;
    }
    return vc;
}
- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}
- (void)loadUpdateConstraintAnimation {
    // 约束变更时，加载动画用
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    __weak __typeof__(self) weak_self = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weak_self layoutIfNeeded];
    }];
}

- (void)dumpWithIndent:(NSString *)indent {
    NSString *class = NSStringFromClass([self class]);
    /*
     NSString *info = @"";
     if ([self respondsToSelector:@selector(title)]) {
     NSString *title = [self performSelector:@selector(title)];
     if (title != nil && [title length] > 0) {
     info = [info stringByAppendingFormat:@" title=%@", title];
     }
     }
     if ([self respondsToSelector:@selector(stringValue)]) {
     NSString *string = [self performSelector:@selector(stringValue)];
     if (string != nil && [string length] > 0) {
     info = [info stringByAppendingFormat:@" stringValue=%@", string];
     }
     }
     NSString *tooltip = [self toolTip];
     if (tooltip != nil && [tooltip length] > 0) {
     info = [info stringByAppendingFormat:@" tooltip=%@", tooltip];
     }
     
     NSLog(@"%@%@%@", indent, class, info);
     */
    printf("%s < %s : %p; frame = %s >\n", [indent UTF8String], [class UTF8String], self, [NSStringFromCGRect(self.frame) UTF8String]);
    if ([[self subviews] count] > 0) {
        NSString *subIndent = [NSString stringWithFormat:@"%@%@", indent, ([indent length]/2)%2==0 ? @" | " : @".. "];
        for (UIView *subview in [self subviews]) {
            [subview dumpWithIndent:subIndent];
        }
    }
}
@end
