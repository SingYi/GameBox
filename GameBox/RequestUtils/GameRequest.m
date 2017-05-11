//
//  GameRequest.m
//  GameBox
//
//  Created by 石燚 on 2017/5/5.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameRequest.h"
#import "UserModel.h"

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
#define GAMESTRAURL @"http://www.185sy.com/api-article-get_list_by_game"
//18


@implementation GameRequest


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

+ (void)showAlertWithMessage:(NSString *)message dismiss:(void(^)(void))dismiss {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}

@end


















