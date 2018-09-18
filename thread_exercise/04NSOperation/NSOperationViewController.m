//
//  NSOperationViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/17.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

/**
 * NSOperation的作用
 * 配合使用 NSOperation 和 NSOperationQueue 实现多线程编程
 *
 * NSOperation 是抽象类，并不具备封装操作的能力，必须使用它的子类
 *
 * 使用NSOperation子类的方式有3种：
 * 1.NSInvocationOperation
 * 2.NSBlockOperation
 * 3.自定义子类继承 NSOperation 实现内部相应的方法
 */
#import "NSOperationViewController.h"
#import "ZYHOperation.h"

@interface NSOperationViewController ()

@property(strong, nonatomic) NSOperationQueue *queue;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 3;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self invocationOperation];
//    [self blockOperation];
//    [self invocationOperationWithQueue];
//    [self blockOperationWithQueue];
//    [self customWithQueue];
//    [self otherNSOperationQueue];
    [self addDependencyAndCompletionBlock];
}

//创建一个主线程的任务
- (void)invocationOperation {
    //1.创建操作，封装任务
    /**
     * 第一个参数：目标对象 self
     * 第二个参数：调用方法的名称
     * 第三个参数：前面方法需要接收的参数 nil
     */
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    //2.开启|执行操作
    [op1 start];
    /**
     * [NSOperationViewController download]-----,<NSThread: 0x60c000066480>{number = 1, name = main}
     */
}

- (void)download {
    NSLog(@"%s-----,%@", __func__, [NSThread currentThread]);
}

//创建一个主线程的任务
- (void)blockOperation {
    //1.创建操作，封装任务
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----,%@", [NSThread currentThread]);
    }];
    //追加任务
    //注意：如果一个操作中的任务数量大于1，那么会开子线程并发执行任务
    //注意：不一定是子线程，有可能是主线程
    [op3 addExecutionBlock:^{
        NSLog(@"4-----,%@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"5-----,%@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"6-----,%@", [NSThread currentThread]);
    }];
    //启动
    [op1 start];
    [op2 start];
    [op3 start];
    /**
     *  1-----,<NSThread: 0x608000078480>{number = 1, name = main}
        2-----,<NSThread: 0x608000078480>{number = 1, name = main}
        3-----,<NSThread: 0x608000078480>{number = 1, name = main}
     */
}

- (void)invocationOperationWithQueue {
    //1.创建操作，封装任务
    /**
     * 第一个参数：目标对象 self
     * 第二个参数：调用方法的名称
     * 第三个参数：前面方法需要接收的参数 nil
     */
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    //2.创建队列
    /**
     * GCD：
     * 串行类型：create & 主队列
     * 并发类型：create & 全局并发队列
     *
     * NSOperation:
     * 主队列：[NSOperationQueue mainQueue] 和GCD中的主队列一样，串行
     * 非主队列：[[NSOperationQueue alloc] init] 非常特殊（同时具备并发和串行的功能）
     */
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3.添加操作到队列中
    [queue addOperation:op1];//内部已经调用了 [op1 start] 方法
    [queue addOperation:op2];
    [queue addOperation:op3];
}


- (void)blockOperationWithQueue {
    //1.创建操作，封装任务
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----,%@", [NSThread currentThread]);
    }];
    //追加任务
    [op3 addExecutionBlock:^{
        NSLog(@"4-----,%@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"5-----,%@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"6-----,%@", [NSThread currentThread]);
    }];

    //2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3.添加操作到队列中
    [queue addOperation:op1];//内部已经调用了 [op1 start] 方法
    [queue addOperation:op2];
    [queue addOperation:op3];

    //简单方法
    //1)创建操作2)添加操作到队列中
    [queue addOperationWithBlock:^{
        NSLog(@"7-----,%@", [NSThread currentThread]);
    }];
}

- (void)customWithQueue {

    //1.封装操作
    ZYHOperation *op1 = [[ZYHOperation alloc] init];
    ZYHOperation *op2 = [[ZYHOperation alloc] init];
    //2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3.添加操作队列
    [queue addOperation:op1];
    [queue addOperation:op2];
}

//NSOperationQueue的其他用法：最大并发数，
- (void)otherNSOperationQueue {

    //1.创建队列
    //默认是并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //2.设置最大并发数 maxConcurrentOperationCount
    //同一时间最多有多少个任务可以执行
    //maxConcurrentOperationCount>1 并发队列
    //maxConcurrentOperationCount==1 串行队列
    //maxConcurrentOperationCount==0 不会执行任务
    //maxConcurrentOperationCount==-1 特殊意义 最大值 表示不收限制
    queue.maxConcurrentOperationCount = 1;
    //3.封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"5-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op6 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"6-----,%@", [NSThread currentThread]);
    }];
    //4.添加到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    [queue addOperation:op6];
}

//最大并发数，暂停，取消，继续
- (IBAction)controlButton:(UIButton *)button {
    switch (button.tag) {
        case 1://开始
            NSLog(@"开始");
            [self.queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                for (NSInteger i = 0; i < 10000; ++i) {
                    NSLog(@"1--%zd---,%@", i, [NSThread currentThread]);
                }
            }]];
            [self.queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                for (NSInteger i = 0; i < 10000; ++i) {
                    NSLog(@"2--%zd---,%@", i, [NSThread currentThread]);
                }
            }]];
            [self.queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                for (NSInteger i = 0; i < 10000; ++i) {
                    NSLog(@"3--%zd---,%@", i, [NSThread currentThread]);
                }
            }]];
            [self.queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                for (NSInteger i = 0; i < 10000; ++i) {
                    NSLog(@"4--%zd---,%@", i, [NSThread currentThread]);
                }
            }]];
            [self.queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                for (NSInteger i = 0; i < 10000; ++i) {
                    NSLog(@"5--%zd---,%@", i, [NSThread currentThread]);
                }
            }]];
            break;
        case 2://暂停
            NSLog(@"暂停");
            /**
             * 队列中的任务也是有状态的：已经执行的完毕的 | 正在执行 | 排队等待状态
             *
             * 注意：不能暂停当前正在处于执行状态的任务，只能暂停排队等待的任务
             */
            [self.queue setSuspended:YES];
            break;
        case 3://继续
            NSLog(@"继续");
            [self.queue setSuspended:NO];
            break;
        case 4://取消
            NSLog(@"取消");
            //取消，不可以恢复
            //该方法内部调用所有操作的cancel方法
            [self.queue cancelAllOperations];
            break;
        default:
            break;
    }
}

//操作依赖和监听
- (void)addDependencyAndCompletionBlock {
    //1.创建队列
    //默认是并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];

    //3.封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----,%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4-----,%@", [NSThread currentThread]);
    }];

    //异步通知
    op3.completionBlock = ^{
        NSLog(@"=======任务3 完成了========%@", [NSThread currentThread]);
    };

    //操作依赖
    //注意点：不能循环依赖
    //可以跨队列依赖
    [op1 addDependency:op4];
    [op4 addDependency:op3];
    [op3 addDependency:op2];
    //4.添加到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue2 addOperation:op4];
}

//下载图片
- (IBAction)downPic:(id)sender {
    __block UIImage *image1;
    __block UIImage *image2;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"http://image08.71.net/image08/38/63/87/46/e1d55250-09b3-42cb-9780-d602219c4429.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:imageData];
        NSLog(@"download---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"http://image08.71.net/image08/38/63/87/46/e1d55250-09b3-42cb-9780-d602219c4429.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image2 = [UIImage imageWithData:imageData];
        NSLog(@"download---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *combie = [NSBlockOperation blockOperationWithBlock:^{
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        //3.2 画图1
        [image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        image1 = nil;
        //3.3 画图2
        [image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        image2 = nil;
        //3.4 根据上下文得到一张图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //3.5 关闭上下文
        UIGraphicsEndImageContext();
        //3.6 更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.imageView setImage:image];
        }];
    }];
    //添加依赖
    [combie addDependency:download1];
    [combie addDependency:download2];
    //添加操作到队列
    [queue addOperation:download1];
    [queue addOperation:download2];
    [queue addOperation:combie];
}
@end
