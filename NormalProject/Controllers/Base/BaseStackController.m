//
//  BaseStackController.m
//  NormalProject
//
//  Created by lf on 2016/11/8.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "BaseStackController.h"

@interface BaseStackController ()

@end

@implementation BaseStackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBatNavigationBar];
    
    __weak __typeof__(self) weak_self = self;
    [self addNavigationBarBackItem:BATNavigationBarBackTypeReturn title:@"🔙" actionBlock:^{
        [weak_self.navigationController popViewControllerAnimated:YES];
    }];
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
