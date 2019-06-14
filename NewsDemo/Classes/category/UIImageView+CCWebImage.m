//
//  UIImageView+CCWebImage.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/25.
//  Copyright © 2019 cc. All rights reserved.
//

#import "UIImageView+CCWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (CCWebImage)

- (void)cc_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

@end
