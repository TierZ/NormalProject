//
//  BATNavigationBar.m
//  NormalProject
//
//  Created by lf on 2016/10/27.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATNavigationBar.h"

@interface BATNavigationBar () {
    UIView *_batBackgroundView; // navigationBar首层视图
    UIView *_batBackdropView;   // _batBackgroundView的子视图(模糊层blear就在它上面)
    UIView *_batShadowView;     // _batBackgroundView的子视图
}
@end

@implementation BATNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setBatNavigationBarTheme:(BATNavigationBarTheme)batNavigationBarTheme {
    switch (batNavigationBarTheme) {
        case BATNavigationBarThemeOriginal: {
            [self setupBatNavigationBarThemeDefault];
            break;
        }
        case BATNavigationBarThemeRed: {
            [self setupBatNavigationBarThemeRed:NO];
            break;
        }
        case BATNavigationBarThemeRedTranslucent: {
            [self setupBatNavigationBarThemeRed:YES];
            break;
        }
        case BATNavigationBarThemeWhite: {
            [self setupBatNavigationBarThemeWhite:NO];
            break;
        }
        case BATNavigationBarThemeWhiteTranslucent: {
            [self setupBatNavigationBarThemeWhite:YES];
            break;
        }
        case BATNavigationBarThemeClear: {
            [self setupBatNavigationBarThemeClear];
            break;
        }
        default: {
            break;
        }
    }
    _batNavigationBarTheme = batNavigationBarTheme;
}
- (void)setupBatNavigationBarThemeDefault {
    // 按钮item
    [self setTintColor:nil];
    // 标题item
    [self setTitleTextAttributes:nil];
    // 背景
    [self setBarTintColor:nil];
    // 透明(模糊层)
    self.translucent = YES;
    // 显示出背景
    self.batBackgroundView.alpha = 1;
    // shadow
    [self setupShadowHidden:NO];
}
- (void)setupBatNavigationBarThemeRed:(BOOL)translucent {
    [self setTintColor:[UIColor whiteColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setBarTintColor:[UIColor redColor]];
    self.translucent = translucent;
    self.batBackgroundView.alpha = 1;
    [self setupShadowHidden:NO];
}
- (void)setupBatNavigationBarThemeWhite:(BOOL)translucent {
    [self setTintColor:[UIColor blackColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self setBarTintColor:[UIColor whiteColor]];
    self.translucent = translucent;
    self.batBackgroundView.alpha = 1;
    [self setupShadowHidden:NO];
}
- (void)setupBatNavigationBarThemeClear {
    self.batBackgroundView.alpha = 0;
}
// navibar 下边的线
- (void)setupShadowHidden:(BOOL)hidden {
    self.clipsToBounds = hidden;
}
// 获取navigationbar首层视图 clearColor就是黑了
- (UIView *)batBackgroundView {
    if (!_batBackgroundView) {
        _batBackgroundView = (UIView *)self.subviews.firstObject;
    }
    return _batBackgroundView; // 还有2个子view一个是backDropView 一个是shadowView
}
// 模糊层的父视图
- (UIView *)batBackdropView {
    if (!_batBackdropView) {
        for (UIView *subView in self.batBackgroundView.subviews) {
            Class dropClass = NSClassFromString(@"_UIBackdropView");
            if ([subView isKindOfClass:dropClass]) {
                _batBackdropView = subView;
                break;
            }
        }
    }
    return _batBackdropView;
}
// shadow视图
- (UIView *)batShadowView {
    if (!_batShadowView) {
        for (UIView *subView in self.batBackgroundView.subviews) {
            if ([subView isKindOfClass:[UIImage class]]) {
                _batShadowView = subView;
                break;
            }
        }
    }
    return _batShadowView;
}
@end
