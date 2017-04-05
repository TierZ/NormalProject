//
//  AdvertView.h
//  NormalProject
//
//  Created by lf on 2016/12/12.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * launch加载时显示的广告view
 **/
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AdvertisementModel; // 广告信息的model
typedef void(^BATAdvertViewWillOpenedBlock)(AdvertisementModel *advertisment);
typedef void(^BATAdvertViewDidClosedBlock)(BOOL finished);

@interface AdvertView : UIView
/** 跳转广告内容的block */
@property (nonatomic, copy) BATAdvertViewWillOpenedBlock  advertOpenedBlock;

/** 广告倒计时完成/跳过的block */
@property (nonatomic, copy) BATAdvertViewDidClosedBlock   advertClosedBlock;

- (void)startTiming;
- (void)stopTiming;
@end
