//
//  AdvertisementModel.h
//  NormalProject
//
//  Created by lf on 2016/12/12.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** 广告model */
#import <Foundation/Foundation.h>
@class AdvertisementSource;
@interface AdvertisementModel : NSObject
// e.g.
@property (nonatomic, copy)   NSString            *identifier;     // id
@property (nonatomic, assign) CGFloat              duration; // 倒计时长
@property (nonatomic, strong) AdvertisementSource *source;   // 资源
@end

typedef NS_ENUM(NSInteger, AdvertisementSourceType) {
    AdvertisementSourceTypeUnknown = -1,
    AdvertisementSourceTypePNG = 0,
    AdvertisementSourceTypeJPEG,
    AdvertisementSourceTypeGIF,
};
// 资源model
@interface AdvertisementSource : NSObject
// e.g.
@property (nonatomic, copy)   NSString   *identifier;    // id
@property (nonatomic, copy)   NSString   *url;           // 下载地址
@property (nonatomic, assign) AdvertisementSourceType type;   // 资源类型(文件后缀.gif/.jpeg/.png/...)
@end
