//
//  BaseWebController.h
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//
/**
 * 用于显示web页面, 可以当做WK的教科书
 * 使用WebKit库，需要手动引用 WKWebView >=iOS8
 * 实现了js<->oc互相调用
 */
#import "BaseViewController.h"
#import <WebKit/WebKit.h>
///////////////////  handler 的js <-> oc 交互协议  ///////////////////
// js->oc 需要下面这个handler定义的协议
@class ScriptMessageHandler;
@protocol ScriptHandlerDelegate <NSObject>
// oc收到js发来消息时调用
- (void)handler:(nullable ScriptMessageHandler *)handler withUserContentController:(nullable WKUserContentController *)userContentController didReceiveScriptMessage:(nullable WKScriptMessage *)message;
@end
///////////////////  js <-> oc handler类  ///////////////////
@interface ScriptMessageHandler : NSObject <WKScriptMessageHandler> // WKScriptMessageHandler-js调oc
@property(nullable, nonatomic, weak) id<ScriptHandlerDelegate> delegate;
@end


///////////////////////////  WKWebViewController  /////////////////////////
@interface BaseWebController : BaseViewController <WKUIDelegate, WKNavigationDelegate, ScriptHandlerDelegate>
@property (nullable, nonatomic, readonly) UILabel         *sourceLabel;
@property (nullable, nonatomic, readonly) WKWebView       *webView;
@property (nullable, nonatomic, readonly) UIProgressView  *progressView;

@end




