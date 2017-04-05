//
//  UIScrollView+BAT.h
//  NormalProject
//
//  Created by lf on 2016/10/28.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 设置scrollView的contentInset, 给了几个枚举
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BATScrollViewInsetType) {
    BATScrollViewInsetTypeNone = -1,
    BATScrollViewInsetTypeStatusBar,
    BATScrollViewInsetTypeNavigationBar,
    BATScrollViewInsetTypeTabBar,
    BATScrollViewInsetTypeBothBars,
    BATScrollViewInsetTypeDefault = BATScrollViewInsetTypeNone,
};
@interface UIScrollView (Public)
/** 调整scrollview 的 insets 分不同模式 */
- (void)adjustScrollViewInsets:(BATScrollViewInsetType)type;
@end
