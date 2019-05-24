
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
#import <WebKit/WebKit.h>


@interface HomeDetailController () <WKNavigationDelegate,WKUIDelegate>

@property(nonatomic, strong)NSMutableURLRequest* urlRequset;

@property (nonatomic, strong) NSDictionary *htmlDict;

/** 浏览器 */
@property (nonatomic, strong) WKWebView *wkWebView;


/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation HomeDetailController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.wkWebView.autoresizingMask = UIViewAutoresizingNone;
    
    self.navigationItem.title= @"新闻详情";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupWebView];
}

-(void) httpPostWithCustomDelegate
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_content"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    //urlencode
    NSString * charaters = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:charaters] invertedSet];
    NSString * hStr2 = @"bfWfBiBooCMbXpgjdf+OMA==";
    NSString * hString2 = [hStr2 stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString * params =[NSString stringWithFormat:@"groupId=%@", hString2];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    self.urlRequset = urlRequest;
    
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSLog(@"Response:%@ %@\n", response, error);
    if(error == nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSDictionary* article_data = [dict objectForKey:@"data"];

        self.htmlDict = article_data;
        NSString* article_content = [article_data objectForKey:@"article_content"];
        NSLog(@"content=%@ \n", article_content);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.navigationItem.title= @"新闻详情";
        }];
        [self loadingHtmlNews];
                                                                    
        }
    }];
    
    
    [dataTask resume];
    
}

//进度值的监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    self.progressView.progress = self.wkWebView.estimatedProgress;
    //    NSLog(@"%f", self.progressView.progress);
    
    //我这里之所以判断加载到大于60%，睡1s的原因是网速太快了，看不到进度条更新，所以停顿一下，主要是想明显看到进度条进度改变，没有其他意思的
    if (self.progressView.progress >0.6) {
        sleep(1);
    }
    //网页加载完毕隐藏进度条
    self.progressView.hidden = (self.wkWebView.estimatedProgress >= 1.0);
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

-(void)loadingHtmlNews{
    NSString* body = [self.htmlDict objectForKey:@"article_content"];
    NSString *html = [NSString stringWithFormat:@"\
                      <html lang=\"en\">\
                      <head>\
                      <meta charset=\"UTF-8\">\
                      </head>\
                      <body>\
                      <div>%@</div>\
                      </body>\
                      </html>"\
                      ,body];
    [self.wkWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
}

-(void)setupWebView{
    WKWebViewConfiguration* configur = [[WKWebViewConfiguration alloc] init];
    WKPreferences* preference = [[WKPreferences alloc] init];
    configur.preferences = preference;
    preference.javaScriptEnabled = YES;
    WKWebView* wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) configuration:configur];
    //WKWebview的estimatedProgress属性，就是加载进度，它是支持KVO监听进度改变的
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:wkWebView];
    self.wkWebView = wkWebView;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置内边距底部，主要是为了让网页最后的内容不被底部的toolBar挡着
    wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    //这句代码是让竖直方向的滚动条显示在正确的位置
    wkWebView.scrollView.scrollIndicatorInsets = wkWebView.scrollView.contentInset;
    
    wkWebView.UIDelegate = self;
    
    self.wkWebView.navigationDelegate = self;
    
    //自定义的方法，发送网络请求，获取新闻数据
    [self httpPostWithCustomDelegate];
    
}

@end
