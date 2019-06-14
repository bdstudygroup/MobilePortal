//
//  CCVideoCell.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/22.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* videoImageView;
@property (nonatomic, strong) CCVideoModel *videoModel;

@end

NS_ASSUME_NONNULL_END
