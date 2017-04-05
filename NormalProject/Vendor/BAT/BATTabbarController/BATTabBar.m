//
//  BATTabBar.m
//  NormalProject
//
//  Created by lf on 16/10/10.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATTabBar.h"

@interface BATTabBar ()
@property (nonatomic, weak)   UITabBarController *tabBarController;
@property (nonatomic, strong) UIImageView        *shadowView;   // 顶部的细线
@property (nonatomic, strong) UIView             *blearView;    // 一个模糊的背景
@property (nonatomic, weak)   BATTabBarButton    *selectedButton; // 当前选中的按钮
@property (nonatomic, strong) NSMutableArray <BATTabBarButton *> *buttons; // 所有按钮
@end

@implementation BATTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTabBarController:(UITabBarController *)tabBarVC {
    self = [self init];
    if (self) {
        _selectedIndex = NSIntegerMax;
        _tabBarController = tabBarVC;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)batCreateSubViews {
    [self addSubview:self.blearView];
    [self addSubview:self.shadowView];
    
    __weak __typeof__(self) weak_self = self;
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weak_self);
        make.height.mas_equalTo(_kBATTabBarShadowHeight);
    }];
    [self.blearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(weak_self);
        make.height.mas_equalTo(_kBATTabBarHeight);
    }];
    [self createButtons];
    [self layoutButtons];
}
// 设置btn
- (void)createButtons {
    NSArray *controllers = nil;
    if ([self.tabBarController respondsToSelector:@selector(viewControllers)]) {
        controllers = [NSArray arrayWithArray:[self.tabBarController performSelector:@selector(viewControllers)]];
    }
    NSInteger defaultIndex = 0;
    if ([self.tabBarController isKindOfClass:[UITabBarController class]]) {
        defaultIndex = self.tabBarController.selectedIndex;
    }
    for (int i = 0; i<controllers.count; i++) {
        UIViewController *vc = controllers[i];
        NSString *title  = vc.tabBarItem.title;
        if (!title) {
            title = vc.title;
        }
        UIImage  *image  = vc.tabBarItem.image;
        UIImage  *sImage = vc.tabBarItem.selectedImage;
        NSString *badge  = vc.tabBarItem.badgeValue;
        
        BATTabBarButton *item = [[BATTabBarButton alloc] initWithTitle:title selectedTitle:title image:image selectedImage:sImage];
        item.itemIndex = i;
        item.badgeType = BATTabBarBtnBadgeTypeNumber;
        [item addTarget:self action:@selector(tabBarButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];

        [item setBadgeValue:badge];
        [self.buttons addObject:item];
        
        if (i == defaultIndex) {
            [self tabBarButtonDidClick:item];
        }
    }
    controllers = nil;
}
// 设置btn的位置
- (void)layoutButtons {
    NSInteger btnC = self.buttons.count;
    CGFloat btnW = self.width/btnC;
    CGFloat btnH = self.height;
    __weak __typeof__(self) weak_self = self;
    for (int i = 0; i < btnC; i++) {
        BATTabBarButton *btn = self.buttons[i];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            make.top.equalTo(weak_self);
            make.centerX.mas_equalTo(weak_self).multipliedBy(1.0*(i*2+1)/btnC);
        }];
    }
}
// 按钮的点击事件
- (void)tabBarButtonDidClick:(BATTabBarButton *)sender {
    NSLog(@"click newItem index %zd", sender.itemIndex);
    // 设置tabBarController要显示的indexVC
    if (self.delegate && [self.delegate respondsToSelector:@selector(batTabBar:responseOfItem:)]) {
        BOOL iRet = [self.delegate batTabBar:self responseOfItem:sender];
        if (iRet) {
            // 代理每次点击都调用 不管是不是同一个
            if (self.delegate && [self.delegate respondsToSelector:@selector(batTabBar:didSelectItem:)]) {
                [self.delegate performSelector:@selector(batTabBar:didSelectItem:) withObject:self withObject:sender];
            }
            //  self.selectedIndex = sender.itemIndex; // tabBarController的setSelected方法重新了，所有这里不用再次调用了，否则得加上
            [self.tabBarController setSelectedIndex:sender.itemIndex];
        }
    }
}
#pragma mark - set get
// 设置选中btn 给外部使用
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    NSLog(@"set selectedIndex %zd", selectedIndex);
    if (selectedIndex>=0 && selectedIndex<self.buttons.count) {
        self.selectedButton.selected = NO;
        BATTabBarButton *nextItem = self.buttons[selectedIndex];
        nextItem.selected = YES;
        self.selectedButton = nextItem;
    }
    _selectedIndex = selectedIndex;
}

// 设置badge
- (void)setupButtonBadgeValue:(NSString *)badge index:(NSInteger)index {
    NSArray *controllers = nil;
    if ([self.tabBarController respondsToSelector:@selector(viewControllers)]) {
        controllers = [NSArray arrayWithArray:[self.tabBarController performSelector:@selector(viewControllers)]];
    }

    if (index>=0 && index<controllers.count) {
        UIViewController *vc = controllers[index];
        vc.tabBarItem.badgeValue = badge;
    }
    if (index>=0 && index<self.buttons.count) {
        BATTabBarButton *btn = [self.buttons objectAtIndex:index];
        [btn setBadgeValue:badge];
    }
    controllers = nil;
}
// 设置shadow颜色
- (void)setShadowColor:(UIColor *)color {
    self.shadowView.backgroundColor = color;
}
// 设置shadow背景图
- (void)setShadowImage:(UIImage *)image {
    self.shadowView.image = image;
}
// 隐藏shadow视图
- (void)setShadowViewHidden:(BOOL)hidden {
    self.shadowView.hidden = hidden;
}
// 设置不模糊背景图片
- (void)setBackgroundImage:(UIImage *)image {
    [self setImage:image];
}
// 重写的设置背景图片
- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self setOpaque:(image == nil)];
}
// 设置不模糊的颜色
- (void)setRealBackgroundColor:(UIColor *)color {
    if (!color || [color isEqual:[UIColor clearColor]]) {
        return;
    }
    [self setOpaque:NO];
    [self setBackgroundColor:color];
}
// 设置不透明
- (void)setOpaque:(BOOL)opeque {
    [super setOpaque:opeque];
    self.blearView.hidden = !opeque;
}
#pragma mark - 懒加载
- (UIImageView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIImageView alloc] init];
        _shadowView.backgroundColor = [UIColor lightGrayColor];
    }
    return _shadowView;
}
- (UIView *)blearView {
    if (!_blearView) {
        if ([UIVisualEffectView class]) {// >=iOS8
            _blearView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        } else {
            _blearView = [[UIView alloc] init];
            _blearView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        }
    }
    return _blearView;
}
- (NSMutableArray<BATTabBarButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttons;
}
@end
