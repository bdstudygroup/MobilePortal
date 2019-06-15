//
//  CCVideoPlayerController.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/19.
//  Copyright © 2019 cc. All rights reserved.
//

#import "CCVideoPlayerController.h"
#import "CCVideoView.h"
#import "UIView+FrameMethods.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#ifdef DEBUG
#define CCDebugLog(fmt, ...) NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CCDebugLog(...)
#endif

@interface CCVideoPlayerController () <CCVideoViewDataSource, CCVideoViewDelegate>

@property (nonatomic, strong) CCVideoView *videoView;
@property (nonatomic, assign) BOOL isVideoFullScreen;

@end

@implementation CCVideoPlayerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    UIDevice *device = [UIDevice currentDevice];
    if (UIDeviceOrientationIsLandscape(device.orientation)) {
        self.isVideoFullScreen = YES;
        
    } else {
        self.isVideoFullScreen = NO;
        
    }
}

#pragma mark - Getter/Setter

- (NSString *)navigationItemTitle {
    if (_navigationItemTitle == nil) {
        _navigationItemTitle = @"";
    }
    return _navigationItemTitle;
}

- (void)setIsVideoFullScreen:(BOOL)isVideoFullScreen {
    
    self.videoView.isVideoFullScreen = isVideoFullScreen;
    
    if (isVideoFullScreen) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
        
        self.videoView.frame = self.view.bounds;
    } else {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO];
        
        CGFloat topBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
        CGSize rootViewSize = self.view.bounds.size;
        self.videoView.frame = CGRectMake(0, topBarHeight, rootViewSize.width, rootViewSize.height  - topBarHeight-20);
    }
    
    _isVideoFullScreen = isVideoFullScreen;
}

#pragma mark - Common Init

- (void)commonInit {
    
    // Root View
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Status Bar & Navigation Bar
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        self.navigationItem.title = self.navigationItemTitle;
    }
    
    self.videoView = [CCVideoView videoViewWithUrl:[NSURL URLWithString:self.videoURLString]];
    self.videoView.toolViewTitle = self.navigationItemTitle;
    self.videoView.loadingImage = self.loadingImage;
    self.videoView.dataSource = self;
    self.videoView.delegate = self;
    [self.view addSubview:self.videoView];
    
    

}

#pragma mark - Protocol

- (NSURL *)videoUrlForCCVideoView:(CCVideoView *)videoView {
    NSLog(@"%s",__func__);
    return [NSURL URLWithString:self.videoURLString];
}

- (void)popControllerFromNavigationControllerStack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
