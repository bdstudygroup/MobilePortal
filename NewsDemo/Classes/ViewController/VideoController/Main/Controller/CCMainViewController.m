//
//  CCMainViewController.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/16.
//  Copyright © 2019 cc. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <YYModel/YYModel.h>
#import "CCMainViewController.h"
#import "CCVideoListManager.h"
#import "CCVideoPlayerController.h"
#import "CCVideoCell.h"
#import "CCVideoModel.h"

#ifdef DEBUG
#define CCDebugLog(fmt, ...) NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CCDebugLog(...)
#endif

static NSString *const kCCVideoCellId = @"kMainCollectionViewCellId";
static CGFloat const videoItemSacle = 175.0 / (97.0 + 30.0); // 175.0: width ; 97.0: videoImage height ; 30.0: title height
static CGFloat const distanceItemLeftToScreen = 10.0;
static CGFloat const distanceItemRightToScreen = 10.0;
static CGFloat const distanceItemToItem = 10.0;

@interface CCMainViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<CCVideoModel *> *videoList;
@property (nonatomic, strong) CCVideoListManager *videoListManager;
@property (nonatomic, strong) CCVideoPlayerController *videoPlayerController;
@property (nonatomic, assign) NSUInteger refreshTime;

@end

@implementation CCMainViewController

+ (UINavigationController *)defaultVideoNavi {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CCMainViewController *vc = [CCMainViewController new];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - Getter/Setter

- (CCVideoPlayerController *)videoPlayerController {
    if (_videoPlayerController == nil) {
        _videoPlayerController = [[CCVideoPlayerController alloc] init];
    }
    return _videoPlayerController;
}

- (NSArray<CCVideoModel *> *)videoList {
    if (_videoList == nil) {
        _videoList = [[NSMutableArray alloc] init];
    }
    return _videoList;
}

#pragma mark - CollectionView DataSource/Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.videoList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (self.view.bounds.size.width - distanceItemLeftToScreen - distanceItemRightToScreen - distanceItemToItem) / 2.0; // 10.0,10.0,10.0 分别为item到屏幕左边框右边框和两个item之间的距离
    CGFloat itemHeight = itemWidth / videoItemSacle;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCVideoCellId forIndexPath:indexPath];
    cell.videoModel = self.videoList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.videoPlayerController = [[CCVideoPlayerController alloc] init];
    self.videoPlayerController.navigationItemTitle = self.videoList[indexPath.row].videoTitle;
    self.videoPlayerController.videoURLString = self.videoList[indexPath.row].videoUrlString;
    self.videoPlayerController.loadingImage = ((CCVideoCell *)[collectionView cellForItemAtIndexPath:indexPath]).videoImageView.image;
    CCDebugLog(@"image %@",self.videoPlayerController.loadingImage);
    [self.navigationController pushViewController:self.videoPlayerController animated:YES];
}

#pragma mark - Private

- (void)commonInit {
    
    self.navigationItem.title = @"Home";
    
    [self setupCollectionView];
    [self updateVideoListData];
    
    self.refreshTime = 1;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        [self.collectionView setRefreshControl:refreshControl];
    } else {
        [self.collectionView addSubview:refreshControl];
    }
}

- (void)setupNavigationItem {
    
    self.navigationItem.title = @"Home";
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 20.0, 10.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1];
    [self.view addSubview: self.collectionView];
    
    [self.collectionView registerClass:[CCVideoCell class] forCellWithReuseIdentifier:kCCVideoCellId];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    self.refreshTime += 1;
    
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"page":@"1" ,
                             @"size":[NSString stringWithFormat:@"%tu",self.refreshTime * 15] ,
                             @"videoid":@"5a0cfb2c7a2059547de69ac4"
                             };
    
    [CCVideoListManager queryVideoListWithParams:params success:^(NSArray<CCVideoModel *> * _Nonnull videoList) {
        
        self.videoList = videoList;
        [self.collectionView reloadData];
        [refreshControl endRefreshing];
    } failure:^(NSError * _Nonnull error){
        
        NSLog(@"%s Error:%@",__func__,error);
        [refreshControl endRefreshing];
    }];
}

- (void)updateVideoListData {
    
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"page":@"1",
                             @"size":@"15",
                             @"videoid":@"5a0cfb2c7a2059547de69ac4"
                             };
    
    [CCVideoListManager queryVideoListWithParams:params success:^(NSArray<CCVideoModel *> * _Nonnull videoList) {
        
        self.videoList = videoList;
        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error){
        
        NSLog(@"%s Error:%@",__func__,error);
        
    }];
}

@end
