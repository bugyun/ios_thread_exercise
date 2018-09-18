//
//  GCDViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/13.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

/**
 * GCD:grand central dispatch
 * 纯C语言，提供了非常多强大的函数
 *
 * GCD优势：
 * 1.GCD是苹果为多核的并行运算提出的解决方案
 * 2.GCD会自动利用更多的CPU内核（比如双核、四核）
 * 3.GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 * 4.程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
 *
 * GCD中有2个核心概念
 * 1.任务：执行什么操作
 * 2.队列：用来存放任务
 *
 * GCD会自动将队列中的任务取出，放到对应的线程中执行
 * 任务的取出遵循队列的FIFO原则：先进先出，后进后出
 *
 *
 * 执行任务：
 * 1.同步的方式
 * dispatch_sync(<#dispatch_queue_t queue#>, <#dispatch_block_t block#>)
 * 2.异步的方式
 * dispatch_async(<#dispatch_queue_t queue#>, <#dispatch_block_t block#>)
 *
 * 同步和异步的区别：
 * 1.同步：只能在当前线程中执行任务，不具备开启新线程的能力
 * 2.异步：可以在新的线程中执行任务，具备开启新线程的能力
 *
 *
 * 主队列（跟主线程相关联的队列）
 * 1.主队列是GCD自带的一种特殊的串行队列
 * 2.放在主队列中的任务，都会放到主线程中执行
 * 3.使用 dispatch_get_main_queue() 获得主队列
 *
 */

#import "GCDViewController.h"

@interface GCDViewController ()
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GCDViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    [self asyncConcurrent];
//    [self asyncSerial];
//    [self syncConcurrent];
//    [self syncSerial];
//    [self asyncMain];
//    [self syncMain];//会发生死锁
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
//    [self delay];
//    [self once];
//    [self once];
    [self barrier];
//    [self apply];
//    [self moveFile];
//    [self moveFileWithGCD];
//    [self group];
//    [self group2];
//    [self groupDownPic];
}

//异步函数+并发队列:会开启多条线程，队列中异步执行，开几条线程有系统内部决定
- (void)asyncConcurrent {
    /**
     * 1.创建队列
     * 第一个参数：C语言的字符串，标签
     * 第二个参数：队列的类型
     * DISPATCH_QUEUE_CONCURRENT：并发
     * DISPATCH_QUEUE_SERIAL：串行
     */
    dispatch_queue_t queue = dispatch_queue_create("com.ruoyun.download", DISPATCH_QUEUE_CONCURRENT);
    //为了区分系统的函数名，所以可以定义名称的时候，mQueue 驼峰的方式定义

    /**
     * 2.封装任务,添加任务到队列中
     * 第一个参数：队列
     * 第二个参数：要执行的任务
    */
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    /**
     *  download1---<NSThread: 0x600000077140>{number = 4, name = (null)}
        download1---<NSThread: 0x60800007b8c0>{number = 3, name = (null)}
        download1---<NSThread: 0x60400007f380>{number = 5, name = (null)}
     */
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
}

//异步函数+串行队列:会开启一条线程，队列中串行执行
- (void)asyncSerial {
    /**
     * 1.创建队列
     * 第一个参数：C语言的字符串，标签
     * 第二个参数：队列的类型
     * DISPATCH_QUEUE_CONCURRENT：并发
     * DISPATCH_QUEUE_SERIAL：串行
     */
    dispatch_queue_t queue = dispatch_queue_create("com.ruoyun.download", DISPATCH_QUEUE_SERIAL);
    //为了区分系统的函数名，所以可以定义名称的时候，mQueue 驼峰的方式定义

    /**
     * 2.封装任务,添加任务到队列中
     * 第一个参数：队列
     * 第二个参数：要执行的任务
    */
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    /**
     *  download1---<NSThread: 0x60c00006fac0>{number = 4, name = (null)}
        download1---<NSThread: 0x60c00006fac0>{number = 4, name = (null)}
        download1---<NSThread: 0x60c00006fac0>{number = 4, name = (null)}
     */
}

//同步函数+并发队列:不会开线程，在主线程中串行执行
- (void)syncConcurrent {
    /**
     * 1.创建队列
     * 第一个参数：C语言的字符串，标签
     * 第二个参数：队列的类型
     * DISPATCH_QUEUE_CONCURRENT：并发
     * DISPATCH_QUEUE_SERIAL：串行
     */
    dispatch_queue_t queue = dispatch_queue_create("com.ruoyun.download", DISPATCH_QUEUE_CONCURRENT);
    //为了区分系统的函数名，所以可以定义名称的时候，mQueue 驼峰的方式定义

    /**
     * 2.封装任务,添加任务到队列中
     * 第一个参数：队列
     * 第二个参数：要执行的任务
    */
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@", [NSThread currentThread]);
    });
    /**
      *  download1---<NSThread: 0x600000064ec0>{number = 1, name = main}
         download2---<NSThread: 0x600000064ec0>{number = 1, name = main}
         download3---<NSThread: 0x600000064ec0>{number = 1, name = main}
      */
}

//同步函数+异步队列:不会开线程，在主线程中串行执行
- (void)syncSerial {
    /**
     * 1.创建队列
     * 第一个参数：C语言的字符串，标签
     * 第二个参数：队列的类型
     * DISPATCH_QUEUE_CONCURRENT：并发
     * DISPATCH_QUEUE_SERIAL：串行
     */
    dispatch_queue_t queue = dispatch_queue_create("com.ruoyun.download", DISPATCH_QUEUE_SERIAL);
    //为了区分系统的函数名，所以可以定义名称的时候，mQueue 驼峰的方式定义

    /**
     * 2.封装任务,添加任务到队列中
     * 第一个参数：队列
     * 第二个参数：要执行的任务
    */
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@", [NSThread currentThread]);
    });
    /**
     *  download1---<NSThread: 0x600000064ec0>{number = 1, name = main}
        download2---<NSThread: 0x600000064ec0>{number = 1, name = main}
        download3---<NSThread: 0x600000064ec0>{number = 1, name = main}
     */
}

//创建队列的两种方式
- (void)getQueue {
    /**
     * 1.创建队列
     * 第一个参数：C语言的字符串，标签
     * 第二个参数：队列的类型
     * DISPATCH_QUEUE_CONCURRENT：并发
     * DISPATCH_QUEUE_SERIAL：串行
     */
    dispatch_queue_t queue = dispatch_queue_create("com.ruoyun.download", DISPATCH_QUEUE_SERIAL);
    /**
     * 获得全局并发队列
     * 优先级
     *   DISPATCH_QUEUE_PRIORITY_HIGH 2
         DISPATCH_QUEUE_PRIORITY_DEFAULT 0
         DISPATCH_QUEUE_PRIORITY_LOW (-2)
         DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 最低
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

//异步函数+主队列
- (void)asyncMain {
    //获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //2.异步函数
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3---%@", [NSThread currentThread]);
    });
}

//同步函数+主队列：产生了死锁
//主队列特点：如果主队列发现当前主线程有任务在执行，那么主队列会暂停调用队列中的任务，知道主线程空闲为止
- (void)syncMain {
    //获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //2.同步函数
    //立刻马上执行，如果我没有执行完毕，那么后面的也别想执行
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@", [NSThread currentThread]);
    });
}

- (IBAction)downPic:(UIButton *)sender {
    NSLog(@"点击事件");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://pic002.cnblogs.com/images/2012/289118/2012030314173540.png"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        //更新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.imageView setImage:image];
//        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.imageView setImage:image];
        });
    });
}

//延迟
- (void)delay {
    NSLog(@"delay----start------");
    //1.延迟执行的第一种方法
    //[self performSelector:@selector(task) withObject:nil afterDelay:2.0];
    //2.延迟执行的第二种方法,repeats YES:持续调用 NO:只调用一次
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(task) userInfo:nil repeats:NO];
    /**GCD
     * 第一个参数：DISPATCH_TIME_NOW 从现在开始计算时间
     * 第二个参数：延迟的时间 2.0 GCD时间单位：纳秒
     * 第三个参数：队列
     * 可以自定义线程，子线程还是主线程
     * dispatch_get_global_queue:子线程
     * dispatch_get_main_queue:主线程
     *
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"GCD----%@", [NSThread currentThread]);
    });
}

- (void)task {
    NSLog(@"task-----%@", [NSThread currentThread]);
}

//一次性代码
//不能放在懒加载中。
//应用场景：单例模式
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"----once----");
    });
}

//栅栏函数
- (void)barrier {
    //栅栏函数不能使用全局并发队列
    //dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"download1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download4---%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3---%@", [NSThread currentThread]);
    });

    NSLog(@"barrier----end");

    /**
     * barrier----end
       download1---<NSThread: 0x604000265f80>{number = 5, name = (null)}
       download4---<NSThread: 0x60c00026a540>{number = 7, name = (null)}
       barrier---<NSThread: 0x60c00026a540>{number = 7, name = (null)}
       download3---<NSThread: 0x60c00026a540>{number = 7, name = (null)}
     */
}

//快速迭代,开子线程和主线程一起完成遍历任务，任务的执行时并发
- (void)apply {
    /**
     * 第一个参数：遍历的次数
     * 第二个参数：队列（并发队列）
     * 第三个参数：index 索引
     */
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"---%@", [NSThread currentThread]);
    });
}

//for 循环
- (void)moveFile {
    //1.文件路径
    NSString *from = @"/Users/fanpu/Desktop/ApkResignerForWalle/out";
    NSString *to = @"/Users/fanpu/Desktop/ApkResignerForWalle/to";
    NSArray *fileFromPaths = [[NSFileManager defaultManager] subpathsAtPath:from];
    NSLog(@"%@", fileFromPaths);

    NSInteger count = fileFromPaths.count;

    for (NSInteger i = 0; i < count; i++) {
        NSLog(@"%zd", i);
        //NSString *fullPath = [from stringByAppendingString:fileFromPaths[i]];//不会自动添加/
        NSString *fullPath = [from stringByAppendingPathComponent:fileFromPaths[i]];//在拼接的时候会自动检查，并添加/
        NSString *toFullPath = [to stringByAppendingPathComponent:fileFromPaths[i]];
        NSLog(@"%@-------to---%@", fullPath, toFullPath);
        /**
         * 第一个参数：要剪切的文件在哪里
         * 第二个参数：文件应该被存到哪个位置
         */
        [[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:toFullPath error:nil];
        NSLog(@"%@", [NSThread currentThread]);
    }
}

- (void)moveFileWithGCD {
    //1.文件路径
    NSString *from = @"/Users/fanpu/Desktop/ApkResignerForWalle/out";
    NSString *to = @"/Users/fanpu/Desktop/ApkResignerForWalle/to";
    NSArray *fileFromPaths = [[NSFileManager defaultManager] subpathsAtPath:from];
    NSLog(@"%@", fileFromPaths);

    NSInteger count = fileFromPaths.count;
    dispatch_apply((size_t) count, dispatch_get_global_queue(0, 0), ^(size_t i) {
        NSLog(@"%zd", i);
        //NSString *fullPath = [from stringByAppendingString:fileFromPaths[i]];//不会自动添加/
        NSString *fullPath = [from stringByAppendingPathComponent:fileFromPaths[i]];//在拼接的时候会自动检查，并添加/
        NSString *toFullPath = [to stringByAppendingPathComponent:fileFromPaths[i]];
        NSLog(@"%@-------to---%@", fullPath, toFullPath);
        /**
        * 第一个参数：要剪切的文件在哪里
        * 第二个参数：文件应该被存到哪个位置
        */
        [[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:toFullPath error:nil];
        NSLog(@"%@", [NSThread currentThread]);
    });
}

//队列组
- (void)group {
    //1.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //2.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //3.异步函数
    /**
     * 1.封装任务
     * 2.把任务添加到队列中
     * 3.会监听任务的执行情况，通知group
     */
    dispatch_group_async(group, queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
    //拦截通知，当队列组中所有的任务都执行完毕的时候会进入到下面的方法
    dispatch_group_notify(group, queue, ^{
        NSLog(@"-----dispatch_group_notify------");
    });
}

//队列组:以前的写法
- (void)group2 {
    //1.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //2.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //3.异步函数
    //在该方法后面的异步任务会被纳入到队列组的监听范围，进入群组
    //dispatch_group_enter|dispatch_group_leave 必须配对使用
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
        //离开群组
        dispatch_group_leave(group);
    });

    //
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
        //离开群组
        dispatch_group_leave(group);
    });

    //拦截通知
    //问题：该方法是阻塞的吗？ 内部本身是异步的
    dispatch_group_notify(group, queue, ^{
        NSLog(@"-----dispatch_group_notify------");
    });

    //等待，死等，直到队列组中所有任务都执行完毕之后才能执行
    //阻塞的
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"----end-----");
}

//队列组
- (void)groupDownPic {
    /**
     * 1.下载图片1 开子线程
     * 2.下载图片2 开子线程
     * 3.合成图片并显示图片 开子线程
     * 4.可以通过栅栏方式来实现 dispatch_barrier_async
     */
    __block UIImage *uiImage1;
    __block UIImage *uiImage2;
    //1.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //2.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //3.异步函数
    dispatch_group_async(group, queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"https://pic002.cnblogs.com/images/2012/289118/2012030314173540.png"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        uiImage1 = [UIImage imageWithData:imageData];
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"https://pic002.cnblogs.com/images/2012/289118/2012030314173540.png"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        uiImage2 = [UIImage imageWithData:imageData];
    });
    //合并图片
    dispatch_group_notify(group, queue, ^{
        //3.1 创建图片上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        //3.2 画图1
        [uiImage1 drawInRect:CGRectMake(0, 0, 200, 100)];
        uiImage1 = nil;
        //3.3 画图2
        [uiImage2 drawInRect:CGRectMake(0, 100, 200, 100)];
        uiImage2 = nil;
        //3.4 根据上下文得到一张图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //3.5 关闭上下文
        UIGraphicsEndImageContext();
        //3.6 更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:image];
        });
    });
}

//补充点
- (void)other {
    //区别：封装任务的方法（block--函数）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%s", __func__);
    });
    /**
     * 第一个参数:队列
     * 第二个参数:要调用的函数的名称
     * 第三个参数:要调用的函数的名称
     */
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task1);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task1);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task1);
}

void task1(void *param) {
    NSLog(@"%s---%@", __func__, [NSThread currentThread]);
};

@end
