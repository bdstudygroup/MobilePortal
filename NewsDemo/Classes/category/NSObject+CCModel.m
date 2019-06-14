//
//  NSObject+CCModel.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/25.
//  Copyright © 2019 cc. All rights reserved.
//

#import "NSObject+CCModel.h"
#import <YYModel/YYModel.h>

@implementation NSObject (CCModel)

+ (NSArray *)cc_modelArrayWithClass:(Class)modelClass json:(id)json {
    
    return [NSArray yy_modelArrayWithClass:modelClass json:json];
}

@end
