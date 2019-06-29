//
//  AppDelegate.m
//  NewsDemo
//
//  Created by student5 on 2019/5/11.
//  Copyright © 2019 news. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DDLog.h"
#import "HomeController.h"
#import "WordController.h"
#import "CCMainViewController.h"
#import "MyController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configGlobalUIStyle];
    [self setupViewControllers];
    self.window.rootViewController = self.tabBarController;
    
    return YES;
}

//导航栏设置
-(void) configGlobalUIStyle{
    UINavigationBar* bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;
    [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
//tabBar
-(void)setupViewControllers{
    UINavigationController *navi0 = [HomeController defaultHomeNavi];
    //UINavigationController *navi1 = [WordController defaultWordNavi];
    CCMainViewController *navi2 = [CCMainViewController defaultVideoNavi];
    UINavigationController *vc3 = [MyController defaultMyNavi];
    CYLTabBarController* tbc = [CYLTabBarController new];
    [self customTabBarForController:tbc];
    [tbc setViewControllers:@[navi0, navi2, vc3]];
    self.tabBarController = tbc;
}

-(void)customTabBarForController:(CYLTabBarController*)tbc{
    NSDictionary *dict0 = @{CYLTabBarItemTitle:@"首页",
                            CYLTabBarItemImage:@"news",
                            CYLTabBarItemSelectedImage:@"newsblue"};
//    NSDictionary *dict1 = @{CYLTabBarItemTitle:@"图文",
//                            CYLTabBarItemImage:@"live",
//                            CYLTabBarItemSelectedImage:@"liveblue"};
    NSDictionary *dict2 = @{CYLTabBarItemTitle:@"视频",
                            CYLTabBarItemImage:@"market",
                            CYLTabBarItemSelectedImage:@"marketblue"};
    NSDictionary *dict3 = @{CYLTabBarItemTitle:@"我的",
                            CYLTabBarItemImage:@"my",
                            CYLTabBarItemSelectedImage:@"myblue"};
    
    NSArray* tabBarItems = @[dict0, dict2, dict3];
    tbc.tabBarItemsAttributes = tabBarItems;
}

-(UIWindow*)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}

-(UITabBarController *)tabBarController{
    if (_tabBarController == nil) {
        _tabBarController = [[UITabBarController alloc] init];
    }
    return _tabBarController;
}









































- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
