//
//  AppDelegate+DDLog.m
//  NewsDemo
//
//  Created by wangld on 2019/5/12.
//  Copyright © 2019 news. All rights reserved.
//

#import "AppDelegate+DDLog.h"

@implementation AppDelegate (DDLog)

- (void)initializeWithApplication:(UIApplication *)application {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

@end
