//
//  ResetPassWordViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "MineModel.h"

@interface ResetPassWordViewController ()

//原始密码
@property (nonatomic, strong) UITextField *oriPassWord;

//新密码
@property (nonatomic, strong) UITextField *reSetWord;

//确认密码
@property (nonatomic, strong) UITextField *affirmWord;

//确认按钮
@property (nonatomic, strong) UIButton *sureBtn;



@end

@implementation ResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.oriPassWord];
    [self.view addSubview:self.reSetWord];
    [self.view addSubview:self.affirmWord];
    [self.view addSubview:self.sureBtn];
}

#pragma mark - responds
- (void)respondsToSureBtn {
    [MineModel postModifyPassWordWithUserID:@"3103" OldPassword:self.oriPassWord.text NewPassword:self.reSetWord.text ConfirmPassword:self.affirmWord.text Completion:^(NSDictionary * _Nullable content, BOOL success) {
       
        NSLog(@"%@",content);
        NSLog(@"%@",content[@"msg"]);
        
    }];
}


#pragma mark - getter
- (UITextField *)oriPassWord {
    if (!_oriPassWord) {
        _oriPassWord = [[UITextField alloc]init];
        _oriPassWord.secureTextEntry = YES;
        _oriPassWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _oriPassWord.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        _oriPassWord.borderStyle = UITextBorderStyleRoundedRect;
        _oriPassWord.placeholder = @"请输入原始密码:";
    }
    return _oriPassWord;
}

- (UITextField *)reSetWord {
    if (!_reSetWord) {
        _reSetWord = [[UITextField alloc]init];
        _reSetWord.secureTextEntry = YES;
        _reSetWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _reSetWord.center = CGPointMake(kSCREEN_WIDTH / 2, 185);
        _reSetWord.borderStyle = UITextBorderStyleRoundedRect;
        _reSetWord.placeholder = @"请输入新密码:";
    }
    return _reSetWord;
}

- (UITextField *)affirmWord {
    if (!_affirmWord) {
        _affirmWord = [[UITextField alloc]init];
        _affirmWord.secureTextEntry = YES;
        _affirmWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _affirmWord.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        _affirmWord.borderStyle = UITextBorderStyleRoundedRect;
        _affirmWord.placeholder = @"请确认密码:";
    }
    return _affirmWord;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _sureBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 315);
        [_sureBtn setTitle:@"确认" forState:(UIControlStateNormal)];
        [_sureBtn setBackgroundColor:[UIColor orangeColor]];
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(respondsToSureBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
