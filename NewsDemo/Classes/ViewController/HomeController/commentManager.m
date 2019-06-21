//
//  commentManager.m
//  NewsDemo
//
//  Created by wangld on 2019/6/20.
//  Copyright © 2019 news. All rights reserved.
//

#import "commentManager.h"

@implementation commentManager

-(void)downloadComment{
    NSDictionary* form = @{@"groupid": self.groupid};
    
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.26.17.164:8080/comment/getCommentByGroupId" parameters:form error:nil];
    
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

-(void)upComment{
    NSDictionary* form = @{@"username": self.username , @"commentDetail":self.commentDetail, @"groupid": self.groupid};
    
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.26.17.164:8080/comment/insertComment" parameters:form error:nil];
    
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

-(NSString* )timeStepChange: (NSString*) timeStep {
    NSString *timeStampString  = timeStep;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}

@end
