//
//  UIView+FrameMethods.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/26.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FrameMethods)

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;

- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;

@end

NS_ASSUME_NONNULL_END
