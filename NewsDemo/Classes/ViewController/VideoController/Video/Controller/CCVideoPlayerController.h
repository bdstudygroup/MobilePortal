//
//  CCVideoPlayerController.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/19.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoPlayerController : UIViewController

@property (nonatomic, strong) NSString *videoURLString;
@property (nonatomic, strong) NSString *navigationItemTitle;
@property (nonatomic, strong) UIImage *loadingImage;

@end

NS_ASSUME_NONNULL_END
