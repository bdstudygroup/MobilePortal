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
#import "InfoManager.h"
#import "ImageSelectManager.h"

@interface MyController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate>
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *myBtn;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) UIAlertController *actionSheet;

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
    userList = @[@"设置",@"收藏栏", @"上传头像"];
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
    return 3;
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
    } else if (indexPath.section == 1) {
        cell.imageView.image = [UIImage imageNamed:@"collect"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"share"];
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
    else if(indexPath.section == 1){
        CollectController* vc = [[CollectController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self callActionSheetFunc];
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
        _myBtn.layer.masksToBounds=YES;
        [_myBtn.layer setCornerRadius:32.5];
        [_myBtn setContentMode:UIViewContentModeScaleAspectFill];
        [_myBtn setClipsToBounds:YES];
        _myBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _myBtn.layer.shadowOffset = CGSizeMake(4, 4);
        _myBtn.layer.shadowOpacity = 0.5;
        _myBtn.layer.shadowRadius = 2.0;
        _myBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        _myBtn.layer.borderWidth = 2.0f;
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
    NSLog(@"%@",dict);
    _myBtn.layer.cornerRadius = _myBtn.frame.size.width / 2;
    _myBtn.clipsToBounds = YES;
    if([dict[@"type"] isEqualToString:@"update"]) {
        self.label.text = @"注册/登陆";
        self.isLogin = false;
    } else {
        self.label.text = dict[@"username"];
        self.isLogin = true;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImage *)getImageFromURL: (NSString *)url {
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    return result;
}

//call when click headImage
- (void)callActionSheetFunc{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请选择图片来源" preferredStyle:0];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"要打开相册了");
        //select from photoLibrary
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
    //show when device support(select from camera)
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //sourceType = UIImagePickerControllerSourceTypeCamera;
            NSLog(@"打开相机");
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }];
        [alertController addAction:camera];
    }
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:^{
        NSLog(@"弹出了");
    }];
}

//choose image, backcall
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //UIImage *image = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    self.image = image;
    self.image = [self scaleToSize:CGSizeMake(100, 100) width:image.size.width height:image.size.height];
    [_myBtn setBackgroundImage:self.image forState:UIControlStateNormal];
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size width:(CGFloat)currentWidth height:(CGFloat)currentHeight
{
    
    CGFloat widthRadio = size.width*1.0/currentWidth;
    CGFloat heightRadio = size.height*1.0/currentHeight;
    
    float radio = 1;
    if(widthRadio>1 && heightRadio>1)
    {
        radio = widthRadio > heightRadio ? widthRadio : heightRadio;
    }
    else
    {
        radio = widthRadio < heightRadio ? widthRadio : heightRadio;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    [self.image drawInRect:CGRectMake(0, 0, currentWidth*radio, currentHeight*radio)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void) checkCookie {
    //通过remeberMe拉取用户信息
     NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
     for (NSHTTPCookie *cookie in [cookieJar cookies]) {
         // NSLog(@"%@", cookie.name);
         if([cookie.domain isEqualToString:@"172.19.31.26"] && [cookie.name isEqualToString:@"rememberMe"]) {
             NSLog(@"getInfo");
             NSString *remeberMe = cookie.value;
             //请求用户信息
             NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.31.26:8080/getUserInfo" parameters:nil error:nil];
             [formRequest addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
             [formRequest addValue:remeberMe forHTTPHeaderField:@"rememberMe"];
             AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
             AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
             [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
             manager.responseSerializer= responseSerializer;
             NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
                 if(error) {
                     NSLog(@"Error: %@", error);
                     [InfoManager cleanInfo];
                     return;
                 }
                 NSInteger code = [responseObject[@"code"] integerValue];
                 if(code == 200) {
                     [self showAlertMessage:@"获取成功！"];
                     NSLog(@"%@", responseObject);
                     NSString *url = responseObject[@"image"];
                     UIImage *image = [self getImageFromURL:url];
                     [InfoManager saveInfo:responseObject[@"username"] image:image];
                     //set UI
                     [self.myBtn setBackgroundImage:[UIImage imageNamed:@"login_portrait_ph"] forState:UIControlStateNormal];
                     self.label.text = responseObject[@"username"];
                     self.isLogin = true;
                 } else {
                     [self showAlertMessage:@"获取失败！"];
                     [InfoManager cleanInfo];
                     self.isLogin = false;
                 }
             }];
             [dataTask resume];
        } else {
            self.isLogin = false;
            [self.myBtn setBackgroundImage:[UIImage imageNamed:@"login_portrait_ph"] forState:UIControlStateNormal];
            self.label.text = @"登陆/注册";
            [InfoManager cleanInfo];
        }
    }
}

@end
