//
//  ControllerManager.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "MyGiftBagViewController.h"
#import "DetailViewController.h"
#import "WebViewController.h"
#import "LoginViewController.h"

@interface ControllerManager : NSObject


/**< 根视图 */
@property (nonatomic, strong) UINavigationController *rootViewController;

//tabbar
@property (nonatomic, strong) MainTabBarController *tabbarController;

/**< 我的礼包 */
@property (nonatomic, strong) MyGiftBagViewController *myGiftBagView;

/**游戏详情页面*/
@property (nonatomic, strong) DetailViewController *detailView;

/**网页视图*/
@property (nonatomic, strong) WebViewController *webController;

/**< 登录页面 */
@property (nonatomic, strong) LoginViewController *loginViewController;

/**< manager的单利 */
+ (ControllerManager *)shareManager;


@end
