//
//  CCVideoModel.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/22.
//  Copyright © 2019 cc. All rights reserved.
//

#import "CCVideoModel.h"

@implementation CCVideoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"videoImageUrlString" : @"cover",
             @"videoTitle" : @"title",
             @"videoUrlString" : @"flv"
             };
}

- (void)setVideoUrlString:(NSString *)videoUrlString {
    _videoUrlString = [videoUrlString stringByReplacingOccurrencesOfString:@".flv" withString:@".mp4"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"imageUrl:%@ \nvideoTitle:%@ \nvideoUrl:%@", self.videoImageUrlString, self.videoTitle, self.videoUrlString];
}

@end
