//
//  SearchCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchCellDelelgate <NSObject>

- (void)didSelectCellRowAtIndexpath:(NSDictionary *)dict;

@end

@interface SearchCell : UITableViewCell

/** 游戏信息 */
@property (nonatomic, strong) NSDictionary *dict;

/** 游戏logo */
@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

/** 游戏评分 */
@property (nonatomic, assign) CGFloat source;

/** 代理 */
@property (nonatomic, weak) id<SearchCellDelelgate> delegate;

@end
