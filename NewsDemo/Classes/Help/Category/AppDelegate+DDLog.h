//
//  AppDelegate+DDLog.h
//  NewsDemo
//
//  Created by wangld on 2019/5/12.
//  Copyright © 2019 news. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDASLLogger.h>

@interface AppDelegate (DDLog)

/** 初始化应用程序 */
- (void)initializeWithApplication:(UIApplication *)application;

@end
