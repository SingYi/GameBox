//
//  GameRequest.h
//  GameBox
//
//  Created by 石燚 on 2017/5/5.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RequestUtils.h"

typedef enum : NSUInteger {
    newGame = 0,
    hotGame,
    rankingGame,
} GameType;

@interface GameRequest : RequestUtils

/** 推荐游戏接口 */
+ (void)recommendGameWithPage:(NSString * _Nullable)page
                   Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 新游/热门/排行接口 */
+ (void)typeGameWithType:(GameType)gameType
                    Page:(NSString * _Nonnull)page
              Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 新游接口 */
+ (void)newGameWithPage:(NSString * _Nullable)page
             Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 热门接口 */
+ (void)hotGameWithPage:(NSString * _Nullable)page
              Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

/** 排行榜 */
+ (void)rankGameWithhPage:(NSString * _Nullable)page
              Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;





@end
