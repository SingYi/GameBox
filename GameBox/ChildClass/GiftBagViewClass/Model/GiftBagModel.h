//
//  GiftBagModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/18.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftBagModel : NSObject

/** 功能:礼包列表的post方法
 * ChannelID:渠道ID,默认为185(非必选)
 * serch:礼包名游戏名搜索(非必选)
 * order:按某个字段排序,默认create_time(非必选)
 * OrderType:排序类型 升序 降序,DESC降序 ASC 升序 默认降序(非必选)
 * page:第几页,默认为第一页(非必选)
 * uid:账号id,未登录为0,(必选)
 * deiviceID:设备id(必填写)
 */
+ (void)getGiftBagListWithUid:(NSString *_Nonnull)uid
                    ChannelID:(NSString *_Nullable)channelID
                    Search:(NSString *_Nullable)search
                     Order:(NSString *_Nullable)order
                 OrderType:(NSString *_Nullable)orderType
                      Page:(NSString *_Nullable)page
             Andcompletion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 功能:根据页码请求礼包数据
 *  page:页码(必选)
 */
+ (void)postGiftBagListWithPage:(NSString *_Nonnull)page
                     Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;




/** 功能:根据游戏ID获取相关礼包
 *  gameId:游戏ID(必选)
 *  order按某个字段排序(非必选)
 *  orderType:排序类型(非必选)
 *  page:页数(非必选)
 */
+ (void)postGiftBagWithGameID:(NSString * _Nonnull)gameId
                        Order:(NSString * _Nullable)order
                    OrderType:(NSString * _Nullable)orderType
                         page:(NSString * _Nullable)page
                   Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;


/** 功能:领取礼包
 *  bagID:礼包ID(必选)
 *  uid:用户id(必选,如果未登录传入0)
 */
+ (void)postGiftBagWithBagID:(NSString * _Nonnull)bagID
                         Uid:(NSString * _Nonnull)uid
                  Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;


/** 功能:获取用户礼包列表
 *  uid:用户ID(必选)
 *  channelID:渠道ID(非必选)
 *  order:按某个字段排序(非必选)
 *  orderType:升降序(非必选)
 *  page:页数(非必选,默认为第一页)
 */
+ (void)postGiftListWihtUserID:(NSString * _Nonnull)uid
                     ChannelID:(NSString * _Nullable)channelID
                         Order:(NSString * _Nullable)order
                     OrderType:(NSString * _Nullable)orderType
                          Page:(NSString * _Nullable)page
                    Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;


+ (void)postGiftRollingViewWithChannelID:(NSString *_Nonnull)channelID
                              Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;


@end
