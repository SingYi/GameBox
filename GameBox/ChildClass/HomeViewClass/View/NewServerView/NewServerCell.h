//
//  NewServerCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewServerCellDelegate <NSObject>

- (void)didselectRowAtIndexpath:(NSIndexPath *)index;

- (void)newServerCellRefreshDataWithIndex:(NSInteger)index;

@end

@interface NewServerCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *DataArray;

/**下标*/
@property (nonatomic, assign) NSInteger idx;

@property (nonatomic, weak) id<NewServerCellDelegate> serverCellDelegate;

- (void)endAnimation;


@end
