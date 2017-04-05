//
//  NSDictionary+Public.m
//  NormalProject
//
//  Created by lf on 2017/2/22.
//  Copyright © 2017年 BAT. All rights reserved.
//

#import "NSDictionary+Public.h"

@implementation NSDictionary (Public)
- (NSObject *)objectForKeyPath:(NSString *)keyPath {
    return [self objectForKeyPath:keyPath otherwise:nil];
}

- (NSObject *)objectForKeyPath:(NSString *)keyPath otherwise:(NSObject *)other {
    if (!keyPath || ![keyPath isKindOfClass:[NSString class]]) {
        return other;
    }
    NSObject     *iRet   = other;
    NSDictionary *tmpDic = self;

    NSArray *array = [keyPath componentsSeparatedByString:@"/"];
    for (NSString *subPath in array) {
        if (![subPath length]) {
            continue;
        }
        iRet = [tmpDic objectForKey:subPath];
        if (!iRet ) {
            iRet = other;
            break;
        }
        if (subPath != [array lastObject]) {
            if ([iRet isKindOfClass:[NSDictionary class]]) {
                tmpDic = (NSDictionary *)iRet;
            } else {
                iRet = other;
                break;
            }
        }
    }
    return iRet;
}
@end
