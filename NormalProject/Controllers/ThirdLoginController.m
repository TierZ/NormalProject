//
//  ThirdLoginController.m
//  NormalProject
//
//  Created by lf on 2016/12/16.
//  Copyright © 2016年 BAT. All rights reserved.
//
// 登录demo 友盟的sdk
#import "ThirdLoginController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ThirdLoginController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ThirdLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.dataArr addObjectsFromArray:@[@"QQ 登录",
                                        @"微信 登录",
                                        @"新浪微博 登录",
                                        ]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self.tableView adjustScrollViewInsets:BATScrollViewInsetTypeBothBars];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.dataArr objectOrNilAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    switch (indexPath.row) {
        case 0: { // QQ
            type = UMSocialPlatformType_QQ;
            break;
        }
        case 1: { // 微信
            type = UMSocialPlatformType_WechatSession;
            break;
        }
        case 2: { // 新浪微博
            type = UMSocialPlatformType_Sina;
            break;
        }
        default:
            break;
    }
    // 授权是授权登录的, 授权窗口瞬间消失21338:两个可能 1.bundle id不一致导致 2. 检查info.plist文件里有没添加URL Types，在URL Schemes里填上wb+APPKEY
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"login err : %@", error);
        } else {
            UMSocialUserInfoResponse *userinfo =result;
            NSString *message = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",userinfo.name,userinfo.iconurl,userinfo.gender];
            NSLog(@"message = \n%@", message);
        }
    }];
}
#pragma set get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
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
