//
//  CollectController.h
//  NewsDemo
//
//  Created by student on 2019/6/15.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeListManager.h"
#import "collectList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView* collectionTable;
@property(nonatomic, strong)NSMutableArray<NSDictionary*>* allList;
@property(nonatomic, strong)collectList* newsCollects;

-(void)update;

@end

NS_ASSUME_NONNULL_END
