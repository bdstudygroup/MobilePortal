
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
#import "WKWebView+XHShowImage.h"
#import <Masonry.h>
#import <WebKit/WebKit.h>
#import "PicDetailController.h"
#import "LBVideoPlayerController.h"


@interface HomeDetailController () <WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>

@property(nonatomic, strong)NSMutableURLRequest* urlRequset;

@property (nonatomic, strong) NSDictionary *htmlDict;

/** 浏览器 */
@property (nonatomic, strong) WKWebView *wkWebView;


/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSMutableArray<NSString*>* img_uri;
@property (nonatomic, strong) NSMutableArray<NSString*>* height;
@property (nonatomic, strong) NSMutableArray<NSString*>* width;
@property (nonatomic, strong) NSMutableArray<NSString*>* video_post;


@end

@implementation HomeDetailController

static NSString * const picMethodName = @"openBigPicture:";
static NSString * const videoMethodName = @"openVideoPlayer:";

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

-(void) httpPostWithCustomDelegate: (NSString*)groupId
{
    //初始化
    self.img_uri = [[NSMutableArray alloc] initWithCapacity:30];
    self.width = [[NSMutableArray alloc] initWithCapacity:30];
    self.height = [[NSMutableArray alloc] initWithCapacity:30];
    self.video_post = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_content"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    //urlencode
    NSString * charaters = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:charaters] invertedSet];
    NSString * hStr2 = groupId;
    NSString * hString2 = [hStr2 stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString * params =[NSString stringWithFormat:@"groupId=%@", hString2];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    self.urlRequset = urlRequest;
    
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    NSLog(@"Response:%@ %@\n", response, error);
        if(error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSDictionary* article_data = [dict objectForKey:@"data"];

            self.htmlDict = article_data;
            NSString* article_content = [article_data objectForKey:@"article_content"];
            NSString* img_prefix = [article_data objectForKey:@"image_url_prefix"];
            NSLog(@"content=%@ \n", article_content);
            NSArray* imgFilter = [self filterImage:article_content];
            NSArray* videoFilter = [self filterVideo:article_content];
            if(videoFilter.count > 0){
                for (int i=0; i<videoFilter.count; i++) {
                    NSString* imgString = videoFilter[i];
                    NSData *stringData = [imgString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
                    [self.video_post addObject:json[@"vposter"]];
                    NSLog(@"first post= %@ \n", self.video_post[i]);
                }
            }
            if (imgFilter.count > 0) {
                for (int i=0; i<imgFilter.count; i++) {
                    NSString* imgString = imgFilter[i];
                    NSData *stringData = [imgString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
                    [self.img_uri addObject: [img_prefix stringByAppendingString:json[@"web_uri"]]];
                    [self.width addObject: json[@"width"]];
                    [self.height addObject: json[@"height"]];
                    
    //                NSLog(@"first img= %@ \n", self.img_uri[i]);
    //                NSLog(@"second img= %@ \n", self.width[i]);
    //                NSLog(@"third img= %@ \n", self.height[i]);
                }
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.navigationItem.title= @"新闻详情";
            }];
            [self loadingHtmlNews];
                                                                    
        }
    }];
    
    
    [dataTask resume];
    
}

-(NSArray *) filterString:(NSString *)html{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"<img "].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"<img "];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@">"].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
}

-(NSArray *) filterStringVideo:(NSString *)html{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(>\\{!--)(.*?)(--\\}<)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@">"].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@">"];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"<"].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    if (resultArray.count > 0) {
        NSLog(@"video result=%@", resultArray[0]);
    }
    return resultArray;
}

- (NSArray *)filterImage:(NSString *)html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"<img src=\"{{image_domain}}"].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"<img src=\"{{image_domain}}"];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\">"].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    return resultArray;
}

-(NSArray *)filterVideo:(NSString *) html{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\{!--)(.*?)(--\\})" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"{!-- PGC_VIDEO:"].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"{!-- PGC_VIDEO:"];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@" --}"].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    return resultArray;
}



-(void)loadingHtmlNews{
    NSString* body = [self.htmlDict objectForKey:@"article_content"];
    NSArray* stringFilter = [self filterString:body];
    NSArray* videoStringFilter = [self filterStringVideo:body];
    if(videoStringFilter.count > 0){
//        NSLog(@"string=%@", videoStringFilter[0]);
        for (int i=0; i<videoStringFilter.count; i++) {
            NSString *str=[NSString stringWithFormat:@"<img src=\"%@\" \\>", self.video_post[i]];
            body = [body stringByReplacingOccurrencesOfString:videoStringFilter[i] withString:str];
        }
    }
    
    if (stringFilter > 0){
        for (int i=0; i<stringFilter.count; i++) {
//            NSLog(@"string=%@\n", stringFilter[i]);
//            NSLog(@"img=%@", self.img_uri[i]);
//            NSLog(@"width=%@", self.width[i]);
//            NSLog(@"height=%@", self.height[i]);
            NSString *str = [NSString stringWithFormat:@"src=\"%@\" height=%@ width=%@ ", self.img_uri[i], self.height[i], self.width[i]];
            body=[body stringByReplacingOccurrencesOfString:stringFilter[i] withString:str];
        }
    }
    
    NSString *html = [NSString stringWithFormat:@"\
                      <html lang=\"en\">\
                      <head>\
                      <meta charset=\"UTF-8\">\
                      <style type=\"text/css\">\
                        body {font-size:25px;}\
                      </style>\
                      </head>\
                      <body>\
                      <script>\
                      window.onload = function(){\
                      var imageArray = document.getElementsByTagName('img');\
                      for(var p in  imageArray){\
                          imageArray[p].style.width = '100%%';\
                          imageArray[p].style.height ='auto'\
                      }\
                      }\
                      </script>\
                      <div >%@</div>\
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
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    [userContentController addScriptMessageHandler:self name:@"openBigPicture"];
    [userContentController addScriptMessageHandler:self name:@"openVideoPlayer"];
    configur.userContentController = userContentController;
    WKWebView* wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) configuration:configur];
    
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
    [self httpPostWithCustomDelegate: self.groupId];
    
}

#pragma mark - show big picture
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView xh_getImageUrlWithWebView:webView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)showBigImage:(NSURLRequest *)request {
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [str substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imgUrlArr = [self.wkWebView getImgUrlArray];
        NSInteger index = 0;
        for (NSInteger i = 0; i < [imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]]){
                index = i;
            }
        }
        NSNumber* Index = [[NSNumber alloc] initWithInteger:index];
        PicDetailController* pc = [[PicDetailController alloc] initWithPicModel:imgUrlArr PicIndex: Index];
        [self.navigationController pushViewController:pc animated:YES];
    }
    
}

#pragma mark - WKUIDelegate(js弹框需要实现的代理方法)
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"tankuang----------");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



@end
