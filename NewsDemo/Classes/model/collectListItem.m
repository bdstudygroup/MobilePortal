//
//  collectListItem.m
//  NewsDemo
//
//  Created by wangld on 2019/6/16.
//  Copyright © 2019 news. All rights reserved.
//

#import "collectListItem.h"

@implementation collectListItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.newsTitle = [aDecoder decodeObjectForKey:@"Title"];
        self.newsID = [aDecoder decodeObjectForKey:@"ID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.newsTitle forKey:@"Title"];
    [aCoder encodeObject:self.newsID forKey:@"ID"];
}

@end
