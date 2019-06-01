//
//  PicDetailController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "PicDetailController.h"
#import <MWPhotoBrowser.h>

@interface PicDetailController () <MWPhotoBrowserDelegate>

@end

@implementation PicDetailController

- (instancetype)initWithPicModel:(NSArray* )imgURL {
    if (self = [super init]) {
        self.imgURL = imgURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [BarItem addBackItemToVC:self];
    
    MWPhotoBrowser *pb = [[MWPhotoBrowser alloc] initWithDelegate:self];
    NSMutableArray *naviVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [naviVCs removeLastObject];
    [naviVCs addObject:pb];
    self.navigationController.viewControllers = naviVCs;
}

#pragma mark - <MWPhotoBrowserDelegate>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imgURL.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.imgURL[index]]];
    return photo;
}


@end
