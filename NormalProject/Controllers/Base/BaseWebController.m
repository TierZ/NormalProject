//
//  BaseWebController.m
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 http://blog.csdn.net/hbblzjy/article/details/52796687
 http://www.jianshu.com/p/1d7a8525ad16
 http://blog.csdn.net/baihuaxiu123/article/details/51286109
 http://blog.csdn.net/reylen/article/details/46437517
 WKWebview提供了API实现js交互 不需要借助JavaScriptCore或者webJavaScriptBridge。使用WKUserContentController实现js native交互。简单的说就是先注册约定好的方法，然后再调用。
 WK不支持NSURLCache缓存
 */
#import "BaseWebController.h"
#define _kWKWebViewProgressKeyPath    @"estimatedProgress"
#define _kWKWebViewTitleKeyPath       @"title"

///////////////////////////  WKWebViewController  /////////////////////////
@interface BaseWebController ()
@property (nullable, nonatomic, strong) UILabel         *sourceLabel;   // 来自xxx的网页
@property (nullable, nonatomic, strong) WKWebView       *webView;       // webView
@property (nullable, nonatomic, strong) UIProgressView  *progressView;  // 进度条
@end

@implementation BaseWebController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak __typeof__(self) weak_self = self;
    
    /*-------------------- webView js-oc --------------------*/
    // 1 webView配置
    // 1.1 配置信息
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 1.1.1 偏好设置
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.javaScriptEnabled = YES; // 默认YES
    config.preferences.minimumFontSize = 20; // 不管用啊
    
    // 2 配置js调用oc的环境 WKUserContentController-交互控制器
    // 2.1 注册js 调用 oc 方法 - 代理处理被调用的接下来行为
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    config.userContentController = userContentController;
    // 2.2 addScriptMessageHandler 会使handler无法释放 所以得绕个远设个代理
    ScriptMessageHandler *handler = [[ScriptMessageHandler alloc] init];
    handler.delegate = self;
    // 2.3 注册提供给js的调用方法
    // 前端需要用 window.webkit.messageHandlers.注册的方法名.postMessage({body:传输的数据} 来给native发送消息 :
    [userContentController addScriptMessageHandler:handler name:@"sayhello"];// 注册一个name为sayhello的oc方法, 以便提供给js调用

    // 3 创建webView 需要前面的设置初始化完成后, 再赋值给webView
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _webView.UIDelegate = self; // 与web交互代理
    _webView.navigationDelegate = self; // 导航代理
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_webView.scrollView adjustScrollViewInsets:BATScrollViewInsetTypeBothBars];

    // 4 oc 调用 js 方法 直接调用, 不用注册, 可用的ok : say()是JS方法名，completionHandler是异步回调block. 就是直接调用js代码的意思
    // e.g. 请在适当位置调用, 此处只是方法的使用
//    [self runJavaScriptCodeWithString:@"say()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"oc 调用 js 的方法say() ret(%@), js是否响应了是不知道的 err(%@)",result, error);
//    }];
    
    /*-------------------- progress 及 title 监听 --------------------*/
    // KVO web加载进度,web的title
    [_webView addObserver:self forKeyPath:_kWKWebViewProgressKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [_webView addObserver:self forKeyPath:_kWKWebViewTitleKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    
    /*-------------------- 网页来自 xxx 约束 --------------------*/
    UIColor *backColor = [UIColor colorWithHexString:@"#555250"];
    _sourceLabel = [[UILabel alloc] init];
    _sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.textColor = [UIColor lightGrayColor];
    _sourceLabel.textAlignment = NSTextAlignmentCenter;
    UIView *scrollViewContentView = _webView.scrollView.subviews.firstObject;
    UIView *boardView = scrollViewContentView.subviews.firstObject;
    boardView.backgroundColor = backColor;
    [boardView addSubview:_sourceLabel];
    [boardView sendSubviewToBack:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boardView).with.offset(-(14+20));
        make.left.and.right.equalTo(boardView);
    }];
    
    /*-------------------- navigationBar --------------------*/
    [self addBatNavigationBar];
    [self addNavigationBarBackItem:BATNavigationBarBackTypeClose title:@"🔙" actionBlock:^{
        if (weak_self.webView.canGoBack) {
            [weak_self.webView goBack];
        } else {
            if (weak_self.presentingViewController) {
                [weak_self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [weak_self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [self.batNavigationBar addSubview:self.progressView];
    
    /*-------------------- your code --------------------*/
//    [self loadRequestWithBundleFile:@"test.html"];
    [self loadRequestWithString:@"http://www.360.com"];
//    [self loadRequestWithString:@"https://nm.lf.cn/index-iphone.shtml"];
//    [self loadRequestWithString:@"http://www.soyoung.work/phone.html"];
//    [self loadRequestWithString:@"http://new.m.lf.cn/index/test"];
//    [self loadRequestWithHTMLString:@"<head><title>html string</title><body><p>this is static string </p></body></head></html>"];
}
#pragma mark - public
// 加载web url:NSURL
- (void)loadRequestWithURL:(NSURL *)url {
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlReq];
}
// 加载web urlStr:NSString
- (void)loadRequestWithString:(NSString *)urlStr {
    [self loadRequestWithURL:[NSURL URLWithString:urlStr]];
}
// 加载沙盒中web文件 filePath = @"/var/Documents/temp/www/test.htlm"
- (void)loadRequestWithSandBoxFile:(NSString *)filePath {
    
}
// 加载工程中web文件 fileName = @"test.html"
- (void)loadRequestWithBundleFile:(NSString *)fileName {
    if (!fileName) {
        return;
    }
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    // /var/mobile/Containers/Bundle/Application/B232A1EC-293B-4E68-A779-12BCA7D65A6A/NormalProject.app/test.html
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    // file:///var/mobile/Containers/Bundle/Application/51EABB03-6584-4048-9F6E-72C02296E43E/NormalProject.app/test.html
    NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",filePath]];
    if (iOSVer >= 9.0) { // [9, ~)
        [self loadRequestWithURL:fileURL];
    } else if (iOSVer >= 8) { // [8, 9)
        
    } else { // 7及以下wk不支持
        
    }
}
// 加载一段html代码
- (void)loadRequestWithHTMLString:(NSString *)htmlStr {
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}
// oc运行js代码段
- (void)runJavaScriptCodeWithString:(NSString *)jsCode  completionHandler:(void (^ _Nullable)(id _Nullable result, NSError * _Nullable error))completionHandler {
    [self.webView evaluateJavaScript:jsCode completionHandler:completionHandler];
}
#pragma mark - private
// 进度监控实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:_kWKWebViewProgressKeyPath]) {
        if (object == self.webView) {
            CGFloat progress = self.webView.estimatedProgress;
            if (self.progressView.alpha == 0) {
                self.progressView.alpha = 1;
            }
            if (progress >= 1) {
                __weak __typeof__(self) weak_self = self;
                [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    weak_self.progressView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            }
            self.progressView.progress = progress;
            NSLog(@"[observe] progress [%.2f]", progress);
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if ([keyPath isEqualToString:_kWKWebViewTitleKeyPath]) {
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - ScriptHandlerDelegate
// js调用了注册的方法，给oc发来了消息，即js调oc
- (void)handler:(ScriptMessageHandler *)handler withUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"js -> oc" message:[NSString stringWithFormat:@"\n oc function name:%@ \n body:%@ \n frameInfo:%@", message.name, message.body, message.frameInfo] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
#pragma mark - webView ui代理
// 创建一个新的窗口WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"[ui] return wkWebView");
    return nil;
}
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"[ui] %s", __FUNCTION__);
}
// web弹出警告框时调用, 即JS端调用alert函数时，会触发此代理方法, 需要自己写个alert以便显示js的alert内容
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"[ui] runJavaScriptAlertPanel");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"from web" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    completionHandler();
}
// web弹出确认框, 即JS端调用confirm函数时, 会触发此方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"[ui] runJavaScriptConfirmPanel");
    completionHandler(YES);
}
// web弹出输入框, 即JS端调用prompt函数时，会触发此方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    NSLog(@"[ui] runJavaScriptTextInputPanel");
    completionHandler(@"inputPanel");
}
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo {
    NSLog(@"[ui] shouldPreviewElement");
    return YES;
}
- (UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id<WKPreviewActionItem>> *)previewActions {
    NSLog(@"[ui] previewingViewControllerForElement");
    return nil;
}
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController {
    NSLog(@"[ui] commitPreviewingViewController");
}
#pragma mark - webView navi代理 一般只写它
/**
 * web方有认证协议/有重定向 成功 http://m.baidu.com
 * decidePolicyForNavigationAction (type-other) http://m.baidu.com
 * didStartProvisionalNavigation
 * decidePolicyForNavigationAction (type-other) https://m.baidu.com
 * didReceiveServerRedirectForProvisionalNavigation
 * didReceiveAuthenticationChallenge (证书验证)
 * decidePolicyForNavigationResponse
 * didCommitNavigation
 * didReceiveAuthenticationChallenge ... (多次) 和progressValue值变次数一样多
 * didFinishNavigation
 * 
 * web方有认证协议/无重定向 成功 https://m.baidu.com
 * decidePolicyForNavigationAction (type-other) https://m.baidu.com
 * didStartProvisionalNavigation
 * didReceiveAuthenticationChallenge
 * decidePolicyForNavigationResponse
 * didCommitNavigation
 * didReceiveAuthenticationChallenge ... (多次)
 * didFinishNavigation
 *
 * web方自定义协议 未测
 *
 * 无证书/有重定向 成功 http://nm.lf.cn/index-iphone.shtml
 * decidePolicyForNavigationAction (type-other) nm.lf.cn
 * didStartProvisionalNavigation
 * decidePolicyForNavigationAction (type-other) m.lf.cn
 * decidePolicyForNavigationResponse
 * didCommitNavigation
 * didFinishNavigation
 *
 * 无证书/无重定向 成功
 *     http://www.soyoung.work/phone.html
 *     http://new.m.lf.cn/index/test
 * decidePolicyForNavigationAction (type-other)
 * didStartProvisionalNavigation
 * decidePolicyForNavigationResponse
 * didCommitNavigation
 * didFinishNavigation
 *
 * 无证书 失败 http://www.soyoung.work/phone.html
 * decidePolicyForNavigationAction (type-other)
 * didStartProvisionalNavigation
 * didFailProvisionalNavigation
 * 
 * bundle中的web文件
 * decidePolicyForNavigationAction (type-other)
 * didStartProvisionalNavigation
 * decidePolicyForNavigationResponse
 * didCommitNavigation
 * didFinishNavigation
 */
// 在发送请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。web内跳转问题, webView、navigationAction相关信息决定这次跳转是否可以继续进行,这些信息包含HTTP发送请求，如头部包含User-Agent,Accept
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"[navi] decidePolicyForNavigationAction : %@ | %@ | %zd", navigationAction.request.mainDocumentURL, navigationAction.request.URL.host.lowercaseString, navigationAction.navigationType);
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow; // 允许在web上继续加载
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: { // 链接的href属性被用户激活
            actionPolicy = WKNavigationActionPolicyAllow;
            break;
        }
        case WKNavigationTypeFormSubmitted: { // 一个表单提交
            actionPolicy = WKNavigationActionPolicyAllow;
            break;
        }
        case WKNavigationTypeBackForward: { // 回到前面/后面条目列表请求
            actionPolicy = WKNavigationActionPolicyAllow;
            break;
        }
        case WKNavigationTypeReload: { // 重新载入
            actionPolicy = WKNavigationActionPolicyAllow;
            break;
        }
        case WKNavigationTypeFormResubmitted: { // 一个表单提交(例如通过前进,后退,或重新加载)
            actionPolicy = WKNavigationActionPolicyAllow;
            break;
        }
        default: { // WKNavigationTypeOther , 导航是发生一些其他原因
            actionPolicy = WKNavigationActionPolicyAllow;
            break;
        }
    }
    decisionHandler(actionPolicy);
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"[navi] didStartProvisionalNavigation : %@ | %@", webView.URL.host, [navigation class]);
}
// 当客户端收到服务器的响应头, 根据response相关信息, 可以决定这次跳转是否可以继续进行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"[navi] decidePolicyForNavigationResponse : %@", webView.URL.host);
    if (!navigationResponse.isForMainFrame) {
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

// 接收到服务器redirect跳转请求之后调用, 主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"[navi] didReceiveServerRedirectForProvisionalNavigation : %@ | %@", webView.URL.host,  [navigation class]);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"[navi] didFailProvisionalNavigation : %@ | %@ | %@", webView.URL.host, [navigation class], error);
}
// 当内容开始返回时调用, 当内容达到main frame时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"[navi] didCommitNavigation : %@ | %@", webView.URL.host, [navigation class]);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"[navi] didFinishNavigation : %@ | %@ [canBack %zd]", webView.URL.host, [navigation class], webView.canGoBack);
    NSString *host = webView.URL.host;
    NSString *sourceString = [NSString stringWithFormat:@"网页由 %@ 提供", host];
    _sourceLabel.text = host?sourceString:@"未知来源";
    
    __weak __typeof__(self) weak_self = self;
    if (webView.canGoBack) {
        if (self.navigationItem.leftBarButtonItems.count == 0) {
            [self addNavigationBarLeftItem:@"🔙" image:nil actionBlock:^{
                if (weak_self.webView.canGoBack) {
                    [weak_self.webView goBack];
                } else {
                    if (weak_self.presentingViewController) {
                        [weak_self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [weak_self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
        } else if (self.navigationItem.leftBarButtonItems.count == 1) {
            [self addNavigationBarLeftItem:@"❌" image:nil actionBlock:^{
                if (weak_self.presentingViewController) {
                    [weak_self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [weak_self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else {
            
        }
    } else {
        [self removeNavigationBarLeftItemAtIndex:1];
    }
    
    [self runJavaScriptCodeWithString:@"say()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"oc 调用 js 的方法say() ret(%@), js是否响应了是不知道的 err(%@)",result, error);
    }];
}
// 导航失败时调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"[navi] didFailNavigation : %@ | %@]", webView.URL.host, [navigation class]);
}
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的 验证中/加载中...被多次调用
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSString *sslHost = challenge.protectionSpace.host;
    NSLog(@"[navi] didReceiveAuthenticationChallenge host : %@ | %@", webView.URL.host, sslHost); // ssl证书中的域名
//    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, [NSURLCredential credentialWithIdentity:<#(nonnull SecIdentityRef)#> certificates:<#(nullable NSArray *)#> persistence:<#(NSURLCredentialPersistence)#>]);
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, [NSURLCredential new]);
}
// ios9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"[navi] webViewWebContentProcessDidTerminate");
}
#pragma mark - 懒加载
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _kBATNaviBarHeight-0.5, self.view.width, 0.5)];
    }
    return _progressView;
}
- (void)dealloc {
    // 移除KVO
    [_webView removeObserver:self forKeyPath:_kWKWebViewProgressKeyPath];
    [_webView removeObserver:self forKeyPath:_kWKWebViewTitleKeyPath];
    
    // 移除js<->oc相关
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sayhello"];

    // 接下来自动会调用[super dealloc];
}
#pragma mark - 内存溢出
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

///////////////////////////    /////////////////////////
@implementation ScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"\nhandler:%@ \nname:%@ \nbody:%@ \nframeInfo:%@ \n",self, message.name,message.body,message.frameInfo);

    if ([self.delegate respondsToSelector:@selector(handler:withUserContentController:didReceiveScriptMessage:)]) {
        [self.delegate handler:self withUserContentController:userContentController didReceiveScriptMessage:message];
    }
}
@end




