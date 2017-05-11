//
//  WebViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/24.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

/**web视图*/
@property (nonatomic, strong) WKWebView * webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setWebURL:(NSString *)webURL {
    _webURL = webURL;
    syLog(@"%@",webURL);
    
//    NSString *urlStr = [NSString stringWithFormat:@"https://m.baidu.com/"];
    
    NSURL *url = [NSURL URLWithString:webURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma makr - getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    syLog(@"star");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    syLog(@"finsh");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    syLog(@"error === %@",error.localizedDescription);
}




@end
