//
//  ZYHTableViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/18.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "ZYHTableViewController.h"
#import "ZYHAPP.h"

@interface ZYHTableViewController ()
@property(nonatomic, strong) NSArray *apps;
@property(nonatomic,strong) NSMutableDictionary *images;
@property(nonatomic,strong) NSOperationQueue *queue;
@property(nonatomic,strong) NSMutableDictionary *operations;
@end

@implementation ZYHTableViewController

-(NSMutableDictionary *)operations{
    if (_operations==nil) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}


-(NSOperationQueue *)queue{
    if (_queue==nil) {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount =3;
    }
    return _queue;
}

-(NSMutableDictionary *)images{
    if (_images==nil) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSArray *)apps {
    if (_apps == nil) {
        //字典数组
        NSArray *arrayM = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil]];
        //字典数组-->模型数组
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in arrayM) {
            [arrM addObject:[ZYHAPP appWithDict:dict]];
        }
        _apps = arrM;
    }
    return _apps;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark ----------
#pragma mark UITableViewDatasource

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}

//cell长什么样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"app";
    //1.创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    //2.设置cell
    //2.1拿到改行cell对应的h数据
    ZYHAPP *appM = self.apps[indexPath.row];
    
    //2.2 设置标题
    cell.textLabel.text = appM.name;
    //2.3 设置子标题
    cell.detailTextLabel.text = appM.download;
    //2.4 设置图标
    //先去检查内存缓存中该图片是否已经存在，如果存在就直接拿来用，否则去检查磁盘缓存
    //如果有磁盘缓存，那么保存一份到内存s，设置图片，否则就直接去下载
    //1）没有下载过
    //2）重新打开程序
    
    UIImage *image= [self.images objectForKey:appM.icon];
    if (image) {
        cell.imageView.image = image;
    }else{
        NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]);
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //获得图片的名称
        NSString *fileName =[appM.icon lastPathComponent];
        //拼接图片的全路径
        NSString *fullPath = [caches stringByAppendingPathComponent:fileName];
        //检查磁盘缓存
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        
        imageData = nil;
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imageView.image = image;
            //把图片保存到内存缓存中
            [self.images setObject:image forKey:appM.icon];
        }else{
            //检查该图片是否正在下载，如果是那就什么都不做，否则再添加下载任务
            NSBlockOperation *download = [self.operations objectForKey:appM.icon];
            if (download) {
                
            }else{
                //先清空,显示占位图片
                cell.imageView.image = nil;
//                cell.imageView.image = [UIImage imageNamed:@""];
                download =[NSBlockOperation blockOperationWithBlock:^{
                    NSURL *url = [NSURL URLWithString:appM.icon];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:imageData];
                    //容错处理
                    if (image==nil) {
                        [self.operations removeObjectForKey:appM.icon];
                        return;
                    }
                    //把图片保存到内存缓存中
                    [self.images setObject:image forKey:appM.icon];
                    //写数据到沙盒
                    [imageData writeToFile:fullPath atomically:YES];
                    //线程间通信
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        //                    cell.imageView.image = image;
                    }];
                    //移除图片的下载操作
                    [self.operations removeObjectForKey:appM.icon];
                }];
                [self.operations setObject:download forKey:appM.icon];
                [self.queue addOperation:download];
            }
        }
    }
    NSLog(@"%@", [NSThread currentThread]);//主线程
    NSLog(@"%zd",indexPath.row);//没有复用
    //3.返回cell
    return cell;
}

- (void)didReceiveMemoryWarning{
    //
    [self.images removeAllObjects];
    //取消队列中所有的操作
    [self.queue cancelAllOperations];
}

/**
 * 1.UI很不流畅---->开子线程下载图片
 * 2.图片重复下载--->先把之前下载的图片保存起来
     内存缓存--->磁盘缓存
     Document:会备份，不容许
     Libray:
         1.）Perferences：偏好设置，保存账号
         2.）caches：缓存文件
     tmp:临时路径（随时会被删除）
    3.图片不会刷新--->刷新某行
    4.图片重复下载(图片下载需要时间，当图片还未完全下载之前，又要重新显示该图片)
    5.数据错乱,设置占位图片
    6.
 */
@end
