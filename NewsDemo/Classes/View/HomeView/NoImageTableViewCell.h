//
//  NoImageTableViewCell.h
//  NewsDemo
//
//  Created by 彭伟林 on 2019/5/26.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoImageTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *numberStar;
@property (nonatomic, strong) UILabel *numberComment;
@end

NS_ASSUME_NONNULL_END
