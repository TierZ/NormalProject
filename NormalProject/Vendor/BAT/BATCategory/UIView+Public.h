//
//  UIView+Public.h
//  demo10_ category
//
//  Created by xxx on 16/8/5.
//  Copyright © 2016年 XXX. All rights reserved.
//

/**
 * view的一些小功能, 来源有很多, 有摘自YY的
 */
#import <UIKit/UIKit.h>

@interface UIView (Public)

@property (nonatomic, assign) CGFloat left;            // originX
@property (nonatomic, assign) CGFloat right;           // originX + width
@property (nonatomic, assign) CGFloat top;             // originY
@property (nonatomic, assign) CGFloat bottom;          // originY + height

@property (nonatomic, assign) CGPoint leftTop;         // 左上角坐标origin
@property (nonatomic, assign) CGPoint leftBottom;      // 左下角
@property (nonatomic, assign) CGPoint rightTop;        // 右上角
@property (nonatomic, assign) CGPoint rightBottom;     // 右下角

@property (nonatomic, readonly) CGPoint boundsCenter;  // bounds的中心坐标
@property (nonatomic, assign) CGPoint topCenter;       // 顶部中心
@property (nonatomic, assign) CGPoint bottomCenter;    // 底部中心
@property (nonatomic, assign) CGPoint leftCenter;      // 左侧中心
@property (nonatomic, assign) CGPoint rightCenter;     // 右侧中心
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize  size;            // frame.size
@property (nonatomic, assign) CGFloat width;           // frame.size.width
@property (nonatomic, assign) CGFloat height;          // frame.size.height
@property (nonatomic, assign) CGPoint origin;          // frame.origin
@property (nonatomic, assign) CGFloat originX;         // frame.origin.x
@property (nonatomic, assign) CGFloat originY;         // frame.origin.y

/** view所在当前VC */
@property (nullable, nonatomic, readonly) UIViewController *viewController;
/** view所在的顶层VC */
@property (nullable, nonatomic, readonly) UIViewController *topViewController;
/** 分层显示view的构成 indent-缩进*/
- (void)dumpWithIndent:(nullable NSString *)indent;
/** 加载更新约束过程动画 */
- (void)loadUpdateConstraintAnimation;
/** 移除所有子view */
- (void)removeAllSubviews;
@end
