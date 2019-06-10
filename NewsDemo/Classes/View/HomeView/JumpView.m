//
//  JumpView.m
//  NewsDemo
//
//  Created by wangld on 2019/6/9.
//  Copyright © 2019 news. All rights reserved.
//

#import "JumpView.h"
#define UI_navBar_Height 64.0

@interface JumpView()
{
    UIView *_contentView;
}
@end

@implementation JumpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, kWindowW, kWindowH-viewHeight);
    self.commentArray = [[NSMutableArray alloc] initWithCapacity:100];
    self.commentIDs = [[NSMutableArray alloc] initWithCapacity:100];
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kWindowH - viewHeight, kWindowW, viewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        //左上角标题
        UILabel* label = [[UILabel alloc] init];
        label.text = @"评论";
        label.font = [UIFont systemFontOfSize:16];
        [_contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker* make){
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(15);
        }];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(kWindowW - 20 - 15, 15, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        //设置UITableView
        UITableView* commentDetail = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_contentView addSubview:commentDetail];
        [commentDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(closeBtn.mas_bottom).mas_equalTo(15);
        }];
        commentDetail.delegate = self;
        commentDetail.dataSource = self;
        self.commentDetail = commentDetail;
        self.commentDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"count: %d", self.commentArray.count);
    return self.commentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 假数据
    cell.textLabel.text = self.commentArray[indexPath.row];
    cell.detailTextLabel.text = @"已评论";
    return cell;
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, kWindowH, kWindowW, viewHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, kWindowH - viewHeight - UI_navBar_Height, kWindowW, viewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    [_contentView setFrame:CGRectMake(0, kWindowH - viewHeight, kWindowW, viewHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, kWindowH, kWindowW, viewHeight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}



@end
