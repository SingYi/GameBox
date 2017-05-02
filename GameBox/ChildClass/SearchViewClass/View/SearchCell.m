//
//  SearchCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *gameName;


@property (weak, nonatomic) IBOutlet UILabel *gameNumber;

@property (weak, nonatomic) IBOutlet UIButton *gameDownload;

@property (weak, nonatomic) IBOutlet UILabel *gameSize;

@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.gameNumber.font = [UIFont systemFontOfSize:14];
    self.gameNumber.textColor = [UIColor lightGrayColor];
    
    self.label1.font = [UIFont systemFontOfSize:12];
    self.label1.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.textColor = RGBCOLOR(197, 188, 100);
    self.label1.text = @"";
    self.label1.layer.cornerRadius = 3;
    self.label1.layer.masksToBounds = YES;
    [self.label1 sizeToFit];
    
    self.label2.font = [UIFont systemFontOfSize:12];
    self.label2.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.textColor = RGBCOLOR(197, 188, 100);
    self.label2.text = @"";
    self.label2.layer.cornerRadius = 3;
    self.label2.layer.masksToBounds = YES;
    [self.label2 sizeToFit];
    
    self.label3.font = [UIFont systemFontOfSize:12];
    self.label3.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.textColor = RGBCOLOR(197, 188, 100);
    self.label3.text = @"";
    self.label3.layer.cornerRadius = 3;
    self.label3.layer.masksToBounds = YES;
    [self.label3 sizeToFit];
    
    
    
    self.gameName.font = [UIFont systemFontOfSize:14];
    [self.gameName sizeToFit];
    
    self.gameSize.font = [UIFont systemFontOfSize:14];
    self.gameSize.textColor = [UIColor lightGrayColor];
    
    [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"downLoadButton"] forState:(UIControlStateNormal)];
    self.gameDownload.layer.cornerRadius = 4;
    self.gameDownload.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    //设置名称
    self.gameName.text = _dict[@"gamename"];
    
    //下载次数
    NSInteger dlNumber = ((NSString *)_dict[@"download"]).integerValue;
    if (dlNumber > 10000) {
        dlNumber = dlNumber / 10000;
        self.gameNumber.text = [NSString stringWithFormat:@"%ld万+次下载",dlNumber];
    } else {
        self.gameNumber.text = [NSString stringWithFormat:@"%ld次下载",dlNumber];
    }
    
    //标签
    NSString *type = _dict[@"types"];
    NSArray *types = [type componentsSeparatedByString:@" "];
    NSInteger i = 0;
    NSArray<UILabel *> *labels = @[self.label1,self.label2,self.label3];
    for (; i < types.count; i ++) {
        labels[i].text = [NSString stringWithFormat:@" %@ ",types[i]];
    }


    self.gameSize.text = [NSString stringWithFormat:@"%@M",_dict[@"size"]];
    
}


- (IBAction)downLoad:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellRowAtIndexpath:)]) {
        [self.delegate didSelectCellRowAtIndexpath:self.selectIndex];
    }
}







@end
