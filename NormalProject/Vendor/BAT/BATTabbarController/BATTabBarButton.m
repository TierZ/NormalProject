//
//  BATTabBarButton.m
//  NormalProject
//
//  Created by lf on 16/10/10.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATTabBarButton.h"

#define _kBATTabBarBtnImgWidth    34.0
#define _kBATTabBarBtnImgHeight   34.0
#define _kBATTabBarBtnFontSize    11.0

@interface BATTabBarButton()
@property (nonatomic, strong) UIImageView *pointView;
@property (nonatomic, strong) UIButton    *badgeView;
@end
@implementation BATTabBarButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithTitle:(NSString *)title
      selectedTitle:(NSString *)sTitle
              image:(UIImage  *)image
      selectedImage:(UIImage  *)sImage
{
    self = [super init];
    if (self) {
        // 初始默认的一些东西
        [self setImage:image  forState:UIControlStateNormal];
        [self setImage:sImage forState:UIControlStateSelected];
        
        [self setTitle:title  forState:UIControlStateNormal];
        [self setTitle:sTitle forState:UIControlStateSelected];
        
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

        self.titleLabel.font = [UIFont boldSystemFontOfSize:_kBATTabBarBtnFontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

        [self batCreateSubViews];
    }
    return self;
}
- (void)batCreateSubViews {
    self.pointView.frame = CGRectMake(0, 4, 8, 8);
    [self addSubview:self.pointView];
    
    self.badgeView.frame = CGRectMake(0, 2, 18, 18);
    [self addSubview:self.badgeView];
}
- (UIImageView *)pointView {
    if (!_pointView) {
        _pointView = [[UIImageView alloc] init];
        _pointView.layer.cornerRadius = 4;
        _pointView.backgroundColor = [UIColor redColor];
        _pointView.hidden = YES;
    }
    return _pointView;
}
- (UIButton *)badgeView {
    if (!_badgeView) {
        _badgeView = [UIButton buttonWithType:UIButtonTypeCustom];
        _badgeView.backgroundColor = [UIColor redColor];
        _badgeView.titleLabel.font = [UIFont systemFontOfSize:11];
        _badgeView.layer.cornerRadius = 9;
//        _badgeView.layer.masksToBounds = YES;
        [_badgeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _badgeView.hidden = YES;
    }
    return _badgeView;
}
// 目的：想在系统计算和设置完按钮的尺寸后，再修改一下尺寸
/**
 *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
 */
- (void)setFrame:(CGRect)frame {
    //    frame.size.width += LFMargin;
    [super setFrame:frame];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    // 1.设置imageView的frame
    self.imageView.hidden = NO;
    self.imageView.opaque = YES;
    CGFloat imageX = (self.frame.size.width - _kBATTabBarBtnImgWidth)/2.0;
    CGRect imageFrame = CGRectMake(imageX, 1, _kBATTabBarBtnImgWidth, _kBATTabBarBtnImgHeight);
    self.imageView.frame = imageFrame;
    // 2.设置titleLabel的frame
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = 2;
    titleFrame.origin.y = 1+_kBATTabBarBtnImgHeight;
    titleFrame.size.width = self.width - 2*2; // 两侧留2
    self.titleLabel.frame = titleFrame;
    // 3.设置badge的frame
    self.pointView.right  = self.imageView.right;
    self.badgeView.left = self.imageView.right-5;
}
- (void)updateBadgeViewWidth:(CGFloat)width {
    self.badgeView.width = width;
    self.badgeView.centerX = self.imageView.right;
}
#pragma mark - set get
- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    if (!badgeValue) {
        self.badgeView.hidden = YES;
        self.pointView.hidden = YES;
        return;
    } else {
        [self setBadgeType:self.badgeType]; // ?为了防止先设置nil 再设置值时都hidden状态
    }
    [self.badgeView setTitle:badgeValue forState:UIControlStateNormal];
    CGFloat updW = 0.0;
    if (badgeValue.length <= 1) {
        updW = 12.0;
    } else if (badgeValue.length == 2) {
        updW = 20.0;
    } else {
        updW = 26.0;
    }
    [self updateBadgeViewWidth:updW];
}
- (void)setBadgeType:(BATTabBarBtnBadgeType)badgeType {
    switch (badgeType) {
        case BATTabBarBtnBadgeTypeNone: {
            self.badgeView.hidden = YES;
            self.pointView.hidden = YES;
            break;
        }
        case BATTabBarBtnBadgeTypeNumber: {
            self.badgeView.hidden = NO;
            self.pointView.hidden = YES;
            break;
        }
        case BATTabBarBtnBadgeTypePoint: {
            self.badgeView.hidden = YES;
            self.pointView.hidden = NO;
            break;
        }
        default: {
            break;
        }
    }
    _badgeType = badgeType;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    // 只要修改了文字，就让按钮重新计算自己的尺寸
//    [self sizeToFit];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    // 只要修改了图片，就让按钮重新计算自己的尺寸
//    [self sizeToFit];
}
- (void)setHighlighted:(BOOL)highlighted {
    // 重写，啥也不写就没有高亮状态了
}
/*
- (void)setSelected:(BOOL)selected {
    // 自定义选中时的状态
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = m_selectedColor;
        [self setTitleColor:m_titleSelectedFontColor forState:UIControlStateNormal];
    } else {
        self.backgroundColor = m_normalColor;
        [self setTitleColor:m_titleNormalColor forState:UIControlStateNormal];
    }
}
 */
@end
