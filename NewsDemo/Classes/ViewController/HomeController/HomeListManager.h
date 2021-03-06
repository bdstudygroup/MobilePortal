//
//  HomeListManager.h
//  NewsDemo
//
//  Created by apple on 2019/5/24.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeListManager : NSObject

@property(nonatomic, assign) NSInteger currentOffset;

+ (instancetype)sharedManager;

- (void)updateWithCompletion:(void (^)(NSArray *articleFeed))completion;
- (void)getAllNews:(void (^)(NSArray * _Nonnull))completion;

@end

NS_ASSUME_NONNULL_END
