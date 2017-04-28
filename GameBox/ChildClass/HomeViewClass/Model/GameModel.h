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

/** 新游,热门,排行榜 */
typedef enum : NSUInteger {
    Newgame = 1,
    HotGame,
    RankingGame,
} GameListType;

/** 开服时间:今天,即将,已经 */
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

/** 推荐游戏列表 */
+ (void)postRecommendGameListWithChannelID:(NSString *_Nullable)channelID
                                      Page:(NSString *_Nullable)page
                                Completion:(void(^_Nullable)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 新游,热门,排行榜列表 */
+ (void)postGameListWithType:(GameListType)gameListType
                   ChannelID:(NSString * _Nullable)channelID
                        Page:(NSString * _Nullable)page
                  Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 请求新游戏列表 */
+ (void)postNewGameListWithChannelID:(NSString *_Nullable) channelID
                                Page:(NSString *_Nullable) page
                          Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 请求开服列表 */
+ (void)postServerListWithType:(ServiceType)serviceTye
                     ChannelID:(NSString * _Nullable)channelID
                          Page:(NSString * _Nullable)page
                    Comoletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 单个游戏的开服情况 */
+ (void)postServerListWithGameID:(NSString * _Nonnull)gameID
                      Copoletion:(void(^ _Nullable)(NSDictionary * _Nullable content, BOOL scccess))compeletion;

/** 游戏详情 */
+ (void)postGameInfoWithGameID:(NSString * _Nonnull)gameID
                        UserID:(NSString * _Nonnull)uid
                     ChannelID:(NSString * _Nonnull)channelID
                    Comoletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 收藏接口 */
+ (void)postCollectionGameWithType:(CollectionType)collectionType
                            GameID:(NSString * _Nonnull)gameID
                            UserID:(NSString * _Nonnull)uid
                        Comoletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;
/** 分类 */
+ (void)postGameClassifyWithChannel:(NSString * _Nonnull )channel
                         Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 分类游戏的详情 */
+ (void)postGameListWithClassifyID:(NSString * _Nonnull)classifyID
                        Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 游戏的图标 */
+ (void)postImageWithUrl:(NSString * _Nonnull)url
              Completion:(void (^ _Nullable)(NSData * _Nullable content, BOOL success))completion;

/** 游戏相关攻略 */
+ (void)postStrategyWithGameID:(NSString * _Nonnull)gameID
                          Page:(NSString * _Nullable)page
                     ChannelID:(NSString * _Nullable)channelID
                    Completion:(void (^ _Nullable)(NSDictionary * _Nullable content, BOOL success))completion;
/** 显示提示信息 */
+ (void)showAlertWithMessage:(NSString *_Nullable)message dismiss:(void(^_Nullable)(void))dismiss;



@end









