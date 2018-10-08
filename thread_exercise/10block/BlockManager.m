//
//  BlockManager.m
//  thread_exercise
//
//  Created by 若云 on 2018/10/8.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "BlockManager.h"

@implementation BlockManager

- (BlockManager *(^)(int))add {
    return ^(int value) {
        //todo
        return self;
    };
}
@end
