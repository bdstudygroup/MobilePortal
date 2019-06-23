//
//  ImageSelectManager.h
//  NewsDemo
//
//  Created by 彭伟林 on 2019/6/22.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageSelectManager : NSObject

- (void)callActionSheetFunc:(MyController *) controller;
- (UIImage *)getImage;


@end

NS_ASSUME_NONNULL_END
