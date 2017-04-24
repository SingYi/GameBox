//
//  WebViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/24.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

/**web视图*/
@property (nonatomic, strong) UIWebView * webView;;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.185sy.net/news/155.html"]]];
    [self.view addSubview:self.webView];
}

- (void)setWebURL:(NSString *)webURL {
    _webURL = webURL;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
}

#pragma makr - getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat: @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>", error.localizedDescription];
    [self.webView loadHTMLString:errorString baseURL:nil];
}



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
