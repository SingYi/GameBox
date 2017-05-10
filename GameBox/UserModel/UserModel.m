//
//  UserModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "UserModel.h"

#import "AFHTTPSessionManager.h"

/** url */
#define USER_LOGIN @"http://www.9344.net/api-user-login"
#define USER_REGISTER @"http://www.9344.net/api-user-register"
#define USER_SENDMSG @"http://www.9344.net/api-user-send_message"
#define USER_CHECKMSG @"http://www.9344.net/api-user-check_smscode"
#define USER_FINDPWD @"http://www.9344.net/api-user-forget_password"
#define USER_MODIFYPWD @"http://www.9344.net/api-user-modify_password"
#define USER_MODIFYNN @"http://www.9344.net/api-user-modify_nicename"
#define USER_UPLOAD @"http://www.9344.net/api-user-upload_portrait"

#define LOGINNOTIFICATION @"logingnotification"


static UserModel *currentUser = nil;

@implementation UserModel

/** 当前用户 */
+ (UserModel *)CurrentUser {
    NSNumber *isLogin = OBJECT_FOR_USERDEFAULTS(ISLOGIN);

    if (isLogin.boolValue) {
        //登录返回用户数据
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentUser = [[UserModel alloc] init];
        });

        currentUser.userID = OBJECT_FOR_USERDEFAULTS(@"userID");
        currentUser.avatar = OBJECT_FOR_USERDEFAULTS(@"avatar");
        currentUser.phoneNumber = OBJECT_FOR_USERDEFAULTS(@"phoneNumber");
        currentUser.nickName = OBJECT_FOR_USERDEFAULTS(@"nickname");
    
        
        return currentUser;

    } else {
        return nil;
    
    }
}

+ (void)logIn {
    USERLOGIN;
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:LOGINNOTIFICATION object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

/** 退出登录 */
+ (void)logOut {
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
    SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:YES], @"setUserAvatar");
    [[NSUserDefaults standardUserDefaults] synchronize];
    USERLOGOUT;
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:LOGINNOTIFICATION object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

+ (NSString *)uid {
    if ([UserModel CurrentUser]) {
        return [UserModel CurrentUser].userID;
    } else {
        return @"0";
    }
}

/** 保存头像 */
+ (BOOL)saveImg:(UIImage *)image {

    //png格式
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar.png"];

    [imagedata writeToFile:imagePath atomically:YES];
    
    return [imagedata writeToFile:imagePath atomically:YES];
}

+ (UIImage *)getImg {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar.png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}


#pragma mark - method ===============================================================
/** 用户登录 */
+ (void)userLoginWithUserName:(NSString *)userName
                     PassWord:(NSString *)passWord
                   Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:passWord forKey:@"password"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_LOGIN");
    if (!urlStr) {
        urlStr = USER_LOGIN;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
}

/** 用户注册 */
+ (void)userRegisterWithUserName:(NSString *)userName
                        PassWord:(NSString *)passWord
                     PhoneNumber:(NSString *)phoneNumber
                         MsgCode:(NSString *)msgCode
                           Email:(NSString *)email
                      Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:userName forKey:@"user_login"];
    [dict setObject:passWord forKey:@"password"];
    [dict setObject:phoneNumber forKey:@"tel"];
    [dict setObject:msgCode forKey:@"msg_code"];
    
    if (email) {
        [dict setObject:email forKey:@"user_email"];
    }
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_REGISTER");
    if (!urlStr) {
        urlStr = USER_REGISTER;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
}

/** 获取手机验证码 */
+ (void)userSendMessageWithPhoneNumber:(NSString *)phoneNumber
                              IsVerify:(NSString *)isVerify
                            Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:phoneNumber forKey:@"mobile"];
    if (isVerify) {
        [dict setObject:@"1" forKey:@"is_verify"];
    } else {
        [dict setObject:@"0" forKey:@"is_verify"];
    }
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_SENDMSG");
    if (!urlStr) {
        urlStr = USER_SENDMSG;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 检验验证码 */
+ (void)userCheckMessageWithPhoneNumber:(NSString *)phoneNumber
                            MessageCode:(NSString *)messageCode
                             Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:phoneNumber forKey:@"mobile"];
    
    [dict setObject:messageCode forKey:@"msg_code"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_CHECKMSG");
    if (!urlStr) {
        urlStr = USER_CHECKMSG;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
}

/** 重置密码 */
+ (void)userForgetPasswordWithUserID:(NSString *)userID
                            Password:(NSString *)password
                          RePassword:(NSString *)rePassword
                               Token:(NSString *)token
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userID forKey:@"id"];
    
    [dict setObject:password forKey:@"password"];
    
    [dict setObject:rePassword forKey:@"repassword"];
    
    [dict setObject:token forKey:@"token"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_FINDPWD");
    if (!urlStr) {
        urlStr = USER_FINDPWD;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 修改密码 */
+ (void)userModifyPasswordWithUserID:(NSString *)userID
                         OldPassword:(NSString *)oldPassword
                         NewPassword:(NSString *)newPassword
                         RePasswordk:(NSString *)rePassword
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userID forKey:@"id"];
    
    [dict setObject:oldPassword forKey:@"oldpassword"];
    
    [dict setObject:newPassword forKey:@"password"];
    
    [dict setObject:rePassword forKey:@"repassword"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_MODIFYPWD");
    if (!urlStr) {
        urlStr = USER_MODIFYPWD;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
    
}

/** 修改昵称 */
+ (void)userModifyNicknameWithUserID:(NSString *)userID
                            NickName:(NSString *)nickName
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userID forKey:@"id"];
    
    [dict setObject:nickName forKey:@"nicename"];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_MODIFYNN");
    if (!urlStr) {
        urlStr = USER_MODIFYNN;
    }
    
    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
}

/** 上传头像 */
+ (void)userUploadPortraitWithUserID:(NSString *)userID
                               Image:(UIImage *)image
                          Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_UPLOAD");
    if (!urlStr) {
        urlStr = USER_UPLOAD;
    }
    
    
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:@{@"id":userID} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"img"
                                fileName:fileName
                                mimeType:@"image/png"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        SAVEOBJECT_AT_USERDEFAULTS(responseObject[@"data"], @"avatar");
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {

    }];
    
    [task resume];
    
    
    
    
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:userID forKey:@"id"];
//    
//    [dict setObject:image forKey:@"img"];
//    
//    NSString *urlStr = OBJECT_FOR_USERDEFAULTS(@"USER_UPLOAD");
//    if (!urlStr) {
//        urlStr = USER_UPLOAD;
//    }
//    
//    [UserModel postRequestWithURL:urlStr params:dict completion:completion];
}


+ (void)showAlertWithMessage:(NSString *)message dismiss:(void(^)(void))dismiss {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}

@end












