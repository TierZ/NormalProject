//
//  BATTabBar.h
//  NormalProject
//
//  Created by lf on 16/10/10.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTabBarButton.h"

#define _kBATTabBarHeight         49.0
#define _kBATTabBarShadowHeight   0.5

NS_ASSUME_NONNULL_BEGIN

@protocol BATTabBarDelegate;

@interface BATTabBar : UIImageView

@property (nonatomic, weak) id<BATTabBarDelegate> delegate;
@property (nonatomic, assign) NSInteger           selectedIndex;

/** 初始化方法 */
- (instancetype)initWithTabBarController:(UITabBarController *)tabBarVC;

/** 创建子视图 偏于private */
//  tabBarController里这样用:
//  - (void)viewDidLayoutSubviews {
//      [super viewDidLayoutSubviews];
//  // 此时才有viewControllers，所以这里才初始化调用，会多次调用，屏幕旋转等等，会被调用多次
//      __weak __typeof__(self) weak_self = self;
//      static dispatch_once_t onceToken;
//          dispatch_once(&onceToken, ^{
//          [weak_self.batTabBar batCreateSubViews];
//      });
//  }
- (void)batCreateSubViews;

/** 设置按钮上面显示的badge */
- (void)setupButtonBadgeValue:(NSString *)badge index:(NSInteger)index;

- (void)setShadowColor:(UIColor *)color;

- (void)setShadowImage:(UIImage *)image;

- (void)setShadowViewHidden:(BOOL)hidden;

- (void)setBackgroundImage:(UIImage *)image;

- (void)setRealBackgroundColor:(UIColor *)color;

@end

@protocol BATTabBarDelegate <NSObject>
@required
// item将要改变时, 新item是否改变选中状态
- (BOOL)batTabBar:(BATTabBar *)tabBar responseOfItem:(BATTabBarButton *)item;

@optional
// 点击了某个item, 并选中了它
- (void)batTabBar:(BATTabBar *)tabBar didSelectItem:(BATTabBarButton *)item;
@end

NS_ASSUME_NONNULL_END
