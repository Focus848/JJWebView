//
//  JJWebView.h
//  JJWebView
//
//  Created by LiHong on 15/12/22.
//  Copyright © 2015年 李红(lh.coder@foxmail.com). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJWebViewDelegateForward;
@interface JJWebView : UIWebView <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet id<JJWebViewDelegateForward> webViewDelegate;
@end

NS_ASSUME_NONNULL_BEGIN

/// WebView代理转发
@protocol JJWebViewDelegateForward <NSObject>
@optional
- (BOOL)jj_WebView:( JJWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)jj_WebViewDidStartLoad:(JJWebView *)webView;
- (void)jj_WebViewDidFinishLoad:(JJWebView *)webView;
- (void)jj_WebView:(JJWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)jj_WebView:(JJWebView *)webView clickOnImageView:(UIImageView *)showImageView indexOfImageView:(NSUInteger)imageIndex allImageURLString:(NSArray<NSString *> *)allImageURLString;
@end

NS_ASSUME_NONNULL_END
