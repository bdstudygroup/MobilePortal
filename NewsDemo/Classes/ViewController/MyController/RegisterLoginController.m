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

@interface RegisterLoginController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSString *username;
    NSString *password;
    NSInteger currentState;
    CGFloat width;
    CGFloat height;
}
//image for user,
@property(nonatomic, strong) UIImageView *headImageView;
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
//alert a table to choose your headImage
@property (strong, nonatomic) UIAlertController *actionSheet;



@end

@implementation RegisterLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [BarItem addBackItemToVC:self];
    self->currentState = 0;
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
    self->width = [[UIScreen mainScreen] bounds].size.width;
    self->height = [[UIScreen mainScreen] bounds].size.height;
    
    //your headImage and add a gesture to the ImageView
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self->width/2 - 50, 0.2*self->height, 100, 100)];
    [self.headImageView setImage:[UIImage imageNamed:@"login_portrait_ph"]];
    [self.headImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callActionSheetFunc)];
    [self.headImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.headImageView];
    self.headImageView.hidden = YES;
    [self.headImageView.layer setCornerRadius:(self.headImageView.frame.size.height/2)];
    [self.headImageView.layer setMasksToBounds:YES];
    [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headImageView setClipsToBounds:YES];
    self.headImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headImageView.layer.shadowOffset = CGSizeMake(4, 4);
    self.headImageView.layer.shadowOpacity = 0.5;
    self.headImageView.layer.shadowRadius = 2.0;
    self.headImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.headImageView.layer.borderWidth = 2.0f;
    
    //the filed to enter your your name
    self.usernameFiled = [[UITextField alloc]initWithFrame:CGRectMake(self->width/8, 0.2*self->height + 130, 3*self->width/4, 30)];
    self.usernameFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.usernameFiled setPlaceholder:@"用户名"];
    [self.view addSubview:self.usernameFiled];
    
    //the filed to enter your password
    self.passwordFiled = [[UITextField alloc]initWithFrame:CGRectMake(self->width/8, 0.2*self->height + 170, 3*self->width/4, 30)];
    self.passwordFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordFiled setPlaceholder:@"密码"];
    self.passwordFiled.secureTextEntry = YES;
    [self.view addSubview:self.passwordFiled];
    
    //when register, confirm password again
    self.confirmPasswordFiled = [[UITextField alloc]initWithFrame:CGRectMake(self->width/8, 0.2*self->height + 210, 3*self->width/4, 30)];
    self.confirmPasswordFiled .borderStyle = UITextBorderStyleRoundedRect;
    [self.confirmPasswordFiled  setPlaceholder:@"再次输入密码"];
    self.confirmPasswordFiled.secureTextEntry = YES;
    self.confirmPasswordFiled.hidden = YES;
    [self.view addSubview:self.confirmPasswordFiled ];
    
    //change current state, login in or register
    self.changeCurrentState = [[UIButton alloc]init];
    [self.changeCurrentState setTitle:@"注册" forState:UIControlStateNormal];
    self.changeCurrentState.frame = CGRectMake(7*self->width/8 - 40, 0.2*self->height + 250, 40, 30);
    [self.changeCurrentState setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.changeCurrentState];
    
    
    self.confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self->width/8, 0.2*self->height + 210, 3*self->width/4, 30)];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.confirmButton];
    
    [self.changeCurrentState addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
}
//function to change state and change UI
- (void)changeState {
    
    if(self->currentState == 0) {
        self->currentState = 1;
        [self.changeCurrentState setTitle:@"登陆" forState:UIControlStateNormal];
        self.headImageView.hidden = NO;
        self.confirmPasswordFiled.hidden = NO;
        self.confirmPasswordTip.hidden = NO;
        self.headImageView.userInteractionEnabled = YES;
        self.confirmButton.frame = CGRectMake(self->width/8, 0.2*self->height + 250, 3*self->width/4, 40);
        self.changeCurrentState.frame = CGRectMake(7*self->width/8 - 40, 0.2*self->height + 290, 40, 30);
    } else {
        self->currentState = 0;
        [self.changeCurrentState setTitle:@"注册" forState:UIControlStateNormal];
        self.headImageView.hidden = YES;
        self.confirmPasswordFiled.hidden = YES;
        self.confirmPasswordTip.hidden = YES;
        [self.confirmPasswordFiled setText:@""];
        self.confirmButton.frame = CGRectMake(self->width/8, 0.2*self->height + 210, 3*self->width/4, 40);
        self.changeCurrentState.frame = CGRectMake(7*self->width/8 - 40, 0.2*self->height + 250, 40, 30);
    }
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
    NSLog(@"%f", image.size.width);
    NSLog(@"%f", image.size.height);
    self.headImageView.image = image;
    self.headImageView.image = [self scaleToSize:CGSizeMake(100, 100) width:image.size.width height:image.size.height];
    NSLog(@"%f", self.headImageView.image.size.width);
    NSLog(@"%f", self.headImageView.image.size.height);}

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
    
    [self.headImageView.image drawInRect:CGRectMake(0, 0, currentWidth*radio, currentHeight*radio)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
