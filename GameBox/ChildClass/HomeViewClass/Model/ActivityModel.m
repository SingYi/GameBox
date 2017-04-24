//
//  ActivityModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/19.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ActivityModel.h"
#import "RequestUtils.h"

#define ACTIVITYURL @"http://www.9344.net/api-article-get_list"

@implementation ActivityModel

+ (void)postWithType:(ActivityType)activityType
                Page:(NSString *)page
           ChannelId:(NSString *)channelId
          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSString *type = [NSString stringWithFormat:@"%ld",activityType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:type forKey:@"type"];
    
    if (channelId) {
        [dict setObject:channelId forKey:@"channel_id"];
    }
    
    if (page) {
        [dict setObject:page forKey:@"page"];
    }
    
    [RequestUtils postRequestWithURL:ACTIVITYURL params:dict completion:completion];
}

@end
