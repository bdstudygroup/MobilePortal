//
//  BarItem.h
//  NewsDemo
//
//  Created by wangld on 2019/5/12.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface BarItem : NSObject

/** 向某个控制器上，添加返回按钮 */
+ (void)addBackItemToVC:(UIViewController *)vc;

@end
