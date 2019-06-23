//
//  RegisterLoginController.m
//  NewsDemo
//
//  Created by student5 on 2019/5/18.
//  Copyright © 2019 news. All rights reserved.
//

#import "RegisterLoginController.h"
#import "RegisterController.h"
#import "MyController.h"
#import "InfoManager.h"

@interface RegisterLoginController ()<UINavigationControllerDelegate, NSURLSessionDelegate>
//username
@property(nonatomic, strong) UITextField *usernameFiled;
//password
@property(nonatomic, strong) UITextField *passwordFiled;
//confirm password
@property(nonatomic, strong) UILabel *confirmPasswordTip;
@property(nonatomic, strong) UITextField *confirmPasswordFiled;
//change current state, login or register
@property(nonatomic, strong) UIButton *changeCurrentState;
//confirm the info
@property(nonatomic, strong) UIButton *confirmButton;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, assign) NSInteger currentState;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@end

@implementation RegisterLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SingletonUser *singleton = [SingletonUser sharedInstance];
    NSLog(@"%@", singleton.username);
    
    
    self.navigationController.navigationBar.hidden = NO;
    [BarItem addBackItemToVC:self];
    self.currentState = 0;
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
    self.width = [[UIScreen mainScreen] bounds].size.width;
    self.height = [[UIScreen mainScreen] bounds].size.height;
    
    //the filed to enter your your name
    self.usernameFiled = [[UITextField alloc]initWithFrame:CGRectMake(self.width/8, 0.1*self.height + 130, 3*self.width/4, 30)];
    self.usernameFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.usernameFiled setPlaceholder:@"用户名"];
    [self.view addSubview:self.usernameFiled];
    
    //the filed to enter your password
    self.passwordFiled = [[UITextField alloc]initWithFrame:CGRectMake(self.width/8, 0.1*self.height + 170, 3*self.width/4, 30)];
    self.passwordFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordFiled setPlaceholder:@"密码"];
    self.passwordFiled.secureTextEntry = YES;
    [self.view addSubview:self.passwordFiled];
    
    //when register, confirm password again
    self.confirmPasswordFiled = [[UITextField alloc]initWithFrame:CGRectMake(self.width/8, 0.1*self.height + 210, 3*self.width/4, 30)];
    self.confirmPasswordFiled .borderStyle = UITextBorderStyleRoundedRect;
    [self.confirmPasswordFiled  setPlaceholder:@"再次输入密码"];
    self.confirmPasswordFiled.secureTextEntry = YES;
    self.confirmPasswordFiled.hidden = YES;
    [self.view addSubview:self.confirmPasswordFiled ];
    
    //change current state, login in or register
    self.changeCurrentState = [[UIButton alloc]init];
    [self.changeCurrentState setTitle:@"注册" forState:UIControlStateNormal];
    self.changeCurrentState.titleLabel.font = [UIFont systemFontOfSize:12];
    self.changeCurrentState.frame = CGRectMake(7*self.width/8 - 40, 0.1*self.height + 250, 40, 30);
    [self.changeCurrentState setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.changeCurrentState];
    
    self.confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width/8, 0.1*self.height + 210, 3*self.width/4, 30)];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton addTarget:self action:@selector(validUser) forControlEvents:UIControlEventTouchUpInside];
    
    [self.changeCurrentState addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
}
//function to change state and change UI
- (void)changeState {
    
    if(self.currentState == 0) {
        self.currentState = 1;
        [self.changeCurrentState setTitle:@"已有账号？登陆" forState:UIControlStateNormal];
        self.confirmPasswordFiled.hidden = NO;
        self.confirmPasswordTip.hidden = NO;
        self.confirmButton.frame = CGRectMake(self.width/8, 0.1*self.height + 250, 3*self.width/4, 40);
        self.changeCurrentState.frame = CGRectMake(7*self.width/8 - 100, 0.1*self.height + 290, 100, 30);
    } else {
        self.currentState = 0;
        [self.changeCurrentState setTitle:@"注册" forState:UIControlStateNormal];
        self.confirmPasswordFiled.hidden = YES;
        self.confirmPasswordTip.hidden = YES;
        [self.confirmPasswordFiled setText:@""];
        self.confirmButton.frame = CGRectMake(self.width/8, 0.1*self.height + 210, 3*self.width/4, 40);
        self.changeCurrentState.frame = CGRectMake(7*self.width/8 - 40, 0.1*self.height + 250, 40, 30);
    }
}

//call when click headImage
- (void)callActionSheetFunc{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请选择图片来源" preferredStyle:0];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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

- (void)validUser {
    //获取输入框内容
    NSString *username = self.usernameFiled.text;
    NSString *password = self.passwordFiled.text;
    NSString *confirmPassword = self.confirmPasswordFiled.text;
    if(self.currentState == 0) { //登陆
        if([username isEqualToString:@""] || [password isEqualToString:@""]) {
            [self showAlertMessage:@"字段不能为空"];
        } else {
            NSDictionary *userDic = @{@"username" : username, @"password" : password, @"remember" : @"on"};
            NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.31.26:8080/login" parameters:userDic error:nil];
            [formRequest setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
            AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
            AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
            [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
            manager.responseSerializer= responseSerializer;
            NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
                if(error) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                NSInteger code = [responseObject[@"code"] integerValue];
                if(code == 200) {
                    [InfoManager saveInfo:@"username" image: @"aa"];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfo" object:self userInfo:@{@"type": @"login", @"username": username}];
                } else {
                    [self showAlertMessage:@"登陆失败！"];
                }
                
            }];
            
            [dataTask resume];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfo" object:self userInfo:@{@"type": @"login", @"username": username}];
        }
    } else { //注册
        if([self validateUserName:username] && [self validatePassword:password]) {
            if(![password isEqualToString:confirmPassword]) {
                [self showAlertMessage:@"密码不对应"];
                return;
            }
            NSDictionary *userDic = @{@"username" : username, @"password" : password};
            NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.31.26:8080/regist" parameters:userDic error:nil];
            [formRequest setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
            AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
            AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
            [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
            manager.responseSerializer= responseSerializer;
            NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
                if(error) {
                    NSLog(@"Error: %@", error);
                    return;
                }
                NSInteger code = [responseObject[@"code"] integerValue];
                if(code == 200) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self showAlertMessage:@"注册成功，请登录！"];
                    self.currentState = 0;
                    [self.changeCurrentState setTitle:@"注册" forState:UIControlStateNormal];
                    self.confirmPasswordFiled.hidden = YES;
                    self.confirmPasswordTip.hidden = YES;
                    [self.confirmPasswordFiled setText:@""];
                    self.confirmButton.frame = CGRectMake(self.width/8, 0.1*self.height + 210, 3*self.width/4, 40);
                    self.changeCurrentState.frame = CGRectMake(7*self.width/8 - 40, 0.1*self.height + 250, 40, 30);
                } else {
                    [self showAlertMessage:@"注册失败！"];
                }
                
            }];
            [dataTask resume];
        } else {
            [self showAlertMessage:@"用户名和密码至少是6位长度的字母和数字串！"];
        }
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

//图片->字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.6f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串->图片
-(UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr
{
    NSData  *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

- (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

- (BOOL) validatePassword:(NSString *)password
{
    NSString *passwordRegex = @"^[A-Za-z0-9_]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    BOOL B = [userNamePredicate evaluateWithObject:password];
    return B;
}

@end
