//
//  BATNavigationController.h
//  NormalProject
//
//  Created by lf on 16/10/9.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 当navigationController作为tabBarController的时候，本VC的作用还是有的
 * 本demo navigationController 和 navigationBar 无直接关联
 */
#import <UIKit/UIKit.h>

@interface BATNavigationController : UINavigationController
/** 自定义的全屏pop返回手势是否可用 默认就是NO */
@property (nonatomic, assign) BOOL    fullScreenPopRecognizerEnable;

/** 自定义的全屏pop手势范围 默认MAXFLOAT */
@property (nonatomic, assign) CGFloat fullScreenPopRecognizerWidth;
@end

