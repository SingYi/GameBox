//
//  GifTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/5/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"

@class FLAnimatedImageView;

@interface GifTableViewCell : UITableViewCell

/** gif图片 */
@property (nonatomic, strong) FLAnimatedImageView *gifImageView;

/** gif图片地址 */
@property (nonatomic, strong) NSString *gifUrl;


@end
