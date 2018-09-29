//
//  Person.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/29.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

void aaa(id self, SEL _cmd) {

}

//任何方法默认都有两个隐式参数， self,_cmd
//_cmd ： 当前方法编号

//什么时候调用：只要一个对象调用了一个未实现的方法调用就会调用这个方法，进行处理
//作用：动态添加方法，处理未实现
+ (BOOL)resolveInstanceMethod:(SEL)sel {


    NSLog(@"%@", NSStringFromSelector(sel));
    if (sel == NSSelectorFromString(@"eat")) {
        /**
         *  第一个参数：给哪个类添加方法
         *  第二个参数：添加哪个方法
         *  第三个参数：方法实现->函数->函数入口->函数名
         *  第四个参数：方法类型
         */
        class_addMethod(self, sel, (IMP)aaa,"V@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
