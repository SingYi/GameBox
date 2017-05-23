//
//  ExceptionHandlerTool.h
//  GameBox
//
//  Created by 石燚 on 2017/5/22.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandlerTool : NSObject

/** app是否消失(强行续) */
@property (nonatomic, assign) BOOL dismissed;


@end

/** 奔溃的信息 */
void HandleException(NSException *exception);
/** 奔溃信号处理 */
void SignalHandler(int signal);
/** 设置获取崩溃信号句柄 */
void InstallUncaughtExceptionHandler(void);


