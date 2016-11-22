//
//  ChatViewController.m
//  MyMobileCustomerServiceDemo
//
//  Created by 马浩哲 on 16/11/2.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "ChatViewController.h"
#import "MJRefresh.h"
#import "IMessageModel.h"
#import "CustomEvaluateTabCell.h"
#import "SatisfactionViewController.h"

//#import "Emoji.h"

@interface ChatViewController ()<CustomEvaluateTabCellDelegate>

@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"客服";
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];//设置头像大小
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];//设置头像圆角
    
    self.showRefreshHeader = YES;
    self.showTableBlankView =YES;
    
    self.delegate = self;
    self.dataSource = self;
    

    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:2];
    [self.chatBarMoreView removeItematIndex:2];
    [self.chatBarMoreView removeItematIndex:2];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    EaseEmotionManager * manager = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:8 emotions:[EaseEmoji allEmoji]];
    [self.faceView setEmotionManagers:@[manager]];
    
    //刷新消息
    [self tableViewDidTriggerHeaderRefresh];
}


//具体样例：
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if ([message.from isEqualToString:@"8001"]) {
        //用户可以根据自己的用户体系，根据message设置用户昵称和头像
        model.avatarImage = [UIImage imageNamed:@"CGUnwrapRed_1"];//默认头像
        model.avatarURLPath = @"http://img15.3lian.com/2015/h1/280/d/10.jpg";//头像网络地址
        model.nickname = @"昵称";//用户昵称
    }
    else
    {
        model.avatarImage = [UIImage imageNamed:@"GroupCopy"];//默认头像
        model.nickname = @"安心客服";//用户昵称
    }
    
    return model;
}


//长按收拾回调样例：
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    //样例给出的逻辑是所有cell都允许长按
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    //样例给出的逻辑是长按cell之后显示menu视图
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

//获取用户点击头像回调的样例：
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    //UserProfileViewController用户自定义的个人信息视图
    //样例的逻辑是选中消息头像后，进入该消息发送者的个人信息
//    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:messageModel.message.from];
//    [self.navigationController pushViewController:userprofile animated:YES];
    NSLog(@"选中头像");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*!
 @method
 @brief 将要接收离线消息的回调
 @discussion
 @result
 */
- (void)willReceiveOfflineMessages
{
    
}

/*!
 @method
 @brief 接收到离线非透传消息的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    for (EMMessage *message in offlineMessages) {
        NSLog(@"%@",message.messageId);
    }
}

/*!
 @method
 @brief 离线非透传消息接收完成的回调
 @discussion
 @param offlineMessages 接收到的离线列表
 @result
 */
- (void)didFinishedReceiveOfflineMessages
{
    
}


/*!
 @method
 @brief 接收到离线透传消息的回调
 @discussion
 @param offlineCmdMessages 接收到的离线透传消息列表
 @result
 */
- (void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{
    
}

/*!
 @method
 @brief 离线透传消息接收完成的回调
 @discussion
 @param offlineCmdMessages 接收到的离线透传消息列表
 @result
 */
- (void)didFinishedReceiveOfflineCmdMessages
{
    
}


/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时，会触发此回调
 针对有附件的消息，此时附件还未被下载。
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:，
 下载完所有附件后，回调didMessageAttachmentsStatusChanged:error:会被触发
 */
//- (void)didReceiveMessage:(EMMessage *)message
//{
//    //在后台时调用这个
//}



/*!
 @method
 @brief 收到消息时的回调
 @param cmdMessage      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时，会触发此回调
 */
- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage
{
    
}

/*!
 @method
 @brief 未读消息数改变时的回调
 @discussion 当EMConversation对象的enableUnreadMessagesCountEvent为YES时，会触发此回调
 @result
 */
- (void)didUnreadMessagesCountChanged
{
//    [self tableViewDidTriggerHeaderRefresh];
}

-(UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    
    if ([self isSatisfactionMessage:messageModel.message]) {
        
        static NSString *cellId = @"myCellId";
        CustomEvaluateTabCell *Mycell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (Mycell == nil) {
            Mycell = [[CustomEvaluateTabCell alloc] initWithStyle:UITableViewCellFocusStyleDefault reuseIdentifier:cellId];
        }
        Mycell.delegate = self;
        Mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Mycell;
        
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
//        cell.textLabel.text = @"立即评价";
//        return cell;
    }
    else
    {
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:messageModel];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:messageModel];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = messageModel;
        
        return sendCell;
    }
    
    
}

- (BOOL)isSatisfactionMessage:(EMMessage*)message
{
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [login isEqualToString:message.from] ? YES : NO;
    if ([message.ext objectForKey:kMesssageExtWeChat] && !isSender) {
        NSDictionary *dic = [message.ext objectForKey:kMesssageExtWeChat];
        if ([dic objectForKey:kMesssageExtWeChat_ctrlType] &&
            [dic objectForKey:kMesssageExtWeChat_ctrlType] != [NSNull null] &&
            [[dic objectForKey:kMesssageExtWeChat_ctrlType] isEqualToString:kMesssageExtWeChat_ctrlType_inviteEnquiry]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 评价代理方法
-(void)ImmediateEvaluationAction
{
    NSLog(@"立即评价");
    
    SatisfactionViewController *vc = [[SatisfactionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
