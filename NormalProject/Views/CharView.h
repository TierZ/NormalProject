//
//  CharView.h
//  NormalProject
//
//  Created by lf on 2016/12/22.
//  Copyright © 2016年 BAT. All rights reserved.
//
// 练习  画线的
#import <UIKit/UIKit.h>

@interface CharView : UIView
- (void)resetYBaseValues:(NSArray *)newData;
- (void)resetXValues:(NSArray *)newData;
- (void)resetYValues:(NSArray *)newData;
- (void)reloadData;
@end
