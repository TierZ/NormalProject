//
//  FileUitl.m
//  NormalProject
//
//  Created by lf on 2016/11/10.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUitl

// 返回沙盒document路径 ..App../Documents/
+ (NSString *)getSandboxDocumentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
// 返回沙盒cache路径 ..App../Library/Caches
+ (NSString *)getSandboxCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
// 返回沙盒tmp路径 ..App../tmp/
+ (NSString *)getSandboxTmpPaht {
    return NSTemporaryDirectory();
}
// 返回沙盒Library路径
+ (NSString *)getSandBoxLibraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}
// 返回沙盒根路径 ..App../
+ (NSString *)getSandboxHomePath {
    return NSHomeDirectory();
}
// 创建目录(存在就不再创建)
+ (BOOL)createDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}
// 创建文件(存在就不再创建)
+ (BOOL)createFile:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:file]) {
        return YES;
    }
    return [fileManager createFileAtPath:file contents:nil attributes:nil];
}
// 删除目录
+ (BOOL)removeDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return [fileManager removeItemAtPath:path error:nil];
    } else {
        return YES;
    }
}
// 清空文件内容(不存在会创建的)
+ (BOOL)clearFileContents:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:file]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];
        [fileHandle truncateFileAtOffset:0];
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
        return YES;
    } else {
        return [fileManager createFileAtPath:file contents:nil attributes:nil];
    }
}
@end
