//
//  BATBootupController.m
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATBootupController.h"
/** launchView -> guideView -> advertView -> rootVC */
#import "AdvertView.h"
#import "GuideView.h"
#import "LaunchView.h"

/** 主rootVC */
#import "BATNavigationController.h"
#import "BATTabBarController.h"

#import "PrivacyController.h"
#import "ThirdShareController.h"
#import "ThirdLoginController.h"
#import "ThirdPayController.h"


@interface BATBootupController()
@property (nonatomic, strong) AdvertView *advertView;
@property (nonatomic, strong) GuideView  *guideView;
@property (nonatomic, strong) LaunchView *launchView;
@end
@implementation BATBootupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 1 先显示静态 lodingView ...
    [self showLaunchView];
    
    // 2 请求需要的数据
    __weak __typeof__(self) weak_self = self;
    [self requestLaunchData:^(BOOL successful) {
        // 3 请求完成后, remove掉loadView
        [weak_self hideLaunchView];
        // 4 Launch后
        [weak_self launchFinished];
    }];
}
// ❗️请求launch必要的数据
- (void)requestLaunchData:(void (^)(BOOL successful))finishedBlock {
    // 模拟请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        finishedBlock(YES);
    });
}
// 显示load视图
- (void)showLaunchView {
    __weak __typeof__(self) weak_self = self;
    [self.view addSubview:self.launchView];
    [self.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.launchView.alpha = 0.75;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weak_self.launchView.alpha = 1;
    } completion:^(BOOL finished) {
        [weak_self.launchView startAnimating];
    }];
}
// 隐藏Launch视图
- (void)hideLaunchView {
    __weak __typeof__(self) weak_self = self;
    [UIView animateWithDuration:0.25 animations:^{
        weak_self.launchView.alpha = 0.75;
    } completion:^(BOOL finished) {
        [weak_self.launchView stopAnimating];
        [weak_self.launchView removeFromSuperview];
    }];
}
// ❗️显示完launchView后要做的
- (void)launchFinished {
    // 当前安装的APP版本
    NSString *currentVersion = getAppBundleVersion();
    // 沙盒里存储的最后一个版本
    NSString *lastVersion = getUserDefault(kAppLastVersionUDKey);
    BOOL needGuide = ![currentVersion isEqualToString:lastVersion];
    if (needGuide) {
        // 需要显示guide, 就不显示广告
        [self showGuideView];
        //  SetUserDefault(currentVersion, kAppLastVersionUDKey);
    } else {
        // 不需要显示guide, 显示广告
        [self showAdvertView];
    }
}
// 显示首次加载视图
- (void)showGuideView {
    __weak __typeof__(self) weak_self = self;
    [self.view addSubview:self.guideView];
    self.guideView.alpha = 0.75;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weak_self.guideView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
// 点击进入app时调用, 设置新的rootVC
- (void)hideGuideView {
    [self.guideView removeFromSuperview];
    [self resetRootViewController];
}
// 显示广告view
- (void)showAdvertView {
    __weak __typeof__(self) weak_self = self;
    [self.view addSubview:self.advertView];
    self.advertView.alpha = 0.75;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weak_self.advertView.alpha = 1;
    } completion:^(BOOL finished) {
        [weak_self.advertView startTiming];
    }];
}
// 隐藏广告view
- (void)hideAdvertView {
    __weak __typeof__(self) weak_self = self;
    [UIView animateWithDuration:0.25 animations:^{
        weak_self.advertView.alpha = 0.75;
    } completion:^(BOOL finished) {
        [weak_self.advertView stopTiming];
        [weak_self.advertView removeFromSuperview];
    }];
}
// 加载广告资源数据，只加载数据，由其他任务拉控制显示广告视图
- (void)loadADDataSource {
    
}
// 加载配置数据
- (void)loadConfigDataSource {
    
}
// ❗️重设rootVC
- (void)resetRootViewController {
    BATTabBarController *tabBarVC = [[BATTabBarController alloc] init];
    BATNavigationController *rootVC = [[BATNavigationController alloc] initWithRootViewController:tabBarVC];
    rootVC.fullScreenPopRecognizerEnable = YES;
    
    PrivacyController *vc1 = [[PrivacyController alloc] init];
    vc1.title = NSLocalizedString(@"LS_TabBar0", nil);
    
    ThirdShareController *vc2 = [[ThirdShareController alloc] init];
    vc2.title = NSLocalizedString(@"LS_TabBar1", nil);
    
    ThirdLoginController *vc3 = [[ThirdLoginController alloc] init];
    vc3.title = NSLocalizedString(@"LS_TabBar2", nil);
    
    ThirdPayController *vc4 = [[ThirdPayController alloc] init];
    vc4.title = NSLocalizedString(@"LS_TabBar3", nil);
    
    tabBarVC.viewControllers = @[vc1, vc2, vc3, vc4];
    
    UIApplication *application = [UIApplication sharedApplication];
    application.keyWindow.rootViewController = rootVC;
    [application.keyWindow makeKeyWindow];
}
#pragma mark - 懒加载
- (AdvertView *)advertView {
    if (!_advertView) {
        _advertView = [[AdvertView alloc] initWithFrame:self.view.bounds];
        _advertView.alpha = 0;
        _advertView.advertOpenedBlock = ^void(AdvertisementModel *advertisment) {
            // 点击广告详情跳转
        };
        _advertView.advertClosedBlock = ^void(BOOL finished) {
            // 倒计时结束/跳过的回调
        };
    }
    return _advertView;
}
- (GuideView *)guideView {
    if (!_guideView) {
        __weak __typeof__(self) weak_self = self;
        _guideView = [[GuideView alloc] initWithFrame:self.view.bounds];
        _guideView.alpha = 0;
        _guideView.actionBlock = ^void() {
            [weak_self hideGuideView];
        };
    }
    return _guideView;
}
- (LaunchView *)launchView {
    if (!_launchView) {
        _launchView = [[LaunchView alloc] init];
        _launchView.alpha = 0;
    }
    return _launchView;
}
// 隐藏statusBar
- (BOOL)prefersStatusBarHidden {
    return YES;
}
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
