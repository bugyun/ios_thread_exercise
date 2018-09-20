//
//  RunLoopViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/20.
//  Copyright © 2018年 ruoyun. All rights reserved.
//
/**
 * 什么是RunLoop
 * 基本作用：
 * 1.保持程序的持续运行
 * 2.处理app中的各种事件（比如触摸事件、定时器事件、Selector事件）
 * 3.节省cpu资源，提高程序性能：该做事时做事，该休息时休息
 *
 * 如何获取RunLoop
 * 1.Foundation
 * 2.NSRunLoop
 *
 * Core Foundation
 * CFRunLoopRef
 *
 * NSRunLoop 和 CFRunLoopRef 都代表着RunLoop 对象
 * NSRunLoop 是基于 CFRunLoopRef 的一层OC包装，所以要了解RunLoop内部结构，需要多研究 CFRunLoopRef 层面的API(Core Foundation层面)
 *
 *
 * 获取RunLoop对象
 * Foundation:
 *  [NSRunLoop currentRunLoop]; 获得当前线程的RunLoop对象
 *  [NSRunLoop mainRunLoop]; 获取主线程的RunLoop对象
 * Core Foundation:
 *  CFRunLoopGetCurrent(); 获得当前线程的RunLoop对象
 *  CFRunLoopGetMain(); 获得主线程RunLoop对象
 */

#import "RunLoopViewController.h"

@interface RunLoopViewController ()

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self runLoop];
//    [self timer];
//    [self timer2];
    [self timerThread];
}

- (void)runLoop {
    //1.获得主线程对应的RunLoop
    NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
    //2.获得当前线程对应的runLoop
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];

    NSLog(@"%p-------%p", mainRunLoop, currentRunLoop);
//    NSLog(@"%@", mainRunLoop);

    //core
    NSLog(@"%p", CFRunLoopGetMain());
//    NSLog(@"%@", CFRunLoopGetMain());
    NSLog(@"%p", CFRunLoopGetCurrent());
//    NSLog(@"%@", CFRunLoopGetCurrent());

    NSLog(@"%p", mainRunLoop.getCFRunLoop);

    //RunLoop和线程的关系
    //一一对应，主线程的runLoop已经创建，但是子线程的需要手动创建
    [[[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil] start];
}

- (void)run {
    //如何创建子线程对应的runLoop,currentRunLoop懒加载
    NSLog(@"%@", [NSRunLoop currentRunLoop]);
    NSLog(@"run---%@", [NSThread currentThread]);
}

/**
 * RunLoop相关类
 * Core Foundation中关于RunLoop的5个类
 * 1.CFRunLoopRef
 * 2.CFRunLoopModeRef
 * 3.CFRunLoopSourceRef
 * 4.CFRunLoopTimerRef
 * 5.CFRunLoopObserverRef
 *
 *
 * CFRunLoopModeRef代表runloop的运行模式
 * 1.一个runloop包含若干个mode,每个mode又包含若干个source/timer/observer
 * 2.每次runloop启动时，只能指定其中一个mode,这个mode被称作currentMode
 * 3.如果需要切换mode,只能退出Loop,再重新指定一个mode进入
 * 4.这样做主要是为了分隔开不同组的source/timer/observer，让其互不影响
 *
 * CFRunLoopModeRef默认5种mode:
 * 1.kCFRunLoopDefaultMode:app的默认mode,通常主线程是在这个mode下运行
 * 2.UITrackingRunLoopMode:界面跟踪mode,用于ScrollView追踪触摸滑动，保证界面滑动时不受其他mode影响
 * 3.UIInitializationRunLoopMode:在刚启动app时进入第一个mode,启动完成后就不在使用
 * 4.GSEventReceiveRunLoopMode:接受系统事件的内部mode,通常用不到
 * 5.kCFRunLoopCommonModes:这是一个占位用的mode,不是一种真正的mode
 */

- (void)timer {
    //1.创建定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    /**
     * 2.添加定时器到runloop中，指定runloop的运行模式
     * 第一个参数：定时器
     * 第二个参数：runloop的运行模式
     */
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];//默认模式，如果界面处于界面滑动的时候，就会暂停这个timer
    /**
     * run-----<NSThread: 0x600001d0d140>{number = 1, name = main}---kCFRunLoopDefaultMode
     */
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];//界面追踪模式

    //NSRunLoopCommonModes = NSDefaultRunLoopMode + UITrackingRunLoopMode
    //凡是添加到 NSRunLoopCommonModes 中的事件，会同时被打上common标签的运行模式上
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];//界面追踪模式
}

//创建timer的第二种方式
- (void)timer2 {
    //该方法内部自动添加到runloop中，当前的runloop为 mainRunLoop ,并且设置运行模式为默认
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}

/**
 * RunLoop与线程
 * 1.每条线程都有唯一的一个与之对应的RunLoop对象
 * 2.主线程的RunLoop已经自动创建好了，子线程的RunLoop需要主动创建
 * 3.RunLoop在第一次获取时创建，在线程结束时销毁
 * 和 android 的 looper 的原理一样
 * https://blog.csdn.net/Luoshengyang/article/details/6817933
 */

//在子线程运行timer
- (void)timerThread {
    [NSThread detachNewThreadWithBlock:^{
        //创建当前线程的runloop,获取当前runloop
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        //如果不手动设置 NSRunLoop ，那么下面的代码就不会执行
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [currentRunLoop run];//开启runloop
    }];
}

- (void)timerRun {
    NSLog(@"run-----%@---%@", [NSThread currentThread], [NSRunLoop currentRunLoop].currentMode);
}
@end
