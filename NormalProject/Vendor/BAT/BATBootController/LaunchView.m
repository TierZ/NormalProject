//
//  LaunchView.m
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "LaunchView.h"
@interface LaunchView()
@property (nonatomic, strong) UIImageView             *staticView;    // logo或者其他
@property (nonatomic, strong) UIImageView             *copyRightView; // copyright
@property (nonatomic, strong) UIActivityIndicatorView *activityView;  // 小菊花
@end

@implementation LaunchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self batCreateSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self batCreateSubViews];
    }
    return self;
}
- (void)batCreateSubViews {
    __weak __typeof__(self) weak_self = self;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.staticView];
    [self.staticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weak_self);
        make.bottom.equalTo(weak_self).with.offset(-80);
    }];
    [self addSubview:self.copyRightView];
    [self.copyRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(weak_self);
        make.height.mas_equalTo(80);
    }];
    [self addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weak_self);
    }];
}
- (void)startAnimating {
    [self.activityView startAnimating];
}
- (void)stopAnimating {
    [self.activityView stopAnimating];
}
- (UIImageView *)staticView {
    if (!_staticView) {
        _staticView = [[UIImageView alloc] init];
        _staticView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xxxx"]];
        _staticView.image = image;
    }
    return _staticView;
}
- (UIImageView *)copyRightView {
    if (!_copyRightView) {
        _copyRightView = [[UIImageView alloc] init];
        _copyRightView.contentMode = UIViewContentModeScaleAspectFit;
//        UIImage *image = [UIImage imageNamed:@"copyRight"];
        UIImage *image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"copyRight.png"]];
        _copyRightView.image = image;
    }
    return _copyRightView;
}
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.color = [UIColor orangeColor]; // 菊花颜色
    }
    return _activityView;
}
@end
