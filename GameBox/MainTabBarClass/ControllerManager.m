//
//  ControllerManager.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ControllerManager.h"


@interface ControllerManager ()




@end



static ControllerManager *manager = nil;

@implementation ControllerManager

/** 单利 */
+ (ControllerManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ControllerManager alloc]init];
    });
    return manager;
}

#pragma mark - method
/** 加载动画 */
+ (void)starLoadingAnimation {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 44, 44);
    imageView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
    NSMutableArray<UIImage *> *imageArray = [NSMutableArray arrayWithCapacity:12];
    
    for (NSInteger i = 1; i <= 12; i++) {
        NSString *str = [NSString stringWithFormat:@"downLoadin_%ld",i];
        UIImage *image = [UIImage imageNamed:str];
        
        [imageArray addObject:image];
    }
    
    
    imageView.animationImages = imageArray;
    imageView.animationDuration = 0.8;
    imageView.animationRepeatCount = 1111111;
    [imageView startAnimating];
    
    [[ControllerManager shareManager].animationWindow addSubview:imageView];

    [[ControllerManager shareManager].animationWindow makeKeyAndVisible];

    
}
/** 停止加载动画 */
+ (void)stopLoadingAnimation {
    [ControllerManager shareManager].animationWindow = nil;
}



#pragma mark - getter 
/** 根视图 */
- (UINavigationController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [[UINavigationController alloc]initWithRootViewController:self.tabbarController];
        _rootViewController.navigationBarHidden = YES;
    }
    return _rootViewController;
}

/** tabbar控制器 */
- (MainTabBarController *)tabbarController {
    if (!_tabbarController) {
        _tabbarController = [[MainTabBarController alloc]init];
    }
    return _tabbarController;
}

/** 我的礼包视图 */
- (MyGiftBagViewController *)myGiftBagView {
    if (!_myGiftBagView) {
        _myGiftBagView = [MyGiftBagViewController new];
    }
    return _myGiftBagView;
}

/** 游戏详情页面 */
- (DetailViewController *)detailView {
    if (!_detailView) {
        _detailView = [DetailViewController new];
    }
    return _detailView;
}

/** 网页 */
- (WebViewController *)webController {
    if (!_webController) {
        _webController = [[WebViewController alloc] init];
        
    }
    return _webController;
}

/** 登录控制器 */
- (LoginViewController *)loginViewController {
    if (!_loginViewController) {
        _loginViewController = [[LoginViewController alloc] init];
    }
    return _loginViewController;
}

/** 搜索视图 */
- (SearchViewController *)searchViewController {
    if (!_searchViewController) {
        _searchViewController = [[SearchViewController alloc] init];
    }
    return _searchViewController;
}

/** 搜搜结果视图 */
- (SearchResultViewController *)searchResultController {
    if (!_searchResultController) {
        _searchResultController = [[SearchResultViewController alloc] init];
    }
    return _searchResultController;
}

/** 我的应用 */
- (MyAppViewController *)myAppViewController {
    if (!_myAppViewController) {
        _myAppViewController = [[MyAppViewController alloc] init];
    }
    return _myAppViewController;
}

/** 我的消息 */
- (MyNewsView *)myNewsViewController {
    if (!_myNewsViewController) {
        _myNewsViewController = [[MyNewsView alloc] init];
    }
    return _myNewsViewController;
}


/** 动画的window */
- (UIWindow *)animationWindow {
    if (!_animationWindow) {
        _animationWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _animationWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _animationWindow;
}


@end
