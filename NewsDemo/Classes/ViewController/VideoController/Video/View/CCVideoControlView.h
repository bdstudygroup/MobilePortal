//
//  CCVideoControlView.h
//  CCVideoDemo
//
//  Created by cc on 2019/4/30.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CCVideoControlViewDelegate;

@interface CCVideoControlView : UIView

@property (nonatomic, weak) id<CCVideoControlViewDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *fullscreenButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UILabel *currentSecondsLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIProgressView *bufferProgressView;
@property (nonatomic, strong) UISlider *playSlider;
@property (nonatomic, strong) UIPanGestureRecognizer *controlViewPanGesture;

- (void)hideAllControls;
- (void)showAllControls;
@end

@protocol CCVideoControlViewDelegate <NSObject>
@required
- (void)didClickedPlayButton;
- (void)didClickedReturnButton;
- (void)didClickedFullscreenButton;
- (void)changeSlider:(UISlider *)slider withEvent:(UIEvent *)event;
@end

NS_ASSUME_NONNULL_END
