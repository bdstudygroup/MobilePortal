//
//  NSObject+CCModel.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/25.
//  Copyright © 2019 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CCModel)

+ (NSArray *)cc_modelArrayWithClass:(Class) modelClass json:(id) json;

@end

NS_ASSUME_NONNULL_END
