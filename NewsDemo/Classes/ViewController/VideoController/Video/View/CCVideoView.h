//
//  CCVideoView.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/29.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CCVideoViewDataSource, CCVideoViewDelegate;

@interface CCVideoView : UIView

@property (nonatomic, weak, nullable) id <CCVideoViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <CCVideoViewDelegate> delegate;

@property (nonatomic, strong) NSString *toolViewTitle;
@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic, assign) BOOL isVideoPlaying;
@property (nonatomic, assign) BOOL isVideoFullScreen;

+ (instancetype)videoViewWithUrl:(NSURL *)videoUrl;
- (void) stopVideoPlayerAction;

@end


@protocol CCVideoViewDataSource <NSObject>
@required
- (NSURL *)videoUrlForCCVideoView:(CCVideoView *)videoView;

@end


@protocol CCVideoViewDelegate <NSObject>
@required
- (void)popControllerFromNavigationControllerStack;

@end

NS_ASSUME_NONNULL_END
