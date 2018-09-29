//
//  IOS9ViewController.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/29.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "IOS9ViewController.h"

/**
 * 泛型：限制类型
 * 为什么要推出泛型？迎合swift
 *
 * (NSSet<UITouch *> *)
 * 泛型作用：1.限制类型 2.提高代码规划，减少沟通成本，一看就知道集合中是什么东西
 * 泛型定义用法：类型<限制类型>
 * 泛型声明：在声明类的时候，在类的后面<泛型名称>
 *
 * 泛型仅仅是报警告
 * 泛型好处：1.从数组中取出来，可以使用点语法
 *          2.给数组添加元素，有提示
 *
 * 泛型在开发中使用场景：1.用于限制集合类型
 *
 * id是不能使用点语法
 *
 * 为什么集合可以使用泛型？使用泛型，必须要先声明泛型？=>如何声明泛型
 *
 * 自定义泛型？
 * 什么时候使用泛型？在声明类的时候，不确定某些属性或者方法类型，在使用这个类的时候才确定，就可以采用泛型。
 *
 * 自定义Person,会一些编程语言（ios,java）,在声明Person，不确定这个人会什么,在使用Person才知道这个Person会什么语言。
 *
 * 如果没有定义泛型，默认就是id
 *
 *
 * 泛型：
 * NSArray<__covariant ObjectType>
 * __covariant：协变，容许子类转父类
 * __contravariant:逆变，父类转子类
 *
 *
 * 泛型注意点：在数组中，一般用可变数组添加方法，泛型才会生效，如果使用不可变数组，添加元素，泛型没有效果。
 */

/**
 * (nullable __kindof UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
 *
 * kindof:相当于
 *
 * __kindof：表示
 *
 * xcode5才出 instancetype
 * xcode5之前用 id
 *
 * id 可以.出任何方法，可以调用任务对象方法，不能进行编译检查
 *
 * instancetype:自动识别当前类对象
 *
 *
 * @interface Person :NSObject
 * +(id)person;//可以.出任何方法，可以调用任务对象方法，不能进行编译检查
 * +(instancetype)person;//自动识别当前类对象
 * +(__kindof Person *)person;//自动转换为当前类或者子类
 * @end
 *
 * @interface SubPerson :Person
 * @end
 *
 * [SubPerson person];
 */


@interface IOS9ViewController ()
@property(nonatomic, strong) NSMutableArray<NSString *> *arr;
@property(nonatomic, strong) NSArray<NSString *> *array;
@end

@implementation IOS9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {


}


@end
