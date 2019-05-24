//
//  HomeListController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "HomeListController.h"
#import "HomeDetailController.h"
#import "HomeListManager.h"

#define kHomeListCell @"kHomeListCell"

@interface HomeListController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *articleList;

@end

@implementation HomeListController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self update];
}

- (void)setup {
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)update {
    __weak __typeof(self) weakSelf = self;
    [[HomeListManager sharedManager] updateWithCompletion:^(NSArray * _Nonnull articleFeed) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.articleList = articleFeed;
        NSLog(@"%@",strongSelf.articleList);
        //[strongSelf.tableView reloadData];

    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.articleList[indexPath.row][@"title"];
    return cell;
}

#pragma mark - Setter

- (void)setArticleList:(NSArray<NSDictionary *> *)articleList {
    _articleList = articleList;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}

@end
