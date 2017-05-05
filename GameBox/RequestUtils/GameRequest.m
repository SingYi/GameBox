//
//  GameRequest.m
//  GameBox
//
//  Created by 石燚 on 2017/5/5.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameRequest.h"

#define GAME_INDEX @"http://www.9344.net/api-game-index"
#define GAME_TYPE @"http://www.9344.net/api-game-gameType"
#define SERVICEURL @"http://www.9344.net/api-game-openServer"
#define GAMEINFOURL @"http://www.9344.net/api-game-gameInfo"
#define COLLECTIONURL @"http://www.9344.net/api-game-collect"
#define CLASSIFYURL @"http://www.9344.net/api-game-gameClass"
#define CLASSINFOURL @"http://www.9344.net/api-game-gameClassInfo"
#define GAMEOPENURL @"http://www.9344.net/api-game-gameOpenServer"
#define GAMESTRAURL @"http://www.9344.net/api-article-get_list_by_game"

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



@end












