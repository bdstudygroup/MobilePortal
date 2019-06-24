//
//  commentManager.h
//  NewsDemo
//
//  Created by wangld on 2019/6/20.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface commentManager : UIViewController

@property(nonatomic, strong)NSString* groupid;
@property(nonatomic, strong)NSString* username;
@property(nonatomic, strong)NSString* commentDetail;

+ (instancetype)sharedManager:(NSString*)groupid;
-(void)upComment;
-(void)downloadComment:(void (^)(NSArray * _Nonnull))completion;

@end

NS_ASSUME_NONNULL_END
