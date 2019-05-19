//
//  BDMainTableViewCell.h
//  BDProj
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019 Chauncey Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDMainTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *starNumberLabel;
@property (nonatomic, strong) UIImageView *starView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
