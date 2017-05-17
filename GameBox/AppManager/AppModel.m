//
//  AppModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "AppModel.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <spawn.h>
#import <sys/wait.h>
#import "GameRequest.h"

#define WORKSPACE [AppModel workSpace]

#define GETTYPE(type) [LSApplicationProxy_class performSelector:@selector(type)];

@interface AppModel ()

+ (NSObject *)workSpace;

@end


@implementation AppModel

/** 获取默认的workSpace */
+ (NSObject *)workSpace {
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    return workspace;
}

/** 打开app */
+ (void)openAPPWithIde:(NSString *)ide {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[AppModel workSpace] performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:ide];
#pragma clang diagnostic pop
    
}

+ (NSDictionary *)getAppinfoWithIde:(NSString *)ide {
    NSDictionary *dict = [[NSDictionary alloc] init];
//    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
//    id test = [LSApplicationProxy_class performSelector:NSSelectorFromString(@"applicationProxyForIdentifier:") withObject:ide];
    return dict;
}

//获取网络上是所有游戏包名
+ (void)getAllGameIdeWith:(void(^)(NSDictionary *content, BOOL success))completion {
    [GameRequest allGameWithType:AllBackage Completion:completion];
}

//获取本地所有的包名;
+ (NSMutableDictionary *)getLocalAllGameIde {
    //获取应用列表
    NSArray *appList = [WORKSPACE performSelector:@selector(allApplications)];
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    //储存总应用的字典
    NSMutableDictionary *list = [NSMutableDictionary new];
    //储存appBundleID的数组;
    NSMutableArray *appBundleID = [NSMutableArray array];
    for (LSApplicationProxy_class in appList) {
        //储存app信息的数组
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        //用户安装还是系统安装
        NSString *applicationType = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        if ([applicationType isEqualToString:@"System"]) {
            continue;
        }
        
        [dict setValue:applicationType forKey:@"applicationType"];
        
        /** bundleID */
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        
        /** 开发版本 */
        NSString *version = GETTYPE(bundleVersion);
        //版本信息
        [dict setValue:version forKey:@"bundleVersion"];
        
        //发布版本
        NSString *shortVersionString = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
        [dict setValue:shortVersionString forKey:@"shortVersionString"];
        
        //本地简写名称
        NSObject *localizedShortName = [LSApplicationProxy_class performSelector:@selector(localizedShortName)];
        [dict setValue:localizedShortName forKey:@"localizedShortName"];
        
        //本地名称
        NSObject *localizedName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        [dict setValue:localizedName forKey:@"localizedName"];
        
        //正在安装
        NSInteger installType = (NSInteger)[LSApplicationProxy_class performSelector:@selector(installType)];
        [dict setValue:@(installType) forKey:@"installType"];
        
        //安装进度
        NSObject *installProgress = [LSApplicationProxy_class performSelector:@selector(installProgress)];
        [dict setValue:installProgress forKey:@"installProgress"];
        
        //app大小
        NSNumber *staticDiskUsage = [LSApplicationProxy_class performSelector:@selector(staticDiskUsage)];
        [dict setObject:staticDiskUsage forKey:@"size"];
/*============================================================================================
        //app图标
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        NSData *data = (NSData *)[LSApplicationProxy_class performSelector:NSSelectorFromString(@"iconDataForVariant:") withObject:@(2)];
        
#pragma clang diagnostic pop
        
        NSInteger lenth = data.length;
        NSInteger width = 87;
        NSInteger height = 87;
        uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
        [data getBytes:pixels range:NSMakeRange(32, lenth - 32)];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        //  注意此处的 bytesPerRow 多加了 4 个字节
        CGContextRef ctx = CGBitmapContextCreate(pixels, width, height, 8, (width + 1) * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        
        UIImage *icon = [UIImage imageWithCGImage:cgImage];
        
        [dict setObject:icon forKey:@"appIcon"];
============================================================================================*/
        [list setValue:dict forKey:bundleID];
        
        [appBundleID addObject:bundleID];
    }
    
    return list;
}

/** 获取本地游戏 */
+ (void)getLocalGamesWithBlock:(void(^_Nullable)(NSArray * _Nullable games, BOOL success))block {
    [GameRequest allGameWithType:AllBackage Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            NSArray *array = content[@"data"];
            NSMutableDictionary *netBackage = [NSMutableDictionary dictionary];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [netBackage setObject:obj forKey:obj[@"ios_pack"]];
//                [netBackage setObject:obj[@"logo"] forKey:@"logo"];
            }];
            
            NSDictionary *localApps = [AppModel getLocalAllGameIde];
            NSArray *localbackgage = [localApps allKeys];
            
            NSMutableSet *localGamesBackage = [NSMutableSet setWithArray:localbackgage];
            NSMutableSet *netGamesBackage = [NSMutableSet setWithArray:[netBackage allKeys]];
            
            [localGamesBackage intersectSet:netGamesBackage];
            
            NSMutableArray *localGames = [NSMutableArray arrayWithCapacity:localGamesBackage.count];
            
            [localGamesBackage enumerateObjectsUsingBlock:^(NSString * obj, BOOL * _Nonnull stop) {
                NSMutableDictionary *dict = [localApps[obj] mutableCopy];
                
                NSDictionary *dict1 = netBackage[obj];
                
                [dict setObject:dict1[@"id"] forKey:@"id"];
                
                [dict setObject:dict1[@"ios_pack"] forKey:@"bundleID"];
                
                [dict setObject:dict1[@"logo"] forKey:@"logo"];
                
                
                [localGames addObject:dict];
                
            }];
            
            if (block) {
                block(localGames , true);
            }
            
        } else {
            if (block) {
                block(nil, false);
            }
        }
    }];
}

/** 获取所有手机的应用 */
+ (NSMutableDictionary *)Apps {
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    
    //获取应用列表
    NSArray *appList = [WORKSPACE performSelector:@selector(allApplications)];

    //应用的类
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    
    //储存总应用的字典
    NSMutableDictionary *list = [NSMutableDictionary new];
    
    //储存appBundleID的数组;
    NSMutableArray *appBundleID = [NSMutableArray arrayWithCapacity:appList.count];
    
    //便利应用列表,获取应用信息,储存需要的信息
    for (LSApplicationProxy_class in appList) {
        
        //储存app信息的数组
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        /** bundleID */
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        
        /** 开发版本 */
        NSString *version = GETTYPE(bundleVersion);
        //版本信息
        [dict setValue:version forKey:@"bundleVersion"];
        
        //发布版本
        NSString *shortVersionString = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
        [dict setValue:shortVersionString forKey:@"shortVersionString"];
        
        //本地简写名称
        NSObject *localizedShortName = [LSApplicationProxy_class performSelector:@selector(localizedShortName)];
        [dict setValue:localizedShortName forKey:@"localizedShortName"];
        
        //本地名称
        NSObject *localizedName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        [dict setValue:localizedName forKey:@"localizedName"];
        
        //正在安装
        NSInteger installType = (NSInteger)[LSApplicationProxy_class performSelector:@selector(installType)];
        [dict setValue:@(installType) forKey:@"installType"];
        
        //安装进度
        NSObject *installProgress = [LSApplicationProxy_class performSelector:@selector(installProgress)];
        [dict setValue:installProgress forKey:@"installProgress"];
        
        
        //用户安装还是系统安装
        NSString *applicationType = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        [dict setValue:applicationType forKey:@"applicationType"];
        
        //app大小
        NSNumber *staticDiskUsage = [LSApplicationProxy_class performSelector:@selector(staticDiskUsage)];
        [dict setObject:staticDiskUsage forKey:@"size"];
/*============================================================================================*/
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        
//        NSData *data = (NSData *)[LSApplicationProxy_class performSelector:NSSelectorFromString(@"iconDataForVariant:") withObject:@(2)];
//        
//#pragma clang diagnostic pop
//        
//        NSInteger lenth = data.length;
//        NSInteger width = 87;
//        NSInteger height = 87;
//        uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
//        [data getBytes:pixels range:NSMakeRange(32, lenth - 32)];
//        
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        
//        //  注意此处的 bytesPerRow 多加了 4 个字节
//        CGContextRef ctx = CGBitmapContextCreate(pixels, width, height, 8, (width + 1) * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//        
//        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
//        CGContextRelease(ctx);
//        CGColorSpaceRelease(colorSpace);
//        
//        UIImage *icon = [UIImage imageWithCGImage:cgImage];
//        
//        [dict setObject:icon forKey:@"appIcon"];
//        
//        [list setValue:dict forKey:bundleID];
//        
        [appBundleID addObject:bundleID];
/*============================================================================================*/
        
        
        
        
        //开发人员
//        NSString *teamID = [LSApplicationProxy_class performSelector:@selector(teamID)];
        
        //文件路径
//        NSObject *resourcesDirectoryURL = [LSApplicationProxy_class performSelector:@selector(resourcesDirectoryURL)];
        
        //app大小
//        NSNumber *staticDiskUsage = [LSApplicationProxy_class performSelector:@selector(staticDiskUsage)];
        
        
//        NSInteger originalInstallType = (NSInteger)[LSApplicationProxy_class performSelector:@selector(originalInstallType)];
        
        
//        NSNumber *itemID = [LSApplicationProxy_class performSelector:@selector(itemID)];
        
//        NSObject *description = [LSApplicationProxy_class performSelector:@selector(description)];
        
//        NSObject *iconStyleDomain = [LSApplicationProxy_class performSelector:@selector(iconStyleDomain)];
        
        
//        NSObject *privateDocumentTypeOwner = [LSApplicationProxy_class performSelector:@selector(privateDocumentTypeOwner)];
        
//        NSObject *privateDocumentIconNames = [LSApplicationProxy_class performSelector:@selector(privateDocumentIconNames)];
    
        
//        NSObject *appStoreReceiptURL = [LSApplicationProxy_class performSelector:@selector(appStoreReceiptURL)];
        
        
//        NSNumber *storeFront = [LSApplicationProxy_class performSelector:@selector(storeFront)];
        
//        NSObject *deviceIdentifierForVendor = [LSApplicationProxy_class performSelector:@selector(deviceIdentifierForVendor)];
        
//        NSArray *requiredDeviceCapabilities = [LSApplicationProxy_class performSelector:@selector(requiredDeviceCapabilities)];
        
//        NSArray *appTags = [LSApplicationProxy_class performSelector:@selector(appTags)];
        
//        NSArray *plugInKitPlugins = [LSApplicationProxy_class performSelector:@selector(plugInKitPlugins)];
        
//        NSArray *VPNPlugins = [LSApplicationProxy_class performSelector:@selector(VPNPlugins)];
        
//        NSArray *externalAccessoryProtocols = [LSApplicationProxy_class performSelector:@selector(externalAccessoryProtocols)];
        
//        NSArray *audioComponents = [LSApplicationProxy_class performSelector:@selector(audioComponents)];
        
//        NSArray *UIBackgroundModes = [LSApplicationProxy_class performSelector:@selector(UIBackgroundModes)];
        
//        NSArray *directionsModes = [LSApplicationProxy_class performSelector:@selector(directionsModes)];
        
//        NSDictionary *groupContaixners = [LSApplicationProxy_class performSelector:@selector(groupContainers)];
        
//        NSString *vendorName = [LSApplicationProxy_class performSelector:@selector(vendorName)];
        
//        NSString *sdkVersion = [LSApplicationProxy_class performSelector:@selector(sdkVersion)];
    
        
        

        //开发团队信息
//        [dict setValue:teamID forKey:@"teamID"];
        //
//        [dict setValue:@(originalInstallType) forKey:@"originalInstallType"];
//        [dict setValue:@(installType) forKey:@"installType"];
//        [dict setValue:itemID forKey:@"itemID"];
//        [dict setValue:description forKey:@"description"];
//        [dict setValue:iconStyleDomain forKey:@"iconStyleDomain"];

//        [dict setValue:privateDocumentTypeOwner forKey:@"privateDocumentTypeOwner"];
//        [dict setValue:privateDocumentIconNames forKey:@"privateDocumentIconNames"];
//        [dict setValue:resourcesDirectoryURL forKey:@"resourcesDirectoryURL"];
//        [dict setValue:appStoreReceiptURL forKey:@"appStoreReceiptURL"];
//        [dict setValue:storeFront forKey:@"storeFront"];
        //        [dict setValue:dynamicDiskUsage forKey:@"dynamicDiskUsage"];
//        [dict setValue:staticDiskUsage forKey:@"staticDiskUsage"];
//        [dict setValue:deviceIdentifierForVendor forKey:@"deviceIdentifierForVendor"];
//        [dict setValue:requiredDeviceCapabilities forKey:@"requiredDeviceCapabilities"];
//        [dict setValue:appTags forKey:@"appTags"];
//        [dict setValue:plugInKitPlugins forKey:@"plugInKitPlugins"];
//        [dict setValue:VPNPlugins forKey:@"VPNPlugins"];
//        [dict setValue:externalAccessoryProtocols forKey:@"externalAccessoryProtocols"];
//        [dict setValue:audioComponents forKey:@"audioComponents"];
//        [dict setValue:UIBackgroundModes forKey:@"UIBackgroundModes"];
//        [dict setValue:directionsModes forKey:@"directionsModes"];
        //        [dict setValue:groupContainers forKey:@"groupContainers"];
//        [dict setValue:vendorName forKey:@"vendorName"];
//        [dict setValue:sdkVersion forKey:@"sdkVersion"];
        
        //发型版本?

        

    }
    
    
    
    return [list copy];
}


+ (void)installAPPWithIDE:(NSString *)ide {

    [[AppModel workSpace] performSelector:@selector(uninstallApplication:withOptions:) withObject:ide withObject:nil];

}


/** 获取路径 */
+ (NSString *)getPlistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [path stringByAppendingPathComponent:@"LocalGames"];
    return plistPath;
}



+ (void)saveLocalGamesWithArray:(NSArray *)games {
    //这里使用位于沙盒的plist（程序会自动新建的那一个）
    NSArray *array = [NSArray arrayWithArray:games];

    [array writeToFile:[AppModel getPlistPath] atomically:YES];
 
}

+ (NSArray *)getLocalGamesWithPlist {
    NSArray *array = [NSArray arrayWithContentsOfFile:[AppModel getPlistPath]];
    return array;
}


@end







