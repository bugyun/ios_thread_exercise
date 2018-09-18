//
//  ViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/13.
//  Copyright © 2018 ruoyun. All rights reserved.
//

#import "DownFileViewController.h"

@interface DownFileViewController ()
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation DownFileViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //    [self download];
    [NSThread detachNewThreadSelector:@selector(download2) toTarget:self withObject:nil];
}


- (void)download {
    [NSThread currentThread];
    NSDate *start = [NSDate date];
    CFTimeInterval startCFT = CFAbsoluteTimeGetCurrent();//绝对时间

    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://pic002.cnblogs.com/images/2012/289118/2012030314173540.png"];
    //2.根据url下载图片二进制数据到本地
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    //3.转换图片格式
    UIImage *image = [UIImage imageWithData:imageData];
    //4.显示ui
    self.imageView.image = image;

    NSDate *end = [NSDate date];
    CFTimeInterval endCFT = CFAbsoluteTimeGetCurrent();

    NSLog(@"%f", [end timeIntervalSinceDate:start]);
    NSLog(@"---%f", endCFT - startCFT);
}

//子线程，操作ui 应该在主线程
- (void)download2 {
    [NSThread currentThread];
    NSDate *start = [NSDate date];
    CFTimeInterval startCFT = CFAbsoluteTimeGetCurrent();//绝对时间

    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://pic002.cnblogs.com/images/2012/289118/2012030314173540.png"];
    //2.根据url下载图片二进制数据到本地
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    //3.转换图片格式
    UIImage *image = [UIImage imageWithData:imageData];
    //4.回到主线程显示ui
    /**
     * 第一个参数：回到主线程要调用哪个方法
     * 第二个参数：前面方法需要传递的参数
     * 第三个参数：是否等待
     */
    //[self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:NO];
    //[self performSelector:@selector(showImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:NO];
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];

    NSDate *end = [NSDate date];
    CFTimeInterval endCFT = CFAbsoluteTimeGetCurrent();

    NSLog(@"%f", [end timeIntervalSinceDate:start]);
    NSLog(@"---%f", endCFT - startCFT);
}

- (void)showImage:(UIImage *)image {
    self.imageView.image = image;
    NSLog(@"UI----%@", [NSThread currentThread]);
}


@end
