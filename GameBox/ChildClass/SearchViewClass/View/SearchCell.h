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

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

@property (nonatomic, weak) id<SearchCellDelelgate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@end
