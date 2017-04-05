//
//  GeneralUtil.m
//  NormalProject
//
//  Created by lf on 2016/12/9.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "GeneralUtil.h"

@implementation GeneralUtil

+ (CGFloat)getLabelHeightWithAttributedText:(NSAttributedString *)text maxWidth:(CGFloat)maxW lineNum:(NSInteger)lines {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxW, CGFLOAT_MAX)];
    label.numberOfLines = lines;
    label.attributedText = text;
    [label sizeToFit];
    return label.frame.size.height;
}
+ (CGFloat)getLabelHeightWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxW lineNum:(NSInteger)lines {
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : font}];
    return [self getLabelHeightWithAttributedText:attText maxWidth:maxW lineNum:lines];
}

+ (NSString *)currencyStringWithDouble:(double)dNum {
    NSNumber *num = [NSNumber numberWithDouble:dNum];
    return [self currencyStringWithNumber:num];
}
+ (NSString *)currencyStringWithString:(NSString *)numStr {
    NSNumber *num = [NSNumber numberWithString:numStr];
    return [self currencyStringWithNumber:num];
}
+ (NSString *)currencyStringWithNumber:(NSNumber *)num {
    if (!num) {
        num = [NSNumber numberWithDouble:0];
    }
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *stdStr = [numFormatter stringFromNumber:num];
    // 货币符号
    NSString *symbol = numFormatter.currencySymbol;
    // 去掉货币符号 $ ￥ 等等
    NSString *retStr = [stdStr stringByReplacingOccurrencesOfString:symbol withString:@""];
    return retStr;
}
@end
