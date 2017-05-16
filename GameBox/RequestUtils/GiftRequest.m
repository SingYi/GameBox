//
//  GiftRequest.m
//  GameBox
//
//  Created by 石燚 on 2017/5/16.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GiftRequest.h"
#import <CommonCrypto/CommonDigest.h>

#define PACKS_LIST @"http://www.185sy.com/api-packs-get_list"
#define GAME_PACK @"http://www.185sy.com/api-packs-get_list_by_game"
#define PACKS_LINGQU @"http://www.185sy.com/api-packs-get_pack"
#define USER_PACK @"http://www.185sy.com/api-packs-get_list_by_user"
#define PACKS_SLIDE @"http://www.185sy.com/api-packs-get_slide"

@implementation GiftRequest

/** 礼包列表接口 */
+ (void)giftListWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:CHANNELID forKey:@"channel_id"];
    if (page) {
        [dict setObject:page forKey:@"page"];
    } else {
        [dict setObject:@"1" forKey:@"page"];
    }
    
    [dict setObject:[UserModel uid] forKey:@"uid"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"PACKS_LIST");
    if (!urlStr) {
        urlStr = PACKS_LIST;
    }
    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
}


/** 搜索礼包接口 */
+ (void)giftSearchWithkeyWord:(NSString *)keyword Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:keyword forKey:@"search"];
    
    [dict setObject:CHANNELID forKey:@"channel_id"];
    [dict setObject:@"1" forKey:@"page"];
    [dict setObject:[UserModel uid] forKey:@"uid"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"PACKS_LIST");
    if (!urlStr) {
        urlStr = PACKS_LIST;
    }
    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
}

/** 游戏相关礼包 */
+ (void)giftWithGameID:(NSString *)gameID WithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:CHANNELID forKey:@"channel_id"];
    [dict setObject:[UserModel uid] forKey:@"uid"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];
    
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"GAME_PACK");
    if (!urlStr) {
        urlStr = GAME_PACK;
    }
    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
    

}


/** 获取礼包接口 */
+ (void)getGiftWithGiftID:(NSString *)pid Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[UserModel uid] forKey:@"uid"];
    [dict setObject:[RequestUtils DeviceIP] forKey:@"ip"];
    [dict setObject:@"2" forKey:@"terminal_type"];
    [dict setObject:pid forKey:@"pid"];
    [dict setObject:[RequestUtils DeviceID] forKey:@"device_id"];
    
    NSString *signStr = [NSString stringWithFormat:@"device_id%@ip%@pid%@terminal_type2uid%@",[RequestUtils DeviceID],[RequestUtils DeviceIP],pid,[UserModel uid]];
    
    const char *cstr = [signStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:signStr.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *cha1str = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [cha1str appendFormat:@"%02x", digest[i]];
    
    NSString *sign = [cha1str uppercaseString];
    
    [dict setObject:sign forKey:@"sign"];
    
    [dict setObject:CHANNELID forKey:@"channel_id"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"PACKS_LINGQU");
    if (!urlStr) {
        urlStr = PACKS_LINGQU;
    }
    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
    

}

/** 获取用户礼包列表 */
+ (void)userGiftListWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:CHANNELID forKey:@"channel_id"];

    [dict setObject:page forKey:@"page"];
    
    [dict setObject:[UserModel uid] forKey:@"uid"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_PACK");
    if (!urlStr) {
        urlStr = USER_PACK;
    }
    [RequestUtils postRequestWithURL:urlStr params:dict completion:completion];
}

/** 获取礼包也轮播图 */
+ (void)giftBannerWithCompletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"PACKS_SLIDE");
    if (!urlStr) {
        urlStr = PACKS_SLIDE;
    }
    [RequestUtils postRequestWithURL:urlStr params:@{@"channel_id":CHANNELID} completion:completion];
}

@end





