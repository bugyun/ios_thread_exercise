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

@interface NSURLSessionViewController () <NSURLSessionDataDelegate>

@end

@implementation NSURLSessionViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self get];
//    [self get2];
//    [self post];
    [self delegate];
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


@end
