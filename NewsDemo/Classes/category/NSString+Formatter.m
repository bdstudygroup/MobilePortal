//
//  NSString+Formatter.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/30.
//  Copyright © 2019 cc. All rights reserved.
//

#import "NSString+Formatter.h"

@implementation NSString (Formatter)

+ (NSString *)stringFormatterWithSeconds:(int)seconds {
    
    int mininute = seconds / 60 ;
    int lastSeconds = seconds - 60 * mininute;
    
    NSString *minStr = [[NSString alloc] init];
    NSString *secStr = [[NSString alloc] init];
    
    if (mininute < 10) {
        minStr = [NSString stringWithFormat:@"0%d",mininute];
    } else {
        minStr = [NSString stringWithFormat:@"%d",mininute];
    }
    
    if (lastSeconds < 10) {
        secStr = [NSString stringWithFormat:@"0%d",lastSeconds];
    } else {
        secStr = [NSString stringWithFormat:@"%d",lastSeconds];
    }
    
    return [NSString stringWithFormat:@"%@:%@",minStr,secStr];
}

@end
