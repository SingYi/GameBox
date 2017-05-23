//
//  RequestUtils.h
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import "SSKeychain.h"

#define REQUESTSUCCESS !((NSString *)content[@"status"]).boolValue
#define REQUESTMSG content[@"msg"]

@interface RequestUtils : NSObject

/** get方法 */
+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary *content,BOOL success))completion;


/** post方法 */
+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 显示提示信息 */
+ (void)showAlertWithMessage:(NSString *)message dismiss:(void(^)(void))dismiss;


/** 设备ID */
+ (NSString *)DeviceID;

/** 设备IP */
+ (NSString *)DeviceIP;



@end
