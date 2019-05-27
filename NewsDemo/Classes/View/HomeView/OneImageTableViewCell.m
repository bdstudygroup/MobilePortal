//
//  OneImageTableViewCell.m
//  NewsDemo
//
//  Created by student4 on 2019/5/25.
//  Copyright © 2019 news. All rights reserved.
//

#import "OneImageTableViewCell.h"

@interface OneImageTableViewCell()

@end

@implementation OneImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        self.content = [[UILabel alloc]init];
        self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.headImageView];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5.0);
            make.left.equalTo(self.contentView.mas_left).offset(5.0);
            make.width.mas_equalTo(width*0.6);
        }];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5.0);
            make.left.equalTo(self.content.mas_right).offset(5.0);
            make.size.mas_equalTo(CGSizeMake((0.4*width - 15), ((0.4*width - 15)*0.56)));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
        }];
        
        
    }
    return self;
}
@end
