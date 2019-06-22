//
//  JumpView.h
//  NewsDemo
//
//  Created by wangld on 2019/6/9.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define viewHeight 600.0

@interface JumpView : UIView<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView* commentDetail;
@property(nonatomic, strong)NSMutableArray* commentArray;
@property(nonatomic, strong)NSMutableArray* commentIDs;
@property(nonatomic, strong)NSMutableArray* commentTimes;
@property(nonatomic, strong)NSMutableArray* commentNames;
@property(nonatomic, strong)NSString* groupid;
@property(nonatomic, strong)NSArray<NSDictionary*>* comments;
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;

- (void)updateContent;


@end

NS_ASSUME_NONNULL_END
