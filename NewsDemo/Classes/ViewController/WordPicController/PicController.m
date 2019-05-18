//
//  PicController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "PicController.h"
#import "WordController.h"
#import "PicDetailController.h"

@interface PicController () 
@property (strong, nonatomic) UISegmentedControl *sc;
@end

@implementation PicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self sc];
}



#pragma mark - 懒加载
- (UISegmentedControl *)sc {
    if(_sc == nil) {
        NSArray *arr = [NSArray arrayWithObjects:@"段子", @"图片", nil];
        _sc = [[UISegmentedControl alloc] initWithItems:arr];
        _sc.frame = CGRectMake(0, 0, 150, 30);
        _sc.tintColor = [UIColor whiteColor];
        _sc.selectedSegmentIndex = 1;
        [_sc bk_addEventHandler:^(id sender) {
            _sc.selectedSegmentIndex = 1;
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [mArr removeLastObject];
            WordController *vc = [WordController new];
            [mArr addObject:vc];
            self.navigationController.viewControllers = mArr;
            
        } forControlEvents:UIControlEventValueChanged];
        
        [self.navigationItem setTitleView:_sc];
    }
    return _sc;
}

@end
