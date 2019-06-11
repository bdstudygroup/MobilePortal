//
//  UIView+FrameMethods.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/26.
//  Copyright © 2019 cc. All rights reserved.
//

#import "UIView+FrameMethods.h"

@implementation UIView (FrameMethods)

- (void)setWidth:(CGFloat)width {
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, width, originRect.size.height);
    self.frame = newRect;
}

- (void)setHeight:(CGFloat)height {
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, height);
    self.frame = newRect;
}

- (void)setSize:(CGSize)size {
    CGRect originRect = self.frame;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, size.width, size.height);
    self.frame = newRect;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return self.frame.size;
}

@end
