//
//  CCVideoListManager.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/17.
//  Copyright © 2019 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoListManager : NSObject

+ (void)queryVideoListWithParams:(NSDictionary *)params success:(void (^)(NSArray<NSDictionary *> *videoList))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
