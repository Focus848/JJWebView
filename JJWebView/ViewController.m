//
//  ViewController.m
//  JJWebView
//
//  Created by LiHong on 15/12/22.
//  Copyright © 2015年 李红(lh.coder@foxmail.com). All rights reserved.
//

#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "JJWebView.h"
#import "ViewController.h"

@interface ViewController ()<JJWebViewDelegateForward>
@property (strong, nonatomic)  JJWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _webView = [[JJWebView alloc] initWithFrame:self.view.bounds];
    _webView.webViewDelegate = self;
    _webView.dataDetectorTypes = UIDataDetectorTypeLink;
    _webView.userInteractionEnabled = YES;
    _webView.scrollView.bounces = NO;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.doubanmeizi.com"]];
    [req setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [_webView loadRequest:req];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JJWebViewDelegateForward
- (void)jj_WebView:(JJWebView *)webView clickOnImageView:(UIImageView *)showImageView indexOfImageView:(NSUInteger)imageIndex allImageURLString:(NSArray<NSString *> *)allImageURLString {
    NSMutableArray *photos = [NSMutableArray array];
    for (NSUInteger i = 0; i < allImageURLString.count; i++) {
        NSURL *url = [NSURL URLWithString:[allImageURLString objectAtIndex:i]];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:showImageView];
    [browser setInitialPageIndex:imageIndex];
    browser.scaleImage = showImageView.image;
    browser.usePopAnimation = YES;
    browser.displayDoneButton = NO;
    browser.displayCounterLabel = YES;
    [self presentViewController:browser animated:YES completion:^{
        [showImageView removeFromSuperview];
    }];
}

- (BOOL)jj_WebView:( JJWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)jj_WebViewDidStartLoad:(JJWebView *)webView {
    
}

- (void)jj_WebViewDidFinishLoad:(JJWebView *)webView {
    
}

- (void)jj_WebView:(JJWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@\n%@",error.localizedDescription,error.localizedFailureReason);
}
@end
