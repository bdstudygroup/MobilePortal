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
        self.content = [[UILabel alloc]init];
        self.numberStar = [[UILabel alloc]init];
        self.numberComment = [[UILabel alloc]init];
        self.numberStar.text = @"star";
        self.numberComment.text = @"comment";
        //self.content.frame = CGRectMake(5, 5, (width- 10), 50);
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.numberStar];
        [self.contentView addSubview:self.numberComment];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5.0);
        make.left.equalTo(self.contentView.mas_left).offset(5.0);
        make.width.mas_equalTo(width - 10);
    }];
    [self.numberStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(5.0);
        make.left.equalTo(self.content.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
    [self.numberComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(5.0);
        make.left.equalTo(self.numberComment.mas_right);
    }];
}

@end
