//
//  MineModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtils.h"


@interface MineModel : NSObject

/** 用户注册
 *  account:用户账号
 *  password:用户密码
 *  phoneNumber:手机号码
 *  phoneCode:手机验证码
 *  email:邮箱
 */
+ (void)postRegisterWithAccount:(NSString * _Nonnull)account
                      PassWord:(NSString * _Nonnull)passWord
                   PhoneNumber:(NSString * _Nonnull)phoneNumber
                     PhoneCode:(NSString * _Nonnull)phoneCode
                         email:(NSString * _Nullable)email
                     Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;


/** 用户登录 */
+ (void)postLoginWithAccount:(NSString * _Nonnull)account
                    PassWord:(NSString * _Nonnull)passWord
                  Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 获取手机验证码
 *  phoneNUmber:手机号码
 *  isVerify:是否需要验证,默认为0,不需要验证(非必选,只在找回密码时为1,需要验证)
 */
+ (void)postPhoneCodeWithPhoneNumber:(NSString * _Nonnull)phoneNumber
                            isVerify:(NSString * _Nullable)isVerify
                          Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 检验验证码接 */
+ (void)postCheckPhoneCodeWithPhoneNumber:(NSString * _Nonnull)phoneNumber
                                PhoneCode:(NSString * _Nonnull)phoneCode
                               Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 重置密码(忘记密码时重置) */
+ (void)postResetPassWordWithUserID:(NSString * _Nonnull)uid
                           PassWord:(NSString * _Nonnull)passWord
                    ConfirmPassWord:(NSString * _Nonnull)confirmPassword
                         Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

/** 修改密码 */
+ (void)postModifyPassWordWithUserID:(NSString * _Nonnull)uid
                         OldPassword:(NSString * _Nonnull)oldPassword
                         NewPassword:(NSString * _Nonnull)newPassword
                     ConfirmPassword:(NSString * _Nonnull)confirmPassword
                          Completion:(void(^_Nonnull)( NSDictionary  * _Nullable content,BOOL success))completion;

@end

















