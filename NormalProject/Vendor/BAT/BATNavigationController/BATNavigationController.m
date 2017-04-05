//
//  BATNavigationController.m
//  NormalProject
//
//  Created by lf on 16/10/9.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BATNavigationController.h"
#import "BATNavigationBar.h"
#import "NavigationControllerDelegate.h"

@interface BATNavigationController ()<UIGestureRecognizerDelegate>
/** UINavigationController的代理 实现push pop动画 及 响应pop手势 */
@property (nonatomic, strong) NavigationControllerDelegate *navigationControllerDelegate;

/** 全屏手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *fullScreenPopRecognizer;
@end

@implementation BATNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _fullScreenPopRecognizerWidth = MAXFLOAT;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // hide系统的navigationBar,原生pop手势也没有了,需要重新设置代理为self
    [self setNavigationBarHidden:YES];
    self.interactivePopGestureRecognizer.delegate = self;
    self.fullScreenPopRecognizerEnable = YES;
}
/*
// 没必要, 用原生UINavigationBar 就行, 因为本demo用的rootVC是navigationVC, 所以给hide了
- (void)replaceUINavigationBar {
    BATNavigationBar *batNavigationBar = [[BATNavigationBar alloc] init];
    [self.view addSubview:batNavigationBar];

    UINavigationBar *sysNavigationBar = self.navigationBar;
    [batNavigationBar addConstraints:sysNavigationBar.constraints];

    [sysNavigationBar removeFromSuperview];
    [self setValue:batNavigationBar forKey:@"navigationBar"];
    
    NSLog(@"\nnavibar : \n[ sys ] %@ \n[ bat ] %@", self.navigationBar, batNavigationBar);
}
 */
// 打开全屏手势, 关闭原生手势
- (void)openFullScreenPopRecognizer {
    // 1 获取系统原生的pop手势 及 所在视图
    // 2 关闭原生的pop手势 加入自定义的

    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    UIView *gestureView = gesture.view;
    gesture.enabled = NO;
    gesture.delegate = nil;
    
    if ([gestureView.gestureRecognizers containsObject:_fullScreenPopRecognizer]) {
        return;
    }
    [gestureView addGestureRecognizer:self.fullScreenPopRecognizer]; // 需要懒加载
}
// 关闭全屏手势, 打开原生手势
- (void)closeFullScreenPopRecognizer {
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    UIView *gestureView = gesture.view;
    gesture.enabled = YES;
    gesture.delegate = self;
    
    if (![gestureView.gestureRecognizers containsObject:_fullScreenPopRecognizer]) {
        return;
    }
    [gestureView removeGestureRecognizer:_fullScreenPopRecognizer];
}
#pragma mark - set get 
// 设置全屏手势是否有效, 与自定义动画同在
- (void)setFullScreenPopRecognizerEnable:(BOOL)enable {
    if (enable == self.fullScreenPopRecognizerEnable) {
        return;
    }
    if (enable) {
        [self openFullScreenPopRecognizer];
    } else {
        [self closeFullScreenPopRecognizer];
    }
    _fullScreenPopRecognizerEnable = enable;
}
- (UIViewController*)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
#pragma mark - 懒加载
- (UIGestureRecognizer *)fullScreenPopRecognizer {
    if (!_fullScreenPopRecognizer) {
        _fullScreenPopRecognizer = [[UIPanGestureRecognizer alloc] init];
        _fullScreenPopRecognizer.delegate = self;
        _fullScreenPopRecognizer.maximumNumberOfTouches = 1;
#if 1
        /** 自定义全屏手势 + 系统动画(私有api) */
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id target = [targets.firstObject valueForKey:@"target"];
        SEL handle = NSSelectorFromString(@"handleNavigationTransition:");
        [_fullScreenPopRecognizer addTarget:target action:handle];
#else
        /** 自定义全屏手势 + 自定义动画(微卡) */
        [_fullScreenPopRecognizer addTarget:self.navigationControllerDelegate action:@selector(handlePopInteractiveTransition:)];
#endif
        /** 原生手势 + 自定义动画 (没有了动画交互过程, 直接完成动画) 下行代码写到别处就行 */
        // [self navigationControllerDelegate];
    }
    return _fullScreenPopRecognizer;
}
// 全屏手势新代理(自定义动画用)
-(NavigationControllerDelegate *)navigationControllerDelegate {
    if (!_navigationControllerDelegate) {
        _navigationControllerDelegate = [[NavigationControllerDelegate alloc] initWithNavigationController:self]; // init里设置了代理
    }
    return _navigationControllerDelegate;
}
#pragma mark - 手势delegate
// 当前navigationVC代理的手势就2个 一个自定义全屏pop 一个原生的pop
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"\n this %@\n\n ori  %@\n\n full %@", gestureRecognizer, self.interactivePopGestureRecognizer, _fullScreenPopRecognizer);
    
    // 到navigationVC.rootVC界面时，手势响应无效 包含了系统原生的 和 自定义的
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if (_fullScreenPopRecognizer == gestureRecognizer) {
        // 绝对位置
        CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
        // 限制全屏手势响应范围
        if (location.x >= _fullScreenPopRecognizerWidth) {
            return NO;
        }
    }
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
