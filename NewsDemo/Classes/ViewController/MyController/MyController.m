//
//  MyController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "MyController.h"
#import "SetController.h"
#import "CollectController.h"
#import "RegisterLoginController.h"

@interface MyController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *myBtn;

@end

@implementation MyController{
    NSArray* userList;
}

- (instancetype)init {
    if (self = [super init]) {
        [self headView];
        [self tableView];
    }
    return self;
}

+ (UINavigationController *)defaultMyNavi {
    MyController *vc = [MyController new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(244, 244, 244);
    userList = @[@"设置",@"收藏栏"];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:@"userInfo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%ld", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = kTitleFont;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"me_setting"];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"collect"];
    }
    cell.textLabel.text = userList[indexPath.section];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SetController *vc = [SetController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        CollectController* vc = [[CollectController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 懒加载
- (UIView *)headView {
    if(_headView == nil) {
        _headView = [[UIView alloc] init];
        UIImageView *imgView = [UIImageView new];
        imgView.image = [UIImage imageNamed:@"tableViewBackgroundImage"];
        [_headView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setBtn setBackgroundImage:[UIImage imageNamed:@"me_setting"]forState:UIControlStateNormal];
        [_headView addSubview:setBtn];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        [setBtn bk_addEventHandler:^(id sender) {
            SetController *vc = [SetController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        
        _myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myBtn setBackgroundImage:[UIImage imageNamed:@"login_portrait_ph"] forState:UIControlStateNormal];
        [_headView addSubview:_myBtn];
        [_myBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        [_myBtn addTarget:self action:@selector(jumpToLogin) forControlEvents:UIControlEventTouchUpInside];
        
        self.label = [UILabel new];
        self.label.text = @"注册/登陆";
        self.label.font = kSubtitleFont;
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.myBtn);
            make.width.mas_equalTo(65);
            make.top.mas_equalTo(self.myBtn.mas_bottom).mas_equalTo(5);
        }];
        
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kWindowH/3);
        }];
    }
    return _headView;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
        }];
    }
    return _tableView;
}

/*
- (void)toLoginOrRegister{
    [self.headView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLogin)];
    [self.headView addGestureRecognizer:tapGesture];
}
*/

- (void)jumpToLogin{
    SingletonUser *singleton = [SingletonUser sharedInstance];
    NSLog(@"%@", singleton.username);
    if(singleton.tag) {
        [self showAlertMessage:@"你已经登陆!"];
    } else {
        RegisterLoginController *controller = [[RegisterLoginController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) showAlertMessage:(NSString *) myMessage{
    //创建提示框指针
    UIAlertController *alertMessage;
    //用参数myMessage初始化提示框
    alertMessage = [UIAlertController alertControllerWithTitle:@"提示" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    //添加按钮
    [alertMessage addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    
    //display the message on screen  显示在屏幕上
    [self presentViewController:alertMessage animated:YES completion:nil];
    
}


//收到通知的时候调用这个方法接受到通知消息
- (void)getInfo:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSLog(@"%@",dict[@"username"]);
    self.label.text = dict[@"username"];
    _myBtn.layer.cornerRadius = _myBtn.frame.size.width /2;
    _myBtn.clipsToBounds = YES;
    [_myBtn setBackgroundImage:dict[@"headImage"] forState:UIControlStateNormal];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
