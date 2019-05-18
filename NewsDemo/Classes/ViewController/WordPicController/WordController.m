//
//  WordController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "WordController.h"
#import "PicController.h"


@interface WordController ()
@property (strong, nonatomic) UISegmentedControl *sc;


@end

@implementation WordController

+ (UINavigationController *)defaultWordNavi {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WordController *vc = [WordController new];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self sc];
}



- (UISegmentedControl *)sc {
    if(_sc == nil) {
        NSArray *arr = [NSArray arrayWithObjects:@"段子",@"图片", nil];
        _sc = [[UISegmentedControl alloc] initWithItems:arr];
        _sc.frame = CGRectMake(0, 0, 150, 30);
        _sc.selectedSegmentIndex = 0;
        _sc.tintColor = [UIColor whiteColor];
        [_sc bk_addEventHandler:^(id sender) {
            NSMutableArray *naviVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [naviVCs removeLastObject];
            PicController *vc = [PicController new];
            [naviVCs addObject:vc];
            self.navigationController.viewControllers = naviVCs;
        } forControlEvents:UIControlEventValueChanged];
        [self.navigationItem setTitleView:_sc];
    }
    return _sc;
}

@end
