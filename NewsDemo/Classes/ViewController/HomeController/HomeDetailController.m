
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
#import "collectList.h"
#import "CollectController.h"
#import "commentManager.h"
#import "RegisterLoginController.h"
#import "InfoManager.h"



@interface HomeDetailController () <WKNavigationDelegate,WKUIDelegate,UITextFieldDelegate>

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

//评论区设计
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UIView* commentView;
@property (nonatomic, strong) NSMutableArray* commentArray;

@end

@implementation HomeDetailController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.wkWebView.autoresizingMask = UIViewAutoresizingNone;
    
    self.navigationItem.title= @"新闻详情";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _commentArray = [[NSMutableArray alloc] initWithCapacity:100];
    [self setUpInputView];
    [self addNotification];
    [self setupWebView];
    [self setUpTableView];
    [self update];
}

-(void)setupWebView{
    WKWebViewConfiguration* configur = [[WKWebViewConfiguration alloc] init];
    WKPreferences* preference = [[WKPreferences alloc] init];
    configur.preferences = preference;
    preference.javaScriptEnabled = YES;
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configur];
    [self.view addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW, kWindowH));
    }];
    
    //设置内边距底部，主要是为了让网页最后的内容不被底部的toolBar挡着
    _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 154, 0);
    //这句代码是让竖直方向的滚动条显示在正确的位置
    _wkWebView.scrollView.scrollIndicatorInsets = _wkWebView.scrollView.contentInset;
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    //自定义的方法，发送网络请求，获取新闻数据
    [self httpPostWithCustomDelegate: self.groupId];
    
}
#pragma 输入框设计

-(void)setUpInputView{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackClicked:)];
    [self.wkWebView addGestureRecognizer:tapGesture];
}

-(void)onBackClicked:(id)sender{
    [self.textField resignFirstResponder];
}

-(void)addNotification{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(onKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)onKeyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    NSTimeInterval duration = [userInfoDic [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardRect = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = MIN(CGRectGetWidth(keyboardRect), CGRectGetHeight(keyboardRect));
    
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.commentView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    } completion:nil];
}

-(void)onKeyBoardWillHide:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    
    NSTimeInterval duration = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
                         self.commentView.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma 懒加载

- (void)setUpTableView{
    self.jumpView = [[JumpView alloc] init];
    _commentView = [[UIView alloc] initWithFrame:CGRectZero];
    _commentView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker* make){
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kWindowW, 70));
    }];
    NSLog(@"fuck=%lf", kWindowH);
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 35)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"请输入文字";
    self.textField.returnKeyType = UIReturnKeySend;
    self.textField.delegate = self;
    [_commentView addSubview:self.textField];
    UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];
    [star setBackgroundImage:[UIImage imageNamed:@"collect"]forState:UIControlStateNormal];
    [_commentView addSubview:star];
    [star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-60);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [star addTarget:self action:@selector(collectNews) forControlEvents:UIControlEventTouchUpInside];
    UIButton *dianzan = [UIButton buttonWithType:UIButtonTypeCustom];
    [dianzan setBackgroundImage:[UIImage imageNamed:@"zan"]forState:UIControlStateNormal];
    [_commentView addSubview:dianzan];
    [dianzan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-120);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
    [comment setBackgroundImage:[UIImage imageNamed:@"mycomment"]forState:UIControlStateNormal];
    [_commentView addSubview:comment];
    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [comment addTarget:self action:@selector(clickCommentShow) forControlEvents:UIControlEventTouchUpInside];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    NSString* text = textField.text;
    self.textField.placeholder = @"请输入文字";
    
    commentManager* manager = [[commentManager alloc] init];
    manager.groupid = self.groupId;
    manager.commentDetail = text;
    manager.username = @"wangld";
    NSString* username;
    if(!([InfoManager getUsername]==nil)){
        [self showAlertMessage:@"你已经登陆了"];
        username = [InfoManager getUsername];
    }else{
        NSLog(@"jump");
        [self showAlertMessage:@"请登录或注册"];
        return YES;
    }
    [manager upComment: username withGroupID:self.groupId];
    [self methodTwoPerformSelector];
    return YES;
}

- (void)methodTwoPerformSelector{
    [self performSelector:@selector(delayMethod2) withObject:nil/*可传任意类型参数*/ afterDelay:0.2];
}
- (void)delayMethod2{
    [self updateComment];
    [self methodOnePerformSelector];
}

-(void)clickCommentShow{
    NSLog(@"sdfsdfa");
    [self.textField resignFirstResponder];
    [self updateComment];
    [self methodOnePerformSelector];
}

- (void)methodOnePerformSelector{
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
}
- (void)delayMethod{
    self.jumpView.comments = self.comments;
    NSLog(@"comments:%@",self.jumpView.comments);
    [self.jumpView showInView:self.view];
    [self.jumpView updateContent];
}

- (void)updateComment {
    __weak __typeof(self) weakSelf = self;
    [[commentManager sharedManager] downloadComment:^(NSArray * _Nonnull comments) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.comments = comments;
        
    } withGroupID:self.groupId];
}

-(void)update{
    __weak __typeof(self) weakSelf = self;
    [[HomeListManager sharedManager] getAllNews:^(NSArray * _Nonnull articleFeed) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.allList = articleFeed;
    }];
}

-(void)collectNews{
    NSLog(@"%@",self.allList[0]);
    collectList* myNewsCollections = [[collectList alloc] init];
    [myNewsCollections loadChecklists];
    NSString* title;
    for (int i=0; i<self.allList.count; i++) {
        if ([self.allList[i][@"group_id"] isEqualToString: self.groupId]) {
            NSLog(@"groupID: %@", self.allList[i][@"group_id"]);
            title = self.allList[i][@"title"];
            break;
        }
    }
    NSLog(@"group_id: %@ ", self.groupId);
    NSLog(@"title: %@", title);
    collectListItem* item = [[collectListItem alloc] init];
    item.newsTitle = title;
    item.newsID = self.groupId;
    if (myNewsCollections.myCollectList.count == 0) {
        [myNewsCollections.myCollectList addObject:item];
        [self showAlertMessage:@"收藏成功"];
    }
    else{
        int flag = 1;
        for (int i=0; i<myNewsCollections.myCollectList.count; i++) {
            if ([myNewsCollections.myCollectList[i].newsID isEqualToString: self.groupId]) {
                flag = 0;
                break;
            }
        }
        if (flag == 1) {
            [myNewsCollections.myCollectList addObject:item];
            [self showAlertMessage:@"收藏成功"];
        }else{
            [self showAlertMessage:@"已收藏"];
        }
    }
    if (myNewsCollections.myCollectList.count > 0) {
        NSLog(@"collect %@", myNewsCollections.myCollectList[0].newsTitle);
        NSLog(@"number: %d", myNewsCollections.myCollectList.count);
    }
    [myNewsCollections saveChecklists];
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
            NSLog(@"prefix=%@", img_prefix);
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
                if ([src containsString:@"{{image_domain}}"]) {
                    [resultArray addObject:src];
                }
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
        for (int i=0; i<videoStringFilter.count; i++) {
            NSString *str=[NSString stringWithFormat:@"<img src=\"%@\" \\>", self.video_post[i]];
            body = [body stringByReplacingOccurrencesOfString:videoStringFilter[i] withString:str];
        }
    }
    
    if (stringFilter > 0){
        for (int i=0; i<stringFilter.count; i++) {
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
