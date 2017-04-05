//
//  BATViewController.m
//  NormalProject
//
//  Created by lf on 2016/10/31.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATViewController.h"
#import "ViewControllerDelegate.h"

@interface BATViewController ()<UIViewControllerTransitioningDelegate> {
    UIView *_batWrapperView; // self.view 的superView
}
/** 本demo VC单独的navibar */
@property (nonatomic, strong) BATNavigationBar          *batNavigationBar;
/** 转场代理 */
@property (nonatomic, strong) ViewControllerDelegate    *transitionDelegate;

@end

@implementation BATViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        _statusBarHidden = NO;
        _statusBarStyle = UIStatusBarStyleDefault;
        _customModelTransitionAnimationEnable = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - public
/** 不用了
// 设置状态栏颜色风格
- (void)setupStatusBarStyle:(UIStatusBarStyle)style {
    if (NS_iOS_VERSION <= NS_iOS_VERSION_9_Max) {
        [[UIApplication sharedApplication] setStatusBarStyle:style];
    }
}
// 设置是否显示状态栏
- (void)setupStatusBarHidden:(BOOL)hidden {
    if (NS_iOS_VERSION <= NS_iOS_VERSION_9_Max) {
        [[UIApplication sharedApplication] setStatusBarHidden:hidden];
    }
}
 */
#pragma mark - 懒加载
- (ViewControllerDelegate *)transitionDelegate {
    if (!_transitionDelegate) {
        _transitionDelegate = [[ViewControllerDelegate alloc] init];
    }
    return _transitionDelegate;
}
#pragma mark - set get
// 设置自定义转常是否有效
- (void)setCustomModelTransitionAnimationEnable:(BOOL)enable {
    if (enable) {
        self.transitioningDelegate = self.transitionDelegate;
    } else {
        self.transitioningDelegate = nil;
    }
    _customModelTransitionAnimationEnable = enable;
}
// 动态设置statusBarStyle
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}
// 动态设置statusBarHidden
- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarStyle = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
#pragma mark - 重新父类的
-(BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}
#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"*** %@ dealloc ***", self);
}
#pragma mark - 内存溢出
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

@implementation UIViewController (BATNavigationController)
// 获取batNavigationController
- (BATNavigationController *)batNavigationContrller {
    if ([self.navigationController isKindOfClass:[BATNavigationController class]]) {
        return (BATNavigationController *)self.navigationController;
    }
    return nil;
}
// 获取batTabBarController
- (BATTabBarController *)batTabBarContrller {
    if ([self.tabBarController isKindOfClass:[BATTabBarController class]]) {
        return (BATTabBarController *)self.tabBarController;
    }
    return nil;
}
@end

@implementation BATViewController (BATNavigationBar)
// 返回batNavigationBar
- (BATNavigationBar *)batNavigationBar {
    return _batNavigationBar;
}
// 设置batNavigationBar主题
- (void)setupBatNavigationBarTheme:(BATNavigationBarTheme)theme {
    if (!_batNavigationBar) {
        return;
    }
    [self.batNavigationBar setBatNavigationBarTheme:theme];
}
// 使用自定义的naviBar
- (void)addBatNavigationBar {
    if ([self.view.subviews containsObject:_batNavigationBar]) {
        return;
    } else {
        if (!_batNavigationBar) {
            _batNavigationBar = [[BATNavigationBar alloc] init];
        }
        [self.view addSubview:_batNavigationBar];
        __weak __typeof__(self) weak_self = self;
        [_batNavigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(weak_self.view);
            make.height.mas_equalTo(_kBATNaviBarHeight);
        }];
        [_batNavigationBar setItems:@[self.navigationItem]];
    }
}
// 创建返回按钮，子类可调用
- (void)addNavigationBarBackItem:(BATNavigationBarBackType)type title:(NSString *)title actionBlock:(BATNavigationBarItemActionBlock)block {
    UIImage *image = nil;
    switch (type) {
        case BATNavigationBarBackTypeNone: {
            break;
        }
        case BATNavigationBarBackTypeReturn: {
            image = nil;
            break;
        }
        case BATNavigationBarBackTypeClose: {
            image = nil;
            break;
        }
        default:
            break;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = title;
    item.image = image;
    item.actionBlock = block;
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [items insertObject:item atIndex:0];
    self.navigationItem.leftBarButtonItems = items;
//    if (!self.navigationItem.backBarButtonItem) {
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//        item.title = title;
//        item.image = image;
//        item.actionBlock = block; // from YY
//        [self.navigationItem setBackBarButtonItem:item];
//    } else {
//        self.navigationItem.backBarButtonItem.title = title;
//        self.navigationItem.backBarButtonItem.image = image;
//        self.navigationItem.backBarButtonItem.actionBlock = block;
//    }
}
// 移除back item
- (void)removeNavigationBarBackItem {
    [self removeNavigationBarLeftItemAtIndex:0];
}
// 添加一个leftItem
- (void)addNavigationBarLeftItem:(NSString *)title image:(UIImage *)image actionBlock:(BATNavigationBarItemActionBlock)block {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = title;
    item.image = image;
    item.actionBlock = block;
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [items addObject:item];
    self.navigationItem.leftBarButtonItems = items;
}
// 移除一个leftItem
- (void)removeNavigationBarLeftItemAtIndex:(NSInteger)index {
    NSMutableArray *leftItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    if (index < 0 || index >= leftItems.count) {
        return;
    }
    [leftItems removeObjectAtIndex:index];
    self.navigationItem.leftBarButtonItems = leftItems;
}
// 添加一个rightItem
- (void)addNavigationBarRightItem:(NSString *)title image:(UIImage *)image actionBlock:(BATNavigationBarItemActionBlock)block {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = title;
    item.image = image;
    item.actionBlock = block;
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [items addObject:item];
    self.navigationItem.rightBarButtonItems = items;
}
// 移除一个leftItem
- (void)removeNavigationBarRightItemAtIndex:(NSInteger)index {
    NSMutableArray *rightItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    if (index < 0 || index >= rightItems.count) {
        return;
    }
    [rightItems removeObjectAtIndex:index];
    self.navigationItem.rightBarButtonItems = rightItems;
}

@end
