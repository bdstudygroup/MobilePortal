//
//  UIImage+Resize.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/28.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Resize)

+ (UIImage *)imageWithImage:(UIImage *)image converToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
