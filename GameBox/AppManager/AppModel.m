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

#define WORKSPACE [AppModel workSpace]

#define GETTYPE(type) [LSApplicationProxy_class performSelector:@selector(type)];

@implementation AppModel

+ (NSObject *)workSpace {
    
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    return workspace;
}

+ (NSMutableDictionary *)Apps {

#pragma GCC diagnostic ignored "-Wundeclared-selector"
    
    NSArray *appList = [WORKSPACE performSelector:@selector(allApplications)];
    
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    
    
    NSMutableDictionary *list = [NSMutableDictionary new];
    
    NSMutableArray *appBundleID = [NSMutableArray arrayWithCapacity:appList.count];
    
    
    for (LSApplicationProxy_class in appList) {
        
        /** bundleID */
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        
        /** 开发版本 */
        NSString *version = GETTYPE(bundleVersion);
        
        //开发人员
        NSString *teamID = [LSApplicationProxy_class performSelector:@selector(teamID)];
        
        //发布版本
        NSString *shortVersionString = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
        
        //本地简写名称
        NSObject *localizedShortName = [LSApplicationProxy_class performSelector:@selector(localizedShortName)];
        //本地名称
        NSObject *localizedName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        
        //文件路径
        NSObject *resourcesDirectoryURL = [LSApplicationProxy_class performSelector:@selector(resourcesDirectoryURL)];
        
        //安装进度
        NSObject *installProgress = [LSApplicationProxy_class performSelector:@selector(installProgress)];
        
        
        //安装类型(用户还是系统)
        NSInteger installType = (NSInteger)[LSApplicationProxy_class performSelector:@selector(installType)];
        //app大小
        NSNumber *staticDiskUsage = [LSApplicationProxy_class performSelector:@selector(staticDiskUsage)];
        
        //用户安装还是系统安装
        NSString *applicationType = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        
        
        NSInteger originalInstallType = (NSInteger)[LSApplicationProxy_class performSelector:@selector(originalInstallType)];
        
        
        NSNumber *itemID = [LSApplicationProxy_class performSelector:@selector(itemID)];
        
        NSObject *description = [LSApplicationProxy_class performSelector:@selector(description)];
        
        NSObject *iconStyleDomain = [LSApplicationProxy_class performSelector:@selector(iconStyleDomain)];
        
        
        NSObject *privateDocumentTypeOwner = [LSApplicationProxy_class performSelector:@selector(privateDocumentTypeOwner)];
        
        NSObject *privateDocumentIconNames = [LSApplicationProxy_class performSelector:@selector(privateDocumentIconNames)];
    
        
        NSObject *appStoreReceiptURL = [LSApplicationProxy_class performSelector:@selector(appStoreReceiptURL)];
        
        
        NSNumber *storeFront = [LSApplicationProxy_class performSelector:@selector(storeFront)];
        
        NSObject *deviceIdentifierForVendor = [LSApplicationProxy_class performSelector:@selector(deviceIdentifierForVendor)];
        
        NSArray *requiredDeviceCapabilities = [LSApplicationProxy_class performSelector:@selector(requiredDeviceCapabilities)];
        
        NSArray *appTags = [LSApplicationProxy_class performSelector:@selector(appTags)];
        
        NSArray *plugInKitPlugins = [LSApplicationProxy_class performSelector:@selector(plugInKitPlugins)];
        
        NSArray *VPNPlugins = [LSApplicationProxy_class performSelector:@selector(VPNPlugins)];
        
        NSArray *externalAccessoryProtocols = [LSApplicationProxy_class performSelector:@selector(externalAccessoryProtocols)];
        
        NSArray *audioComponents = [LSApplicationProxy_class performSelector:@selector(audioComponents)];
        
        NSArray *UIBackgroundModes = [LSApplicationProxy_class performSelector:@selector(UIBackgroundModes)];
        
        NSArray *directionsModes = [LSApplicationProxy_class performSelector:@selector(directionsModes)];
        
//        NSDictionary *groupContaixners = [LSApplicationProxy_class performSelector:@selector(groupContainers)];
        
        NSString *vendorName = [LSApplicationProxy_class performSelector:@selector(vendorName)];
        
        NSString *sdkVersion = [LSApplicationProxy_class performSelector:@selector(sdkVersion)];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        
        //版本信息
        [dict setValue:version forKey:@"bundleVersion"];
        //开发团队信息
        [dict setValue:teamID forKey:@"teamID"];
        //
        [dict setValue:@(originalInstallType) forKey:@"originalInstallType"];
        [dict setValue:@(installType) forKey:@"installType"];
        [dict setValue:itemID forKey:@"itemID"];
        [dict setValue:description forKey:@"description"];
        [dict setValue:itemID forKey:@"itemID"];
        [dict setValue:iconStyleDomain forKey:@"iconStyleDomain"];
        [dict setValue:localizedShortName forKey:@"localizedShortName"];
        [dict setValue:localizedName forKey:@"localizedName"];
        [dict setValue:privateDocumentTypeOwner forKey:@"privateDocumentTypeOwner"];
        [dict setValue:privateDocumentIconNames forKey:@"privateDocumentIconNames"];
        [dict setValue:resourcesDirectoryURL forKey:@"resourcesDirectoryURL"];
        [dict setValue:installProgress forKey:@"installProgress"];
        [dict setValue:appStoreReceiptURL forKey:@"appStoreReceiptURL"];
        [dict setValue:storeFront forKey:@"storeFront"];
        //        [dict setValue:dynamicDiskUsage forKey:@"dynamicDiskUsage"];
        [dict setValue:staticDiskUsage forKey:@"staticDiskUsage"];
        [dict setValue:deviceIdentifierForVendor forKey:@"deviceIdentifierForVendor"];
        [dict setValue:requiredDeviceCapabilities forKey:@"requiredDeviceCapabilities"];
        [dict setValue:appTags forKey:@"appTags"];
        [dict setValue:plugInKitPlugins forKey:@"plugInKitPlugins"];
        [dict setValue:VPNPlugins forKey:@"VPNPlugins"];
        [dict setValue:externalAccessoryProtocols forKey:@"externalAccessoryProtocols"];
        [dict setValue:audioComponents forKey:@"audioComponents"];
        [dict setValue:UIBackgroundModes forKey:@"UIBackgroundModes"];
        [dict setValue:directionsModes forKey:@"directionsModes"];
        //        [dict setValue:groupContainers forKey:@"groupContainers"];
        [dict setValue:vendorName forKey:@"vendorName"];
        [dict setValue:applicationType forKey:@"applicationType"];
        [dict setValue:sdkVersion forKey:@"sdkVersion"];
        
        //发型版本?s
        [dict setValue:shortVersionString forKey:@"shortVersionString"];
        
        
        
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
        
        
        //安装进度

        
        
        
        
        
        [list setValue:dict forKey:bundleID];
        
        [appBundleID addObject:bundleID];
        

    }
    
    
    
    return [list copy];
}

+ (void)openAPPWithIde:(NSString *)ide {

    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:ide];
    #pragma clang diagnostic pop
    
}

+ (void)installAPPWithIDE:(NSString *)ide {
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    [workspace performSelector:@selector(uninstallApplication:withOptions:) withObject:@"XXX" withObject:nil];
//    [workspace performSelector:NSSelectorFromString(@"uninstallApplication:withOptions:") withObject:ide];
    [workspace performSelector:@selector(uninstallApplication:withOptions:) withObject:ide withObject:nil];
    
    
//    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, ide, kCFStringEncodingUTF8);
//    if (identifier != NULL) {
//        MobileInstallationUninstallForLaunchServices(identifier, NULL, NULL, NULL);
//        CFRelease(identifier);
//    }
    
    
}




@end







