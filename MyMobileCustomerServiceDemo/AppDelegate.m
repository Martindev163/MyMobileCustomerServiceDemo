//
//  AppDelegate.m
//  MyMobileCustomerServiceDemo
//
//  Created by 马浩哲 on 16/11/1.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //registerSDKWithAppKey: 注册的AppKey，详细见下面注释。
    //apnsCertName: 推送证书名（不需要加后缀），详细见下面注释。
    EMError *error = [[EaseMob sharedInstance] registerSDKWithAppKey:@"1117161031178448#kefuchannelapp30054" apnsCertName:@"kefuchannelapp30054"];
    if (!error) {
        NSLog(@"初始化成功");
    }
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:@"8001" password:@"111111" withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
        }
        else
        {
            NSLog(@"%@",error.description);
        }
    } onQueue:nil];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"8001" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
        }
        else
        {
            NSLog(@"%@",error.description);
        }
    } onQueue:nil];
    
    ViewController *rootVC = [[ViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}


// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}


/*!
 @method
 @brief 将要发起自动重连操作时发送该回调
 @discussion
 @result
 */
- (void)willAutoReconnect
{
    
}

/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error);
    }
}


@end
