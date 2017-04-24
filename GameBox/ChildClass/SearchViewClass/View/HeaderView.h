//
//  HeaderView.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RollingCarouselView;

@interface HeaderView : UIView

@property (nonatomic ,strong) RollingCarouselView *rollingCarouselView;


@property (nonatomic, strong) NSMutableArray *imageArray;

@end
