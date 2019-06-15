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
    _collectionNews = [[NSMutableArray alloc] initWithCapacity:100];
    [self collectionTable];
}
#pragma 懒加载

- (UITableView *)collectionTable{
    if(_collectionTable == nil) {
        _collectionTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellID:%ld", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"fuck you";
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
