//
//  CCVideoCell.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/22.
//  Copyright © 2019 cc. All rights reserved.
//

#import "CCVideoCell.h"
#import "CCVideoModel.h"
#import "UIImageView+CCWebImage.h"


static CGFloat const videoImageScale = 175.0 / 97.0;

@interface CCVideoCell ()

@property (nonatomic, strong) UILabel *videoTitleLabel;

@end

@implementation CCVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat contentView_w = CGRectGetWidth(self.contentView.bounds);
    CGFloat contentView_h = CGRectGetHeight(self.contentView.bounds);
    self.videoImageView.frame = CGRectMake(0, 0, contentView_w, contentView_w / videoImageScale);
    CGFloat imageView_h = CGRectGetHeight(self.videoImageView.bounds);
    self.videoTitleLabel.frame = CGRectMake(0, imageView_h, contentView_w, contentView_h - imageView_h);
}

#pragma mark - Getter/Setter

- (void)setVideoModel:(CCVideoModel *)videoModel {
    
    _videoModel = videoModel;
    
    [self.videoImageView cc_setImageWithURL:[NSURL URLWithString:videoModel.videoImageUrlString]
                           placeholderImage:[UIImage imageNamed:@"cc"]];
    [self.videoTitleLabel setText:videoModel.videoTitle];
    
    [self setNeedsLayout];
}

#pragma mark - Private


- (void)commonInit {
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.clipsToBounds = YES;
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.videoImageView = [[UIImageView alloc] init];
    self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.videoImageView];
    
    self.videoTitleLabel = [[UILabel alloc] init];
    [self.videoTitleLabel setFont: [UIFont systemFontOfSize:14]];
    self.videoTitleLabel.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1];
    [self.contentView addSubview:self.videoTitleLabel];
}

@end
