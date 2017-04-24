//
//  GiftBagModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/18.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GiftBagModel.h"
#import "RequestUtils.h"
#import <CommonCrypto/CommonDigest.h>

#define MAIN_URL @"http://www.9344.net"
#define LISTURL @"http://www.9344.net/api-packs-get_list"
#define GAMEIDURL @"http://www.9344.net/api-packs-get_list_by_game"
#define BAGIDURL @"http://www.9344.net/api-packs-get_pack"
#define BAGLISTWITHUSER @"http://www.9344.net/api-packs-get_list_by_user"
#define BAGROLLING @"http://www.9344.net/api-packs-get_slide"

@implementation GiftBagModel


/** 功能:获取礼包列表
 *  ui:用户id(未登录传入0)
 *  channelid:渠道id
 *  search:搜索礼包
 *  order:按某个字段排序,默认按时间排序
 *  orderType:升降序
 *  page:页码
 */
+ (void)getGiftBagListWithUid:(NSString *_Nonnull)uid
                    ChannelID:(NSString *_Nullable)channelID
                       Search:(NSString *_Nullable)search
                        Order:(NSString *_Nullable)order
                    OrderType:(NSString *_Nullable)orderType
                         Page:(NSString *_Nullable)page
                Andcompletion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (channelID) {
        [dict setObject:channelID forKey:@"channel_id"];
    }
    
    if (search) {
        [dict setObject:search forKey:@"search"];
    }
    
    if (order) {
        [dict setObject:order forKey:@"order"];
    }
    
    if (orderType) {
        [dict setObject:orderType forKey:@"order_type"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];
    
    
    [RequestUtils postRequestWithURL:LISTURL params:dict completion:^(NSDictionary *content, BOOL success) {
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


+ (void)postGiftBagListWithPage:(NSString *)page
                     Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion {
    
    [GiftBagModel getGiftBagListWithUid:@"0" ChannelID:@"185" Search:nil Order:nil OrderType:nil Page:page Andcompletion:^(NSDictionary * _Nullable content, BOOL success) {
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

/**根据游戏ID获取礼包*/
+ (void)postGiftBagWithGameID:(NSString *)gameId
                        Order:(NSString *)order
                    OrderType:(NSString *)orderType
                         page:(NSString *)page
                   Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (order) {
        [dict setObject:order forKey:@"order"];
    }
    
    if (orderType) {
        [dict setObject:orderType forKey:@"order_type"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [dict setObject:gameId forKey:@"game_id"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];

    
    
    [RequestUtils postRequestWithURL:GAMEIDURL params:dict completion:^(NSDictionary *content, BOOL success) {
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

/**根据礼包ID获取礼包*/
+ (void)postGiftBagWithBagID:(NSString * _Nonnull)bagID
                         Uid:(NSString * _Nonnull)uid
                  Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:[RequestUtils DeviceIP] forKey:@"ip"];
    [dict setObject:@"2" forKey:@"terminal_type"];
    [dict setObject:bagID forKey:@"pid"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];
    
    NSString *signStr = [NSString stringWithFormat:@"device_id%@ip%@pid%@terminal_type2uid%@",[RequestUtils DeviceID],[RequestUtils DeviceIP],bagID,uid];
    
    const char *cstr = [signStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:signStr.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *cha1str = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [cha1str appendFormat:@"%02x", digest[i]];
//    NSLog(@"%@",cha1str);
    NSString *sign = [cha1str uppercaseString];
//    NSLog(@"%@",sign);
    [dict setObject:sign forKey:@"sign"];
    
    [RequestUtils postRequestWithURL:BAGIDURL params:dict completion:^(NSDictionary *content, BOOL success) {
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

/**根据用户ID获取用户礼包*/
+ (void)postGiftListWihtUserID:(NSString * _Nonnull)uid
                     ChannelID:(NSString * _Nullable)channelID
                         Order:(NSString * _Nullable)order
                     OrderType:(NSString * _Nullable)orderType
                          Page:(NSString * _Nullable)page
                    Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (channelID) {
        [dict setObject:channelID forKey:@"channel_id"];
    }
    
    if (order) {
        [dict setObject:order forKey:@"order"];
    }
    
    if (orderType) {
        [dict setObject:orderType forKey:@"order_type"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [dict setObject:uid forKey:@"uid"];
    
    
    [RequestUtils postRequestWithURL:BAGLISTWITHUSER params:dict completion:^(NSDictionary *content, BOOL success) {
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

/**获取礼包轮播图*/
+ (void)postGiftRollingViewWithChannelID:(NSString *)channelID
                              Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion {
    
    
    [RequestUtils postRequestWithURL:BAGROLLING params:@{@"channel_id":channelID} completion:completion];
    
}


@end











