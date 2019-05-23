//
//  SingletonUser.m
//  NewsDemo
//
//  Created by 彭伟林 on 2019/5/21.
//  Copyright © 2019 news. All rights reserved.
//

#import "SingletonUser.h"

@implementation SingletonUser

static SingletonUser *sharedSingleton = nil;

+ (SingletonUser *)allocWithZone:(struct _NSZone *)zone {
    if (!sharedSingleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [super allocWithZone:zone];
        });
    }
    return sharedSingleton;
}

- (SingletonUser *)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [super init];
        sharedSingleton.username = @"";
        sharedSingleton.tag = false;
    });
    return sharedSingleton;
}

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (SingletonUser *)copyWithZone:(struct _NSZone *)zone {
    return sharedSingleton;
}

+ (SingletonUser *)mutableCopyWithZone:(struct _NSZone *)zone {
    return sharedSingleton;
}

@end
