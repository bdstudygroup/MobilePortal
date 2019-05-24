//
//  NewsListView.h
//  NewsDemo
//
//  Created by wangld on 2019/5/24.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsListView : NSObject

@property(nonatomic, strong)NSMutableArray* titles;
@property(nonatomic, strong)NSMutableArray* groupIds;

-(void)httpPostWithCustomDelegate:(int) count;
-(NSMutableArray*)getTitles;
-(NSMutableArray*)getgroupIds;

@end

NS_ASSUME_NONNULL_END
