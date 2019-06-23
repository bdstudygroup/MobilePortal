//
//  TokenManager.h
//  NewsDemo
//
//  Created by 彭伟林 on 2019/6/14.
//  Copyright © 2019 news. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoManager : NSObject

+(void)saveInfo:(NSString *)username image : (UIImage *)image;

+(NSString *)getUsername;

+(UIImage *)getImage;

+(void)cleanInfo;

@end

NS_ASSUME_NONNULL_END
