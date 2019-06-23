//
//  TokenManager.m
//  NewsDemo
//
//  Created by 彭伟林 on 2019/6/14.
//  Copyright © 2019 news. All rights reserved.
//

#import "InfoManager.h"

NSString *const USERNAME_KEY = @"username";
NSString *const IMAGE_KEY = @"image";


@implementation InfoManager

// 存储token
+(void)saveInfo:(NSString *)username image : (NSString *)image
{
    NSError *error = nil;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *usernameData = [NSKeyedArchiver archivedDataWithRootObject:username requiringSecureCoding:false error:&error];
    NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:image requiringSecureCoding:false error:&error];
    [userDefaults setObject:usernameData forKey:USERNAME_KEY];
    [userDefaults setObject:imageData forKey:IMAGE_KEY];
    [userDefaults synchronize];
}

// 读取username
+(NSString *)getUsername
{
    NSError *error;
    NSSet *codingClasses = [NSSet setWithArray:@[ [NSDictionary class],[NSArray class] ]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *usernameData = [userDefaults objectForKey:USERNAME_KEY];
    NSString *username = [NSKeyedUnarchiver unarchivedObjectOfClass:codingClasses.class fromData:usernameData error:&error];
    [userDefaults synchronize];
    return username;
}

+(NSString *)getImage
{
    NSError *error;
    NSSet *codingClasses = [NSSet setWithArray:@[ [NSDictionary class],[NSArray class] ]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDefaults objectForKey:IMAGE_KEY];
    NSString *image = [NSKeyedUnarchiver unarchivedObjectOfClass:codingClasses.class fromData:imageData error:&error];
    [userDefaults synchronize];
    return image;
}

// 清空token
+(void)cleanInfo
{
    NSUserDefaults *UserLoginState = [NSUserDefaults standardUserDefaults];
    [UserLoginState removeObjectForKey:USERNAME_KEY];
    [UserLoginState removeObjectForKey:IMAGE_KEY];
    [UserLoginState synchronize];
}


// 跟新token
+(NSString *)refreshToken
{
    return nil;
}
@end
