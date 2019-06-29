//
//  UIImageView+CCWebImage.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/25.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (CCWebImage)

- (void)cc_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder;

@end

NS_ASSUME_NONNULL_END
