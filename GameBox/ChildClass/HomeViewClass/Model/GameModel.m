//
//  GameModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/19.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameModel.h"
#import "RequestUtils.h"


#define RECOMMENDLISTURL @"http://www.9344.net/api-game-index"
#define GAMELISTURL @"http://www.9344.net/api-game-gameType"
#define SERVICEURL @"http://www.9344.net/api-game-openServer"
#define GAMEINFOURL @"http://www.9344.net/api-game-gameInfo"
#define COLLECTIONURL @"http://www.9344.net/api-game-collect"
#define CLASSIFYURL @"http://www.9344.net/api-game-gameClass"
#define CLASSINFOURL @"http://www.9344.net/api-game-gameClassInfo"
#define GAMEOPENURL @"http://www.9344.net/api-game-gameOpenServer"
#define GAMESTRAURL @"http://www.9344.net/api-article-get_list_by_game"

@implementation GameModel

+ (void)postRecommendGameListWithChannelID:(NSString *)channelID
                                      Page:(NSString *)page
                                Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    
    if (channelID) {
        [dict setObject:channelID forKey:@"channel"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [RequestUtils postRequestWithURL:RECOMMENDLISTURL params:dict completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            if (completion) {
                completion(content,true);
            }
        } else {
            if (completion) {
                completion(nil,false);
            }
        }
    }];
    
}

+ (void)postNewGameListWithChannelID:(NSString *)channelID
                                Page:(NSString *)page
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    [GameModel postGameListWithType:Newgame ChannelID:channelID Page:page Completion:completion];
}

+ (void)postGameListWithType:(GameListType)gameListType
                   ChannelID:(NSString *)channelID
                        Page:(NSString *)page
                  Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSString *type = [NSString stringWithFormat:@"%ld",gameListType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:type forKey:@"type"];
    
    if (channelID) {
        [dict setObject:channelID forKey:@"channel"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [RequestUtils postRequestWithURL:GAMELISTURL params:dict completion:completion];

}

+ (void)postServerListWithType:(ServiceType)serviceTye
                     ChannelID:(NSString *)channelID
                          Page:(NSString *)page
                    Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSString *type = [NSString stringWithFormat:@"%ld",serviceTye];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:type forKey:@"type"];
    
    if (channelID) {
        [dict setObject:channelID forKey:@"channel"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [RequestUtils postRequestWithURL:SERVICEURL params:dict completion:completion];
    
}

+ (void)postServerListWithGameID:(NSString *)gameID
                      Copoletion:(void (^)(NSDictionary * _Nullable, BOOL))compeletion {
    
    NSDictionary *dict = @{@"gid":gameID};
    
    [RequestUtils postRequestWithURL:GAMEOPENURL params:dict completion:compeletion];
    
}

+ (void)postGameInfoWithGameID:(NSString *)gameID
                        UserID:(NSString *)uid
                     ChannelID:(NSString *)channelID
                    Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:gameID forKey:@"gid"];
    [dict setObject:uid forKey:@"uid"];
    
    if (channelID) {
        [dict setObject:channelID forKey:@"channel"];
    }
    

    
    [RequestUtils postRequestWithURL:GAMEINFOURL params:dict completion:completion];
}

+ (void)postCollectionGameWithType:(CollectionType)collectionType
                            GameID:(NSString *)gameID
                            UserID:(NSString *)uid
                        Comoletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSString *type = [NSString stringWithFormat:@"%ld",collectionType];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:type forKey:@"type"];
    [dict setObject:gameID forKey:@"gid"];
    [dict setObject:uid forKey:@"uid"];

    
    [RequestUtils postRequestWithURL:COLLECTIONURL params:dict completion:completion];
    
}

+ (void)postGameClassifyWithChannel:(NSString *)channel
                         Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"1" forKey:@"page"];
    
    
    [RequestUtils postRequestWithURL:CLASSIFYURL params:dict completion:completion];
    
}

+ (void)postGameListWithClassifyID:(NSString *)classifyID
                        Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSDictionary *dict = @{@"classId":classifyID};
    
    
    [RequestUtils postRequestWithURL:CLASSINFOURL params:dict completion:completion];
}

+ (void)postImageWithUrl:(NSString * _Nonnull)url
              Completion:(void (^ _Nullable)(NSData * _Nullable content, BOOL success))completion {
    
    [RequestUtils postDataWithUrl:[NSString stringWithFormat:@"%@%@",IMAGEURL,url] params:nil completion:completion];
    
}

+ (void)postStrategyWithGameID:(NSString *)gameID
                          Page:(NSString *)page
                     ChannelID:(NSString *)channelID
                    Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"1" forKey:@"type"];
    if (page) {
        [dict setObject:page forKey:@"page"];
    } else {
        [dict setObject:@"1" forKey:@"page"];
    }
    
    if (channelID) {
        [dict setObject:channelID forKey:@"channel_id"];
    } else {
        [dict setObject:@"185" forKey:@"channel_id"];
    }
    
    [RequestUtils postRequestWithURL:GAMESTRAURL params:dict completion:completion];
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











