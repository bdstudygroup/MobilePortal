//
//  SingletonUser.h
//  NewsDemo
//
//  Created by 彭伟林 on 2019/5/21.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingletonUser : NSObject
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) Boolean tag;
+ (SingletonUser *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
