//
//  PicDetailController.h
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailController : UIViewController

@property(nonatomic, strong)NSArray* imgURL;
- (instancetype)initWithPicModel:(NSArray*)imgURL;

@end
