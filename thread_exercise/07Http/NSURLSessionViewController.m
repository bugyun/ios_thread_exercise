//
//  NSURLSessionViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/25.
//  Copyright © 2018年 ruoyun. All rights reserved.
//
/**
 * NSURLSession
 * 使用步骤：
 * 使用NSURLSession对象创建Task,然后执行Task
 *
 * Task类型
 *              NSURLSessionTask
 *                |          |
 * NSURLSessionDataTask    NSURLSessionDownloadTask
 *                |
 * NSURLSessionUploadTask
 *
 * 获得共享的Session
 * [NSURLSession sharedSession]
 *
 * 自定义Session:
 * [NSURLSession sessionWithConfiguration:<#(NSURLSessionConfiguration *)configuration#> delegate:<#(nullable id <NSURLSessionDelegate>)delegate#> delegateQueue:<#(nullable NSOperationQueue *)queue#>]
 *
 *
 */
#import "NSURLSessionViewController.h"

@interface NSURLSessionViewController () <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@end

@implementation NSURLSessionViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self get];
//    [self get2];
//    [self post];
//    [self delegate];
//    [self downloadWithBlock];
    [self downloadWithDelegate];
}

- (void)get {
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@""];

    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //3.创新会话对象
    NSURLSession *session = [NSURLSession sharedSession];

    //4.创建一个Task
    /**
     * 第一个参数：请求对象
     * 第二个参数：completionHandler 当请求完成之后调用,在子线程中执行
     *          data：响应提信息
     *          response：响应头信息
     *          error：错误信息当请求失败的时候 error 有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //6.解析数据
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];

    //5.执行Task
    [dataTask resume];
}

//get请求有省略模式
- (void)get2 {
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@""];

    //2.创建请求对象
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //3.创新会话对象
    NSURLSession *session = [NSURLSession sharedSession];

    //4.创建一个Task
    /**
     * 第一个参数：请求对象
     * 第二个参数：completionHandler 当请求完成之后调用，在子线程中执行
     *          data：响应提信息
     *          response：响应头信息
     *          error：错误信息当请求失败的时候 error 有值
     * 注意：dataTaskWithURL 内部会自动的将请求路径作为参数创建一个请求对象（GET）
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //6.解析数据
        NSLog(@"%@", [NSThread currentThread]);//子线程
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];

    //5.执行Task
    [dataTask resume];
}

- (void)post {
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];

    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //2.1设置post
    request.HTTPMethod = @"POST";
    //2.1设置请求体
    request.HTTPBody = [@"请求体" dataUsingEncoding:NSUTF8StringEncoding];

    //3.创新会话对象
    NSURLSession *session = [NSURLSession sharedSession];

    //4.创建一个Task
    /**
     * 第一个参数：请求对象
     * 第二个参数：completionHandler 当请求完成之后调用，在子线程中执行
     *          data：响应提信息
     *          response：响应头信息
     *          error：错误信息当请求失败的时候 error 有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //6.解析数据
        NSLog(@"%@", [NSThread currentThread]);//子线程
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];

    //5.执行Task
    [dataTask resume];
}

- (void)delegate {
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];

    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //3.创新会话对象
    /**
     * 第一个参数：配置信息 [NSURLSessionConfiguration defaultSessionConfiguration]
     * 第二个参数：
     * 第三个参数：
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    //4.创建一个Task
    /**
     * 第一个参数：请求对象
     * 第二个参数：completionHandler 当请求完成之后调用,在子线程中执行
     *          data：响应提信息
     *          response：响应头信息
     *          error：错误信息当请求失败的时候 error 有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];

    //5.执行Task
    [dataTask resume];
}

/**
 * 1.接收服务器的响应 默认会取消该请求
 * @param session 会话对象
 * @param dataTask 请求任务
 * @param response 响应头信息
 * @param completionHandler 回调 传给系统
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {

    /**
     *  NSURLSessionResponseCancel = 0, 取消，默认
        NSURLSessionResponseAllow = 1, 接收
        NSURLSessionResponseBecomeDownload = 2,变成下载任务
        NSURLSessionResponseBecomeStream 变成下载任务
     */

    NSLog(@"%s", __func__);
    NSLog(@"%@", [NSThread currentThread]);
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据 调用多次
 * @param session 会话对象
 * @param dataTask 请求任务
 * @param data 本次下载的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%s", __func__);
    NSLog(@"%@", [NSThread currentThread]);

}

/**
 * 请求结束或者失败的时候调用
 * @param session 会话对象
 * @param task 请求任务
 * @param error 错误信息
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s", __func__);
    NSLog(@"%@", [NSThread currentThread]);//主线程

}

//优点:不需要担心内存
//缺点:无法监听文件下载进度
- (void)downloadWithBlock {
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://img02.tooopen.com/images/20160509/tooopen_sy_161967094653.jpg"];

    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //3.创建session
    NSURLSession *session = [NSURLSession sharedSession];

    //4.创建Task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 回调
        location:
        response:响应头信息
        error:错误信息
     */
    //该方法内部已经实现了边接受数据边写沙盒(tmp)的操作
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            NSLog(@"发生错误");
            return;
        }

        //6.处理数据
        NSLog(@"%@---%@", location, [NSThread currentThread]);//子线程

        //6.1 拼接文件全路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];

        //6.2 剪切文件
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
        NSLog(@"%@", fullPath);
    }];

    //5.执行Task
    [downloadTask resume];
}

- (void)downloadWithDelegate {
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://img02.tooopen.com/images/20160509/tooopen_sy_161967094653.jpg"];

    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //3.创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    //4.创建Task
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];

    //5.执行Task
    [downloadTask resume];
}

#pragma mark ----------------------
#pragma mark NSURLSessionDownloadDelegate

/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //1. 获得文件的下载进度
    NSLog(@"%f", 1.0 * totalBytesWritten / totalBytesExpectedToWrite);
}

/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s", __func__);
}

/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%@", location);

    //1 拼接文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];

    //2 剪切文件
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@", fullPath);
}

/**
 *  请求结束
 */
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    NSLog(@"didCompleteWithError");
//}


@end
