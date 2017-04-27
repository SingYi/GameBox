//
//  RegisterViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RegisterViewController.h"
#import "MineModel.h"

@interface RegisterViewController ()<UITextFieldDelegate>

//用户名
@property (nonatomic, strong) UITextField *userName;

//密码
@property (nonatomic, strong) UITextField *passWord;

//手机号
@property (nonatomic, strong) UITextField *phoneNumber;

//验证码
@property (nonatomic, strong) UITextField *securityCode;

//邮箱
@property (nonatomic, strong) UITextField *email;

//注册按钮
@property (nonatomic, strong) UIButton *registerBtn;

/**< 发送验证码按钮 */
@property (nonatomic, strong) UIButton *sendMessageBtn;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self allTextFieldResignFistResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self allTextFieldResignFistResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterFace];
}

- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:217 / 255.0 blue:217/255.0 alpha:1];
    self.navigationItem.title = @"注册";
    [self.view addSubview:self.userName];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.phoneNumber];
    [self.view addSubview:self.securityCode];
    [self.view addSubview:self.email];
    [self.view addSubview:self.registerBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTextFieldResignFistResponder];
}

- (void)allTextFieldResignFistResponder {
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.securityCode resignFirstResponder];
    [self.email resignFirstResponder];
}

#pragma mark - responds
/** 注册 */
- (void)respondsToRegisterBtn {
    [MineModel postRegisterWithAccount:self.userName.text PassWord:self.passWord.text PhoneNumber:self.phoneNumber.text PhoneCode:self.securityCode.text email:nil Completion:^(NSDictionary * _Nullable content, BOOL success) {
        NSLog(@"%@",content);
        NSLog(@"%@",content[@"msg"]);
    }];
}

/** 响应发送验证码按钮 */
- (void)respondsToSendMessageBtn {
    if (self.phoneNumber.text) {
        [MineModel postPhoneCodeWithPhoneNumber:self.phoneNumber.text isVerify:nil Completion:^(NSDictionary * _Nullable content, BOOL success) {
            NSLog(@"%@",content[@"msg"]);
        }];
    }
    
}


#pragma mark - getter
- (UITextField *)creatTextFieldWithLeftView:(UIImageView *)lefitView WithRightView:(UIImageView *)rigthView WithPlaceholder:(NSString *)placeholder WithBounds:(CGRect)Bounds WithsecureTextEntry:(BOOL)secureTextEntry  {
    UITextField *textfield = [[UITextField alloc] init];
    textfield.bounds = Bounds;

    textfield.leftView = lefitView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.placeholder = placeholder;
    textfield.secureTextEntry = secureTextEntry;
    textfield.delegate = self;

    return textfield;
}

- (UITextField *)userName {
    if (!_userName) {
        _userName = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入手机号或用户名" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
    }
    return _userName;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入密码" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:YES];
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.3);
    }
    return _passWord;
}

- (UITextField *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入手机号" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _phoneNumber.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.4);
    }
    return _phoneNumber;
}

- (UITextField *)securityCode {
    if (!_securityCode) {
        _securityCode = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入验证码" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        
        _securityCode.rightView = self.sendMessageBtn;
        _securityCode.rightViewMode = UITextFieldViewModeAlways;
        
        _securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.5);
    }
    return _securityCode;
}

- (UITextField *)email {
    if(!_email) {
        _email = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入邮箱" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _email.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.6);
    }
    return _email;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _registerBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.7);
        [_registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateHighlighted)];
        [_registerBtn setBackgroundColor:[UIColor orangeColor]];
        _registerBtn.layer.cornerRadius = 4;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn addTarget:self action:@selector(respondsToRegisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _registerBtn;
}

- (UIButton *)sendMessageBtn {
    if (!_sendMessageBtn) {
        _sendMessageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendMessageBtn.backgroundColor = [UIColor orangeColor];
        [_sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [_sendMessageBtn addTarget:self action:@selector(respondsToSendMessageBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _sendMessageBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.3, 44);
    }
    
    return _sendMessageBtn;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
