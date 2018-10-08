//
//  BlockManager.h
//  thread_exercise
//
//  Created by 若云 on 2018/10/8.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockManager : NSObject

-(BlockManager *(^)(int))add;


@end

NS_ASSUME_NONNULL_END
