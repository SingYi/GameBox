//
//  ResetPassWordViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "UserModel.h"

@interface ResetPassWordViewController ()<UITextFieldDelegate>

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.oriPassWord.text = @"";
    self.reSetWord.text = @"";
    self.affirmWord.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.oriPassWord becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.oriPassWord];
    [self.view addSubview:self.reSetWord];
    [self.view addSubview:self.affirmWord];
    [self.view addSubview:self.sureBtn];
}

- (void)allTextFiledresignFirstResponder {
    [self.oriPassWord resignFirstResponder];
    [self.reSetWord resignFirstResponder];
    [self.affirmWord resignFirstResponder];
}

#pragma mark - responds
/** 修改密码按钮 */
- (void)respondsToSureBtn {
    [self allTextFiledresignFirstResponder];
    
    if (self.oriPassWord.text.length < 6) {
        [UserModel showAlertWithMessage:@"原始密码长度不少于6位" dismiss:nil];
        [self.oriPassWord becomeFirstResponder];
        return;
    }
    
    if (self.reSetWord.text.length < 6) {
        [UserModel showAlertWithMessage:@"新密码长度不少于6位" dismiss:nil];
        [self.reSetWord becomeFirstResponder];
        return;
    }
    
    if (self.affirmWord.text.length < 6) {
        [UserModel showAlertWithMessage:@"确认密码长度不少于6位" dismiss:nil];
        [self.affirmWord becomeFirstResponder];
        return;
    }
    
    if (![self.reSetWord.text isEqualToString:self.affirmWord.text]) {
        [UserModel showAlertWithMessage:@"两次输入密码不相等" dismiss:nil];
        return;
    }
    
    [ControllerManager starLoadingAnimation];
    [UserModel userModifyPasswordWithUserID:[UserModel uid] OldPassword:self.oriPassWord.text NewPassword:self.reSetWord.text RePasswordk:self.affirmWord.text Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            if (REQUESTSUCCESS) {
                [ControllerManager stopLoadingAnimation];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [UserModel showAlertWithMessage:@"密码修改成功" dismiss:nil];
            } else {
                [ControllerManager stopLoadingAnimation];
                [UserModel showAlertWithMessage:REQUESTMSG dismiss:nil];
            }
        } else {
            [ControllerManager stopLoadingAnimation];
            [UserModel showAlertWithMessage:@"网络不知道哪里去了" dismiss:nil];
        }
    }];
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.affirmWord) {
        [self respondsToSureBtn];
    } else if (textField == self.oriPassWord) {
        [self.oriPassWord resignFirstResponder];
        [self.reSetWord becomeFirstResponder];
    } else if (textField == self.reSetWord) {
        [self.reSetWord resignFirstResponder];
        [self.affirmWord becomeFirstResponder];
    }
    
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if (textField.text.length >= 16) {
        textField.text = [textField.text substringToIndex:16];
        return NO;
    }
    
    return YES;
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
        _oriPassWord.returnKeyType = UIReturnKeyNext;
        _oriPassWord.delegate = self;
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
        _reSetWord.returnKeyType = UIReturnKeyNext;
        _reSetWord.delegate = self;
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
        _affirmWord.returnKeyType = UIReturnKeyDone;
        _affirmWord.delegate = self;
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
