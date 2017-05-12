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
+ (NSMutableDictionary *_Nullable)Apps;

/** 根据app的bundleID打开app */
+ (void)openAPPWithIde:(NSString *_Nullable)ide;

/** 获取本地游戏 */
+ (void)getLocalGamesWithBlock:(void(^_Nullable)(NSArray * _Nullable games, BOOL success))block;

//+ (NSDictionary *_Nullable)getAppinfoWithIde:(NSString *_Nullable)ide;

/** test */
//+ (void)installAPPWithIDE:(NSString *)ide;


@end
