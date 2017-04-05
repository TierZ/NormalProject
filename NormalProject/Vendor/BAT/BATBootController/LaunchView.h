//
//  LaunchView.h
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** 
 * App加载时的等待视图 非广告 无任何操作 只是有个小菊花
 */
#import <UIKit/UIKit.h>

@interface LaunchView : UIView
/** 小菊花 */
- (void)startAnimating;

- (void)stopAnimating;
@end
