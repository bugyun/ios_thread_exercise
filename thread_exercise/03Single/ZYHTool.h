//
//  ZYHTool.h
//  thread_exercise
//
//  Created by 若云 on 2018/9/17.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHTool : NSObject <NSCopying, NSMutableCopying>

/**类方法
 * 1.方便访问
 * 2.标明身份
 * 3.注意：share+类名|default+类名|share|default|类名
 */

+ (instancetype)shareTool;

@end
