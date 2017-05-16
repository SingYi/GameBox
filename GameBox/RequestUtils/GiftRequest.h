//
//  GiftRequest.h
//  GameBox
//
//  Created by 石燚 on 2017/5/16.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftRequest : RequestUtils

/** 礼包列表接口 */
+ (void)giftListWithPage:(NSString * _Nonnull)page
              Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 搜搜礼包接口 */
+ (void)giftSearchWithkeyWord:(NSString * _Nonnull)keyword
                       Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 获取游戏相关的礼包 */
+ (void)giftWithGameID:(NSString * _Nonnull)gameID
              WithPage:(NSString * _Nonnull)page
            Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 获取礼包接口 
 *  pid: 礼包ID
 */
+ (void)getGiftWithGiftID:(NSString * _Nonnull)pid
               Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 获取用户礼包 */
+ (void)userGiftListWithPage:(NSString * _Nonnull)page
                  Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 获取礼包也轮播图 */
+ (void)giftBannerWithCompletion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;


@end






