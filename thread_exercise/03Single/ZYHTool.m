//
//  ZYHTool.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/17.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "ZYHTool.h"

@implementation ZYHTool

//0.提供全局变量
static ZYHTool *_instance;

//1.alloc->allocWithZone
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    //加互斥锁，解决多线程访问安全问题
//    @synchronized (self) {
//        if (_instance == nil) {
//            _instance = (ZYHTool *) [super allocWithZone:zone];
//        }
//    }
    //本身就是线程安全的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = (ZYHTool *) [super allocWithZone:zone];
    });
    return _instance;
}

//2.提供类方法
+ (instancetype)shareTool {
    return [[self alloc] init];
}

//3.严谨
- (id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}

#if __has_feature(objc_arc)
//条件满足ARC
#else
//MRC
- (oneway void)release {

}

- (instancetype)retain {
    return _instance;
}

- (NSUInteger)retainCount {
    return MAXFLOAT;
}
#endif

@end
