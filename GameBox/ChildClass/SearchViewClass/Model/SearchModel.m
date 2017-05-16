//
//  SearchModel.m
//  GameBox
//
//  Created by 石燚 on 2017/5/8.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

/** 获取路径 */
+ (NSString *)getPlistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [path stringByAppendingPathComponent:@"searchPlist"];
    return plistPath;
}

/** 获取搜索历史 */
+ (NSArray *)getSearchHistory {
    NSArray *array = [NSArray arrayWithContentsOfFile:[SearchModel getPlistPath]];
    return array;
}

/** 添加历史记录 */
+ (void)addSearchHistoryWithKeyword:(NSString *)keyword {
    NSMutableArray *array = [[SearchModel getSearchHistory] mutableCopy];
    
    if (!array) {
        array = [NSMutableArray array];
        [array addObject:keyword];
    } else {
        NSInteger i = 0;
        for (; i < array.count; i++) {
            if ([array[i] isEqualToString:keyword]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:0];
                [array writeToFile:[SearchModel getPlistPath] atomically:YES];
                break;
            }
        }
    
        
        if (i < array.count) {
            return;
        }
        
        if (array.count >= 50) {
            [array replaceObjectAtIndex:0 withObject:keyword];
        } else {
            [array insertObject:keyword atIndex:0];
        }
    }
    
    
    
    

    [array writeToFile:[SearchModel getPlistPath] atomically:YES];
}

/** 清楚历史记录 */
+ (BOOL)clearSearchHistory {
    NSArray *array = nil;
    [array writeToFile:[SearchModel getPlistPath] atomically:YES];
    
    BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:[SearchModel getPlistPath] error:nil];
    
    return delete;

}

#pragma mark =====================================================
/** 获取礼包路径 */
+ (NSString *)getGiftPlistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [path stringByAppendingPathComponent:@"giftSearchPlist"];
    return plistPath;
}

/** 获取礼包搜索历史 */
+ (NSArray *)getGiftSearchHistory {
    NSArray *array = [NSArray arrayWithContentsOfFile:[SearchModel getGiftPlistPath]];
    return array;
}

/** 添加礼包历史记录 */
+ (void)addGiftSearchHistoryWithKeyword:(NSString *)keyword {
    NSMutableArray *array = [[SearchModel getGiftSearchHistory] mutableCopy];
    
    if (!array) {
        array = [NSMutableArray array];
        [array addObject:keyword];
    } else {
        NSInteger i = 0;
        for (; i < array.count; i++) {
            if ([array[i] isEqualToString:keyword]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:0];
                [array writeToFile:[SearchModel getGiftPlistPath] atomically:YES];
                break;
            }
        }
        
        
        if (i < array.count) {
            return;
        }
        
        if (array.count >= 50) {
            [array replaceObjectAtIndex:0 withObject:keyword];
        } else {
            [array insertObject:keyword atIndex:0];
        }
    }
    
    
    
    
    
    [array writeToFile:[SearchModel getGiftPlistPath] atomically:YES];
}

/** 清除礼包历史记录 */
+ (BOOL)clearGiftSearchHistory {
    NSArray *array = nil;
    [array writeToFile:[SearchModel getGiftPlistPath] atomically:YES];
    
    BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:[SearchModel getGiftPlistPath] error:nil];
    
    return delete;
    
}






@end










