//
//  NSDictionary+Public.h
//  NormalProject
//
//  Created by lf on 2017/2/22.
//  Copyright © 2017年 BAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Public)

/**
 返回字典中的键值
 @param keyPath 键路径 /var/www/http/
 @return 键值
 */
- (NSObject *)objectForKeyPath:(NSString *)keyPath;
/**
 返回字典中的键值
 @param keyPath 键路径 /var/www/http/
 @param other 默认值
 @return 键值
 */
- (NSObject *)objectForKeyPath:(NSString *)keyPath otherwise:(NSObject *)other;

@end
