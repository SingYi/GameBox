//
//  RequestUtils.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RequestUtils.h"
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


@implementation RequestUtils

+ (void)getRequestWithURL:(NSString *)url
                  params:(NSDictionary *)dicP
              completion:(void(^)(NSDictionary * content,BOOL success))completion
{
    NSMutableString * strUrl = [NSMutableString stringWithString:url];
    if (dicP && dicP.count) {
        NSArray * arrKey = [dicP allKeys];
        NSMutableArray * pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString * strP = [pValues componentsJoinedByString:@"&"];
        [strUrl appendFormat:@"?%@",strP];
    }
    NSURLSession * session  = [NSURLSession sharedSession];
    
    NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
                NSLog(@"NSJSONSerialization error");
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });
                    
                }
            }
        } else {
            NSLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}


+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary * content,BOOL success))completion
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (dicP && dicP.count) {
        NSArray *arrKey = [dicP allKeys];
        NSMutableArray *pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString *strP = [pValues componentsJoinedByString:@"&"];
        [request setHTTPBody:[strP dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
//            NSLog(@"%@",obj);
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
                NSLog(@"NSJSONSerialization error");
//                NSLog(@"%@",error.localizedDescription);
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });
                }
            }
        } else {
            NSLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}

+ (void)postDataWithUrl:(NSString *)url
                 params:(NSDictionary *)dicP
             completion:(void(^)(NSData *resultData,BOOL success))completion {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (dicP && dicP.count) {
        NSArray *arrKey = [dicP allKeys];
        NSMutableArray *pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString *strP = [pValues componentsJoinedByString:@"&"];
        [request setHTTPBody:[strP dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setHTTPMethod:@"POST"];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(data,true);
                }
            });
                           
        } else {
            NSLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
    
}


+ (NSString *)DeviceID {
    
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"];
    
    if (deviceID.length != 0) {
        return deviceID;
    } else {
        
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:idfv forKey:@"deviceID"];
        return idfv;
    }

}

+ (NSString *)DeviceIP {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}




@end
