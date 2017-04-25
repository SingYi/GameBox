//
//  SearchCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchCellDelelgate <NSObject>

- (void)didSelectCellRowAtIndexpath:(NSInteger)idx;

@end

@interface SearchCell : UITableViewCell

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

@property (nonatomic, weak) id<SearchCellDelelgate> delegate;

@end
