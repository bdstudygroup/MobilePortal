//
//  commentManager.m
//  NewsDemo
//
//  Created by wangld on 2019/6/20.
//  Copyright © 2019 news. All rights reserved.
//

#import "commentManager.h"
#import "InfoManager.h"
#import "RegisterLoginController.h"

@implementation commentManager

+ (instancetype)sharedManager{
    static commentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[commentManager alloc] init];
    });
    return manager;
}

-(void)downloadComment:(void (^)(NSArray * _Nonnull))completion withGroupID: (NSString* )groupid{
    NSDictionary* form = @{@"groupid": groupid};
    NSLog(@"ID: %@", groupid);
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.3.119:8080/comment/getCommentByGroupId" parameters:form error:nil];
    
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

- (void) showAlertMessage:(NSString *) myMessage{
    //创建提示框指针
    UIAlertController *alertMessage;
    //用参数myMessage初始化提示框
    alertMessage = [UIAlertController alertControllerWithTitle:@"提示" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    //添加按钮
    [alertMessage addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    
    //display the message on screen  显示在屏幕上
    [self presentViewController:alertMessage animated:YES completion:nil];
    
}

-(void)upComment:(NSString*)username withGroupID: (NSString*) groupid{
    
    
    NSDictionary* form = @{@"username": username , @"commentDetail":self.commentDetail, @"groupid": groupid};
    
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.3.119:8080/comment/insertComment" parameters:form error:nil];
    
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
