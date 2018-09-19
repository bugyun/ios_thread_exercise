//
//  ZYHAPP.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/19.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#import "ZYHAPP.h"

@implementation ZYHAPP
+(instancetype)appWithDict:(NSDictionary *)dict{
    ZYHAPP *appM = [[ZYHAPP alloc]init];
    //kvc
    [appM setValuesForKeysWithDictionary:dict];
    return appM;
}
@end
