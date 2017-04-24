//
//  NewServerTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "NewServerTableViewCell.h"

@implementation NewServerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gameName.font = [UIFont systemFontOfSize:14];
    self.startTime.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
