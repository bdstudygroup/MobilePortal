//
//  ThreeImageTableViewCell.h
//  NewsDemo
//
//  Created by student4 on 2019/5/25.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreeImageTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *imageFirst;
@property (nonatomic, strong) UIImageView *imageSecond;
@property (nonatomic, strong) UIImageView *imageThird;
@end

NS_ASSUME_NONNULL_END
