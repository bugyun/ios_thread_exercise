//
//  UIImage+Image.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/29.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "UIImage+Image.h"
#import <objc/message.h>

@implementation UIImage (Image)

//把类加载进内存的时候调用，只会调用一次
+ (void)load {
    //获取imageNamed
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    //获取zyh_imageNamed
    Method zyh_imageNamedMethod = class_getClassMethod(self, @selector(zyh_imageNamed:));
    //交换方法： runtime
    method_exchangeImplementations(imageNamedMethod, zyh_imageNamedMethod);
}

+ (UIImage *)zyh_imageNamed:(NSString *)name {
    UIImage *image = [UIImage zyh_imageNamed:name];
    if (image) {
        NSLog(@"加载成功");
    } else {
        NSLog(@"加载失败");
    }
    return image;
}

@end
