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
+ (NSMutableDictionary *_Nullable)getLocalAllGameIde;

/** 根据app的bundleID打开app */
+ (void)openAPPWithIde:(NSString *_Nullable)ide;

/** 获取本地游戏 */
+ (void)getLocalGamesWithBlock:(void(^_Nullable)(NSArray * _Nullable games, BOOL success))block;

/** 将获取的本地游戏存入plist文件 */
+ (void)saveLocalGamesWithArray:(NSArray * _Nullable)games;

/** 读取本地plist文件中的游戏 */
+ (NSArray *_Nullable)getLocalGamesWithPlist;

//+ (NSDictionary *_Nullable)getAppinfoWithIde:(NSString *_Nullable)ide;

/** test */
//+ (void)installAPPWithIDE:(NSString *)ide;


@end
