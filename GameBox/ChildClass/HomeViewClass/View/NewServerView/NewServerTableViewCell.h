//
//  NewServerTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewServerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UILabel *startTime;

@end
