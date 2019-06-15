//
//  CollectController.m
//  NewsDemo
//
//  Created by student on 2019/6/15.
//  Copyright © 2019 news. All rights reserved.
//

#import "CollectController.h"

@interface CollectController ()

@end

@implementation CollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [BarItem addBackItemToVC:self];
    self.title = @"收藏栏";
    
}



@end
