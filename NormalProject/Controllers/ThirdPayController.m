//
//  ThirdPayController.m
//  NormalProject
//
//  Created by lf on 2016/12/20.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "ThirdPayController.h"
#import "CharView.h"
#import "HttpService.h"
@interface ThirdPayController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger      ticketsCount;
@property (nonatomic, strong) NSMutableArray *threadArr;
@end

@implementation ThirdPayController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    CharView *charView = [[CharView alloc] initWithFrame:CGRectMake(10, 80, 300, 160)];
//    charView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:charView];
//    
//    [charView resetYBaseValues:@[@"9", @"7", @"5", @"3", @"1"]];
//    [charView resetXValues:@[@"2016.12.12", @"2016.12.17"]];
//    [charView resetYValues:@[@"1.3", @"3.2", @"5.9", @"3.2", @"8.9", @"1.3", @"3.2", @"5.9", @"3.2", @"8.9", @"1.3", @"3.2", @"5.9", @"3.2", @"8.9", @"1.3", @"3.2", @"5.9", @"3.2", @"8.9", @"8.9", @"1.3", @"3.2", @"5.9", @"3.2",]];
//    [charView reloadData];
//    
//    return;

    // 腾讯红包问题
    NSArray *gifts = @[@1, @2, @2, @3, @3, @2, @5, @2];
    NSNumber *money = gifts[0];
    NSInteger cnt = 1;
    for (NSInteger i = 1; i < gifts.count-1; i++) {
        if ([gifts[i] isEqualToValue:money]) {
            cnt++;
        } else {
            cnt--;
        }
        if (!cnt) {
            money = gifts[i];
            cnt = 1;
        }
    }
    NSLog(@"----- value [%@] -----", money);
    
    // 售票问题
    self.ticketsCount=20;
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread1.name = @"售票员1";
    [self.threadArr addObject:thread1];
    [thread1 start];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread2.name = @"售票员2";
    [self.threadArr addObject:thread2];
    [thread2 start];
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread3.name = @"售票员3";
    [self.threadArr addObject:thread3];
    [thread3 start];
    
    [self.dataArr addObjectsFromArray:@[@"QQ 财付通支付",
                                        @"微信 支付",
                                        @"支付宝 支付",
                                        ]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self.tableView adjustScrollViewInsets:BATScrollViewInsetTypeBothBars];
}
- (void)saleTicket {
    while (1) {
        @synchronized (self) {
            if (self.ticketsCount > 0) {
                [NSThread sleepForTimeInterval:0.1];
                NSString *name = [NSThread currentThread].name;
                self.ticketsCount = self.ticketsCount - 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *string = [NSString stringWithFormat:@"%@卖了一张票, 还剩%zd张票", name, self.ticketsCount];
                    NSLog(@"%@", string);
                });
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"%@: 对不起，票卖完了", [NSThread currentThread]);
                });
                return;
            }
        }
    }
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
    HttpService *ser = [HttpService sharedService];
    [ser postRequestWithUrl:@"public_room/getroominfo.shtml" parameters:@{@"room_id":@"888"} success:^(id  _Nonnull data) {
        NSLog(@"dataStr = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"err = %@", error);
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
- (NSMutableArray *)threadArr {
    if (!_threadArr) {
        _threadArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _threadArr;
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
