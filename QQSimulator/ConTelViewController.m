//
//  ConTelViewController.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/27.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ConTelViewController.h"
#import "QQCache.h"
#import "QQMessageCell.h"
#import "QQMessage.h"
#import "MJRefresh.h"
#import "DataCenter.h"
#import "Masonry.h"
@interface ConTelViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) UITableView *conversationTableView;
@property (nonatomic, strong) UITableView *TelTableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation ConTelViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@" 消 息 ",@" 电 话 "]];
    self.segmentControl.frame = CGRectMake(100, 10, 120, 30);
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.segmentControl;
    [self.segmentControl addTarget: self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self Refresh];
    [NotificationCenter addObserver:self selector:@selector(reloadConversationFromStart) name:Notify_Message_Refresh object:nil];
    [NotificationCenter addObserver:self selector:@selector(reloadConversationForNewCell) name:Notify_Message_InsertCellRefresh object:nil];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(addNewMessageToLocalDB) userInfo:nil repeats:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.segmentControl.selectedSegmentIndex){
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        default:
            return 1;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.segmentControl.selectedSegmentIndex){
        case 0:
        {
            return self.messageArray.count;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        default:
            return 1;
            break;
    }
}
//不同的tableview上添加不同的控件
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.conversationTableView]) {
        QQMessageCell *cell = [QQMessageCell cellView];
        cell.message = (QQMessage *)self.messageArray[indexPath.row];
        cell.badgeView.hidden = NO;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.tabBarItem.badgeValue = [NSString stringWithFormat: @"%ld", self.messageArray.count];
        
        return  cell;
    }else if ([tableView isEqual:self.TelTableView]){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"这是电话列表";
            cell.detailTextLabel.text = @"这是电话列表";
        }
            return  cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


//切换视图
- (void)segmentAction:(id)sender{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.TelTableView.hidden = YES;
            self.conversationTableView.hidden = NO;
            [self.conversationTableView reloadData];
            break;
        case 1:
            self.TelTableView.hidden = NO;
            self.conversationTableView.hidden = YES;
            [self.TelTableView reloadData];
            break;
        default:
            NSLog(@"segmentActionDefault");
            break;
    }
}

#pragma mark - 懒加载
- (UITableView *)conversationTableView{
    if (!_conversationTableView) {
        WS(ws);
        _conversationTableView = [[UITableView alloc]init];
        _conversationTableView.dataSource = self;
        _conversationTableView.delegate = self;
        [self.view addSubview: _conversationTableView];
        [_conversationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width, ws.view.bounds.size.height));
        }];

    }
    return _conversationTableView;
}

- (UITableView *)TelTableView{
    if (!_TelTableView) {
        WS(ws);
        _TelTableView = [[UITableView alloc]init];
        _TelTableView.dataSource = self;
        _TelTableView.delegate = self;
        [self.view addSubview: _TelTableView];
        [_TelTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width, ws.view.bounds.size.height));
        }];
    }
    return _TelTableView;
}

- (NSArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray arrayWithArray:[QQCache getHistoryMessage]];
    }
    return _messageArray;
}
//从数据库中取出之前已存入的10条数据并刷新表格，完成后移除相应观察者，并发送通知插入Cell
- (void)reloadConversationFromStart {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([QQCache getHistoryMessage].count<=10&&[QQCache getHistoryMessage].count>0) {
            self.messageArray = [NSMutableArray arrayWithArray:[QQCache getHistoryMessage]];
            [self.conversationTableView reloadData];
            if (self.messageArray.count == 10) {
                [NotificationCenter removeObserver:self name:Notify_Message_Refresh object:nil];
                [NotificationCenter postNotificationName:Notify_Message_InsertCellRefresh object:nil];
                
            }

        }
    });
}
//每10s插入一行cell并刷新表格
- (void)reloadConversationForNewCell{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([QQCache getHistoryMessage].count>10) {
            [self.messageArray insertObject:[[QQCache getHistoryMessage] lastObject] atIndex:0];
            [self.conversationTableView reloadData];

        }
    });
}
- (void)dealloc {
    [NotificationCenter removeObserver:self];
}
- (void)Refresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.conversationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws pullDownRefresh];
    }];
    // 马上进入刷新状态
    [self.conversationTableView.mj_header beginRefreshing];
}

- (void)pullDownRefresh{
    [self.conversationTableView reloadData];
    [self.conversationTableView.mj_header endRefreshing];
}
//一共132条数据
- (void)addNewMessageToLocalDB{
    if (self.messageArray.count<132 &&self.messageArray.count>0) {
        QQMessage *newMessage = [[QQMessage alloc]init];
        NSArray *QQFriendArray = [QQCache getFriend];
        QQFriend *friend = QQFriendArray[self.messageArray.count];
        newMessage.message = friend.intro;
        newMessage.nickname = friend.nickname;
        newMessage.avatarURL = friend.avatarURL;
        NSDate *now=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        NSString * nowString=[dateformatter stringFromDate:now];
        newMessage.time = nowString;
        [DataCenter addMessage:newMessage];
        [NotificationCenter postNotificationName:Notify_Message_InsertCellRefresh object:nil];
    }else return;
}
@end
