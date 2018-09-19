//
//  ZYHAPP.h
//  thread_exercise
//
//  Created by 若云 on 2018/9/19.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYHAPP : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *download;

+(instancetype)appWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
