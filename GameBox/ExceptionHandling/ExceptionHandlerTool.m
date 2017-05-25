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
#import "AFHTTPSessionManager.h"

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";


volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;


@interface ExceptionHandlerTool ()


@property (nonatomic, strong) UIView *window;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UILabel *label;


@end


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


- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {


}

/** 后续处理获取到的崩溃信息(续1秒) */
- (void)handleException:(NSException *)exception {
    
//    [self validateAndSaveCriticalApplicationData:exception];
    
    //发生异常时弹出对话框, 用户选择退出还是续1秒
    //注:续1秒是强行续,很多功能无法继续正常运行,建议用户重新启动app
    //AlertController 无法使用

//    [self.window addSubview:self.label];
//    [self.window addSubview:self.sureButton];
//    [self.window makeKeyWindow];
    
    //自定义加载提示
    [[UIApplication sharedApplication].keyWindow addSubview:self.window];
    [self.window addSubview:self.label];
    [self.window addSubview:self.sureButton];
    [self.window addSubview:self.cancelButton];

    
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



//点击确定按钮
- (void)clicksureButton:(UIButton *)sender {
    _dismissed = YES;
}

//点击取消按钮
- (void)clickcancelButton {
    [self.window removeFromSuperview];
    [self.label removeFromSuperview];
    [self.sureButton removeFromSuperview];
    [self.cancelButton removeFromSuperview];
}

#pragma mark - getter 
- (UIView *)window {
    if (!_window) {
        _window = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _window.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    }
    return _window;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, kSCREEN_WIDTH * 0.9 * 0.618)];
        _label.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _label.backgroundColor = [UIColor whiteColor];
        _label.layer.cornerRadius = 10;
        _label.layer.masksToBounds = YES;
        _label.text = @"发生了不可预知的错误,程序崩溃了.建议您关闭应用程序,然后重新打开以解决问题\n如果依然存在问题,可能是应用版本过低,建议您卸载后重新下载安装.\n点击确定关闭应用";
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureButton.frame = CGRectMake(CGRectGetMinX(self.label.frame), CGRectGetMaxY(self.label.frame), kSCREEN_WIDTH * 0.9 / 2, 44);
        [_sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
        _sureButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        [_sureButton addTarget:self action:@selector(clicksureButton:) forControlEvents:(UIControlEventTouchUpInside)];
        _sureButton.layer.cornerRadius = 8;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelButton.frame = CGRectMake(CGRectGetMaxX(self.sureButton.frame), CGRectGetMinY(self.sureButton.frame), kSCREEN_WIDTH * 0.9 / 2, 44);

        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        [_cancelButton addTarget:self action:@selector(clickcancelButton) forControlEvents:(UIControlEventTouchUpInside)];
        _cancelButton.layer.cornerRadius = 8;
        _cancelButton.layer.masksToBounds = YES;
    }
    return _cancelButton;
}

@end


/** 获取奔溃信号 */
void HandleException(NSException *exception) {

    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    //时间
    NSDate *date = [NSDate date];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@\nException date: %@",name, reason, stackArray,date];
    
    //保存异常()
    SAVEOBJECT_AT_USERDEFAULTS(exceptionInfo, @"BoxWarring");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
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
    
    [[[ExceptionHandlerTool alloc] init] performSelectorOnMainThread:@selector(handleException:)withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason: [NSString stringWithFormat:@"Signal %d was raised.",
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





