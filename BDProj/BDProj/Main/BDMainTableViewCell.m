//
//  BDMainTableViewCell.m
//  BDProj
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019 Chauncey Qu. All rights reserved.
//

#import "BDMainTableViewCell.h"

static NSString *const BDMainTableViewCellId = @"BDMainTableViewCellId";

@implementation BDMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    BDMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BDMainTableViewCellId];
    if (cell == nil) {
        cell = [[BDMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BDMainTableViewCellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 50, 50)];
        //self.iconView.image = [UIImage imageNamed: @"cat"];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(80, 10, 150, 50)];        [self.contentView addSubview:self.nameLabel];
        
        self.starNumberLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.contentView.frame.size.width - 30 - 50, 25, 50, 20)];
        self.starNumberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.starNumberLabel];
        
        self.starView = [[UIImageView alloc] initWithFrame: CGRectMake(self.contentView.frame.size.width - 30, 25, 20, 20)];
        self.starView.clipsToBounds = YES;
        self.starView.contentMode = UIViewContentModeScaleAspectFit;
        self.starView.image = [UIImage imageNamed:@"star"];
        [self.contentView addSubview:self.starView];
    }
    return self;
}

@end
