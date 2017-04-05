//
//  UserEntity.m
//  NormalProject
//
//  Created by lf on 16/10/21.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "UserEntity.h"
#define _kBATUserEntityInfoUDKey  @"[BAT] UserEntity info"

@implementation UserEntity
static UserEntity *instance = nil;
+ (UserEntity *)sharedUserEntity {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserEntity alloc] init];
        [instance loadDataFromUserDefault];
    });
    return instance;
}
- (instancetype)init {
    if (self = [super init]) {
        // 这里往往放一些要初始化的变量，比如单例对象具有一个字典属性，那么就要在此处初始化
        NSLog(@"正在 初始化 或 重置 ...");
    };
    return self;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)copy {
    return self;
}
#pragma mark - private
- (void)loadDataFromUserDefault {
    NSDictionary *jsonDic = getUserDefault(_kBATUserEntityInfoUDKey);
    [self setValuesForKeysWithDictionary:jsonDic];
}
- (void)saveDataToUserDefault {
    NSDictionary *jsonDic = [self modelToJSONObject];
    setUserDefault(jsonDic, _kBATUserEntityInfoUDKey);
}
- (void)loadDataFromFile {
    NSData *jsonData = nil;
    [self modelSetWithJSON:jsonData];
}
- (BOOL)saveDataToFile {
    NSString *fileDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = @"USERENTITY.JSON";
    NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL iRet  = NO;
    if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDir]) {
        iRet = [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!iRet) {
        NSLog(@"创建文件目录失败");
        return NO;
    }
    if (![fileManager fileExistsAtPath:filePath]) {
        iRet = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    if (!iRet) {
        NSLog(@"创建文件失败");
        return NO;
    }
    NSData *data = [self modelToJSONData];
    // 可以加密
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandle truncateFileAtOffset:0];
    [fileHandle writeData:data];
    [fileHandle synchronizeFile];
    [fileHandle closeFile];
    return YES;
}
#pragma mark - public
- (void)link {
    [self loadDataFromFile];
}
- (void)save {
    [self saveDataToUserDefault];
}
- (void)reset {
    [UserEntity new];
    [self saveDataToUserDefault];
}
- (NSString *)description {
    return [NSString stringWithFormat:@"\n \
            UserEntity <%p> {\n \
            userId   = %@,\n \
            userName = %@,\n \
            userPassword  = %@,\n \
            userRole = %zd,\n \
            nikeName = %@,\n \
            authSign = %@,\n \
            lastLoginTime = %@ \n\
            }\n", self, self.userId, self.userName, self.userPassword, self.userRole, self.nickName, self.authSign, self.lastLoginTime];
}
@end
