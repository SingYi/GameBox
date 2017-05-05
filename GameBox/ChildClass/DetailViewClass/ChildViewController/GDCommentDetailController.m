//
//  GDCommentDetailController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/5.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GDCommentDetailController.h"

@interface GDCommentDetailController ()

@end

@implementation GDCommentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4)];
    NSMutableArray<UIImage *> *imageArray = [NSMutableArray arrayWithCapacity:12];
    
    for (NSInteger i = 1; i <= 12; i++) {
        NSString *str = [NSString stringWithFormat:@"downLoadin_%ld",i];
        UIImage *image = [UIImage imageNamed:str];
        
        [imageArray addObject:image];
    }
    
    
    imageView.animationImages = imageArray;
    imageView.animationDuration = 1;
    imageView.animationRepeatCount = 1000;
    [imageView startAnimating];
    
    [self.view addSubview:imageView];
    
}



@end
