//
//  HttpViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/21.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

/**
 * ios中发送HTTP请求的方案
 * 苹果原生
 *  1.NSURLConnection:用法简单，最古老最经典最直接的一种方案【坑比较多】
 *  2.NSURLSession:功能比 NSURLConnection 更加强大，苹果目前比较推荐使用这种技术【2013推出，ios7开始出的技术】
 *  3.CFNetwork:NSURL*的底层，纯c语言
 * 第三方框架
 *  1.ASIHttpRequest:外号"Http终结者"，功能及其强大，可惜早已停止更新
 *  2.AFNetworking:简单易用，提供了基本够用的常用功能，维护和使用者多
 *  3.MKNetworkKit:简单易用，产自三哥的故乡印度，维护和使用者少
 *
 *
 * 常用类
 * NSURL:请求地址
 * NSURLRequest:一个NSURLRequest对象代表一个请求，它包含的信息有
 *  1.一个NSURL请求
 *  2.请求方法、请求头、请求体
 *  3.请求超时
 *  ...
 *
 * NSMutableURLRequest:NSURLRequest的子类
 *
 * NSURLConnection
 *  负责发送请求，建立客户端和服务端的连接
 *  发送数据给服务器，并收集来自服务器的响应数据
 */

#import "NSURLConnectionViewController.h"
#import "SVProgressHUD.h"

@interface NSURLConnectionViewController () <NSURLConnectionDataDelegate>
@property(weak, nonatomic) IBOutlet UITextField *usernameTF;
@property(weak, nonatomic) IBOutlet UITextField *pwdTF;
@property(nonatomic, strong) NSMutableData *resultData;
@end

@implementation NSURLConnectionViewController

- (NSMutableData *)resultData {
    if (_resultData == nil) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    [self getSyncNSURLConnection];
//    [self getAsyncNSURLConnection];
//    [self getDelegateNSURLConnection];
//    [self postSyncNSURLConnection];
//    [self encoding];
//    [self jsonToOC];
    [self ocToJson];
}

//发送同步请求
- (void)getSyncNSURLConnection {
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://juejin.im/post/5ba34495e51d450e9e440d1f"];
    //2.创建请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //3.发送get同步请求
    NSHTTPURLResponse *response;
    /**
     * 第一个参数：请求对象
     * 第二个参数：响应头信息
     * 第三个参数：错误信息
     */
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //4.解析 data-->字符串
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"%@", response);
}

//发送同步请求
- (void)getAsyncNSURLConnection {
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://juejin.im/post/5ba34495e51d450e9e440d1f"];
    //2.创建请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //3.发送get异步请求
    /**
     * 第一个参数：请求对象
     * 第二个参数：队列 决定代码块completionHandler的调用线程
     * 第三个参数：completionHandler 当请求完成（成功|失败）的时候回调
     *      response:响应头
     *      data:响应体
     *      connectionError:错误信息
     */
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //4.解析 data-->字符串
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"%@", response);

        NSHTTPURLResponse *res = (NSHTTPURLResponse *) response;
        NSLog(@"%zd", res.statusCode);
    }];
}

//下载文件的时候使用
- (void)getDelegateNSURLConnection {
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://juejin.im/post/5ba34495e51d450e9e440d1f"];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.1设置代理，发送请求
    //[NSURLConnection connectionWithRequest:request delegate:self];
    //3.2
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    //3.3设置代理，并不会发送请求
    /**
     * startImmediately
     *  YES:会直接发送
     *  NO:需要调用开发方法 [connection start]
     */
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    //调用开始方法
    [connection start];
    //[connection cancel];//取消
}

#pragma mark ---------
#pragma mark NSURLConnectionDataDelegate

//1.当接收到服务器响应的时候调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s", __func__);
}

//2.接收到服务器返回数据的时候调用，调用多次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s", __func__);
    //拼接数据
    [self.resultData appendData:data];
}

//3.当请求失败的时候调用
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%s", __func__);

}

//4.请求结束的时候调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s", __func__);
    //4.解析 data-->字符串
    NSLog(@"%@", [[NSString alloc] initWithData:self.resultData encoding:NSUTF8StringEncoding]);
}

- (void)postSyncNSURLConnection {
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://juejin.im/post/5ba34495e51d450e9e440d1f"];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    //设置属性,请求超时
    request.timeoutInterval = 10;
    //设置请求头
    [request setValue:@"ios 12" forHTTPHeaderField:@"User-Agent"];

    //4.设置请求体信息,字符串--->NSData
    request.HTTPBody = [@"username=123&pwd=123" dataUsingEncoding:NSUTF8StringEncoding];
    //5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //6.解析数据 NSData---->NSString
        NSLog(@"%@", [[NSString alloc] initWithData:self.resultData encoding:NSUTF8StringEncoding]);
    }];
}

//中文转义，get需要，post不需要
- (void)encoding {
    NSString *urlStr = @"https://juejin.im/post/5ba34495e51d450e9e440d1f?name=小哥哥";
    NSLog(@"转码前：%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"转码后：%@", urlStr);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url-----%@", url);
    //2.创建请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //3.发送get异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@", connectionError);
            return;
        }
        //4.解析 data-->字符串
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

//登录
- (IBAction)loginBtnClick:(id)sender {
    //添加遮罩
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *usernameStr = _usernameTF.text;
    NSString *pwdStr = _pwdTF.text;
    if (usernameStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.usernameTF.placeholder];
        return;
    }
    if (pwdStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.pwdTF.placeholder];
        return;
    }
//    [SVProgressHUD show];
    [SVProgressHUD showWithStatus:@"稍等。。。"];
    NSString *urlStr = [NSString stringWithFormat:@"https://juejin.im/post/5ba34495e51d450e9e440d1f?name=%@&pwd=%@", usernameStr, pwdStr];
    NSLog(@"转码前：%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"转码后：%@", urlStr);
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url-----%@", url);
    //2.创建请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //3.发送get异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        if (connectionError) {
            NSLog(@"%@", connectionError);
            return;
        }
        //4.解析 data-->字符串
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

/**
 * json解析方案
 * 在ios中，json的常见解析方案有4种
 * 1.第三方框架：JSONKit、SBJson、TouchJSON(性能从左到右，越差)
 * 2.苹果原生（自带）：NSJSONSerialization(性能最好)
 *
 * NSJSONSerialization的常见方法
 * 1.json数据->oc对象
 *    [NSJSONSerialization JSONObjectWithData:<#(NSData *)data#> options:<#(NSJSONReadingOptions)opt#> error:<#(NSError **)error#>];
 * 2.oc对象->json数据
 *    [NSJSONSerialization dataWithJSONObject:<#(id)obj#> options:<#(NSJSONWritingOptions)opt#> error:<#(NSError **)error#>]
 */
- (void)jsonToOC {
    /**
     * 第一个参数：json的二进制数据
     * 第二个参数：
     *    NSJSONReadingMutableContainers = (1UL << 0),  可变字典和数组
     *    NSJSONReadingMutableLeaves = (1UL << 1),      内部所有的字符串都是可变的 ios7之后有问题 一般不用
     *    NSJSONReadingAllowFragments = (1UL << 2)      既不是字典也不是数组，则必须使用该枚举
     * 第三个参数：错误信息
     */
    NSString *string = @"{\"name\":\"你好\"}";
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict);

    //复杂json 写入文件
    [dict writeToFile:@"/Users/fanpu/Downloads/language/ios/video.plist" atomically:YES];
}

//
/**
 * json   oc
 * {}      @{}
 * []       @[]
 * ""       @""
 * false  NSNumber 0
 * true  NSNumber 1
 * null     NSNull 为空
 */
- (void)jsonWithOC {
    [NSNull null];//该方法获得的是一个单例，表示为空，可以用在字典或者是数组中
}

- (void)ocToJson {
    NSDictionary *dictM = @{
            @"name": @"zhang",
            @"age": @3
    };
    //注意：并不是所有的oc对象都能转换为JSON,下面的方法用来判断是否可以转换
    /**
     * 转换要求：
     * 最外层必须是 NSArray or NSDictionary
     * 所有的元素必须是 NSString ,NSNumber,NSArray,NSDictionary,NSNull
     * 字典中所有的key都必须是 NSString类型
     * NSNumber 不能是无穷大
     */
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dictM];
    if (!isValid) {
        NSLog(@"%zd", isValid);
        return;
    }
    /**
     * 第一个参数：要转换的oc对象
     * 第二个参数：选项 NSJSONWritingOptions 排版
     *    NSJSONWritingPrettyPrinted = (1UL << 0), 排版 美观
     *    NSJSONWritingSortedKeys
     * 第三个参数：错误信息
     */
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    NSArray *arrayM = @[@"123", @"222"];

    isValid = [NSJSONSerialization isValidJSONObject:arrayM];
    if (!isValid) {
        NSLog(@"%zd", isValid);
        return;
    }

    data = [NSJSONSerialization dataWithJSONObject:arrayM options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
