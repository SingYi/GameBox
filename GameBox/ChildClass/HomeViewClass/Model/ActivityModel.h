//
//  ActivityModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/19.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ActivityList = 1,
    StrategList,
} ActivityType;

@interface ActivityModel : NSObject

+ (void)postWithType:(ActivityType)activityType
                Page:(NSString * _Nullable)page
           ChannelId:(NSString * _Nullable)channelId
          Completion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion;

@end
