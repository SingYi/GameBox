//
//  UserModel.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "UserModel.h"

#define ISLOGIN @"currentUserLogin"

#define USERLOGIN SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:YES], @"currentUserLogin");[[NSUserDefaults standardUserDefaults] synchronize]


#define USERLOGOUT SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], @"currentUserLogin");[[NSUserDefaults standardUserDefaults] synchronize]


static UserModel *currentUser = nil;

@implementation UserModel

/** 当前用户 */
+ (UserModel *)CurrentUser {
    NSNumber *isLogin = OBJECT_FOR_USERDEFAULTS(@"isLogin");

    if (isLogin.boolValue) {
        //登录返回用户数据
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentUser = [[UserModel alloc] init];
        });

        currentUser.uid = OBJECT_FOR_USERDEFAULTS(@"userID");
        currentUser.avatar = OBJECT_FOR_USERDEFAULTS(@"avatar");

        
        
        return currentUser;

    } else {
        return nil;
        //登录返回用户数据
    }
}

+ (void)logIn {
    USERLOGIN;
}

/** 退出登录 */
+ (void)logOut {
    USERLOGOUT;
}

+ (NSString *)uid {
    if ([UserModel CurrentUser]) {
        return [UserModel CurrentUser].uid;
    } else {
        return @"0";
    }
}

#pragma mark - setter




@end












