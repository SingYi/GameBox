//
//  ReSetPassWordView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "NewPassWordView.h"
#import "LoginViewController.h"

//@class LoginViewController;

@interface NewPassWordView ()<UITextFieldDelegate>

//新密码
@property (nonatomic, strong) UITextField *passWord;

//确认密码
@property (nonatomic, strong) UITextField *affimPassWord;

//完成按钮
@property (nonatomic, strong) UIButton *completeBtn;

@end

@implementation NewPassWordView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新密码";
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.affimPassWord];
    [self.view addSubview:self.completeBtn];
}

#pragma mark - responds
- (void)respondsToCompleteBtn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - getter
- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [[UITextField alloc]init];
        _passWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        
        _passWord.borderStyle = UITextBorderStyleRoundedRect;
        _passWord.placeholder = @"请输入新密码";
        _passWord.secureTextEntry = YES;
        _passWord.delegate = self;
        _passWord.returnKeyType = UIReturnKeySend;
    }
    return _passWord;
}

- (UITextField *)affimPassWord {
    if (!_affimPassWord) {
        _affimPassWord = [[UITextField alloc]init];
        _affimPassWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _affimPassWord.center = CGPointMake(kSCREEN_WIDTH / 2, 185);
        
        _affimPassWord.borderStyle = UITextBorderStyleRoundedRect;
        _affimPassWord.placeholder = @"确认密码";
        _affimPassWord.secureTextEntry = YES;
        _affimPassWord.delegate = self;
        _affimPassWord.returnKeyType = UIReturnKeySend;
    }
    return _affimPassWord;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _completeBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _completeBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        [_completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [_completeBtn setBackgroundColor:[UIColor orangeColor]];
        _completeBtn.layer.cornerRadius = 4;
        _completeBtn.layer.masksToBounds = YES;
        [_completeBtn addTarget:self action:@selector(respondsToCompleteBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _completeBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
