//
//  ExceptionHandlerTool.h
//  GameBox
//
//  Created by 石燚 on 2017/5/22.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandlerTool : NSObject

@property (nonatomic, assign) BOOL dismissed;

void InstallUncaughtExceptionHandler();

@end
