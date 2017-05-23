//
//  ExceptionHandlerTool.m
//  GameBox
//
//  Created by 石燚 on 2017/5/22.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ExceptionHandlerTool.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";


volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;


@implementation ExceptionHandlerTool

+ (NSArray *)backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

/** 处理崩溃信息 */
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {
//    syLog(@"===================%@",[exception callStackSymbols]);
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    syLog(@"========================================%@", exceptionInfo);
    
}

/** 获取奔溃信息 */
- (void)handleException:(NSException *)exception {
    
    [self validateAndSaveCriticalApplicationData:exception];
    
    //发生异常时弹出对话框, 用户选择退出还是续1秒
    //注:续1秒是强行续,很多功能无法继续正常运行,建议用户重新启动app
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉，程序出现了异常"  message:[NSString stringWithFormat:@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"@"异常原因如下:\n%@\n%@",[exception reason],[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]] preferredStyle:UIAlertControllerStyleAlert];
//
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        syLog(@"2");
//        _dismissed = YES;
//    }]];
//    
//    
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    
//        [alertController dismissViewControllerAnimated:YES completion:nil];
//        
//        syLog(@"1");
//    }]];
    
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    
    //AlertController 无法使用
    
    UIButton *testBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    testBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    testBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [testBtn addTarget:self action:@selector(clicktestBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:testBtn];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:testBtn];

    /** 强行续1秒 */
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!_dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}


- (void)clicktestBtn:(UIButton *)sender {
    [sender removeFromSuperview];
//    _dismissed = YES;
}

@end


/** 获取奔溃信号 */
void HandleException(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    
    NSArray *callStack = [ExceptionHandlerTool backtrace];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    //获取到的异常发送到 ExceptionHandlerTool的handleExceptio:法法
        [[[ExceptionHandlerTool alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}

/** 获取崩溃信息号后的相关操作 */
void SignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [ExceptionHandlerTool backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[ExceptionHandlerTool alloc] init] performSelectorOnMainThread:@selector(handleException:)withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason: [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),
       signal] userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]]waitUntilDone:YES];
}

/** 获取句柄,侦测奔溃信号 */
void InstallUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}





