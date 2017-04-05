//
//  UIColor+BAT.m
//  NormalProject
//
//  Created by lf on 2017/2/7.
//  Copyright © 2017年 BAT. All rights reserved.
//

#import "UIColor+BAT.h"

@implementation UIColor (BAT)
+ (UIColor *)randomColor {
    return [self randomColor:1];
}
+ (UIColor *)randomColor:(CGFloat)alpha {
    return [self colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:alpha];
}

@end
