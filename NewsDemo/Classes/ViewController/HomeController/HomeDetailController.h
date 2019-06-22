//
//  HomeDetailController.h
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JumpView.h"
#import "collectList.h"

@interface HomeDetailController : UIViewController

@property(nonatomic, strong)NSString* groupId;
@property(nonatomic, strong)JumpView* jumpView;
@property(nonatomic, strong)collectList* newsCollections;
@property(nonatomic, strong)NSArray<NSDictionary*>* allList;
@property(nonatomic, strong)NSArray<NSDictionary*>* comments;

@end
