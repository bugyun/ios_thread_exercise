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
@end

@implementation ZYHTableViewController

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
    NSURL *url = [NSURL URLWithString:appM.icon];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;

    NSLog(@"%@", [NSThread currentThread]);//主线程
    NSLog(@"%zd",indexPath.row);//没有复用
    //3.返回cell
    return cell;
}

/**
 * 1.UI很不流畅---->开子线程下载图片
 * 2.图片重复下载--->先把之前下载的图片保存起来
 */
@end
