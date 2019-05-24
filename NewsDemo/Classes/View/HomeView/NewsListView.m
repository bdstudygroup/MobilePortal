//
//  NewsListView.m
//  NewsDemo
//
//  Created by wangld on 2019/5/24.
//  Copyright © 2019 news. All rights reserved.
//

#import "NewsListView.h"

@interface NewsListView()


@end

@implementation NewsListView



-(void)initWithCount:(int) count{
    self.titles = [[NSMutableArray alloc] initWithCapacity:100];
    self.groupIds = [[NSMutableArray alloc] initWithCapacity:100];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_feed"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString * params =[NSString stringWithFormat:@"uid=4822&offset=0&count=%d", count];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Response:%@ %@\n", response, error);
        if(error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary* article_data = [dict objectForKey:@"data"];
            NSArray* article_list = [article_data objectForKey:@"article_feed"];
            for (int i=0; i < article_list.count; i++) {
                [self.titles addObject: [article_list[i] objectForKey:@"title"]];
                [self.groupIds addObject: article_list[i][@"group_id"]];
            }
            NSLog(@"titles = %@ \n", self.titles[1]);
            NSLog(@"groupIds = %@", self.groupIds[1]);
        }
    }];
    
    
    [dataTask resume];
    
}

@end
