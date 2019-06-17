//
//  AllList.h
//  NewsDemo
//
//  Created by wangld on 2019/6/16.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllListItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllList : NSObject

@property(nonatomic, strong)NSMutableArray<AllListItem*>* allList;

@end

NS_ASSUME_NONNULL_END
