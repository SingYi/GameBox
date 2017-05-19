//
//  AppDelegate.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "AppDelegate.h"
#import "ControllerManager.h"
#import "LaunchScreen.h"
#import "RequestUtils.h"
#import "AppModel.h"
#import "ChangyanSDK.h"
#import "GameRequest.h"
#import <UserNotifications/UserNotifications.h>
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>



#define WEIXINAPPID @"wx7ec31aabe8cc710d"
#define QQAPPID @"1106099979"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>



@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [ControllerManager shareManager].rootViewController;
    
    [self.window makeKeyAndVisible];
    
    //注册畅言SDK
    [ChangyanSDK registerApp:@"cysYKUClL"
                      appKey:@"6c88968800e8b236e5c69b8634db704d"
                 redirectUrl:nil
        anonymousAccessToken:nil];
    
    //注册微信
    [WXApi registerApp:WEIXINAPPID];
    
    //注册QQ
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:nil];
    
    
    //第一次登陆
    NSString *isFirst = [[NSUserDefaults standardUserDefaults] stringForKey:@"isFirst"];
    
    
    if (!isFirst) {
        
        
        [self.window addSubview:[LaunchScreen new]];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    //请求数据总借口
    [RequestUtils postRequestWithURL:URLMAP params:nil completion:^(NSDictionary *content, BOOL success) {
        if (success && !((NSString *)content[@"status"]).boolValue) {
            NSDictionary *dict = content[@"data"];
            NSArray *keys = [dict allKeys];
            [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SAVEOBJECT_AT_USERDEFAULTS(dict[obj], obj);
            }];
            SAVEOBJECT_AT_USERDEFAULTS(keys, @"MAP");
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
    //存入本地游戏列表
    [AppModel getLocalGamesWithBlock:^(NSArray * _Nullable games, BOOL success) {
        if (success) {
            [AppModel saveLocalGamesWithArray:games];
        }
    }];
    
    //注册通知
    [self resignNotifacation];
    
    //仅在WIFI下下载游戏
    SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:YES], WIFIDOWNLOAD);
    SAVEOBJECT;
    
    //检查更新
    [self cheackVersion];

    

    
    return YES;
}

/** 注册通知 */
- (void)resignNotifacation {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    [center removeAllDeliveredNotifications];
    
    //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:granted], NOTIFICATIONSETTING);
        } else {
            SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], NOTIFICATIONSETTING);
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    
    
}

//检查版本更新
- (void)cheackVersion {
    [GameRequest chechBoxVersionCompletion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {

            NSString *update = content[@"data"];
            if ([update isKindOfClass:[NSNull class]]) {
                
            } else {
                [GameRequest boxUpdateWithUrl:content[@"data"]];
            }
        }
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    [self cheackVersion];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}






#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //1. 处理通知
    
    
    
    
    
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}


@end






