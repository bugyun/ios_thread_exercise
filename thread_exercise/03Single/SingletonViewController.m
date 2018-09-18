//
//  SingletonViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/17.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "SingletonViewController.h"
#import "ZYHTool.h"
#import "ZYHSingleTool.h"

@interface SingletonViewController ()

@end

@implementation SingletonViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZYHTool *t1 = [[ZYHTool alloc] init];
    ZYHTool *t2 = [[ZYHTool alloc] init];
    ZYHTool *t3 = [[ZYHTool alloc] init];
    ZYHTool *t4 = [ZYHTool shareTool];
    ZYHTool *t5 = [t1 copy];
    ZYHTool *t6 = [t1 mutableCopy];


    ZYHSingleTool *s1 = [ZYHSingleTool shareSingleTool];


    NSLog(@"t1:%p t2:%p t3:%p", t1, t2, t3);
}

@end
