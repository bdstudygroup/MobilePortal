//
//  NSObject+Hint.h
//  NewsDemo
//
//  Created by wangld on 2019/5/12.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface NSObject (Hint)

/** 显示加载 */
- (void)showLoad;
/** 加载完毕 */
- (void)hideLoad;

/** 显示成功（及提示文字） */
- (void)showSuccessWithMsg:(NSObject *)msg;
/** 显示错误（及提示文字） */
- (void)showErrorWithMsg:(NSObject *)msg;

@end
