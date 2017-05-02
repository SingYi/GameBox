//
//  AboutUsView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "AboutUsView.h"

@interface AboutUsView ()

//logo
@property (nonatomic, strong) UIImageView *imageView;

//官网
@property (nonatomic, strong) UIView *viewIE;


//微博
@property (nonatomic, strong) UIView *viewWeiBo;


//微信
@property (nonatomic, strong) UIView *viewWeixin;

@end

@implementation AboutUsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterFace];
}


- (void)initUserInterFace {
    self.view.backgroundColor = RGBCOLOR(228, 217, 219);
    self.navigationItem.title = @"关于我们";
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.viewIE];
    [self.view addSubview:self.viewWeiBo];
    [self.view addSubview:self.viewWeixin];
}

#pragma mark - getter 
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.bounds = CGRectMake(0, 0, 80, 80);
        _imageView.center = CGPointMake(kSCREEN_WIDTH / 2, 120);

        _imageView.image = [UIImage imageNamed:@"aboutUs"];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}


- (UIView *)viewIE {
    if (!_viewIE) {
        _viewIE = [[UIView alloc] init];
        _viewIE.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _viewIE.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imageView.image = [UIImage imageNamed:@"aboutus_IE"];
        [_viewIE addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, kSCREEN_WIDTH - 100, 30)];
        title.text = @"官网地址:www.185sy.com";
        title.font = [UIFont systemFontOfSize:16];
        [_viewIE addSubview:title];
        
        _viewIE.backgroundColor = RGBCOLOR(201, 194, 194);
        _viewIE.layer.cornerRadius = 22;
        _viewIE.layer.masksToBounds = YES;
        
    }
    return _viewIE;
}



- (UIView *)viewWeiBo {
    if (!_viewWeiBo) {
        _viewWeiBo = [[UIView alloc] init];
        _viewWeiBo.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _viewWeiBo.center = CGPointMake(kSCREEN_WIDTH / 2, 315);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imageView.image = [UIImage imageNamed:@"aboutus_weibo"];
        [_viewWeiBo addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, kSCREEN_WIDTH - 100, 30)];
        title.text = @"官方微博:www.185sy.com";
        title.font = [UIFont systemFontOfSize:16];
        [_viewWeiBo addSubview:title];
        
        _viewWeiBo.backgroundColor = RGBCOLOR(201, 194, 194);
        _viewWeiBo.layer.cornerRadius = 22;
        _viewWeiBo.layer.masksToBounds = YES;
        
    }
    return _viewWeiBo;
}


- (UIView *)viewWeixin {
    if (!_viewWeixin) {
        _viewWeixin = [[UIView alloc] init];
        _viewWeixin.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _viewWeixin.center = CGPointMake(kSCREEN_WIDTH / 2, 380);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imageView.image = [UIImage imageNamed:@"aboutus_weixin"];
        [_viewWeixin addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, kSCREEN_WIDTH - 100, 30)];
        title.text = @"官方微信:www.185sy.com";
        title.font = [UIFont systemFontOfSize:16];
        [_viewWeixin addSubview:title];
        
        _viewWeixin.backgroundColor = RGBCOLOR(201, 194, 194);
        _viewWeixin.layer.cornerRadius = 22;
        _viewWeixin.layer.masksToBounds = YES;
        
    }
    return _viewWeixin;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
