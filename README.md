# JJWebView

```Objective-c
- (BOOL)jj_WebView:( JJWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- 
- (void)jj_WebViewDidStartLoad:(JJWebView *)webView;
- 
- (void)jj_WebViewDidFinishLoad:(JJWebView *)webView;
- 
- (void)jj_WebView:(JJWebView *)webView didFailLoadWithError:(NSError *)error;
- 
- (void)jj_WebView:(JJWebView *)webView clickOnImageView:(UIImageView *)showImageView indexOfImageView:(NSUInteger)imageIndex allImageURLString:(NSArray<NSString *> *)allImageURLString;

```
