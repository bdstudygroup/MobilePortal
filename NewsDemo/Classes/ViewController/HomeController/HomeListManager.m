//
//  HomeListManager.m
//  NewsDemo
//
//  Created by apple on 2019/5/24.
//  Copyright © 2019 news. All rights reserved.
//

#import "HomeListManager.h"

static NSString *const feedUrl = @"https://i.snssdk.com/course/article_feed";

@implementation HomeListManager

+ (instancetype)sharedManager {
    static HomeListManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HomeListManager alloc] init];
    });
    return manager;
}

- (void)updateWithCompletion:(void (^)(NSArray * _Nonnull))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:feedUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"uid=4822&offset=0&count=20" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        completion(dict[@"data"][@"article_feed"]);
    }];
    [task resume];
    
}

@end
