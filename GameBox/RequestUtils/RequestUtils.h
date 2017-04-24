//
//  RequestUtils.h
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtils : NSObject

+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary *content,BOOL success))completion;


+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary *content,BOOL success))completion;

+ (void)postDataWithUrl:(NSString *)url
                 params:(NSDictionary *)dicP
             completion:(void(^)(NSData *resultData,BOOL success))completion;



+ (NSString *)DeviceID;

+ (NSString *)DeviceIP;

@end
