//
//  ThirdShareController.m
//  NormalProject
//
//  Created by lf on 2016/12/16.
//  Copyright © 2016年 BAT. All rights reserved.
//
// 分享demo 友盟的
#import "ThirdShareController.h"

#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
@interface ThirdShareController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ThirdShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.dataArr addObjectsFromArray:@[@"QQ",
                                        @"QQ空间",
                                        @"腾讯微博",
                                        @"微信",
                                        @"微信朋友圈",
                                        @"新浪微博",
                                        @"友盟UI",
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
    BOOL is_um_ui = NO;
    __block UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    switch (indexPath.row) {
        case 0: { // QQ
            type = UMSocialPlatformType_QQ;
            break;
        }
        case 1: { // QQ空间
            type = UMSocialPlatformType_WechatSession;
            break;
        }
        case 2: { // 腾讯微博
            type = UMSocialPlatformType_TencentWb;
            break;
        }
        case 3: { // 微信
            type = UMSocialPlatformType_WechatSession;
            break;
        }
        case 4: { // 微信朋友圈
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        }
        case 5: { // 新浪微博
            type = UMSocialPlatformType_Sina;
            break;
        }
        default:
            is_um_ui = YES;
            break;
    }
    if (is_um_ui) {
        // 仅仅显示UI
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            NSLog(@"type = %zd ,userInfo = %@", platformType, userInfo);
        }];
    } else {
        //创建分享消息对象 除了纯文本, 其余都要有shareObject
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象, 新浪的分享必须有[缩略图]
        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = @"http://mobile.umeng.com/social";
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"share err : %@", error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    NSLog(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    NSLog(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }
        }];
    }
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
