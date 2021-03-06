//
//  JumpView.m
//  NewsDemo
//
//  Created by wangld on 2019/6/9.
//  Copyright © 2019 news. All rights reserved.
//

#import "JumpView.h"
#import "CommentViewCell.h"
#define UI_navBar_Height 64.0

@interface JumpView()
{
    UIView *_contentView;
}
@end

@implementation JumpView

- (void)setupContent {
    self.frame = CGRectMake(0, 0, kWindowW, kWindowH-viewHeight);
    self.commentArray = [[NSMutableArray alloc] initWithCapacity:100];
    self.commentIDs = [[NSMutableArray alloc] initWithCapacity:100];
    self.commentTimes = [[NSMutableArray alloc] initWithCapacity:100];
    self.commentNames = [[NSMutableArray alloc] initWithCapacity:100];
    self.headImages = [[NSMutableArray alloc] initWithCapacity:100];
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
        self.commentDetail = commentDetail;
        self.commentDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

-(void)updateContent{
    [self updateComment];
    self.commentDetail.delegate = self;
    self.commentDetail.dataSource = self;
    [self.commentDetail reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"number: %d", self.commentArray.count);
    return self.commentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%ld", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    ((CommentViewCell*)cell).comment.text = self.commentArray[indexPath.section];
    ((CommentViewCell*)cell).time.text = self.commentTimes[indexPath.section];
    ((CommentViewCell*)cell).name.text = self.commentNames[indexPath.section];
    NSLog(@"has image: %@", self.headImages[indexPath.section]);
    if (![self.headImages[indexPath.section] isEqualToString:@"http://172.19.3.119:8080/"]) {
        [((CommentViewCell*)cell).headImage setImage:[self getImageFromURL:self.headImages[indexPath.section]]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"YES");
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"YES2");
    return 100;
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [self updateComment];
    NSLog(@"comment: %@", self.comments);
    [self setupContent];
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

-(NSString* )timeStepChange: (NSString*) timeStep {
    NSString *timeStampString  = timeStep;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}

- (UIImage *)getImageFromURL: (NSString *)url {
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    return result;
}

-(void)updateComment{
    for (int i=0; i<self.comments.count; i++) {
        [self.commentIDs addObject:self.comments[i][@"id"]];
        [self.commentArray addObject:self.comments[i][@"commentDetail"]];
        [self.commentNames addObject:self.comments[i][@"username"]];
        [self.commentTimes addObject:[self timeStepChange: self.comments[i][@"commentTime"]]];
        NSString* imageURL;
        if ([self.comments[i][@"iconPath"]isEqual:[NSNull null]]) {
            imageURL = @"http://172.19.3.119:8080/";
        }
        else{
            imageURL = [@"http://172.19.3.119:8080/" stringByAppendingString:self.comments[i][@"iconPath"]];
        }
        NSLog(@"url, %@", imageURL);
        [self.headImages addObject:imageURL];
    }
}

@end
