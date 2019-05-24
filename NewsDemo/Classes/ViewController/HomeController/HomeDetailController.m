
//
//  HomeDetailController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "HomeDetailController.h"
#import "BarItem.h"
#import "NSObject+Hint.h"
#import <Masonry.h>


@interface HomeDetailController () 

@end

@implementation HomeDetailController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self httpPostWithCustomDelegate];
}

-(void) httpPostWithCustomDelegate
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_feed"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString * params =@"uid=4822&offset=0&count=2";
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                NSLog(@"Response:%@ %@\n", response, error);
                                                                if(error == nil) {
                                                                    NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                    NSLog(@"Data = %@",text);
                                                                    NSDictionary* article_data = [dict objectForKey:@"data"];
                                                                    NSArray* article_feed = [article_data objectForKey:@"article_feed"];
                                                                    NSDictionary* article = [article_feed objectAtIndex:1];
                                                                    NSString* title = [article objectForKey:@"title"];
                                                                    NSLog(@"title=%@ \n", title);
                                                                }
                                                            }];
    [dataTask resume];
    
}

@end
