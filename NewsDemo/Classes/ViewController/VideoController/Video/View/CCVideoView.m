//
//  CCVideoView.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/29.
//  Copyright © 2019 cc. All rights reserved.
//

#import "CCVideoView.h"
#import "CCVideoControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+Formatter.h"
#import "UIView+FrameMethods.h"

#ifdef DEBUG
#define CCDebugLog(fmt, ...) NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CCDebugLog(...)
#endif

@interface CCVideoView () <CCVideoControlViewDelegate>

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) NSURL *playerUrl;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSTimer *hideControlViewCountDownTimer;
@property (nonatomic, strong) id playSliderTimeObserver;
@property (nonatomic, assign) BOOL isControlViewShow;
@property (nonatomic, strong) CCVideoControlView *videoControlView;


@end

@implementation CCVideoView

@synthesize toolViewTitle = _toolViewTitle;

+ (instancetype)videoViewWithUrl:(NSURL *)videoUrl {
    
    return [[CCVideoView alloc] initWithUrl:videoUrl];
}

- (instancetype)initWithUrl:(NSURL *)videoUrl {
    
    self = [super init];
    if (self) {
        self.playerUrl = videoUrl;
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.videoControlView.frame = self.playerLayer.videoRect;
    self.loadingImageView.frame = self.bounds;
    self.activityIndicatorView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)dealloc {
    
    [self.player pause];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.playerItem = nil;
    [self.player removeTimeObserver:self.playSliderTimeObserver];
    self.player = nil;
    
}

#pragma mark - Getter/Setter

- (NSString *)toolViewTitle {
    if (_toolViewTitle == nil) {
        _toolViewTitle = [[NSString alloc] init];
    }
    return _toolViewTitle;
}

- (void)setToolViewTitle:(NSString *)toolViewTitle {
    
    _toolViewTitle = toolViewTitle;
    self.videoControlView.titleLabel.text = toolViewTitle;
}


- (void)setIsVideoPlaying:(BOOL)isVideoPlaying {
    
    if (isVideoPlaying) {
        
        [self.videoControlView.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.player play];
    } else {
        
        [self.videoControlView.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.player pause];
    }
    _isVideoPlaying = isVideoPlaying;
}



#pragma mark - Common Init

- (void)commonInit {
    
    self.isControlViewShow = NO;
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControlView)];
    [self addGestureRecognizer:tapGesture];
    // player layer
    self.playerItem = [AVPlayerItem playerItemWithURL:self.playerUrl];
    [self addPlayerItemObserver]; // PlayerItem Observer
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.playerLayer];
    
    // CCVideo Tool View
    self.videoControlView = [[CCVideoControlView alloc] init];
    self.videoControlView.hidden = YES;
    self.videoControlView.delegate = self;
    [self addSubview:self.videoControlView];
    
    // Loading Image
    self.loadingImageView = [[UIImageView alloc] init];
    self.loadingImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.loadingImageView.image = [UIImage imageNamed:@"cc"];
    [self addSubview:self.loadingImageView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.color = [UIColor grayColor];
    [self.activityIndicatorView startAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    [self addSubview:self.activityIndicatorView];
    
}

- (void)toggleControlView {
    
    // show -> hide
    if (self.isControlViewShow) {
        self.isControlViewShow = NO;
        self.videoControlView.hidden = YES;
    // hide -> show
    } else {
        self.isControlViewShow = YES;
        self.videoControlView.hidden = NO;
    }
}

#pragma mark - Protocol CCVideoControlViewDelegate

- (void)didClickedPlayButton {
    
    self.isVideoPlaying = !self.isVideoPlaying;
}

- (void)didClickedReturnButton {
    
    if (self.isVideoFullScreen) {
        
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    } else {
        if ([self.delegate respondsToSelector:@selector(popControllerFromNavigationControllerStack)]) {
            [self.delegate popControllerFromNavigationControllerStack];
        }
        
    }
}

- (void)didClickedFullscreenButton {
    
    if (self.isVideoFullScreen) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [self.videoControlView.fullscreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    } else {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        [self.videoControlView.fullscreenButton setImage:[UIImage imageNamed:@"exit_fullscreen"] forState:UIControlStateNormal];
    }
}

- (void)changeSlider:(UISlider *)slider withEvent:(UIEvent *)event {
    
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
        case UITouchPhaseBegan:
            self.videoControlView.controlViewPanGesture.enabled = NO;
            self.isVideoPlaying = NO;
            break;
        case UITouchPhaseMoved:
            break;
        case UITouchPhaseEnded:
            self.videoControlView.controlViewPanGesture.enabled = YES;
            double seconds = slider.value;
            CMTime startTime = CMTimeMakeWithSeconds(seconds, 1.0);
            [self.playerItem seekToTime:startTime];
            self.isVideoPlaying = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Observers

- (void)addPlayerItemObserver {
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                CCDebugLog(@"player item failed");
                break;
            case AVPlayerItemStatusUnknown:
                CCDebugLog(@"player item unknown");
                break;
            case AVPlayerItemStatusReadyToPlay:{
                CCDebugLog(@"player item ready to play");
                self.isVideoPlaying = YES;
                
                if (!self.playSliderTimeObserver) {
                    
                    __weak typeof(self) self_ = self;
                    
                    self.playSliderTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                        float currenTimeSeconds = CMTimeGetSeconds(self_.playerItem.currentTime);
                        
                        self_.videoControlView.playSlider.value = currenTimeSeconds;
                        self_.videoControlView.currentSecondsLabel.text = [NSString stringFormatterWithSeconds:(int)currenTimeSeconds];
                        
                        if (currenTimeSeconds > 0.1) {
                            [self_.activityIndicatorView stopAnimating];
                            self_.loadingImageView.hidden = YES;
                        }
                    }];
                }
                
                float sliderMaxValueSeconds = CMTimeGetSeconds(self.playerItem.duration);
                if (sliderMaxValueSeconds > 0) {
                    self.videoControlView.playSlider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
                    self.videoControlView.durationLabel.text = [NSString stringFormatterWithSeconds:(int)sliderMaxValueSeconds];
                }
                self.videoControlView.frame = self.playerLayer.videoRect;
                
//                self.videoControlView.hidden = NO;
                
                break;
            }
            default:
                break;
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray *loadedTimeRanges = self.playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        
        self.videoControlView.bufferProgressView.progress = (startSeconds + durationSeconds) / CMTimeGetSeconds(self.playerItem.duration);
    }
}



@end
