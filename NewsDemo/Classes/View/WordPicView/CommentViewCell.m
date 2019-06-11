//
//  CommentViewCell.m
//  NewsDemo
//
//  Created by wangld on 2019/6/11.
//  Copyright © 2019 news. All rights reserved.
//

#import "CommentViewCell.h"

@implementation CommentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.name = [[UILabel alloc]init];
        self.name.text = @"dog";
        self.headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.comment = [[UILabel alloc]init];
        self.comment.numberOfLines = 0;
        self.time = [[UILabel alloc]init];
        self.time.numberOfLines = 0;
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.comment];
        [self.contentView addSubview:self.time];
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.left.mas_equalTo(self.headImage.mas_right).offset(5.0);
    }];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(5);
        make.top.mas_equalTo(self.name.mas_bottom).offset(5);
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.comment.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headImage.mas_right).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [self.contentView addSubview:zanBtn];
    [zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

@end
