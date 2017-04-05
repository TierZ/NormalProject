//
//  GeneralUtil.h
//  NormalProject
//
//  Created by lf on 2016/12/9.
//  Copyright © 2016年 BAT. All rights reserved.
//
/** 通用工具 */
#import <Foundation/Foundation.h>

@interface GeneralUtil : NSObject
/**
 计算label的高
 @param text  attributed字符串
 @param maxW  最大宽度
 @param lines 行数
 @return 内容所需高度
 */
+ (CGFloat)getLabelHeightWithAttributedText:(NSAttributedString *)text maxWidth:(CGFloat)maxW lineNum:(NSInteger)lines;


/**
 计算label的高
 @param text  字符串
 @param font  字体
 @param maxW  最大宽度
 @param lines 行数
 @return 内容所需高度
 */
+ (CGFloat)getLabelHeightWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxW lineNum:(NSInteger)lines;

@end
