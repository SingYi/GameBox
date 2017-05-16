//
//  SearchModel.h
//  GameBox
//
//  Created by 石燚 on 2017/5/8.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

//@property (nonatomic, strong) NSString *keyword;

/** 获取搜索历史 */
+ (NSArray *)getSearchHistory;

/** 添加搜索记录 */
+ (void)addSearchHistoryWithKeyword:(NSString *)keyword;

/** 清空搜索记录 */
+ (BOOL)clearSearchHistory;

/** 礼包搜索记录 */
+ (NSArray *)getGiftSearchHistory;

/** 添加礼包搜索记录 */
+ (void)addGiftSearchHistoryWithKeyword:(NSString *)keyword;

/** 清空搜索记录 */
+ (BOOL)clearGiftSearchHistory;

@end
