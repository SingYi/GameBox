//
//  SearchCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

@end
