//
//  AboutUsView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "AboutUsView.h"

@interface AboutUsView ()

@property (nonatomic, strong) UIImageView *imageView;

//官网
@property (nonatomic, strong) UITextField *label1;


//微博
@property (nonatomic, strong) UITextField *label2;


//微信
@property (nonatomic, strong) UITextField *label3;

@end

@implementation AboutUsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterFace];
}


- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于我们";
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
}

#pragma mark - getter 
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.bounds = CGRectMake(0, 0, 80, 80);
        _imageView.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        _imageView.backgroundColor = [UIColor orangeColor];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UITextField *)label1 {
    if (!_label1) {
        _label1 = [[UITextField alloc]init];
        _label1.userInteractionEnabled = NO;
        _label1.text = @"    官网地址:www.185sy.com";
        _label1.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _label1.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        
        _label1.backgroundColor = [UIColor lightGrayColor];
        
        _label1.layer.cornerRadius = 22;
        _label1.layer.masksToBounds = YES;
    }
    return _label1;
}

- (UITextField *)label2 {
    if (!_label2) {
        _label2 = [[UITextField alloc]init];
        _label2.userInteractionEnabled = NO;
        _label2.text = @"    官方微博:www.185sy.com";
        _label2.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _label2.center = CGPointMake(kSCREEN_WIDTH / 2, 315);
        
        _label2.backgroundColor = [UIColor lightGrayColor];
        
        _label2.layer.cornerRadius = 22;
        _label2.layer.masksToBounds = YES;
    }
    return _label2;
}

- (UITextField *)label3 {
    if (!_label3) {
        _label3 = [[UITextField alloc]init];
        _label3.userInteractionEnabled = NO;
        _label3.text = @"    官网地址:www.185sy.com";
        _label3.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _label3.center = CGPointMake(kSCREEN_WIDTH / 2, 380);
        
        _label3.backgroundColor = [UIColor lightGrayColor];
        
        _label3.layer.cornerRadius = 22;
        _label3.layer.masksToBounds = YES;
    }
    return _label3;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
