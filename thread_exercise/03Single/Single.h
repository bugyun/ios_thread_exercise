//
//  Single.h
//  thread_exercise
//
//  Created by 若云 on 2018/9/17.
//  Copyright © 2018年 ruoyun. All rights reserved.
//

#define SingleH(name) +(instancetype)share##name;

//判断是否是ARC 或 MRC
#if __has_feature(objc_arc)
#define SingleM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)share##name {\
return [[self alloc] init];\
}\
- (id)copyWithZone:(nullable NSZone *)zone {\
return _instance;\
}\
- (id)mutableCopyWithZone:(nullable NSZone *)zone {\
return _instance;\
}
#else
#define SingleM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)share##name {\
return [[self alloc] init];\
}\
- (id)copyWithZone:(nullable NSZone *)zone {\
return _instance;\
}\
- (id)mutableCopyWithZone:(nullable NSZone *)zone {\
return _instance;\
}\
- (oneway void)release {\
\
}\
- (instancetype)retain {\
    return _instance;\
}\
- (NSUInteger)retainCount {\
    return MAXFLOAT;\
}
#endif





