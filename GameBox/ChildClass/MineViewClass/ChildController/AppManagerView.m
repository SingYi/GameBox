//
//  AppManagerView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "AppManagerView.h"

@interface AppManagerView ()

@end

@implementation AppManagerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterFace];
}


- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"应用管理";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
