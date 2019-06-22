//
//  commentManager.m
//  NewsDemo
//
//  Created by wangld on 2019/6/20.
//  Copyright © 2019 news. All rights reserved.
//

#import "commentManager.h"

@implementation commentManager

+ (instancetype)sharedManager:(NSString*)groupid {
    static commentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[commentManager alloc] init];
        manager.groupid = groupid;
    });
    return manager;
}

-(void)downloadComment:(void (^)(NSArray * _Nonnull))completion{
    NSDictionary* form = @{@"groupid": self.groupid};
    
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.31.26:8080/comment/getCommentByGroupId" parameters:form error:nil];
    
    [formRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    
    manager.responseSerializer= responseSerializer;
    
    NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
        
        if(error) {
            
            NSLog(@"Error: %@", error);
            
            return;
            
        }
        
        NSLog(@"response: %@, object: %@", response, responseObject);
        completion(responseObject[@"data"][@"comments"]);
        
    }];
    
    [dataTask resume];
}

-(void)upComment{
    NSDictionary* form = @{@"username": self.username , @"commentDetail":self.commentDetail, @"groupid": self.groupid};
    
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.31.26:8080/comment/insertComment" parameters:form error:nil];
    
    [formRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    
    manager.responseSerializer= responseSerializer;
    
    NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
        
        if(error) {
            
            NSLog(@"Error: %@", error);
            
            return;
            
        }
        
        NSLog(@"%@ %@", response, responseObject);
        
    }];
    
    [dataTask resume];
}

@end
