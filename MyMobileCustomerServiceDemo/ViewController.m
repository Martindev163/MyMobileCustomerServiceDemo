//
//  ViewController.m
//  MyMobileCustomerServiceDemo
//
//  Created by 马浩哲 on 16/11/1.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

#define kDeviceWidth [[UIScreen mainScreen] bounds].size.width
#define kDeviceHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<IChatManagerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *messageField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-150)/2.0, 100, 150, 40)];
    registerBtn.backgroundColor = [UIColor redColor];
    [registerBtn setTitle:@"注    册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(userRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-150)/2.0, 210, 150, 40)];
    loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn setTitle:@"登    陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(userLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-150)/2.0, 270, 150, 40)];
    loginOutBtn.backgroundColor = [UIColor redColor];
    [loginOutBtn setTitle:@"登    出" forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(userLoginOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutBtn];
    
    //设置信息输入框
    _messageField = [[UITextField alloc] initWithFrame:CGRectMake(10, 320, kDeviceWidth - 20, 40)];
    _messageField.delegate = self;
    _messageField.layer.borderColor = [UIColor blueColor].CGColor;
    _messageField.layer.borderWidth = 1;
    _messageField.layer.masksToBounds = YES;
    [self.view addSubview:_messageField];
    
    UIButton *sendMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-150)/2.0, 370, 150, 40)];
    sendMessageBtn.backgroundColor = [UIColor redColor];
    [sendMessageBtn setTitle:@"发    送" forState:UIControlStateNormal];
    [sendMessageBtn addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendMessageBtn];
    
    
    UIButton *turnToServiceBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-150)/2.0, 420, 150, 40)];
    turnToServiceBtn.backgroundColor = [UIColor redColor];
    [turnToServiceBtn setTitle:@"找客服去" forState:UIControlStateNormal];
    [turnToServiceBtn addTarget:self action:@selector(turnToServiceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:turnToServiceBtn];
    
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)dealloc
{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 注册
-(void)userRegisterAction
{
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:@"8001" password:@"111111" withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
        }
        else
        {
            NSLog(@"%@",error.description);
        }
    } onQueue:nil];

}
#pragma mark - 登录
-(void)userLoginAction
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"8001" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
        }
        else
        {
            NSLog(@"%@",error.description);
        }
    } onQueue:nil];
}
#pragma mark - 登出
-(void)userLoginOutAction
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES/NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
            // 退出，传入YES，会解除device token绑定，不再收到群消息；传NO，不解除device token
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
        }
        else
        {
            NSLog(@"%@",error.description);
        }
    } onQueue:nil];
}

#pragma mark - 跳转到客服页面
-(void)turnToServiceAction
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:@"kefuchannelimid_414792" conversationType:eConversationTypeChat];
    
    [self presentViewController:chatVC animated:YES completion:nil];
}

#pragma mark - 发送信息
-(void)sendMessageAction
{
    EMChatText *txtChat = [[EMChatText alloc] initWithText:_messageField.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:@"kefuchannelimid_414792" bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    
    
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager sendMessage:message progress:nil error:&error];
    if (error) {
        NSLog(@"----%@",error.description);
    }
}

/*!
 @method
 @brief 用户注销后的回调
 @discussion
 @param error        错误信息
 @result
 */
- (void)didLogoffWithError:(EMError *)error
{
    if (!error) {
        NSLog(@"注销成功");
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
    }
}

/*!
 @method
 @brief 当前登录账号在其它设备登录时的通知回调
 @discussion
 @result
 */
- (void)didLoginFromOtherDevice
{
    NSLog(@"在其他设备登录");
}

#pragma mark - 在线接收信息
//-(void)didReceiveMessage:(EMMessage *)message
//{
//    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
//    switch (msgBody.messageBodyType) {
//        case eMessageBodyType_Text:
//        {
//            //接收到文字消息
//            NSString *txt = ((EMTextMessageBody *)msgBody).text;
//            NSLog(@"接收到的文字是：%@",txt);
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
@end
