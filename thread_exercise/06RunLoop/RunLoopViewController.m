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
@property(nonatomic, strong) dispatch_source_t timer;
@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self runLoop];
//    [self timer];
    [self timer2];
//    [self timerThread];
//    [self runLoopWithGCD];
    [self observer];
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
 * 3.CFRunLoopSourceRef 是事件源（输入源）
 * 4.CFRunLoopTimerRef 是基于时间的触发器，基本上讲的就是NSTimer
 * 5.CFRunLoopObserverRef 是观察者，能够监听RunLoop状态改变
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

- (void)runLoopWithGCD {
    //1.创建GCD中的定时器
    /**
     * 第一个参数：source的类型 DISPATCH_SOURCE_TYPE_TIMER 表示是定时器
     * 第二个参数：描述信息，线程ID
     * 第三个参数：更详细的描述信息
     * 第四个参数：队列，决定GCD定时器中的任务在哪个线程中执行
     */
    //需要保存这个变量，不然当执行下面的操作的时候，这个对象就被销毁了
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //2.设置定时器（起始时间|间隔时间|精准度）
    /**
     * 第一个参数：定时器对象
     * 第二个参数：起始时间，DISPATCH_TIME_NOW 从现在开始计时
     * 第三个参数：间隔时间 2.0 GCD中时间单位为纳秒
     * 第四个参数：精准度 绝对精准0
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //3.设置定时器执行的任务
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD----%@", [NSThread currentThread]);
    });
    //4.启动执行
    dispatch_resume(timer);
    _timer = timer;
}

/**
 * CFRunLoopSourceRef 输入源
 * source0 系统触发
 * source1 用户触发
 */
- (IBAction)sourceBtnClick:(id)sender {
    NSLog(@"%s", __func__);
}

/**
 * CFRunLoopObserverRef 6种状态
 * kCFRunLoopEntry          即将进入Loop
 * kCFRunLoopBeforeTimers   即将处理Timer
 * kCFRunLoopBeforeSources  即将处理source
 * kCFRunLoopBeforeWaiting  即将进入休眠
 * kCFRunLoopAfterWaiting   刚从休眠中唤醒
 * kCFRunLoopExit           即将推出Loop
 * kCFRunLoopAllActivities  所有状态
 */
- (void)observer {
    //1.创建监听者
    /**
     * 第一个参数：怎么分配存储空间
     * 第二个参数：要监听的状态 kCFRunLoopAllActivities 所有的状态
     * 第三个参数：是否要持续监听
     * 第四个参数：优先级 总是传0
     * 第五个参数：当状态改变时候的回调
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入Loop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理Timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"刚从休眠中唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"即将推出Loop");
                break;
            default:
                break;
        }
    });
    /**
     * 第一个参数：要监听的哪个runloop
     * 第二个参数：观察者
     * 第三个参数：运行模式
     *   NSDefaultRunLoopMode  ==  kCFRunLoopDefaultMode
     *   NSRunLoopCommonModes  ==  kCFRunLoopCommonModes
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}

//runloop应用
//让一条线程永远不死
- (void)taskNoDead {
    NSLog(@"task1----%@", [NSThread currentThread]);
    //解决方法：开runloop
    //1.获得子线程对应的runloop
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    //保证runloop不退出
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
//    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    //2.默认是没有开启
    [runloop run];
//    [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];//10秒后结束
    NSLog(@"----end-----");
}

/**
 * RunLoop面试题
 * 1.什么是RunLoop？
 *  1）从字面意思看：运行循环、跑圈
 *  2）其实它内部就是do-while循环，在这个循环内部不断地处理各种任务（比如source/timer/observer）
 *  3）一个线程对应一个runloop,主线程的runloop默认已经启动，子线程的runloop得手动启动（调用run方法）
 *  4）runloop只能选择一个mode启动，如果当前mode中没有任何source(source0/source1)、timer,那么就直接退出runloop
 *
 *
 * 2.自动释放池什么时候释放？
 *  1)第一次创建释放池：启动runloop
 *  2)最后一次销毁释放池：runloop退出的时候
 *  3)其他时间创建和销毁：当runloop进入休眠的时候，销毁释放池；当runloop唤醒的时候，创建释放池
 *  4)通过Observer监听runloop的状态
 *
 *
 * 3.在开发中如何使用RunLoop?什么应用场景？
 *  1）开启一个常驻线程（让一个子线程不进入消亡状态，等待其他线程发来消息，处理其他时间）
 *      a）在子线程中开启一个定时器
 *      b）在子线程中进行一些长期监控
 *  2）可以控制定时器在特定模式下执行
 *  3）可以让某些事件（行为、任务）在特定模式下执行
 *  4）可以添加Observer监听RunLoop的状态，比如监听点击事件的处理（在所有点击事件之前做一些事情）
 */


@end
