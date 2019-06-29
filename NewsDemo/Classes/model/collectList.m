//
//  collectList.m
//  NewsDemo
//
//  Created by student on 2019/6/15.
//  Copyright © 2019 news. All rights reserved.
//

#import "collectList.h"

@implementation collectList

#pragma mark 获取沙盒地址

-(NSString*)documentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    return documentsDirectory;
}

-(NSString*)dataFilePath{
    
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Collections.plist"];
}

-(void)saveChecklists{
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.myCollectList forKey:@"Collections"];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
    
    
}

-(void)loadChecklists{
    
    NSString *path = [self dataFilePath];
    NSLog(@"path: %@", path);
    if([[NSFileManager defaultManager]fileExistsAtPath:path]){
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        self.myCollectList = [unarchiver decodeObjectForKey:@"Collections"];
        
        [unarchiver finishDecoding];
    }else{
        
        self.myCollectList = [[NSMutableArray alloc]initWithCapacity:100];
    }
    
}

@end
