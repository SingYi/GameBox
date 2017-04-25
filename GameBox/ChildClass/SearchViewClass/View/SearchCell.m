//
//  SearchCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameImage;

@property (weak, nonatomic) IBOutlet UILabel *gameName;


@property (weak, nonatomic) IBOutlet UILabel *gameNumber;

@property (weak, nonatomic) IBOutlet UIButton *gameDownload;

@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.gameNumber.font = [UIFont systemFontOfSize:14];
    self.gameNumber.textColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.gameName.text = _dict[@"gamename"];
    self.gameNumber.text = [NSString stringWithFormat:@"%@次 下载",_dict[@"download"]];
}


- (IBAction)downLoad:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellRowAtIndexpath:)]) {
        [self.delegate didSelectCellRowAtIndexpath:self.selectIndex];
    }
}







@end
