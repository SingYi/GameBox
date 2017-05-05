//
//  RequestUtils.h
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtils : NSObject

/** get方法 */
+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary *content,BOOL success))completion;


/** post方法 */
+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary *content,BOOL success))completion;



/** 设备ID */
+ (NSString *)DeviceID;

/** 设备IP */
+ (NSString *)DeviceIP;



@end
