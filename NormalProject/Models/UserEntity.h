//
//  UserEntity.h
//  NormalProject
//
//  Created by lf on 16/10/21.
//  Copyright © 2016年 BAT. All rights reserved.
//
/*
 * 本地用户基本信息管理，用于需要用户登录的
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserEntityUserRole) {
    UserEntityUserRoleUnknown = -1,
    UserEntityUserRoleCommon = 0,  // 普通用户
    UserEntityUserRoleManager,     // 管理员
    UserEntityUserRoleSupper,      // 超级
    UserEntityUserRoleDefault = UserEntityUserRoleCommon,
};

@interface UserEntity : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, assign) UserEntityUserRole  userRole;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *authSign;
@property (nonatomic, copy) NSString *lastLoginTime;

/** 单例 */
+ (instancetype)sharedUserEntity;
/** 保存用户信息到指定位置 */
- (void)save;
/** 重置UserEntity和它所存储的信息 */
- (void)reset;

@end



