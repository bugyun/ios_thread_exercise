//
//  ViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/13.
//  Copyright © 2018 ruoyun. All rights reserved.
//

#import "SafeThreadViewController.h"
#import <pthread.h>
#import "ZYHNSThread.h"

@interface SafeThreadViewController ()

/**
 * 售票员A
 */
@property(nonatomic, strong) NSThread *threadA;
/**
 * 售票员B
 */
@property(nonatomic, strong) NSThread *threadB;
/**
 * 售票员C
 */
@property(nonatomic, strong) NSThread *threadC;

/**
 * 票的总数
 */
@property(nonatomic, assign) NSInteger totalCount;

/**
 * atomic:   原子属性，为setter方法加锁（默认就是atomic）  线程安全，需要消耗大量的资源
 * nonatomic:非原子属性，不会为setter方法加锁             非线程安全，适合内存小的移动设备
 *
 * ios开发建议：
 * 1.所有属性都声明为nonatomic
 * 2.尽量避免多线程抢夺同一块资源
 * 3.尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减小移动客户端的压力
 */

/**
 * 线程间通信
 *
 * -(void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
 *
 * -(void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
 *
 *
 */
@end

@implementation SafeThreadViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self createNewNSThread];
}

- (void)createNewNSThread {
    self.totalCount = 100;
    self.threadA = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil]; //1.创建线程
    self.threadB = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil]; //1.创建线程
    self.threadC = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil]; //1.创建线程
    self.threadA.name = @"售票员A";
    self.threadB.name = @"售票员B";
    self.threadC.name = @"售票员C";
    [self.threadA start];                                                                                   //2.启动线程
    [self.threadB start];                                                                                   //2.启动线程
    [self.threadC start];                                                                                   //2.启动线程
}

- (void)saleTicket {
    while (true) {
        //互斥锁：必须是全局唯一的
        //1.注意加锁的位置
        //2.注意加锁的前提条件，多线程共享同一块资源
        //3.注意加锁是需要代价的，需要耗费性能的
        //4.加锁的结果：线程同步
        @synchronized (self) {
            NSInteger count = self.totalCount;
            if (count <= 0) {
                NSLog(@"票卖完了");
                break;
            } else {
                //卖出去一张票
                [NSThread sleepForTimeInterval:1.0];
                self.totalCount = count - 1;
                NSLog(@"%@卖出去一张票，还剩下%zd张票", [NSThread currentThread].name, count);
            }
        }
    }
}

@end
