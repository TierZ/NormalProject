//
//  UIScrollView+BAT.m
//  NormalProject
//
//  Created by lf on 2016/10/28.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "UIScrollView+BAT.h"
#define _kBATStatusBarHeight       kStatusBarHeight
#define _kBATNaviBarHeight         kNavigationBarHeight
#define _kBATTabBarHeight          kTabBarHeight

@implementation UIScrollView (Public)
- (void)adjustScrollViewInsets:(BATScrollViewInsetType)type {
    CGFloat top = 0.0;
    CGFloat bottom = 0.0;
    switch (type) {
        case BATScrollViewInsetTypeNone: {
            break;
        }
        case BATScrollViewInsetTypeStatusBar: {
            top = _kBATStatusBarHeight;
            break;
        }
        case BATScrollViewInsetTypeNavigationBar: {
            top = _kBATNaviBarHeight;
            break;
        }
        case BATScrollViewInsetTypeTabBar: {
            bottom = _kBATTabBarHeight;
            break;
        }
        case BATScrollViewInsetTypeBothBars: {
            top = _kBATNaviBarHeight;
            bottom = _kBATTabBarHeight;
            break;
        }
        default:
            break;
    }
    [self setContentInset:UIEdgeInsetsMake(top, 0, bottom, 0)];
    [self setContentOffset:CGPointMake(0, -top) animated:NO];
}
@end
