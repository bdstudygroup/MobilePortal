//
//  CollectController.h
//  NewsDemo
//
//  Created by student on 2019/6/15.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSMutableArray* collectionNews;
@property(nonatomic, strong)UITableView* collectionTable;

@end

NS_ASSUME_NONNULL_END
