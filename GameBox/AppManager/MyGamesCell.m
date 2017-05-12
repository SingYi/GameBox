//
//  MyGamesCell.m
//  GameBox
//
//  Created by 石燚 on 2017/5/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyGamesCell.h"

@interface MyGamesCell ()

/** 游戏logo */
@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;
/** 游戏名称 */
@property (weak, nonatomic) IBOutlet UILabel *gameName;
/** 游戏大小 */
@property (weak, nonatomic) IBOutlet UILabel *gameSize;
/** 游戏版本 */
@property (weak, nonatomic) IBOutlet UILabel *gameVersion;
/** 打开游戏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@end

@implementation MyGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//游戏名称
- (void)setGameNameText:(NSString *)gameNameText {
    _gameNameText = gameNameText;
    self.gameName.text = _gameNameText;
    [self.gameName sizeToFit];
}

//游戏大小
- (void)setGameSizeText:(NSString *)gameSizeText {
    _gameSizeText = gameSizeText;
    self.gameSize.text = _gameSizeText;
    [self.gameSize sizeToFit];
}

//游戏版本
- (void)setGameVersionText:(NSString *)gameVersionText {
    _gameVersionText = gameVersionText;
    self.gameVersion.text = _gameVersionText;
    [self.gameVersion sizeToFit];
}

//游戏图标
- (void)setGameLogoImage:(UIImage *)gameLogoImage {
    self.gameLogo.image = gameLogoImage;
}


@end















