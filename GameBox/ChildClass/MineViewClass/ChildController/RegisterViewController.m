//
//  RegisterViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"
#import "ChangyanSDK.h"



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
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

//当前的时间;
@property (nonatomic, assign) NSInteger currnetTime;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.userName.text = @"";
    self.passWord.text = @"";
    self.phoneNumber.text = @"";
    self.securityCode.text = @"";
    self.email.text = @"";
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
    
    //用户名太短,返回
    if (self.userName.text.length < 3) {
        [UserModel showAlertWithMessage:@"用户名长度太短" dismiss:nil];
        return;
    }
    //密码太短
    if (self.passWord.text.length < 6) {
        [UserModel showAlertWithMessage:@"密码长度太短" dismiss:nil];
    }
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:self.phoneNumber.text]) {
        [UserModel showAlertWithMessage:@"手机号码有误" dismiss:nil];
        return;
    }
    //验证码长度不正确
    if (self.securityCode.text.length != 4) {
        [UserModel showAlertWithMessage:@"验证码长度有误" dismiss:nil];
    }
    //email格式不对
    if (self.email.text.length > 0) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:self.email.text]) {
            [UserModel showAlertWithMessage:@"邮箱地址有误" dismiss:nil];
        }
    }
    
    [ControllerManager starLoadingAnimation];
    [UserModel userRegisterWithUserName:self.userName.text PassWord:self.passWord.text PhoneNumber:self.phoneNumber.text MsgCode:self.securityCode.text Email:self.email.text Completion:^(NSDictionary * _Nullable content, BOOL success) {
        [ControllerManager stopLoadingAnimation];
        if (success) {
            if (REQUESTSUCCESS) {

                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"avatar"], @"avatar");
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"id"],     @"userID");
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"tel"],    @"phoneNumber");
                SAVEOBJECT_AT_USERDEFAULTS(content[@"data"][@"nicename"], @"nickname");
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                //畅言单点登录
                [ChangyanSDK loginSSO:content[@"data"][@"id"] userName:content[@"data"][@"nicename"] profileUrl:@"" imgUrl:[NSString stringWithFormat:IMAGEURL,content[@"data"][@"avatar"]] completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                    
                    /*
                     CYSuccess           = 0,     成功
                     CYParamsError       = 1,     参数错误
                     CYLoginError        = 2,     登录错误
                     CYOtherError        = 3,     其他错误 */
                    
                }];
                
                [UserModel logIn];
                [UserModel showAlertWithMessage:@"注册成功" dismiss:nil];
//                syLog(@"%@",content);
            } else {
                
                if (content) {
                    [UserModel showAlertWithMessage:REQUESTMSG dismiss:nil];
                } else {
                    [UserModel showAlertWithMessage:@"网络不知道飞哪里去了~" dismiss:nil];
                }
            }
        } else {
            [UserModel showAlertWithMessage:@"网络不知道飞哪去了" dismiss:nil];
        }
        
    
    }];
}

/** 响应发送验证码按钮 */
- (void)respondsToSendMessageBtn {
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (![regextestmobile evaluateWithObject:self.phoneNumber.text]) {
        [UserModel showAlertWithMessage:@"手机号码有误" dismiss:nil];
        return;
    }
    
    WeakSelf;
    
    [UserModel userSendMessageWithPhoneNumber:self.phoneNumber.text IsVerify:nil Completion:^(NSDictionary * _Nullable content, BOOL success) {
        
        if (success) {
            _currnetTime = 59;
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
            [UserModel showAlertWithMessage:content[@"msg"] dismiss:nil];
        } else {
            [UserModel showAlertWithMessage:@"网络不知道飞哪去了~" dismiss:nil];
        }
    }];
    
}

- (void)refreshTime {
    [self.sendMessageBtn setTitle:[NSString stringWithFormat:@"%lds",_currnetTime] forState:(UIControlStateNormal)];
    [self.sendMessageBtn setUserInteractionEnabled:NO];
    if (_currnetTime <= 0) {
        [self stopTimer];
        [self.sendMessageBtn setUserInteractionEnabled:YES];
        [self.sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
    }
    _currnetTime--;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.email) {
        [self respondsToRegisterBtn];
    } else if (textField == self.userName) {
        [self.userName resignFirstResponder];
        [self.passWord becomeFirstResponder];
    } else if (textField == self.passWord) {
        [self.passWord resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    } else if (textField == self.phoneNumber) {
        [self.phoneNumber resignFirstResponder];
        [self.securityCode becomeFirstResponder];
    } else if (textField == self.securityCode) {
        [self.securityCode resignFirstResponder];
        [self.email becomeFirstResponder];
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
    } else if (textField == self.phoneNumber) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.phoneNumber.text.length >= 11) {
            self.phoneNumber.text = [textField.text substringToIndex:11];
            return NO;
        }
    } else if (textField == self.securityCode) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.securityCode.text.length >= 4) {
            self.securityCode.text = [textField.text substringToIndex:4];
            return NO;
        }
    } else if (textField == self.email) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.email.text.length >= 30) {
            self.email.text = [textField.text substringToIndex:30];
            return NO;
        }
    }
    return YES;
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
        _userName.returnKeyType = UIReturnKeyNext;
        _userName.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _userName;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入密码" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:YES];
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.3);
        _passWord.returnKeyType = UIReturnKeyNext;
    }
    return _passWord;
}

- (UITextField *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入手机号" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _phoneNumber.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.4);
        _phoneNumber.returnKeyType = UIReturnKeyNext;
        _phoneNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _phoneNumber;
}

- (UITextField *)securityCode {
    if (!_securityCode) {
        _securityCode = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入验证码" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        
        _securityCode.rightView = self.sendMessageBtn;
        _securityCode.rightViewMode = UITextFieldViewModeAlways;
        
        _securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.5);
        _securityCode.returnKeyType = UIReturnKeyNext;
        _securityCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _securityCode;
}

- (UITextField *)email {
    if(!_email) {
        _email = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入邮箱" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _email.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.6);
        _email.returnKeyType = UIReturnKeyDone;
        _email.keyboardType = UIKeyboardTypeEmailAddress;
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
        _sendMessageBtn.layer.cornerRadius = 2;
        _sendMessageBtn.layer.masksToBounds = YES;
    }
    
    return _sendMessageBtn;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
