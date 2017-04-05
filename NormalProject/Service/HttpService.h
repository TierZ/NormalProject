//
//  HttpService.h
//  NormalProject
//
//  Created by lf on 2016/12/29.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 网络请求基类使用 适配https
 * 将在服务器上生成的CA证书ca.cer(红色)，服务器证书server.cer(蓝色)和客户端P12文件client.p12拷贝到本地，加入到工程的Bundle Resource里
 * server.cer配p12使用, ca.cer单独使用
 */
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpService : NSObject


+ (instancetype)sharedService;

- (void)postRequestWithUrl:(NSString *)url
                parameters:(nullable NSDictionary *)paramList
                   success:(nullable void (^)(id data))success
                   failure:(nullable void (^)(NSError *error))failure;

- (void)postRequestWithUrl:(NSString *)url
                parameters:(nullable NSDictionary *)paramList
                  progress:(nullable void (^)(NSProgress *upLoadProgress))progress
                   success:(nullable void (^)(id data))success
                   failure:(nullable void (^)(NSError *error))failure;

- (void)postRequestWithUrl:(NSString *)url
                parameters:(nullable NSDictionary *)paramList
                identifier:(nullable NSString *)identifier
           groupIdentifier:(nullable NSString *)groupIdentifier
                  progress:(nullable void (^)(NSProgress *upLoadProgress))progress
                   success:(nullable void (^)(id data))success
                   failure:(nullable void (^)(NSError *error))failure;


/** 取消url.path的网络连接请求 */
- (void)cancelRequestWithPath:(NSString *)path;

/** 取消指定identifier的网络连接请求 */
- (void)cancelRequestWithIdentifier:(NSString *)identifier;

/** 取消组identifier的网络连接请求 */
- (void)cancelRequestWithGroupIdentifier:(NSString *)groupIdentifier;

/** 取消全部网络连接请求 */
- (void)cancelAllRequest;
@end

/** 给sessionTask 添加一个属性 用于记录请求id */
@interface NSURLSessionTask (SessionTaskExtention)
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *groupIdentifier;
@end

NS_ASSUME_NONNULL_END

