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
        self.content = [[UILabel alloc]init];
        self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.numberStar = [[UILabel alloc]init];
        self.numberComment = [[UILabel alloc]init];
        self.numberStar.text = @"点赞";
        self.numberComment.text = @"评论";
        self.numberStar.font = [UIFont systemFontOfSize:12];
        self.numberStar.textColor = [UIColor lightGrayColor];
        self.numberComment.font = [UIFont systemFontOfSize:12];
        self.numberComment.textColor = [UIColor lightGrayColor];
        self.content.numberOfLines = 0;
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.numberStar];
        [self.contentView addSubview:self.numberComment];
        [self setUp];
    }
    return self;
}

-(void)setUp {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5.0);
        make.left.equalTo(self.contentView.mas_left).offset(5.0);
        make.width.mas_equalTo(width*0.6);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5.0);
        make.left.equalTo(self.content.mas_right).offset(5.0);
        make.width.mas_equalTo(0.4*width - 15);
        make.height.mas_equalTo((0.4*width - 15)*0.56);
        //make.size.mas_equalTo(CGSizeMake((0.4*width - 15), ((0.4*width - 15)*0.56)));
        // make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
    [self.numberStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_left);
        make.top.equalTo(self.headImageView.mas_bottom).offset(-12);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
    [self.numberComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberStar.mas_right).offset(5.0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
}
@end
