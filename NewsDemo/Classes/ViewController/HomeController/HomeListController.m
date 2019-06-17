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
#import "PicDetailController.h"
#import "../../View/HomeView/OneImageTableViewCell.h"
#import "../../View/HomeView/ThreeImageTableViewCell.h"
#import "../../View/HomeView/NoImageTableViewCell.h"
#import "AllList.h"
#import "AllListItem.h"
#define kHomeListCell @"kHomeListCell"

@interface HomeListController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *articleList;
@property (nonatomic, strong) HomeListManager *manager;

@end
@implementation HomeListController

#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [HomeListManager sharedManager];
    self.manager.currentOffset = 0;
    [self setup];
    [self update];
}

- (void)setup {
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self update];
    }];
    [self.view addSubview:self.tableView];
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
        //NSLog(@"%@", url);
        
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
        //push data
        NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
        NSInteger nextRow = indexPath.row + visibleRows.count;
        if(self.articleList.count - indexPath.row < visibleRows.count) {
            [self.tableView.mj_footer beginRefreshing];
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeDetailController* detailController = [[HomeDetailController alloc] init];
    detailController.groupId = self.articleList[indexPath.row][@"group_id"];
    //NSLog(@"%@", self.articleList[indexPath.row][@"image_infos"]);
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

- (void) update {
    static Boolean noMoreData = false;
    [self.manager  updateWithCompletion:^(NSArray *articleFeed) {
        if(articleFeed == NULL) {
            noMoreData = true;
        } else {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.articleList];
            [temp addObjectsFromArray:articleFeed];
            self.articleList = temp;
        }
    }];
    if(noMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = YES;
    }
}
@end
