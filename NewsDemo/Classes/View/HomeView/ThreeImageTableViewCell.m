//
//  ThreeImageTableViewCell.m
//  NewsDemo
//
//  Created by student4 on 2019/5/25.
//  Copyright © 2019 news. All rights reserved.
//

#import "ThreeImageTableViewCell.h"

@interface ThreeImageTableViewCell()

@end

@implementation ThreeImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.content = [[UILabel alloc]init];
        //self.content.frame = CGRectMake(5,5,width - 10,50);
        self.content.numberOfLines = 0;
        self.imageFirst = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.imageSecond = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.imageThird = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.numberStar = [[UILabel alloc]init];
        self.numberComment = [[UILabel alloc]init];
        self.numberStar.text = @"star";
        self.numberComment.text = @"comment";
        self.numberStar.font = [UIFont systemFontOfSize:12];
        self.numberStar.textColor = [UIColor lightGrayColor];
        self.numberComment.font = [UIFont systemFontOfSize:12];
        self.numberComment.textColor = [UIColor lightGrayColor];
        //self.imageFirst.frame = CGRectMake(5, 60, (width - 14)/3, 70);
        //self.imageSecond.frame = CGRectMake(7 + (width-14)/3, 60, (width - 14)/3, (width - 14)/3*0.7);
        //self.imageThird.frame = CGRectMake(9 + 2*(width - 14)/3, 60, (width - 14)/3, (width - 14)/3*0.7);
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.imageFirst];
        [self.contentView addSubview:self.imageSecond];
        [self.contentView addSubview:self.imageThird];
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
        make.left.equalTo(self.contentView.mas_left).offset(2.0);
        make.width.mas_equalTo(width - 10);
    }];
    [self.imageFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(5.0);
        make.left.equalTo(self.content.mas_left);
        make.width.mas_equalTo((width - 14)/3);
        make.height.mas_equalTo((width - 14)/3*0.7);
    }];
    
    [self.imageSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(5.0);
        make.left.equalTo(self.imageFirst.mas_right).offset(2.0);
        make.width.mas_equalTo((width - 14)/3);
        make.height.mas_equalTo((width - 14)/3*0.7);
    }];
    
    [self.imageThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(5.0);
        make.left.equalTo(self.imageSecond.mas_right).offset(2.0);
        make.width.mas_equalTo((width - 14)/3);
        make.height.mas_equalTo((width - 14)/3*0.7);
    }];
    [self.numberStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageFirst.mas_bottom).offset(5.0);
        make.left.equalTo(self.imageFirst.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
    [self.numberComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageFirst.mas_bottom).offset(5.0);
        make.left.equalTo(self.numberStar.mas_right).offset(5.0);
    }];
}

@end
