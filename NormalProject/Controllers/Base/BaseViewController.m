//
//  BaseViewController.m
//  NormalProject
//
//  Created by lf on 16/10/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end
@implementation BaseViewController
- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    /** 保证navigationBar在最顶层 */
    [self.view bringSubviewToFront:self.batNavigationBar]; // navibar不是懒加载的
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSLog(@" viewDidLoad \n [ sys ] naviVC = %@ tabVC = %@ \n [ bat ] naviVC = %@ tabVC = %@", \
          self.navigationController, self.tabBarController, self.batNavigationContrller, self.batTabBarContrller);
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
