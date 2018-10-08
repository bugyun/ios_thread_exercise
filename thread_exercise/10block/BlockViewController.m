//
//  BlockViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/10/8.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "BlockViewController.h"

@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    [self test02];

}

int c = 1;

- (void)test {
    int a = 1;
    __block int b = 2;
    //如果是局部变量，block 是值传递
    //如果是静态变量，全局变量，__block修饰的变量，block 都是指针传递
    void (^block)() =^{
        NSLog(@"%d ,%d ,%d", a, b, c);
    };
    a = 5;
    b = 6;
    c = 7;
    block();//  结果： 1 ,6 ,7
}

- (void)test01 {
    //怎么区分参数是block，就看有没有^，只要有^，把block当做参数
    //把block当做参数，并不是马上就调用block，什么时候调用，由方法内部决定
    //什么时候需要把block当做参数去使用:做的事情由外界决定，但是什么时候做由内部决定。
    [UIView animateWithDuration:0 animations:^{

    }];
}

//把block 当成返回值   Masonry ,
- (void)test02 {

    self.bbbb();

}


- (void (^)())bbbb {
    NSLog(@"%s", __func__);
    return ^{
        NSLog(@"调用了block");
    };
}


//链式调用
- (void)test03 {
    BlockManager *manager = [[BlockManager alloc] init];
    manager.add(5).add(6);
}

@end
