//
//  HttpService.m
//  NormalProject
//
//  Created by lf on 2016/12/29.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "HttpService.h"
#import <objc/runtime.h>

@interface HttpService ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation HttpService
static HttpService *instance = nil;
+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpService alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if (self = [super init]) {
        // 这里往往放一些要初始化的变量，比如单例对象具有一个字典属性，那么就要在此处初始化
    };
    return self;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)copy {
    return self;
}
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://napi.lf.cn"]];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
//        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];

        [_manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"application/x-javascript",@"application/text" ,nil]];

        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 15.0;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
        //  适配ATS  //
        // http://www.jianshu.com/p/36ddc5b009a7
        // 客户端与服务器建立 https 链接 使得客户端只能与server.cer的服务器建立https证书连接, 若买的证书，客户端只需将http改为https即可, 因为买的证书苹果已经认证
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:
                                            AFSSLPinningModeCertificate];//AFSSLPinningModeCertificate  需要客户端预先保存服务端的证书(自建证书)
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        // validatesDomainName 是否需要验证域名，默认为YES；
        // 假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        // 置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        // 如置为NO，建议自己添加对应域名的校验逻辑。
        [securityPolicy setValidatesDomainName:NO];
        
        // validatesCertificateChain 是否验证整个证书链，默认为YES
        // 设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
        // GeoTrust Global CA
        //    Google Internet Authority G2
        //        *.google.com
        // 那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
        // 如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
        // securityPolicy.validatesCertificateChain = NO;
        
        _manager.securityPolicy = securityPolicy;
        
        // 网上大概就是这两种方法 取其一
#if 0
        [self setSingleCertification];
#else
//        [self setEachCertification];
#endif
    }
    return _manager;
}
- (void)setSingleCertification {
    // other demo
    __weak __typeof__(self) weakSelf = self;
    [_manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
        // 导入多张CA证书（Certification Authority，支持SSL证书以及自签名的CA），请替换掉你的证书名称
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];
        NSData   *cerData = [NSData dataWithContentsOfFile:cerPath];
        NSSet    *cerSet  = [NSSet setWithArray:(cerData?@[cerData]:nil)];
        weakSelf.manager.securityPolicy.pinnedCertificates = cerSet;
        
        SecCertificateRef cerRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
        NSCAssert(cerRef != nil, @"cerRef is nil");
        NSArray *cerArray = @[(__bridge id)(cerRef)];
        NSCAssert(cerArray != nil, @"cerArray is nil");
        OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)cerArray);
        SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
        NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([weakSelf.manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        return disposition;
    }];
}
- (void)setEachCertification {
    // from Mr.zhang
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData   *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet    *cerSet  = [NSSet setWithArray:(cerData?@[cerData]:nil)];
    _manager.securityPolicy.pinnedCertificates = cerSet;
    
    // 实现客户端验证 (双向认证?解析p12)
    __weak __typeof__(self) weakSelf = self;
    [_manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([weakSelf.manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition =NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client"ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12]) {
                NSLog(@"client.p12 failed with err info not exist");
            } else {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                
                if ([[weakSelf class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]) {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition =NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
}
+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    // client certificate password p12 密码
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"12344321"
                                                                forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary, &items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"p12 Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}
#pragma mark - public method
- (void)postRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)paramList
                   success:(void (^)(id _Nonnull))success
                   failure:(void (^)(NSError * _Nonnull))failure {
    [self postRequestWithUrl:url parameters:paramList progress:nil success:success failure:failure];
}
-(void)postRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)paramList
                 progress:(void (^)(NSProgress * _Nonnull))progress
                  success:(void (^)(id _Nonnull))success
                  failure:(void (^)(NSError * _Nonnull))failure {
    [self postRequestWithUrl:url parameters:paramList identifier:nil groupIdentifier:nil  progress:progress success:success failure:failure];
}
-(void)postRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)paramList
               identifier:(NSString *)identifier
          groupIdentifier:(NSString *)groupIdentifier
                 progress:(void (^)(NSProgress * _Nonnull))progress
                  success:(void (^)(id _Nonnull))success
                  failure:(void (^)(NSError * _Nonnull))failure {

    NSURLSessionDataTask *task = [self.manager POST:url parameters:paramList progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    task.identifier = identifier;
    task.groupIdentifier = groupIdentifier;
    

    NSURL *_url = task.originalRequest.URL;
    NSString *scheme = _url.scheme;
    NSString *host   = _url.host;
    NSString *path   = _url.path;
    NSString *param  = _url.parameterString; // post请求参数是null?
    NSString *urlStr = _url.absoluteString;
    NSLog(@"post request task :\n scheme-[%@]\n host-[%@]\n path-[%@]\n param/paramList-[%@ / %@]\n url-[%@]", scheme, host, path, param, paramList, urlStr);
}
- (void)cancelRequestWithPath:(NSString *)path {
    [self.manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *taskPath = obj.originalRequest.URL.path;
        if ([taskPath isEqualToString:path]) {
            [obj cancel];
        }
    }];
}
- (void)cancelRequestWithIdentifier:(NSString *)identifier {
    [self.manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *taskIdentifier = obj.identifier;
        if ([taskIdentifier isEqualToString:identifier]) {
            [obj cancel];
        }
    }];
}
- (void)cancelRequestWithGroupIdentifier:(NSString *)groupIdentifier {
    [self.manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *taskGroupIdentifier = obj.groupIdentifier;
        if ([taskGroupIdentifier isEqualToString:groupIdentifier]) {
            [obj cancel];
        }
    }];
}
- (void)cancelAllRequest {
    [self.manager.operationQueue cancelAllOperations];
}
@end

///////////////////////////////////////////////////////////////////////////
/*
 set 方法
 OBJC_ASSOCIATION_ASSIGN;            // assign策略
 OBJC_ASSOCIATION_COPY_NONATOMIC;    // copy策略
 OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
 
 OBJC_ASSOCIATION_RETAIN;
 OBJC_ASSOCIATION_COPY;
 */
/*
 * id object 给哪个对象的属性赋值
 const void *key 属性对应的key
 id value  设置属性值为value
 objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
 objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
 */
@implementation NSURLSessionTask (SessionTaskExtention)
- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @"identifierKey", identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)identifier {
    return objc_getAssociatedObject(self, @"identifierKey");
}
- (void)setGroupIdentifier:(NSString *)groupIdentifier {
    objc_setAssociatedObject(self, @"groupIdentifierKey", groupIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)groupIdentifier {
    return objc_getAssociatedObject(self, @"groupIdentifierKey");
}
@end
