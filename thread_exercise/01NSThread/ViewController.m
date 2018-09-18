//
//  ViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/13.
//  Copyright © 2018 ruoyun. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "ZYHNSThread.h"

@interface ViewController ()

@end

@implementation ViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSLog(@"%@", NSThread.currentThread);
    //    NSLog(@"%@", [NSThread currentThread]);
    //    NSThread *_thread = [NSThread mainThread];//获得主线程
    //    BOOL _isMainThread = [NSThread isMainThread];//是否为主线程
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    [self createNewPThread];
//    [self createNewNSThread1];
//    [self createNewNSThread2];
//    [self createNewNSThread3];
    [self createNewNSThread4];
}

void *test(void *param) {
    NSLog(@"pthread_t--------%@", [NSThread currentThread]);
    return NULL;
}

//使用c 代码中的pthread_t 来创建线程
- (void)createNewPThread {
    pthread_t thread; //p_thread
    /**
     * 第一个参数：线程对象 传递地址
     * 第二个参数：线程的属性 NULL
     * 第三个参数：指向函数的指针
     * 第四个参数：函数需要接收的参数
     */
    pthread_create(&thread, NULL, test, "参数");
}

//alloc init 创建线程，需要手动启动线程
- (void)createNewNSThread1 {
    /**
     * 第一个参数：目标对象 self
     * 第二个参数：方法选择器 调用的方法
     * 第三个参数：函数需要接收的参数
     */
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"ABC"]; //1.创建线程
    thread.name = @"线程1";//线程名字
    thread.threadPriority = 0.5;//线程优先级 0.0-1.0 默认0.5 ，0.0 最低 ，1.0最高 To be deprecated; use qualityOfService below
    thread.qualityOfService = NSQualityOfServiceDefault;//线程优先级
    [thread start];                                                                                   //2.启动线程
}

//分离 子线程,会自动启动线程，缺点：没有办法拿到线程对象，设置不了名称和优先级等其他参数
- (void)createNewNSThread2 {
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"分离子线程"];//2.启动线程
}

//开启一条后台线程，缺点：没有办法拿到线程对象，设置不了名称和优先级等其他参数
- (void)createNewNSThread3 {
    [self performSelectorInBackground:@selector(run:) withObject:@"开启后台线程"];
}

//查看NSThread生命周期：当任务执行完毕之后被释放
- (void)createNewNSThread4 {
    ZYHNSThread *thread = [[ZYHNSThread alloc] initWithTarget:self selector:@selector(run:) object:@"ABC"]; //1.创建线程
    thread.name = @"线程1";//线程名字
    thread.threadPriority = 0.5;//线程优先级 0.0-1.0 默认0.5 ，0.0 最低 ，1.0最高 To be deprecated; use qualityOfService below
    thread.qualityOfService = NSQualityOfServiceDefault;//线程优先级
    [thread start];                                                                                   //2.启动线程
}

- (void)run:(NSString *)param {
    NSLog(@"NSThread--------%@---%@", [NSThread currentThread], param);
    for (int i = 0; i < 100; ++i) {
        NSLog(@"%i----%@", i, [NSThread currentThread].name);
        if (i == 50) {
            [NSThread sleepForTimeInterval:2.0];//阻塞（暂停）线程 2秒
        } else if (i == 70) {
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];//阻塞（暂停）线程 3秒
        } else if (i == 98) {
            NSLog(@"强制停止线程") ;
            [NSThread exit];//强制停止线程，退出当前线程
        }
    }
}

@end