//
//  collectList.h
//  NewsDemo
//
//  Created by student on 2019/6/15.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "collectListItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface collectList : NSObject

@property(nonatomic, strong)NSMutableArray<collectListItem*>* myCollectList;
-(void)loadChecklists;
-(void)saveChecklists;

@end

NS_ASSUME_NONNULL_END
