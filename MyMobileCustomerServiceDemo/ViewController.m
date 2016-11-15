//
//  ViewController.m
//  MyMobileCustomerServiceDemo
//
//  Created by 马浩哲 on 16/11/1.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"
#import "EaseMob.h"
#define kDeviceWidth [[UIScreen mainScreen] bounds].size.width
#define kDeviceHeight [[UIScreen mainScreen] bounds].size.height
static const CGFloat kDefaultPlaySoundInterval = 3.0;
@interface ViewController ()<IChatManagerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *messageField;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"标记" forState:UIControlStateNormal];
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rigtItem];
    
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
    
    [self registerNotifications];
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self _showNotificationWithMessage:message];
    }else {
        [self _playSoundAndVibration];
    }
#endif
}

#pragma mark - private chat

- (void)_playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)_showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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
    
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    [self.navigationController pushViewController:chatVC animated:YES];
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


#pragma mark - 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
        [self setupUnreadMessageCount];
}
#pragma mark - 离线非透传消息接收完成的回调
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
        [self setupUnreadMessageCount];
}

#pragma mark - 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (unreadCount > 0) {
        [_rightBtn setTitle:[NSString stringWithFormat:@"%i",unreadCount] forState:UIControlStateNormal];
    }
    else
    {
        [_rightBtn setTitle:[NSString stringWithFormat:@"标记",unreadCount] forState:UIControlStateNormal];
    }
    
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
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
