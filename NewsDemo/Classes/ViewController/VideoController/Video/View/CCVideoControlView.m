//
//  CCVideoControlView.m
//  CCVideoDemo
//
//  Created by cc on 2019/4/30.
//  Copyright © 2019 cc. All rights reserved.
//

#import "CCVideoControlView.h"
#import "UIView+FrameMethods.h"
#import "UIImage+Resize.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CCVideoControlView ()

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UITapGestureRecognizer *controlViewTapGesture;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) BOOL isAllControlsShow;

@end

@implementation CCVideoControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.returnButton.frame = CGRectMake(0, 10, 30, 30);
    self.titleLabel.frame = CGRectMake(40, 0, self.width - 50, 50);
    self.playButton.size = CGSizeMake(50, 50);
    self.playButton.center = CGPointMake(self.width / 2, self.height / 2);
    
    CGRect bottomBarRect = CGRectMake(0, self.height - 50, self.width, 50);
    CGFloat bottomBarOriginX = bottomBarRect.origin.x;
    CGFloat bottomBarOriginY = bottomBarRect.origin.y;
    CGFloat bottomBarWidth = bottomBarRect.size.width;
    CGFloat bottomBarHeight = bottomBarRect.size.height;
    self.currentSecondsLabel.frame = CGRectMake(bottomBarOriginX + 10, bottomBarOriginY + 10 , bottomBarWidth / 9 , 30);
    self.durationLabel.frame = CGRectMake(bottomBarWidth / 9 * 7 , bottomBarOriginY + 10, 30, 30);
    
    self.bufferProgressView.frame = CGRectMake(bottomBarWidth / 9 + 10 + 2, bottomBarOriginY + bottomBarHeight / 2 - 1, bottomBarWidth / 9 * 5.5, 0);
    self.playSlider.frame = CGRectMake(bottomBarWidth / 9 + 10, bottomBarOriginY, bottomBarWidth / 9 * 5.5, bottomBarHeight);
    self.fullscreenButton.frame = CGRectMake(bottomBarWidth / 9 * 8 , bottomBarOriginY + 10, 30, 30);
    
    
}

#pragma mark - Getter/Setter

- (MPVolumeView *)volumeView {
    
    if (_volumeView == nil) {
        _volumeView = [[MPVolumeView alloc] init];
    }
    return _volumeView;
}

- (UISlider *)volumeSlider {
    
    if (_volumeSlider == nil) {
        for(UIView *view in self.volumeView.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"MPVolumeSlider"]) {
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeSlider;
}

#pragma mark - Common Init

-(void)commonInit {
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    self.isAllControlsShow = YES;
    self.controlViewPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureStateChange:)];
    [self addGestureRecognizer:self.controlViewPanGesture];
    
    self.returnButton = [[UIButton alloc] init];
    [self.returnButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [self.returnButton addTarget:self action:@selector(clickReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.returnButton];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    
    self.playButton = [[UIButton alloc] init];
    self.playButton.backgroundColor = [UIColor clearColor];
    self.playButton.clipsToBounds = YES;
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    
    self.currentSecondsLabel = [[UILabel alloc] init];
    self.currentSecondsLabel.textColor = [UIColor whiteColor];
    self.currentSecondsLabel.font = [UIFont systemFontOfSize:10];
    self.currentSecondsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.currentSecondsLabel];
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.font = [UIFont systemFontOfSize:10];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.durationLabel];
    
    self.bufferProgressView = [[UIProgressView alloc] init];
    self.bufferProgressView.progress = 0.5;
    self.bufferProgressView.trackTintColor = [UIColor whiteColor];
    self.bufferProgressView.progressTintColor = [UIColor grayColor];
    [self addSubview:self.bufferProgressView];
    
    self.playSlider = [[UISlider alloc] init];
    self.playSlider.maximumTrackTintColor = [UIColor clearColor];
    self.playSlider.minimumTrackTintColor = [UIColor blueColor];
//    UIImage *sliderThumbImage = [UIImage imageNamed:@"circle"];
//    [self.playSlider setThumbImage:[UIImage imageWithImage:sliderThumbImage converToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [self.playSlider addTarget:self action:@selector(onPlaySliderValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.playSlider];
    
    self.fullscreenButton = [[UIButton alloc] init];
    [self.fullscreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    self.fullscreenButton.backgroundColor = [UIColor clearColor];
    [self.fullscreenButton addTarget:self action:@selector(clickFullscreenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fullscreenButton];   
}

#pragma mark - Actions
- (void)clickPlayButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickedPlayButton)]) {
        [self.delegate didClickedPlayButton];
    }
}

- (void)clickReturnButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickedReturnButton)]) {
        [self.delegate didClickedReturnButton];
    }
}

- (void)clickFullscreenButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickedFullscreenButton)]) {
        [self.delegate didClickedFullscreenButton];
    }
}

- (void)onPlaySliderValueChanged:(UISlider *)sender forEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(changeSlider:withEvent:)]) {
        [self.delegate changeSlider:sender withEvent:event];
    }
}

#pragma mark - Gesture

- (void)onPanGestureStateChange:(UIPanGestureRecognizer *)panGesture {
    
    switch (panGesture.state) {
            
        case UIGestureRecognizerStateBegan:
            self.originPoint = [panGesture locationInView:self];
            break;
            
        case UIGestureRecognizerStateChanged: {
            [self handleGestureRecognizerStateChanged:panGesture];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleGestureRecognizerStateChanged:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat valueOffset = [panGesture translationInView:self].y / 500.0;
    if (self.originPoint.x < self.bounds.size.width/2.0) {
        CGFloat newBrightness = [[UIScreen mainScreen] brightness] - valueOffset;
        [[UIScreen mainScreen] setBrightness:MAX(0,MIN(1, newBrightness))];
    } else {
        CGFloat newVolume = self.volumeSlider.value - valueOffset;
        self.volumeSlider.value = MAX(0,MIN(1, newVolume));
    }
}



@end
