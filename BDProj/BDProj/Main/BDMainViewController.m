//
//  BDMainViewController.m
//  BDProj
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019 Chauncey Qu. All rights reserved.
//

#import "BDMainViewController.h"
#import "BDMainTableViewCell.h"
#import "AFNetworking.h"

static NSString *const testURLString = @"https://api.github.com/users/SlaunchaMan/repos?page=1";

@interface BDMainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewData;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *currentUserName;

@end

@implementation BDMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, 50)];
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.placeholder = @"Search";
    [self.view addSubview:self.searchBar];
    
    self.searchBar.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.searchBar.bounds.size.height)];
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self searchWithName:@"SlaunchaMan" andPageNumber:1];
    
}

- (NSMutableArray *)tableViewData {
    if (_tableViewData == nil) {
        _tableViewData = [[NSMutableArray alloc] init];
    }
    return _tableViewData;
}

- (UIImage *)iconImage {
    if (_iconImage == nil) {
        _iconImage = [[UIImage alloc] init];
    }
    return _iconImage;
}

- (NSString *)currentUserName {
    if (_currentUserName == nil) {
        _currentUserName = @"";
    }
    return _currentUserName;
}

- (void)searchWithName:(NSString *)name andPageNumber:(NSInteger)page {
    NSString *searchURLString = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos?page=%zd",name,page];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress-->%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *responseDataArray = responseObject;
        
        [self.tableViewData removeAllObjects];
        self.iconImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:responseDataArray[0][@"owner"][@"avatar_url"]]]];
        for (NSUInteger i=0; i<responseDataArray.count; ++i) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict[@"name"] = responseDataArray[i][@"name"];
            dict[@"stargazers_count"] = responseDataArray[i][@"stargazers_count"];
            [self.tableViewData addObject:dict];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-->%@",error);
    }];
    
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BDMainTableViewCell *cell = [BDMainTableViewCell cellWithTableView:tableView];
    cell.iconView.image = self.iconImage;
    cell.nameLabel.text = self.tableViewData[indexPath.row][@"name"];
    cell.starNumberLabel.text = [NSString stringWithFormat:@"%@",self.tableViewData[indexPath.row][@"stargazers_count"]] ;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self searchWithName:searchBar.text andPageNumber:1];
}




@end
