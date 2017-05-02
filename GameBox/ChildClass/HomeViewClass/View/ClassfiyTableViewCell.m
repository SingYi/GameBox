//
//  ClassfiyTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ClassfiyTableViewCell.h"

@interface ClassfiyTableViewCell ()



@end

@implementation ClassfiyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.imageView1 setCenter:CGPointMake(kSCREEN_WIDTH / 8, self.bounds.size.height / 2)];
    [self.imageView2 setCenter:CGPointMake(kSCREEN_WIDTH / 8 * 3, self.bounds.size.height / 2)];
    [self.imageView3 setCenter:CGPointMake(kSCREEN_WIDTH / 8 * 5, self.bounds.size.height / 2)];
    [self.imageView4 setCenter:CGPointMake(kSCREEN_WIDTH / 8 * 7, self.bounds.size.height / 2)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
