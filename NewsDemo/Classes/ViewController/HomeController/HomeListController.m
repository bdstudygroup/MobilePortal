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
#import "../../View/HomeView/OneImageTableViewCell.h"
#import "../../View/HomeView/ThreeImageTableViewCell.h"
#import "../../View/HomeView/NoImageTableViewCell.h"
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
    self.tableView.tableFooterView = [UIView new];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:self.tableView];
}

- (void)update {
    __weak __typeof(self) weakSelf = self;
    [[HomeListManager sharedManager] updateWithCompletion:^(NSArray * _Nonnull articleFeed) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.articleList = articleFeed;
        NSLog(@"%@",strongSelf.articleList);
        [strongSelf.tableView reloadData];
        
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articleList count];
    //return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [[NSArray alloc]initWithArray:self.articleList[indexPath.row][@"image_infos"]];
    NSError *err = nil;
    NSString *cellID = [NSString stringWithFormat:@"cellID:%ld", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if([arr count] == 0) {
        cell = [[NoImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        ((NoImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
        return cell;
    }else if([arr count] == 1 || [arr count] == 2) {
        //NSLog(@"%d", self.articleList[indexPath.row][@"image_infos"].count);
        cell = [[OneImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        ((OneImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr[0] options:kNilOptions error:&err];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSString *url = json[@"url_prefix"];
        url = [url stringByAppendingString:json[@"web_uri"]];
        NSLog(@"%@", url);
        
        [((OneImageTableViewCell*)cell).headImageView setImageWithURL:url];
        return cell;
    }else{
        NSMutableArray *url_arr = [[NSMutableArray alloc]init];
        for(int i = 0; i < 3; i++) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr[i] options:kNilOptions error:&err];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSString *url = json[@"url_prefix"];
            url = [url stringByAppendingString:json[@"web_uri"]];
            [url_arr addObject:url];
        }
        cell = [[ThreeImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        ((ThreeImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
        [((ThreeImageTableViewCell*)cell).imageFirst setImageWithURL:url_arr[0]];
        [((ThreeImageTableViewCell*)cell).imageSecond setImageWithURL:url_arr[1]];
        [((ThreeImageTableViewCell*)cell).imageThird setImageWithURL:url_arr[2]];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeDetailController* detailController = [[HomeDetailController alloc] init];
    detailController.groupId = self.articleList[indexPath.row][@"group_id"];
    NSLog(@"%@", self.articleList[indexPath.row][@"image_infos"]);
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Setter

- (void)setArticleList:(NSArray<NSDictionary *> *)articleList {
    _articleList = articleList;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)loadData {
    
}

- (void)loadMoreData {
    
}
@end
