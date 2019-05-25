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
        self.content.text = @"text";
        self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_portrait_ph"]];
        self.content.frame = CGRectMake(5, 5, 0.6 * width, 90);
        self.content.numberOfLines = 0;
        self.headImageView.frame = CGRectMake(0.6 * width + 5, 5, 0.4 * width - 10, 90);
        [self addSubview:self.content];
        [self addSubview:self.headImageView];
    }
    return self;
}
@end
