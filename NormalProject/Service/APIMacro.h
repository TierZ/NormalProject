//
//  APISMacro.h
//  NormalProject
//
//  Created by shagualicai on 2016/12/9.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** API接口 */
#ifndef APIMacro_h
#define APIMacro_h

#define  DEBUG_API                  1      // 1 测试 0 正式

#if  DEBUG_API
#define kAPIBaseURL                 @"https://dapi.xxx.com"
#define kFileBaseURL                @"https://dfile.xxx.com"
#else
#define kAPIBaseURL                 @"https://api.xxx.com"
#define kFileBaseURL                @"https://file.xxx.com"
#endif

#define kConfigShortURL             @"/client/config.shtml"
#define kLoginShortURL              @"/user/login.shtml"
#define kLogoutShortURL             @"/user/logout.shtml"
#define kRegistShortURL             @"/user/regist.shtml"
#define kVerificationCodeShortURL   @"/general/verificationCode.shtml"

#define kAvatarFilePath             @"/download/avatar/user_id/"
#define kImageFilePath              @"/download/image/resource_id/"

#endif /* APIMacro_h */
