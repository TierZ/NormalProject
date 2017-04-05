//
//  BATTabBarController.m
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATTabBarController.h"

#import "TabBarControllerDelegate.h"
#import "NotificationModel.h"
#import "AdvertisementModel.h"

#import "BaseWebController.h"
#import "FPSUtil.h"                   // fps

@interface BATTabBarController ()<BATTabBarDelegate>
/** 底部tabBar */
@property (nonatomic, strong) BATTabBar *batTabBar;
/** 自定义转场动画是否可用 */
@property (nonatomic, assign) BOOL       customTransitionAnimationEnable;
/** tabBarController代理对象 */
@property (nonatomic, strong) TabBarControllerDelegate *tabBarControllerDelegate;

@end

@implementation BATTabBarController
- (instancetype)init
{
    self = [super init]; // 这里面会先调用viewDidLoad 然后再返回实例化对象
    if (self) {

    }
    return self;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 此时才有viewControllers，所以这里才初始化调用，会多次调用，屏幕旋转等等，会被调用多次
    __weak __typeof__(self) weak_self = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [weak_self.batTabBar batCreateSubViews];
    });
    /** fps永在最上层 */
    [FPSUtil showFPS];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 先调用的viewDidLoad 然后调用init
    // 本demo中，tabBarController作为navigationController的rootVC，所以设置NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createCustomTabBar];
    
    UIApplication *application = [UIApplication sharedApplication];
    // 设置 appDelegate 的通知 代理
    if ([application.delegate respondsToSelector:@selector(setNotificationDelegate:)]) {
        [application.delegate performSelector:@selector(setNotificationDelegate:) withObject:self];
    }
    // 获取appdelegate里待处理的通知消息pendingNotification
    if ([application.delegate respondsToSelector:@selector(pendingNotification)]) {
        self.pendingNotification = (NotificationModel *)[application.delegate performSelector:@selector(pendingNotification)];
    }
    // 延时执行通知和广告消息
    __weak __typeof__(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weak_self.pendingAdvertisement) {
            [weak_self pushWithNotification:weak_self.pendingNotification];
        }
        if (weak_self.pendingAdvertisement) {
            [weak_self pushWithAdvertisement];
        }
    });
}
#pragma mark - UI
// 创建自定义的tabBar
- (void)createCustomTabBar {
    /** 将原生的tabBar remove掉 */
    [self.tabBar removeFromSuperview];
    /** 加入自定义的 tabBar */
    [self.view addSubview:self.batTabBar];
    /** 设置约束 */
    __weak __typeof__(self) weak_self = self;
    [self.batTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(weak_self.view);
        make.height.mas_equalTo(_kBATTabBarHeight);
    }];
    /** 不是继承的tabBar 会崩
     [self setValue:self.batTabBar forKey:@"tabBar"];
     */
}
#pragma mark - private
// 推送跳转 只有当launchView/bootView/advertView都显示过去之后再设置代理, 以便到了响应位置才进行跳转
- (void)pushWithNotification:(NotificationModel *)notiModel {
    NSLog(@"push ... notification ...");
    BaseViewController *vc = [[BaseViewController alloc] init];
    vc.title = @"push通知";
    [self.navigationController pushViewController:vc animated:NO];
}
// 广告的跳转
- (void)pushWithAdvertisement {
    NSLog(@"push ... advertisement ...");
    BaseWebController *vc = [[BaseWebController alloc] init];
    vc.title = @"push广告";
    [self.navigationController pushViewController:vc animated:NO];

}
#pragma mark - set get
// 自定义转场是否可用
- (void)setCustomTransitionAnimationEnable:(BOOL)enable {
    if (enable) {
        self.delegate = self.tabBarControllerDelegate;
    } else {
        self.delegate = nil;
    }
    _customTransitionAnimationEnable = enable;
}
#pragma mark - 重写父类
// 重写父类
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSLog(@"set selectedIndex %zd", selectedIndex);
    [super setSelectedIndex:selectedIndex];
    [self.batTabBar setSelectedIndex:selectedIndex];
}
// 设置badge
- (void)setupItemBadgeValue:(NSString *)badge index:(NSInteger)index {
    [self.batTabBar setupButtonBadgeValue:badge index:index];
}
#pragma mark - 懒加载
- (BATTabBar *)batTabBar {
    if (!_batTabBar) {
        _batTabBar = [[BATTabBar alloc] initWithTabBarController:self];
        _batTabBar.delegate = self;
    }
    return _batTabBar;
}
- (TabBarControllerDelegate *)tabBarControllerDelegate {
    if (!_tabBarControllerDelegate) {
        _tabBarControllerDelegate = [[TabBarControllerDelegate alloc] init];
    }
    return _tabBarControllerDelegate;
}

#pragma BATTabBarDelegate
- (BOOL)batTabBar:(BATTabBar *)tabBar responseOfItem:(nonnull BATTabBarButton *)item {
    if (item.itemIndex == 2) {
        return NO;
    }
    return YES;
}
- (void)batTabBar:(BATTabBar *)tabBar didSelectItem:(nonnull BATTabBarButton *)item {
    NSLog(@"tabBar delegate : didSelectItem %zd -> %zd", tabBar.selectedIndex, item.itemIndex);
}
#pragma pushNoti delegate
- (void)batApplicationDidReceiveNotification:(NotificationModel *)notiModel {
    NSLog(@"收到了推送信息: %@", notiModel.userInfo.content);
    [self pushWithNotification:notiModel];
}
#pragma mark - 内存警告
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
