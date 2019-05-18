//
//  MyImageView.m
//  NewsDemo
//
//  Created by wangld on 2019/5/12.
//  Copyright © 2019 news. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

- (UIImageView *)imgView {
    if(_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _imgView;
}

@end
