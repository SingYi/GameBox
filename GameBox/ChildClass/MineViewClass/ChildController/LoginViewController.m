//
//  LoginViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPassWordView.h"
#import "UserModel.h"
#import "ChangyanSDK.h"
#import <SDWebImageDownloader.h>

@interface LoginViewController ()<UITextFieldDelegate>

//用户名输入框
@property (nonatomic, strong) UITextField *userName;
//密码输入框
@property (nonatomic, strong) UITextField *passWord;
//登录按钮
@property (nonatomic, strong) UIButton *loginBtn;
//忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBtn;
//分割线
@property (nonatomic, strong) UIView *separateLine;
//注册按钮
@property (nonatomic, strong) UIButton *registerBtn;

//注册页面
@property (nonatomic, strong) RegisterViewController *registerView;
//忘记密码页面
@property (nonatomic, strong) ForgetPassWordView *forgetPaswordView;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.userName.text = @"";
    self.passWord.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.userName];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.separateLine];
    [self.view addSubview:self.registerBtn];
}

#pragma mark - responds
- (void)respondsToBtn:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
   if ([sender.titleLabel.text isEqualToString:@"忘记密码"]) {
       [self.navigationController pushViewController:self.forgetPaswordView animated:YES];
    } else {
        [self.navigationController pushViewController:self.registerView animated:YES];
    }
//    self.hidesBottomBarWhenPushed = NO;
}

/** 登录 */
- (void)respondsToLogin {
    //释放第一响应者
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    if (self.userName.text.length < 3) {
        
        [UserModel showAlertWithMessage:@"用户名太短" dismiss:nil];
        
        return;
    }
    
    if (self.passWord.text.length < 6) {
        [UserModel showAlertWithMessage:@"密码长度有误" dismiss:nil];
    }
    
    [UserModel userLoginWithUserName:self.userName.text PassWord:self.passWord.text Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            if (REQUESTSUCCESS) {
                //登录成功
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"avatar"], @"avatar");
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"id"],     @"userID");
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"tel"],    @"phoneNumber");
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"nicename"], @"nickname");
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //畅言单点登录
                [ChangyanSDK loginSSO:content[@"data"][@"id"] userName:content[@"data"][@"nicename"] profileUrl:@"" imgUrl:[NSString stringWithFormat:IMAGEURL,content[@"data"][@"avatar"]] completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                   
                    /*    
                    CYSuccess           = 0,     成功
                    CYParamsError       = 1,     参数错误
                    CYLoginError        = 2,     登录错误
                    CYOtherError        = 3,     其他错误 */
                    
                }];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [UserModel logIn];
                [UserModel showAlertWithMessage:@"登录成功" dismiss:nil];
            } else {
                
                [UserModel showAlertWithMessage:REQUESTMSG dismiss:nil];
            }
        } else {
            [UserModel showAlertWithMessage:@"网络不知道飞哪去了" dismiss:nil];
        }
    }];
    
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.secureTextEntry) {
        //这里写登录的事情
        [self respondsToLogin];
    } else {
        [self.userName resignFirstResponder];
        [self.passWord becomeFirstResponder];
    }
    
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.userName) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.userName.text.length >= 15) {
            self.userName.text = [textField.text substringToIndex:15];
            return NO;
        }
    } else if (textField == self.passWord) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passWord.text.length >= 16) {
            self.passWord.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}


#pragma mark - getter
- (UITextField *)userName {
    if (!_userName) {
        _userName = [[UITextField alloc]init];
        _userName.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _userName.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_account"]];
        imageView.bounds = CGRectMake(0, 0, 20, 20);
        imageView.center = CGPointMake(20, 15);
        
        [view addSubview:imageView];
        
        _userName.leftView = view;
        
        _userName.leftViewMode = UITextFieldViewModeAlways;
        _userName.borderStyle = UITextBorderStyleRoundedRect;
        _userName.placeholder = @"请输入手机号或用户名";
        _userName.keyboardType = UIKeyboardTypeASCIICapable;
        _userName.delegate = self;
        _userName.returnKeyType = UIReturnKeyNext;
    }
    return _userName;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [[UITextField alloc]init];
        _passWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, 185);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
        imageView.bounds = CGRectMake(0, 0, 20, 20);
        imageView.center = CGPointMake(20, 15);
        
        [view addSubview:imageView];
        
        _passWord.leftView = view;
        
        _passWord.leftViewMode = UITextFieldViewModeAlways;
        _passWord.borderStyle = UITextBorderStyleRoundedRect;
        _passWord.placeholder = @"请输入密码";
        _passWord.secureTextEntry = YES;
        _passWord.delegate = self;
        _passWord.returnKeyType = UIReturnKeyJoin;
    }
    return _passWord;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _loginBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _loginBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 260);
        _loginBtn.backgroundColor = [UIColor orangeColor];
        [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
        
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        
        [_loginBtn addTarget:self action:@selector(respondsToLogin) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginBtn;
}

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _forgetBtn.frame = CGRectMake(kSCREEN_WIDTH / 6 - 1, 285, kSCREEN_WIDTH / 3, 30);
        [_forgetBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        [_forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _forgetBtn;
}

- (UIView *)separateLine {
    if (!_separateLine) {
        _separateLine = [[UIView alloc] init];
        _separateLine.bounds = CGRectMake(0, 0, 2, 20);
        _separateLine.center = CGPointMake(kSCREEN_WIDTH / 2, 300);
        _separateLine.backgroundColor = [UIColor grayColor];
    }
    return _separateLine;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _registerBtn.frame = CGRectMake(kSCREEN_WIDTH / 2 + 1, 285, kSCREEN_WIDTH / 3, 30);
        [_registerBtn setTitle:@"立即注册" forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _registerBtn;
}

- (RegisterViewController *)registerView {
    if (!_registerView) {
        _registerView = [RegisterViewController new];
    }
    return _registerView;
}

- (ForgetPassWordView *)forgetPaswordView {
    if (!_forgetPaswordView) {
        _forgetPaswordView = [ForgetPassWordView new];
    }
    return _forgetPaswordView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
