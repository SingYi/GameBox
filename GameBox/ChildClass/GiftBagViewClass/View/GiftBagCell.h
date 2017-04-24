//
//  GiftBagCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftBagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *packLogo;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *packCounts;

@property (weak, nonatomic) IBOutlet UIView *packProgress;


@property (nonatomic, strong) UILabel * titlelabel;

@property (nonatomic, strong) UIView * progressView;;

@end
