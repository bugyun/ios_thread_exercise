//
//  ZYHOperation.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/17.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "ZYHOperation.h"

@implementation ZYHOperation

//告知要执行的任务是什么
//1.有利于代码隐藏
//2.复用性
- (void)main {
    //苹果官方的建议：放到耗时操作之后，不要一直判断
    if (self.cancelled) {
        return;
    }
    NSLog(@"main----%@", [NSThread currentThread]);

}


@end
