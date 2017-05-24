//
//  RequestUtils.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RequestUtils.h"


#define KEYCHAINSERVICE @"tenoneTec.com"
#define DEVICEID @"deviceID%forGAMEbox"


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
                syLog(@"NSJSONSerialization error");
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
            syLog(@"Request Failed...");
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
    
    request.timeoutInterval = 10.f;
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
//            syLog(@"%@",obj);
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
//                syLog(@"NSJSONSerialization error");

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
//            syLog(@"Request Failed...");
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
    
    NSString *deviceID = [SSKeychain passwordForService:KEYCHAINSERVICE account:DEVICEID];
    
    if (deviceID == nil) {
        deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:deviceID forService:KEYCHAINSERVICE account:DEVICEID];
    }
    
    return deviceID;
}

+ (NSString *)DeviceIP {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    success = getifaddrs(&interfaces);
    if (success == 0) {
    
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
               
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
    
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

+ (void)showAlertWithMessage:(NSString *)message dismiss:(void(^)(void))dismiss {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}



@end
