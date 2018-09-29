//
//  NSObject+Property.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/29.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>

/**
 * 动态添加属性：什么时候需要动态添加属性
 *
 * 使用场景：
 *      给系统的类添加属性的时候，可以使用runtime动态添加属性方法
 *
 * 本质：动态添加属性，就是让某个属性与对象产生关联
 */
@implementation NSObject (Property)

- (void)setName:(NSString *)name {
    //让这个字符串与当前对象产生联系
    /**
     * 第一个参数：给哪个对象添加属性
     * 第二个参数：属性名称
     * 第三个参数：属性名
     * 第四个参数：保存策略
     */
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, @"name");

}
@end



