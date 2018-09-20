//
//  main.m
//  thread_exercise
//
//  Created by 若云 on 2018/9/13.
//  Copyright © 2018 ruoyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSLog(@"AppDelegate----start");
        int number = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"AppDelegate----start");
        return number;
    }

}