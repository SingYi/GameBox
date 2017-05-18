//
//  GameRequest.m
//  GameBox
//
//  Created by 石燚 on 2017/5/5.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameRequest.h"
#import "UserModel.h"
#import <UserNotifications/UserNotifications.h>
#import <WXApi.h>

#define GAME_INDEX @"http://www.185sy.com/api-game-index"
#define GAME_TYPE @"http://www.185sy.com/api-game-gameType"
#define OPEN_SERVER @"http://www.185sy.com/api-game-openServer"
#define GAME_INFO @"http://www.185sy.com/api-game-gameInfo"
#define GAME_COLLECT @"http:/www.185sy.com/api-game-collect"
#define GAME_CLASS @"http://www.185sy.com/api-game-gameClass"
#define GAME_CLASS_INFO @"http://www.185sy.com/api-game-gameClassInfo"
#define GAME_OPEN_SERVER @"http://www.185sy.com/api-game-gameOpenServer"
#define GAME_GETALLNAME @"http://www.185sy.com/api-game-getAllGameName"
#define GAME_GETHOT @"http://www.185sy.com/api-game-hotGameSearch"
//10
#define GAME_SEARCH_LIST @"http://www.185sy.com/api-game-gameSearchList"
#define GAME_UPDATA @"http://www.185sy.com/api-game-gameUpdata"
#define GAME_CHANNEL_DOWNLOAD @"http://www.185sy.com/api-game-channelDownload"
#define GAME_MY_COLLECT @"http://www.185sy.com/api-game-myCollect"
#define GAME_INSTALL @"http://www.185sy.com/api-game-gameInstall"
#define GAME_UNINSTALL @"http://www.185sy.com/api-game-gameUninstall"
#define GAME_GRADE @"http://www.185sy.com/api-game-gameGrade"
#define GAME_GONGLUE @"http://www.185sy.com/api-article-get_list_by_game"
//18
#define INDEX_ARTICLE @"http://www.185sy.com/api-article-get_list"
#define GAME_CHECK_CLIENT @"http://www.185sy.com/api-game-checkClient"

@implementation GameRequest


//下载游戏
+ (void)downLoadAppWithURL:(NSString *)url {
    if (url && url.length != 0) {
        //网路状态
        NSString *state = [GameRequest getNetWorkStates];
        if ([state isEqualToString:@"wifi"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            NSNumber *isWifiDown = OBJECT_FOR_USERDEFAULTS(WIFIDOWNLOAD);
            if (isWifiDown.boolValue) {
                [GameRequest showAlertWithMessage:@"请链接WIFI下载,或者在设置中将仅用WIFI下载关闭" dismiss:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
    } else {
        [GameRequest showAlertWithMessage:@"下载地址有误" dismiss:nil];
    }
}

+ (NSString *)getNetWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    return state;
}







/** 推荐游戏 
 *  URLKey:GAME_INDEX
 *
 */
+ (void)recommendGameWithPage:(NSString *)page
                   Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!page) {
        page = @"1";
    }
    
    //页数
    [dict setObject:page forKey:@"page"];
    //渠道ID
    [dict setObject:CHANNELID forKey:@"channel"];
    //设备ID
    [dict setObject:@"2" forKey:@"system"];
    
    //请求地址
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_INDEX");
    if (!urlStr) {
        urlStr = GAME_INDEX;
    }

    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];

}

/** 游戏类型接口 */
+ (void)typeGameWithType:(GameType)gameType Page:(NSString *)page Completion:(void (^ _Nullable)(NSDictionary * _Nullable, BOOL))completion {
    
    NSString *type = [NSString stringWithFormat:@"%ld",gameType];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //页数
    [dict setObject:page forKey:@"page"];
    //渠道
    [dict setObject:CHANNELID forKey:@"channel"];
    //系统
    [dict setObject:@"2" forKey:@"system"];
    //游戏类型
    [dict setObject:type forKey:@"type"];

    //请求地址
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_TYPE");
    if (!urlStr) {
        urlStr = GAME_TYPE;
    }

    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
}

/** 新游接口 */
+ (void)newGameWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    if (!page) {
        page = @"1";
    }
    
    [GameRequest typeGameWithType:newGame Page:page Completion:completion];
}

/** 热门 */
+ (void)hotGameWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    if (!page) {
        page = @"1";
    }
    [GameRequest typeGameWithType:hotGame Page:page Completion:completion];
}

/** 排行榜 */
+ (void)rankGameWithhPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    if (!page) {
        page = @"1";
    }
    [GameRequest typeGameWithType:rankingGame Page:page Completion:completion];
}

/** 开服列表 */
+ (void)openGameServerWithType:(openService)serviceTye Page:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSString *type = [NSString stringWithFormat:@"%ld",serviceTye];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:CHANNELID forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    
    //请求地址
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"OPEN_SERVER");
    if (!urlStr) {
        urlStr = OPEN_SERVER;
    }
    
    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
}

+ (void)todayServerOpenWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    [GameRequest openGameServerWithType:TodaySer Page:page Completion:completion];
}

+ (void)CommingSoonServerOpenWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    [GameRequest openGameServerWithType:CommingSoonSer Page:page Completion:completion];
}

+ (void)AlredayServerOpenWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    [GameRequest openGameServerWithType:AlredaySer Page:page Completion:completion];
}

/** 游戏详情 */
+ (void)gameInfoWithGameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:gameID forKey:@"gid"];
    
    [dict setObject:[UserModel uid] forKey:@"uid"];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:CHANNELID forKey:@"channel"];
    
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_INFO");
    if (!urlStr) {
        urlStr = GAME_INFO;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}


/** 单一游戏开服 */
+ (void)gameServerOpenWithGameID:(NSString *)gameID
                      Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSDictionary *dict = @{@"gid":gameID};
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_OPEN_SERVER");
    if (!urlStr) {
        urlStr = GAME_OPEN_SERVER;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 收藏接口 */
+ (void)gameCollectWithType:(CollectionType)collectionType GameID:(NSString *)gameID Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSString *type = [NSString stringWithFormat:@"%ld",collectionType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:type forKey:@"type"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:gameID forKey:@"gid"];
    [dict setObject:[UserModel uid] forKey:@"uid"];
    

    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_COLLECT");
    if (!urlStr) {
        urlStr = GAME_COLLECT;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 游戏分类 */
+ (void)gameClassifyWithPage:(NSString *)page Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:CHANNELID forKey:@"channel"];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:page forKey:@"page"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_CLASS");
    if (!urlStr) {
        urlStr = GAME_CLASS;
    }
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 分类详情 */
+ (void)ClassifyWithID:(NSString *)classifyID
                  Page:(NSString *)page
            Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:classifyID forKey:@"classId"];
    [dict setObject:CHANNELID forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:page forKey:@"page"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_CLASS_INFO");
    if (!urlStr) {
        urlStr = GAME_CLASS_INFO;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 所有游戏名或者包名 */
+ (void)allGameWithType:(AllType)type Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
    [dict setObject:CHANNELID forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];

    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_GETALLNAME");
    if (!urlStr) {
        urlStr = GAME_GETALLNAME;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 搜索热门 */
+ (void)searchHotGameCompletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:CHANNELID forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_GETHOT");
    if (!urlStr) {
        urlStr = GAME_GETHOT;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

+ (void)searchGameWithKeyword:(NSString *)keyword Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:CHANNELID forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:keyword forKey:@"keyword"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_SEARCH_LIST");
    if (!urlStr) {
        urlStr = GAME_SEARCH_LIST;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}


+ (void)gameUpdateWithIDs:(NSString *)ids Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:ids forKey:@"ids"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_UPDATA");
    if (!urlStr) {
        urlStr = GAME_UPDATA;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 子渠道下载地址 */
+ (void)downLoadGameWithTag:(NSString *)tag ChannelID:(NSString *)channelID Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:tag forKey:@"tag"];
    [dict setObject:channelID forKey:@"channel"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_CHANNEL_DOWNLOAD");
    if (!urlStr) {
        urlStr = GAME_CHANNEL_DOWNLOAD;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 我的收藏 */
+ (void)myCollectionGameWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:[UserModel uid] forKey:@"uid"];
    [dict setObject:page forKey:@"page"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_MY_COLLECT");
    if (!urlStr) {
        urlStr = GAME_MY_COLLECT;
    }
    

    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 游戏安装 */
+ (void)gameInstallWithGameID:(NSString *)gameID gamePack:(NSString *)gamePackName gameVersion:(NSString *)gameVersion Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:gamePackName forKey:@"pack"];
    [dict setObject:gameVersion forKey:@"version"];
    [dict setObject:gameID forKey:@"gid"];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:[GameRequest DeviceID] forKey:@"code"];
    [dict setObject:CHANNELID forKey:@"channel"];
    if ([UserModel CurrentUser]) {
        [dict setObject:[UserModel uid] forKey:@"uid"];
    }
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_INSTALL");
    if (!urlStr) {
        urlStr = GAME_INSTALL;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
    
}

+ (void)gameUninstallWithGamePackName:(NSString *)gamePackName Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:gamePackName forKey:@"pack"];
//    [dict setObject:gameVersion forKey:@"version"];
//    [dict setObject:gameID forKey:@"gid"];
    
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:[GameRequest DeviceID] forKey:@"code"];
    [dict setObject:CHANNELID forKey:@"channel"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_UNINSTALL");
    if (!urlStr) {
        urlStr = GAME_UNINSTALL;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

+ (void)gameGradeWithSorce:(NSString *)sorce GameID:(NSString *)gameID UserID:(NSString *)uid Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:sorce forKey:@"sorce"];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:gameID forKey:@"gid"];
    
    [dict setObject:@"2" forKey:@"system"];

    [dict setObject:CHANNELID forKey:@"channel"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_GRADE");
    if (!urlStr) {
        urlStr = GAME_GRADE;
    }
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 活动 */
+ (void)activityWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:CHANNELID forKey:@"channel_id"];

    if (page) {
        [dict setObject:page forKey:@"page"];
    } else {
        [dict setObject:@"1" forKey:@"page"];
    }
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"INDEX_ARTICLE");
    if (!urlStr) {
        urlStr = INDEX_ARTICLE;
    }
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 攻略 */
+ (void)setrategyWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:CHANNELID forKey:@"channel_id"];
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    } else {
        [dict setObject:@"1" forKey:@"page"];
    }
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"INDEX_ARTICLE");
    if (!urlStr) {
        urlStr = INDEX_ARTICLE;
    }
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 搜索攻略 */
+ (void)searchStrategyWithKeyword:(NSString *)keyword
                             Page:(NSString * _Nonnull)page
                       Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:CHANNELID forKey:@"channel_id"];
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    } else {
        [dict setObject:@"1" forKey:@"page"];
    }
    
    [dict setObject:keyword forKey:@"search"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"INDEX_ARTICLE");
    if (!urlStr) {
        urlStr = INDEX_ARTICLE;
    }
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 游戏相关攻略 */
+ (void)setrategyWIthGameID:(NSString *)gameID Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:gameID forKey:@"game_id"];
    
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:CHANNELID forKey:@"channel_id"];
    [dict setObject:@"1" forKey:@"page"];
    
    
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_GONGLUE");
    if (!urlStr) {
        urlStr = GAME_GONGLUE;
    }
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

/** 客户端检查更新 */
+ (void)chechBoxVersionCompletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:CHANNELID forKey:@"channel_id"];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"CFBundleVersion"]];
    [dict setObject:version forKey:@"version"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_CHECK_CLIENT");
    if (!urlStr) {
        urlStr = GAME_CHECK_CLIENT;
    }
    
    [GameRequest postRequestWithURL:urlStr params:dict completion:completion];
}

+ (void)boxUpdateWithUrl:(NSString *)url {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:@"游戏有更新,前往更新" preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[self getNetWorkStates] isEqualToString:@"wifi"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为流量" message:@"是否前去更新" preferredStyle:UIAlertControllerStyleAlert];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }]];
        }
    }]];

}


//使用 UNNotification 本地通知
+ (void)registerNotificationWith:(NSDate * _Nonnull)alerTime
                           Title:(NSString * _Nullable)title
                         Detail:(NSString * _Nullable)detail
                      Identifier:(NSString * _Nonnull)identifier
                        GameDict:(NSDictionary *_Nonnull)dict {
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    
    content.body = [NSString localizedUserNotificationStringForKey:detail arguments:nil];
    content.sound = [UNNotificationSound defaultSound];

    //设置推送时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M";
    NSString *month = [formatter stringFromDate:alerTime];
    formatter.dateFormat = @"d";
    NSString *day = [formatter stringFromDate:alerTime];
    formatter.dateFormat = @"H";
    NSString *hour = [formatter stringFromDate:alerTime];
    formatter.dateFormat = @"m";
    NSString *minute = [formatter stringFromDate:alerTime];
    

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month.integerValue;
    components.day = day.integerValue;
    components.hour = hour.integerValue;
    components.minute = minute.integerValue;

    
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:calendarTrigger];
    
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            [GameRequest showAlertWithMessage:@"提醒添加失败" dismiss:nil];
        } else {
            [GameRequest addNotificationRecordWith:dict];
            [GameRequest showAlertWithMessage:@"提醒添加成功" dismiss:nil];
        }
    }];
}

/** 移除通知 */
+ (void)deleteNotificationWithIdentifier:(NSString *)identifier {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
}

/** 获取路径 */
+ (NSString *)getPlistPathWithFileName:(NSString *)fileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [path stringByAppendingPathComponent:fileName];
    return plistPath;
}

/** 获取通知记录 */
+ (NSArray *)notificationRecord {
    NSArray *array = [NSArray arrayWithContentsOfFile:[GameRequest getPlistPathWithFileName:@"NotificationRecord"]];
    return array;
}

/** 添加通知记录 */
+ (void)addNotificationRecordWith:(NSDictionary *)dict {
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[GameRequest getPlistPathWithFileName:@"NotificationRecord"]];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    [array addObject:dict];
    [array writeToFile:[GameRequest getPlistPathWithFileName:@"NotificationRecord"] atomically:YES];
    
}

/** 删除通知记录 */
+ (void)deleteNotificationRecordWith:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[GameRequest getPlistPathWithFileName:@"NotificationRecord"]];
    if (array == nil) {
        
    } else {
        [GameRequest deleteNotificationWithIdentifier:array[index][@"tag"]];
        [array removeObjectAtIndex:index];
    }
    [array writeToFile:[GameRequest getPlistPathWithFileName:@"NotificationRecord"] atomically:YES];
}

/** 删除全部通知记录 */
+ (void)deleteAllNotificationRecord {
    NSMutableArray *array = [NSMutableArray new];

    [array writeToFile:[GameRequest getPlistPathWithFileName:@"NotificationRecord"] atomically:YES];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
}

#pragma mark - ===========================微信分享======================================
+ (void)shareToFirednCircleWithTitle:(NSString *)title
                            SubTitle:(NSString *)subTitle
                                 Url:(NSString *)url
                               Image:(UIImage *)image {
    
    WXWebpageObject *object = [WXWebpageObject object];
    object.webpageUrl = url;
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = subTitle;
    [message setThumbImage:image];
    message.mediaObject = object;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}



@end


















