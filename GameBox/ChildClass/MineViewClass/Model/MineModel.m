//
//  MineModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MineModel.h"
#import <UIKit/UIKit.h>



#define REGISTERURL @"http://www.9344.net/api-user-register"
#define LOGINURL @"http://www.9344.net/api-user-login"
#define SENDMESSAGEURL @"http://www.9344.net/api-user-send_message"
#define CHECKMESSAGEURL @"http://www.9344.net/api-user-check_smscode"
#define RESETPASSWORDURL @"http://www.9344.net/api-user-forget_password"
#define MODIFYPASSWORDURL @"http://www.9344.net/api-user-modify_password"


@implementation MineModel


/** 用户注册 */
+ (void)postRegisterWithAccount:(NSString *)account
                       PassWord:(NSString *)passWord
                    PhoneNumber:(NSString *)phoneNumber
                      PhoneCode:(NSString *)phoneCode
                          email:(NSString *)email
                     Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:account forKey:@"user_login"];
    [dict setObject:passWord forKey:@"password"];
    [dict setObject:phoneNumber forKey:@"tel"];
    [dict setObject:phoneCode forKey:@"msg_code"];
    
    if (email) {
        [dict setObject:email forKey:@"user_email"];
    }
    
    [RequestUtils postRequestWithURL:REGISTERURL params:dict completion:completion];
    
}

/** 用户登录 */
+ (void)postLoginWithAccount:(NSString *)account
                    PassWord:(NSString *)passWord
                  Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:account forKey:@"username"];
    [dict setObject:passWord forKey:@"password"];
    
    
    [RequestUtils postRequestWithURL:LOGINURL params:dict completion:completion];
}


+ (void)postPhoneCodeWithPhoneNumber:(NSString *)phoneNumber
                            isVerify:(NSString *)isVerify
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:phoneNumber forKey:@"mobile"];
    if (isVerify) {
        [dict setObject:@"1" forKey:@"is_verify"];
    } else {
        [dict setObject:@"0" forKey:@"is_verify"];
    }
    
    
    [RequestUtils postRequestWithURL:SENDMESSAGEURL params:dict completion:completion];
}


+ (void)postCheckPhoneCodeWithPhoneNumber:(NSString *)phoneNumber
                                PhoneCode:(NSString *)phoneCode
                               Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:phoneNumber forKey:@"mobile"];

    [dict setObject:phoneCode forKey:@"msg_code"];

    
    [RequestUtils postRequestWithURL:CHECKMESSAGEURL params:dict completion:completion];
}



+ (void)postResetPassWordWithUserID:(NSString *)uid
                           PassWord:(NSString *)passWord
                    ConfirmPassWord:(NSString *)confirmPassword
                              Token:(NSString *)token
                         Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:uid forKey:@"id"];
    
    [dict setObject:passWord forKey:@"password"];
    
    [dict setObject:confirmPassword forKey:@"repassword"];
    
    [dict setObject:token forKey:@"token"];
    
    [RequestUtils postRequestWithURL:RESETPASSWORDURL params:dict completion:completion];
    
}


+ (void)postModifyPassWordWithUserID:(NSString *)uid
                         OldPassword:(NSString *)oldPassword
                         NewPassword:(NSString *)newPassword
                     ConfirmPassword:(NSString *)confirmPassword
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:uid forKey:@"id"];
    
    [dict setObject:oldPassword forKey:@"oldpassword"];
    
    [dict setObject:newPassword forKey:@"password"];
    
    [dict setObject:confirmPassword forKey:@"repassword"];
    
    [RequestUtils postRequestWithURL:MODIFYPASSWORDURL params:dict completion:completion];
    
}

+ (void)postModifyNickNameWithUserID:(NSString *)uid NickName:(NSString *)nickName Copletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    
}


+ (void)showAlertWithMessage:(NSString *)message dismiss:(void(^)(void))dismiss {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}




@end






