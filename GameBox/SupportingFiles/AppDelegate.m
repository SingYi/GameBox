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
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [ControllerManager shareManager].rootViewController;
    
    [self.window makeKeyAndVisible];
    
    [ChangyanSDK registerApp:@"cysYKUClL"
                      appKey:@"6c88968800e8b236e5c69b8634db704d"
                 redirectUrl:nil
        anonymousAccessToken:nil];
    
//    [ChangyanSDK setAllowSelfLogin:YES];
//    
//    [ChangyanSDK setAllowAnonymous:NO];
//    [ChangyanSDK setAllowRate:NO];
//    [ChangyanSDK setAllowUpload:YES];
//    [ChangyanSDK setAllowWeiboLogin:NO];
//    [ChangyanSDK setAllowQQLogin:NO];
//    [ChangyanSDK setAllowSohuLogin:NO];
    
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
            syLog(@"%@",content);
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
    
    
    [self resignNotifacation];
    
    return YES;
}

/** 注册通知 */
- (void)resignNotifacation {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:granted], NOTIFICATIONSETTING);
        } else {
            SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], NOTIFICATIONSETTING);
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
