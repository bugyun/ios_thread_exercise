//
//  RunTimeViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/29.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "RunTimeViewController.h"
#import <objc/message.h>

@interface RunTimeViewController ()

@end

@implementation RunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    id cl = [NSObject alloc];
//    cl = [cl init];

    objc_getClass("NSObject");
    //java中是通过包名.类名 来获取这个class
    //oc中是直接通过字符串来获取class，所以oc没有包名管理机制。



    id cl = objc_msgSend([NSObject class], @selector(alloc));
    cl = objc_msgSend(cl, @selector(init));


}

@end

/**
 * runtime 简介
 *
 *  RunTime简称运行时。OC就是运行时机制，也就是在运行时候的一些机制，其中最主要的是消息机制。
 *
    对于C语言，函数的调用在编译的时候会决定调用哪个函数。

    对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。

    事实证明：
        在编译阶段，OC可以调用任何函数，即使这个函数并未实现，只要声明过就不会报错。
        在编译阶段，C语言调用未实现的函数就会报错。
 *
 * 发送消息：
 *
 *
 * 需要用到runtime，消息机制,和java中的反射原理很相同。
 * 1.装逼，YYKit
 * 2.不得不用runtime消息机制，可以帮我们调用私有的方法。
 *
 *
 *
 * 方法调用流程：
 *
 * 怎么去调用eat方法，对象方法：类对象的方法列表 类方法：元类中方法列表
 * 1.通过isa去对应的类中查找
 * 2.注册方法编号
 * 3.根据方法编号去查找对应方法
 * 4.找到只是最终函数实现地址，根据地址去方法区调用对应函数
 */

/**
 * 内容5大区
 * 1.栈 2.堆 3.静态区 4.常量区 5.方法区
 *
 * 栈：不需要手动管理内存，自动管理
 * 堆：需要手动管理内存，自己去释放
 *
 */


