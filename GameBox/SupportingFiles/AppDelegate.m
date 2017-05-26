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

#import "ChangyanSDK.h"
#import "GameRequest.h"
#import <TencentOpenAPI/TencentOAuth.h>

#import "ExceptionHandlerTool.h"



#define WEIXINAPPID @"wx7ec31aabe8cc710d"
#define QQAPPID @"1106099979"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>



@end


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //视图
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [ControllerManager shareManager].rootViewController;
    
    [self.window makeKeyAndVisible];
    
    //第一次登陆
    NSString *isFirstGuide = [[NSUserDefaults standardUserDefaults] stringForKey:@"isFirstGuide"];
    
    //引导页
    if (!isFirstGuide) {
        [self.window addSubview:[LaunchScreen new]];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstGuide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    //第一次安装
    NSString *isFirstInstall = [[NSUserDefaults standardUserDefaults] stringForKey:@"isFirstInstall"];
    if (!isFirstInstall) {
        //每次启动统计
        [GameRequest gameBoxStarUpWithCompletion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                [GameRequest gameBoxInstallWithCompletion:^(NSDictionary * _Nullable content, BOOL success) {
                    if (success && REQUESTSUCCESS) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstInstall"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }];
            }
        }];
    } else {
        //每次启动统计
        [GameRequest gameBoxStarUpWithCompletion:nil];
    }
    

    
    //请求数据总接口
    [RequestUtils postRequestWithURL:URLMAP params:nil completion:^(NSDictionary *content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            NSDictionary *dict = content[@"data"];
            NSArray *keys = [dict allKeys];
            [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SAVEOBJECT_AT_USERDEFAULTS(dict[obj], obj);
            }];
            SAVEOBJECT_AT_USERDEFAULTS(keys, @"MAP");
            SAVEOBJECT;
        }
    }];
    
    
    //注册通知
    [self resignNotifacation];
    
    //仅在WIFI下下载游戏
    SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:YES], WIFIDOWNLOAD);
    SAVEOBJECT;
    
    //检查更新
    [self cheackVersion];

    //监听崩溃
    InstallUncaughtExceptionHandler();
    
    //获取所有的游戏名
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [GameRequest allGameWithType:AllName Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                [GameRequest saveAllGameNameWithArry:content[@"data"]];
            }
        }];
    });
    
    
    //注册畅言SDK
    [ChangyanSDK registerApp:@"cysYKUClL"
                      appKey:@"6c88968800e8b236e5c69b8634db704d"
                 redirectUrl:nil
        anonymousAccessToken:nil];
    
    //注册微信
    [WXApi registerApp:WEIXINAPPID];
    
    //注册QQ
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:nil];
    
    [oAuth isSessionValid];
    
    
    //上传异常
    NSString *waringString = OBJECT_FOR_USERDEFAULTS(@"BoxWarring");
    if (waringString) {
        [GameRequest gameBOxUploadWarring:waringString Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                SAVEOBJECT_AT_USERDEFAULTS(nil, @"BoxWarring");
                SAVEOBJECT;
            }
        }];
    }
    
    
    //多线程加载数据(请求所有游戏的详细信息,保存在本地)
    [GameRequest allGameWithType:AllBackage Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {

            NSArray *array = content[@"data"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //请求每个游戏信息
                    [GameRequest gameInfoWithGameID:obj[@"id"] Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
                        if (success && REQUESTSUCCESS) {
                            //请求道的游戏信息保存到数据库
                            [GameRequest saveGameAtLocalWithDictionary:content[@"data"][@"gameinfo"]];
                            
                            //缓存图片
                            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,content[@"data"][@"gameinfo"][@"logo"]]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                if (finished) {
                                    [GameRequest saveGameLogoData:image WithGameID:obj[@"id"]];
                                }
                            }];
                            //所有游戏本地保存完毕,获取本地所有应用,比对,获取到本地的游戏
                            if (idx == array.count - 1) {
                                //获取本地游戏保存
                                [GameRequest saveLocalGameAtLocal];
                            }

                        }
                    }];
                    
                }];
                
                
                [AppModel getLocalGamesWithBlock:^(NSArray * _Nullable games, BOOL success) {
                    if (success) {
                        [AppModel saveLocalGamesWithArray:games];
                    }
                }];
                
                
            });
        }
    }];
    

    
    
//    //3DTouch
//    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
//    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"item2" localizedTitle:@"分享" localizedSubtitle:@"" icon:shareIcon userInfo:nil];
//    
//    /** 将items 添加到app图标 */
//    application.shortcutItems = @[shareItem];
    
    
    
    syLog(@"diviceID ===== %@",[GameRequest DeviceID]);
    
    return YES;
}

//- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
//    if ([shortcutItem.localizedTitle isEqualToString:@"分享"]) {
//       
//    }
//    
//}


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
    
    //保存上下文
    [self saveContext];
}






#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //1. 处理通知
    

    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}



#pragma mark - ============================CoreData==========================================
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Game185"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        context = self.persistentContainer.viewContext;
        
    } else {
        
        context = self.managedObjectContext;
    }
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        abort();
    }
}

#pragma mark - Core Data stack 9.0
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectContext *)managedObjectContext {
    
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        return self.persistentContainer.viewContext;
    }
    
    
    NSPersistentStoreCoordinator *cordinator = [self persistentStoreCoordinator];
    
    if (cordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:cordinator];
    }

    return _managedObjectContext;
    
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"Game185" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSURL *storeURL = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Game185.sqlite"]];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    
    //版本迁移
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                NSInferMappingModelAutomaticallyOption:@(YES)};
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    }
    return _persistentStoreCoordinator;
}



@end






