//
//  NoImageTableViewCell.m
//  NewsDemo
//
//  Created by 彭伟林 on 2019/5/26.
//  Copyright © 2019 news. All rights reserved.
//

#import "NoImageTableViewCell.h"

@implementation NoImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        self.content = [[UILabel alloc]init];
        self.content.font = [UIFont systemFontOfSize:16];
        self.content.text = @"text";
        //self.content.frame = CGRectMake(5, 5, (width- 10), 50);
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5.0);
            make.left.equalTo(self.contentView.mas_left).offset(5.0);
            make.width.mas_equalTo(width - 10);
        }];
    }
    return self;
}

@end
