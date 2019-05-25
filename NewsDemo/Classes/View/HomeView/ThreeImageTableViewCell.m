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
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        self.content = [[UILabel alloc]init];
        self.content.frame = CGRectMake(5,5,width - 10,50);
        self.content.numberOfLines = 0;
        self.imageFirst = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.imageSecond = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.imageThird = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.imageFirst.frame = CGRectMake(5, 60, (width - 20)/3, 70);
        self.imageSecond.frame = CGRectMake(10 + width/3, 60, (width - 20)/3, 70);
        self.imageThird.frame = CGRectMake(15 + 2*width/3, 60, (width - 20)/3, 70);
        [self addSubview:self.content];
        [self addSubview:self.imageFirst];
        [self addSubview:self.imageSecond];
        [self addSubview:self.imageThird];
    }
    return self;
}

@end
