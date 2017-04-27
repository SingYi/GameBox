//
//  UserModel.h
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/** 用户id */
@property (nonatomic, strong) NSString *uid;

/** 用户账号 */
@property (nonatomic, strong) NSString *account;

/** 用户手机 */
@property (nonatomic, strong) NSString *phoneNumber;

/** 用户邮箱 */
@property (nonatomic, strong) NSString *email;

/** 用户头像 */
@property (nonatomic, strong) NSData *avatar;


/** 当前的用户 */
+ (UserModel *)CurrentUser;


/** 退出登录 */
+ (void)logOut;

/** 用户id */
+ (NSString *)uid;


@end










