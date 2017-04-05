//
//  PrivacyController.m
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "PrivacyController.h"
#import "PrivacyUtil.h"
#import <UserNotifications/UserNotifications.h>
#import "BaseWebController.h"
@interface PrivacyController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation PrivacyController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataArr addObjectsFromArray:@[@"相机",
                                        @"相册",
                                        @"位置",
                                        @"通讯录",
                                        @"麦克风",
                                        @"远程通知",
                                        @"蜂窝网络",
                                        @"后台刷新",
                                        ]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self.tableView adjustScrollViewInsets:BATScrollViewInsetTypeBothBars];

    __weak __typeof__(self) weak_self = self;
    [self addNavigationBarRightItem:@"本地通知" image:nil actionBlock:^{
        [weak_self addLocalNotification];
    }];
    [self addNavigationBarBackItem:BATNavigationBarBackTypeClose title:@"返回" actionBlock:^{
        [weak_self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    NSDictionary *dic = @{@"var":@{@"www":@{@"http":@"www.baidu.com"}}};
    NSLog(@"1111 = %@", [dic objectForKeyPath:@"/var/www/http" otherwise:@"0.0"]);
    NSLog(@"2222 = %@", [dic objectForKeyPath:@"/var/www/https" otherwise:@"0.0"]);
    NSLog(@"3333 = %@", [dic objectForKeyPath:@"/var/" otherwise:@"0.0"]);
    NSLog(@"4444 = %@", [dic objectForKeyPath:@"/var/wh/https" otherwise:@"0.0"]);
    NSLog(@"5555 = %@", [dic objectForKeyPath:nil otherwise:@"0.0"]);
    NSLog(@"6666 = %@", [dic objectForKeyPath:@"/var///www" otherwise:@"0.0"]);

    self.batNavigationBar.batBackgroundView.backgroundColor = [UIColor orangeColor];
    
//    [UIView animateWithDuration:10 animations:^{
//        weak_self.batNavigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
//    }];
}
#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count+10;
    NSTimer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor randomColor];
    cell.textLabel.text = [self.dataArr objectOrNilAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [AuthorityUitl openSystemSetting:indexPath.row];
//    return;
    if (indexPath.row%2 == 0) {
        BaseWebController *vc = [[BaseWebController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        BaseWebController *vc = [[BaseWebController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
}
- (void)addLocalNotification {
    NSLog(@" 发送 本地 通知 ！！！");
    // ios[8, 10)
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
    // 2.2.设置通知的内容
    localNote.alertBody = @"ios[8, 10) body";
    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
    localNote.alertAction = @"ios[8, 10) alertAction";
    // 2.4.决定alertAction是否生效
    localNote.hasAction = YES;
    // 2.5.设置点击通知的启动图片
    localNote.alertLaunchImage = @"../Documents/IMG_0024.jpg";
    // 2.6.设置alertTitle
    localNote.alertTitle = @"ios[8, 10) alertTitle";
    // 2.7.设置有通知时的音效
    localNote.soundName = UILocalNotificationDefaultSoundName;
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = arc4random()%100+1;
    // 2.9.设置额外信息
    localNote.userInfo = @{@"type":@(arc4random()%3+1), @"content":@"ios[8, 10) hello world"};
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    
    // ios [10, ~)
    // 1 新建通知内容对象
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"ios[10, ~) title";
    content.subtitle = @"ios[10, ~) subTitle";
    content.body = @"ios[10, ~) body";
    content.badge = @(arc4random()%100+1);
    content.sound = [UNNotificationSound soundNamed:UILocalNotificationDefaultSoundName];
    content.userInfo = @{@"content":@"ios[10, ~) hello world"};
    
    // 2 通知触发机制（重复提醒时, 时间间隔要大于60s）
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    // 3 创建UNNotificationRequest通知请求对象
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ios10 RequestIdentifier" content:content trigger:trigger];
    
    // 4 将通知加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"ios10 发送本地通知完成");
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
