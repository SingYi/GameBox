//
//  AppModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

/** 获取用户所有安装的app */
+ (NSMutableDictionary *)Apps;

/** 根据app的bundleID打开app */
+ (void)openAPPWithIde:(NSString *)ide;

+ (void)installAPPWithIDE:(NSString *)ide;

@end
