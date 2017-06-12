//
//  WebViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/24.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "ControllerManager.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

/**web视图*/
@property (nonatomic, strong) WKWebView * webView;

/** 进度条 */
@property (nonatomic, strong) UIImageView *progressView;

/** 无法加载页面 */
@property (nonatomic, strong) UIImageView *ImageBackView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setWebURL:(NSString *)webURL {
    _webURL = webURL;
    [self.ImageBackView removeFromSuperview];
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
//    webURL = @"http://qm.qq.com/cgi-bin/qm/qr?k=9ueFqAZ5F1V6TUpWi5y29htTh68b_Bpa";
    url = [NSURL URLWithString:webURL];
    request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.progressView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        NSString *new = change[@"new"];
        
        self.progressView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * new.floatValue * 2, 2);
        
        if(_webView.estimatedProgress >= 1.0f) {
            
            self.progressView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 2, 2);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView removeFromSuperview];
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma makr - getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    }
    return _webView;
}

- (UIImageView *)progressView {
    if (!_progressView) {
        _progressView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webView_progress"]];
        _progressView.frame = CGRectMake(0, 65, 0, 0);
    }
    return _progressView;
}

- (UIImageView *)ImageBackView {
    if (!_ImageBackView) {
        _ImageBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _ImageBackView.image = [UIImage imageNamed:@"wuwangluo"];
    }
    return _ImageBackView;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}

// ================
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //页面加载失败
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"页面加载失败,请检查网络" preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    [self.view addSubview:self.ImageBackView];
    
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}




@end
