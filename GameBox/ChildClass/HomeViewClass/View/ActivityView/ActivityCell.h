//
//  ActivityCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityName;

@property (weak, nonatomic) IBOutlet UILabel *activitySummary;

@property (weak, nonatomic) IBOutlet UILabel *activityTime;

@property (weak, nonatomic) IBOutlet UIImageView *activityLogo;

@end
