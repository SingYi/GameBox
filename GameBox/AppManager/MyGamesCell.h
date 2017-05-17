//
//  MyGamesCell.h
//  GameBox
//
//  Created by 石燚 on 2017/5/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyGamesCell;

@protocol MygamesCellDelegate <NSObject>

- (void)myGameCellClickOpenBtnWithIndex:(NSInteger)idx;

@end

@interface MyGamesCell : UITableViewCell

@property (nonatomic, strong) NSString *gameLogoImage;

@property (nonatomic, strong) NSString *gameNameText;

@property (nonatomic, strong) NSString *gameSizeText;

@property (nonatomic, strong) NSString *gameVersionText;

@property (nonatomic, assign) NSInteger  index;

@property (nonatomic, weak) id<MygamesCellDelegate> delegate;


@end
