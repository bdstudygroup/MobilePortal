//
//  HomeController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "HomeController.h"
#import "HomeListController.h"
#import "HomeDetailController.h"
#import "HomeListManager.h"

@interface HomeController ()<PYSearchViewControllerDelegate>

@property(nonatomic, strong)NSArray<NSDictionary *> *articleList;
@property(nonatomic, strong)NSMutableArray<NSString *>* titles;
@property(nonatomic, strong)NSMutableArray<NSString *>* groupIds;

@end

@implementation HomeController

+ (UINavigationController *)defaultHomeNavi {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HomeController *vc = [[HomeController alloc] initWithViewControllerClasses:[self viewControllerClasses] andTheirTitles:[self itemNames]];
        vc.keys = [self vcKeys];
        vc.values = [self vcValues];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = NO;
}

+ (NSArray *)itemNames {
    return @[@""];
}

+ (NSArray *)viewControllerClasses {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:[HomeListController class]];
    }
    return [mArr copy];
}

+ (NSArray *)vcKeys {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:@"infoType"];
    }
    return [mArr copy];
}

+ (NSArray *)vcValues {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:@(i)];
    }
    return [mArr copy];
}

-(void)searchButton{
    NSArray *hotSeaches = @[@"NBA", @"科技", @"民生", @"游戏", @"小说", @"音乐", @"影视"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索新闻", @"搜索新闻") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        HomeDetailController* controller = [[HomeDetailController alloc] init];
        for (int i=0; i<self.articleList.count; i++) {
            if ([self.articleList[i][@"title"] containsString:searchText]) {
                controller.groupId = self.articleList[i][@"group_id"];
            }
        }
        [searchViewController.navigationController pushViewController:controller animated:YES];
    }];
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.delegate = self;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    [self update];
    if (searchText.length) {
        
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i=0; i<self.articleList.count; i++) {
                if ([self.articleList[i][@"title"] containsString:searchText]) {
                    [searchSuggestionsM addObject: self.articleList[i][@"title"]];
                }
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

-(void)update{
    __weak __typeof(self) weakSelf = self;
    [[HomeListManager sharedManager] getAllNews:^(NSArray * _Nonnull articleFeed) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.articleList = articleFeed;
        // NSLog(@"%@",strongSelf.articleList);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日热点";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
    [self update];
}

@end
