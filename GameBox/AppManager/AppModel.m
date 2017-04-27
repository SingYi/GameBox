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

@implementation AppModel

+ (NSMutableDictionary *)Apps {

    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    NSArray *appList = [workspace performSelector:@selector(allApplications)];
    
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    
    
    
    NSMutableDictionary *list = [NSMutableDictionary new];
    
    NSMutableArray *appBundleID = [NSMutableArray arrayWithCapacity:appList.count];
    
    for (LSApplicationProxy_class in appList) {
        
        
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        
        NSString *version = [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
        
        NSString *teamID = [LSApplicationProxy_class performSelector:@selector(teamID)];
        
        NSInteger originalInstallType = [LSApplicationProxy_class performSelector:@selector(originalInstallType)];
        
        NSInteger installType = [LSApplicationProxy_class performSelector:@selector(installType)];
        
        NSNumber *itemID = [LSApplicationProxy_class performSelector:@selector(itemID)];
        
        NSString *shortVersionString = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
        NSObject *description = [LSApplicationProxy_class performSelector:@selector(description)];
        
        NSObject *iconStyleDomain = [LSApplicationProxy_class performSelector:@selector(iconStyleDomain)];
        
        NSObject *localizedShortName = [LSApplicationProxy_class performSelector:@selector(localizedShortName)];
        
        NSObject *localizedName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        
        NSObject *privateDocumentTypeOwner = [LSApplicationProxy_class performSelector:@selector(privateDocumentTypeOwner)];
        
        NSObject *privateDocumentIconNames = [LSApplicationProxy_class performSelector:@selector(privateDocumentIconNames)];
        
        NSObject *resourcesDirectoryURL = [LSApplicationProxy_class performSelector:@selector(resourcesDirectoryURL)];
        
        NSObject *installProgress = [LSApplicationProxy_class performSelector:@selector(installProgress)];
        
        NSObject *appStoreReceiptURL = [LSApplicationProxy_class performSelector:@selector(appStoreReceiptURL)];
        
        NSNumber *storeFront = [LSApplicationProxy_class performSelector:@selector(storeFront)];
        
        NSNumber *staticDiskUsage = [LSApplicationProxy_class performSelector:@selector(staticDiskUsage)];
        
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
        
        NSString *applicationType = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        
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
        
        //发型版本?
        [dict setValue:shortVersionString forKey:@"shortVersionString"];
        
        
        
        //app图标
        NSData *data = [LSApplicationProxy_class performSelector:NSSelectorFromString(@"iconDataForVariant:") withObject:@(2)];
        
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
        UIImage *icon = [UIImage imageWithCGImage: cgImage];
        
        [dict setObject:icon forKey:@"appIcon"];
        
        
        [list setValue:dict forKey:bundleID];
        
        [appBundleID addObject:bundleID];
        

    }
    
    
    
    return [list copy];
}

+ (void)openAPPWithIde:(NSString *)ide {
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:ide];
    
}

+ (void)installAPPWithIDE:(NSString *)ide {
//    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
////    [workspace performSelector:@selector(uninstallApplication:withOptions:) withObject:@"XXX" withObject:nil];
////    [workspace performSelector:NSSelectorFromString(@"uninstallApplication:withOptions:") withObject:ide];
//    [workspace performSelector:@selector(uninstallApplication:withOptions:) withObject:ide withObject:nil];
    
    
    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, ide, kCFStringEncodingUTF8);
    if (identifier != NULL) {
        MobileInstallationUninstallForLaunchServices(identifier, NULL, NULL, NULL);
        CFRelease(identifier);
    }
    
    
}




@end







