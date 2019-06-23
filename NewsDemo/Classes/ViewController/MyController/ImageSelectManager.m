//
//  ImageSelectManager.m
//  NewsDemo
//
//  Created by 彭伟林 on 2019/6/22.
//  Copyright © 2019 news. All rights reserved.
//

#import "ImageSelectManager.h"
#import "MyController.h"

@interface ImageSelectManager ()<UIImagePickerControllerDelegate>
//alert a table to choose your headImage
@property (strong, nonatomic) UIAlertController *actionSheet;
@property (strong, nonatomic) UIImage *image;

@end


@implementation ImageSelectManager

//call when click headImage
- (void)callActionSheetFunc:(MyController *) controller{
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
        
        [controller presentViewController:imagePickerController animated:YES completion:^{
            
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
            
            [controller presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }];
        [alertController addAction:camera];
    }
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [controller presentViewController:alertController animated:YES completion:^{
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
    // NSLog(@"%f", image.size.width);
    // NSLog(@"%f", image.size.height);
    self.image = image;
    self.image = [self scaleToSize:CGSizeMake(100, 100) width:image.size.width height:image.size.height];
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

- (UIImage *)getImage {
    return self.image;
}

@end
