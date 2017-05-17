//
//  UserModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RequestUtils.h"
#import <UIKit/UIKit.h>
#import "ControllerManager.h"

#define ISLOGIN @"currentUserLogin"
#define USERLOGIN SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:YES], ISLOGIN);[[NSUserDefaults standardUserDefaults] synchronize]

#define USERLOGOUT SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], ISLOGIN);[[NSUserDefaults standardUserDefaults] synchronize]

@interface UserModel : RequestUtils

#pragma mark =======================用户属性================================
/** 用户id */
@property (nonatomic, strong) NSString * _Nullable userID;

/** 用户账号 */
@property (nonatomic, strong) NSString * _Nullable account;

/** 用户手机 */
@property (nonatomic, strong) NSString * _Nullable phoneNumber;

/** 用户邮箱 */
@property (nonatomic, strong) NSString * _Nullable email;

/** 用户头像 */
@property (nonatomic, strong) NSData * _Nullable avatar;

/** 用户昵称 */
@property (nonatomic, strong) NSString * _Nullable nickName;

#pragma mark ========================模型方法===============================
/** 当前的用户 */
+ (UserModel *_Nullable)CurrentUser;

/** 退出登录 */
+ (void)logOut;

/** 登录 */
+ (void)logIn;


/** 用户id */
+ (NSString *_Nonnull)uid;

/** 保存头像在本地 */
+ (BOOL)saveImg:(UIImage * _Nonnull)image;

/** 获取本地头像 */
+ (UIImage *_Nonnull)getImg;

#pragma mark =======================登录注册方法==============================
/** 用户登录接口
 *  username:用户名或者手机号
 */
+ (void)userLoginWithUserName:(NSString *_Nonnull)userName
                     PassWord:(NSString *_Nonnull)passWord
                   Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 用户注册接口 */
+ (void)userRegisterWithUserName:(NSString * _Nonnull)userName
                        PassWord:(NSString * _Nonnull)passWord
                     PhoneNumber:(NSString * _Nonnull)phoneNumber
                         MsgCode:(NSString * _Nonnull)msgCode
                           Email:(NSString * _Nullable)email
                      Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 获取手机验证码接口 
 *  isVerify:是否需要验证(非必选,默认0,设置为1时需要验证.在通过手机号码找回密码时需要验证)
 */
+ (void)userSendMessageWithPhoneNumber:(NSString * _Nonnull)phoneNumber
                              IsVerify:(NSString * _Nullable)isVerify
                            Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;


/** 检验验证码接口 */
+ (void)userCheckMessageWithPhoneNumber:(NSString * _Nonnull)phoneNumber
                            MessageCode:(NSString * _Nonnull)messageCode
                             Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 找回密码接口 */
+ (void)userForgetPasswordWithUserID:(NSString * _Nonnull)userID
                            Password:(NSString * _Nonnull)password
                          RePassword:(NSString * _Nonnull)rePassword
                               Token:(NSString * _Nonnull)token
                          Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 修改密码接口 */
+ (void)userModifyPasswordWithUserID:(NSString * _Nonnull)userID
                         OldPassword:(NSString * _Nonnull)oldPassword
                         NewPassword:(NSString * _Nonnull)newPassword
                         RePasswordk:(NSString * _Nonnull)rePassword
                          Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 修改昵称接口 */
+ (void)userModifyNicknameWithUserID:(NSString * _Nonnull)userID
                            NickName:(NSString * _Nonnull)nickName
                          Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 上传头像 */
+ (void)userUploadPortraitWithUserID:(NSString * _Nonnull)userID
                               Image:(UIImage * _Nonnull)image
                          Completion:(void(^_Nullable)(NSDictionary *_Nullable content, BOOL success))completion;

/** 显示提示信息 */
+ (void)showAlertWithMessage:(NSString *_Nullable)message dismiss:(void(^_Nullable)(void))dismiss;


@end

















