//
//  JJWebView.m
//  JJWebView
//
//  Created by LiHong on 15/12/22.
//  Copyright © 2015年 李红(lh.coder@foxmail.com). All rights reserved.
// http://yulingtianxia.com/blog/2015/10/20/Try-to-implement-picture-browser-mode-on-webview/

#import "JJWebView.h"

@implementation JJWebView

- (instancetype) init {
    if (self = [super init]) {
        [self doInitWork];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self doInitWork];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self doInitWork];
    }
    return self;
}


- (void)doInitWork {
    self.delegate = self;
}


- (void)addJavaScript {
    NSString *script =
    @"function setImage(){\
      var imgs = document.getElementsByTagName(\"img\");\
        for (var i=0;i<imgs.length;i++){\
            imgs[i].setAttribute(\"onClick\",\"imageClick(\"+i+\")\");\
        }\
    }\
    function imageClick(i){\
        var rect = getImageRect(i);\
        var url=\"lh2wqq1314::\"+i+\"::\"+rect;\
        document.location = url;\
    }\
    function getImageRect(i){\
        var imgs = document.getElementsByTagName(\"img\");\
        var rect;\
        rect = imgs[i].getBoundingClientRect().left+\"::\";\
        rect = rect+imgs[i].getBoundingClientRect().top+\"::\";\
        rect = rect+imgs[i].width+\"::\";\
        rect = rect+imgs[i].height;\
        return rect;\
    }\
    function getAllImageUrl(){\
        var imgs = document.getElementsByTagName(\"img\");\
        var urlArray = [];\
        for (var i=0;i<imgs.length;i++){\
            var src = imgs[i].src;\
            urlArray.push(src);\
        }\
        return urlArray.toString();\
    }\
    function getImageData(i){\
        var imgs = document.getElementsByTagName(\"img\");\
        var img=imgs[i]; \
        var canvas=document.createElement(\"canvas\"); \
        var context=canvas.getContext(\"2d\"); \
        canvas.width=img.width; canvas.height=img.height; \
        context.drawImage(img,0,0,img.width,img.height); \
        return canvas.toDataURL(\"image/png\") \
    }";
    [self stringByEvaluatingJavaScriptFromString:script];
    [self stringByEvaluatingJavaScriptFromString:@"setImage()"];
}

- (void)parseRequest:(NSURLRequest *)request {
    NSString *reqURLString = [[request URL] absoluteString];
    NSArray *components = [reqURLString componentsSeparatedByString:@"::"];
    @try {
        if ([components[0] isEqualToString:@"lh2wqq1314"]) {
            int imgIndex = [components[1] intValue];
            CGRect frame = CGRectMake([components[2] floatValue], [components[3] floatValue], [components[4] floatValue], [components[5] floatValue]);
            UIImageView *showImageView = [[UIImageView alloc] initWithFrame:frame];
            [self addSubview:showImageView];
            NSString *javascript = [NSString stringWithFormat:@"getImageData(%d);", imgIndex];
            NSString *imageBase64 = [self stringByEvaluatingJavaScriptFromString:javascript];
            imageBase64 = [imageBase64 substringFromIndex:22]; // strip the string "data:image/png:base64,"
            NSData *data = [[NSData alloc] initWithBase64EncodedString:imageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            showImageView.image = [UIImage imageWithData:data];
            NSString *urls = [self stringByEvaluatingJavaScriptFromString:@"getAllImageUrl();"];
            NSArray *URLStringArray = [urls componentsSeparatedByString:@","];
            
            if(_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(jj_WebView:clickOnImageView:indexOfImageView:allImageURLString:)]) {
                [_webViewDelegate jj_WebView:self clickOnImageView:showImageView indexOfImageView:imgIndex allImageURLString:URLStringArray];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"\n\nJJWebViw:%@\n\n",[exception name]);
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self parseRequest:request];

    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(jj_WebView:shouldStartLoadWithRequest:navigationType:)]) {
       return [_webViewDelegate jj_WebView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(jj_WebViewDidStartLoad:)]) {
        [_webViewDelegate jj_WebViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self addJavaScript];
    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(jj_WebViewDidFinishLoad:)]) {
        [_webViewDelegate jj_WebViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewDelegate jj_WebView:self didFailLoadWithError:error];
    }
}
@end

