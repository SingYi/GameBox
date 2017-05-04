//
//  GDLikesTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/5/4.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GDLikesTableViewCell.h"

#import <UIImageView+WebCache.h>

@interface GDLikesTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *game1Logo;

@property (weak, nonatomic) IBOutlet UILabel *game1Label;

@property (weak, nonatomic) IBOutlet UIImageView *game2Logo;

@property (weak, nonatomic) IBOutlet UILabel *game2Label;

@property (weak, nonatomic) IBOutlet UIImageView *game3Logo;

@property (weak, nonatomic) IBOutlet UILabel *game3Label;

@property (weak, nonatomic) IBOutlet UIImageView *game4Logo;

@property (weak, nonatomic) IBOutlet UILabel *game4Label;



@end

@implementation GDLikesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray<UIImageView *> *logoArray = @[self.game1Logo,self.game2Logo,self.game3Logo,self.game4Logo];
    NSArray<UILabel *> *labeArry = @[self.game1Label,self.game2Label,self.game3Label,self.game4Label];
    
    [labeArry enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        obj.frame = CGRectMake(kSCREEN_WIDTH / 4 * idx, 70, kSCREEN_WIDTH / 4, 20);
        obj.font = [UIFont systemFontOfSize:13];
        obj.textAlignment = NSTextAlignmentCenter;
        obj.textColor = [UIColor darkTextColor];
        
        logoArray[idx].bounds = CGRectMake(0, 0, 60, 60);
        
        logoArray[idx].center = CGPointMake(obj.center.x, 40);
        
    }];
}

- (void)setArray:(NSArray *)array {
    _array = array;
    NSInteger i = 0;
    NSArray<UIImageView *> *logoArray = @[self.game1Logo,self.game2Logo,self.game3Logo,self.game4Logo];
    NSArray<UILabel *> *labeArry = @[self.game1Label,self.game2Label,self.game3Label,self.game4Label];
    
    for (; i < array.count; i++) {
        logoArray[i].hidden = NO;
        labeArry[i].hidden = NO;
        
        labeArry[i].text = array[i][@"gamename"];
        [logoArray[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,array[i][@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    }
    
    for (; i < logoArray.count; i++) {
        logoArray[i].hidden = YES;
        labeArry[i].hidden = YES;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}










@end
