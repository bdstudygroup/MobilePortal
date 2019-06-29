//
//  CCVideoListManager.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/17.
//  Copyright © 2019 cc. All rights reserved.
//

#import "CCVideoListManager.h"
#import "CCVideoModel.h"
#import "NSObject+CCModel.h"
#import "CCURL.h"

#ifdef DEBUG
#define CCDebugLog(fmt, ...) NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CCDebugLog(...)
#endif

@interface CCVideoListManager ()

@end

@implementation CCVideoListManager

+ (void)queryVideoListWithParams:(NSDictionary *)params success:(void (^)(NSArray<NSDictionary *> * _Nonnull videoList))success failure:(void (^)(NSError * _Nonnull error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/javascript", nil];

    [manager GET:[CCURL videosUrl] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *infoList = responseObject[@"data"][@"info_list"];
        //CCDebugLog(@"info_item:%@",infoList[0]);
        NSArray *videoList = [NSArray cc_modelArrayWithClass:CCVideoModel.class json:infoList];
        success(videoList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}


@end
