//
//  OneImageTableViewCell.h
//  NewsDemo
//
//  Created by student4 on 2019/5/25.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneImageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *numberStar;
@property (nonatomic, strong) UILabel *numberComment;
@end

NS_ASSUME_NONNULL_END
