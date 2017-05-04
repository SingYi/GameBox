//
//  GameDetailViewController.h
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameDetailViewController : UIViewController

/**展示图数组*/
@property (nonatomic, strong) NSArray * imagasArray;

/**猜你喜欢数组*/
@property (nonatomic, strong) NSArray * likes;

/**游戏相关数据*/
@property (nonatomic, strong) NSDictionary *dict;

/** 游戏简介 */
@property (nonatomic, strong) NSString *abstract;

/** 游戏特征 */
@property (nonatomic, strong) NSString *feature;

/** 游戏返利 */
@property (nonatomic, strong) NSString *rebate;

/** 评论数组 */
@property (nonatomic, strong) NSArray *commentArray;



/** 返回顶部 */
- (void)goToTop;

@end
