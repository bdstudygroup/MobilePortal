//
//  CommentViewCell.h
//  NewsDemo
//
//  Created by wangld on 2019/6/11.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentViewCell : UITableViewCell

@property(nonatomic, strong)UIImageView* headImage;
@property(nonatomic, strong)UILabel* zan;
@property(nonatomic, strong)UILabel* name;
@property(nonatomic, strong)UILabel* comment;
@property(nonatomic, strong)UILabel* time;

@end

NS_ASSUME_NONNULL_END
