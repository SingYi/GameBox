//
//  NewServerTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "NewServerTableViewCell.h"

@interface NewServerTableViewCell ()

/** 游戏名称标签 */
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

/** 游戏开始标签 */
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

/** 提醒按钮 */
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

@end

@implementation NewServerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gameNameLabel.font = [UIFont systemFontOfSize:14];
    self.startTimeLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    if (_dict != dict) {
        _dict = dict;
    }
    
    //设置游戏名
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@ - %@",_dict[@"gamename"],_dict[@"server_id"]];
    
    //设置开服时间
    NSString *timeStr = _dict[@"start_time"];
    NSDate *starDate = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd hh:mm";
    timeStr = [formatter stringFromDate:starDate];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开服时间: %@",timeStr];
}




@end









