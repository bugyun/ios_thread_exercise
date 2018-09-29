//
//  NSObject+Property.h
//  thread_exercise
//
//  Created by 若云 on 2018/9/29.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Property)

//@property分类：只会生成get,set方法声明，不会生成实现，也不会生成下划线成员属性
@property NSString *name;

@end

NS_ASSUME_NONNULL_END
