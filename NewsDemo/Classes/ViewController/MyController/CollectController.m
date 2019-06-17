//
//  CollectController.m
//  NewsDemo
//
//  Created by student on 2019/6/15.
//  Copyright © 2019 news. All rights reserved.
//

#import "CollectController.h"
#import "HomeDetailController.h"

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
    self.newsCollects = [[collectList alloc] init];
    [self.newsCollects loadChecklists];
    [self collectionTable];
}

-(void)update{
    __weak __typeof(self) weakSelf = self;
    [[HomeListManager sharedManager] getAllNews:^(NSArray * _Nonnull articleFeed) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.allList = articleFeed;
    }];
}

#pragma 懒加载

- (UITableView *)collectionTable{
    if(_collectionTable == nil) {
        _collectionTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _collectionTable.dataSource = self;
        _collectionTable.delegate = self;
        _collectionTable.tableFooterView = [UIView new];
        [self.view addSubview:_collectionTable];
        [_collectionTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _collectionTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsCollects.myCollectList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellID:%ld", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.newsCollects.myCollectList[indexPath.row].newsTitle;
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeDetailController* detailController = [[HomeDetailController alloc] init];
    detailController.groupId = self.newsCollects.myCollectList[indexPath.row].newsID;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.newsCollects.myCollectList removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.newsCollects saveChecklists];
}


@end
