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

/**游戏简介*/
@property (nonatomic, strong) NSString * aboutString;

@end
