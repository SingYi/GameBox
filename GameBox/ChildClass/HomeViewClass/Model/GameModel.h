//
//  GameModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/19.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>

typedef enum : NSUInteger {
    Newgame = 1,
    HotGame,
    RankingGame,
} GameListType;

typedef enum : NSInteger {
    TodayService = 1,
    CommingSoonService,
    AlredayService,
} ServiceType;

typedef enum : NSInteger {
    collection = 1,
    cancel,
} CollectionType;


@interface GameModel : NSObject

+ (void)postRecommendGameListWithChannelID:(NSString *_Nullable)channelID
                                      Page:(NSString *_Nullable)page
                                Completion:(void(^_Nullable)( NSDictionary  * _Nullable content,BOOL success))completion;

+ (void)postGameListWithType:(GameListType)gameListType
                   ChannelID:(NSString * _Nullable)channelID
                        Page:(NSString * _Nullable)page
                  Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postNewGameListWithChannelID:(NSString *_Nullable) channelID
                                Page:(NSString *_Nullable) page
                          Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postServerListWithType:(ServiceType)serviceTye
                     ChannelID:(NSString * _Nullable)channelID
                          Page:(NSString * _Nullable)page
                    Comoletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postServerListWithGameID:(NSString * _Nonnull)gameID
                      Copoletion:(void(^ _Nullable)(NSDictionary * _Nullable content, BOOL scccess))compeletion;

+ (void)postGameInfoWithGameID:(NSString * _Nonnull)gameID
                        UserID:(NSString * _Nonnull)uid
                     ChannelID:(NSString * _Nonnull)channelID
                    Comoletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postCollectionGameWithType:(CollectionType)collectionType
                            GameID:(NSString * _Nonnull)gameID
                            UserID:(NSString * _Nonnull)uid
                        Comoletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postGameClassifyWithChannel:(NSString * _Nonnull )channel
                         Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postGameListWithClassifyID:(NSString * _Nonnull)classifyID
                        Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

+ (void)postImageWithUrl:(NSString * _Nonnull)url
              Completion:(void (^ _Nullable)(NSData * _Nullable content, BOOL success))completion;

@end









