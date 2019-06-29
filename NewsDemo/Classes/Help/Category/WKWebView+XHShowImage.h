//
//  WKWebView+XHShowImage.h
//  NewsDemo
//
//  Created by student13 on 2019/6/1.
//  Copyright © 2019 news. All rights reserved.
//



#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (XHShowImage)

- (NSArray *)xh_getImageUrlWithWebView:(WKWebView *)webView;

- (NSArray *)getImgUrlArray;

@end

NS_ASSUME_NONNULL_END

