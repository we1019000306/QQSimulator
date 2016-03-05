//
//  ContactListTableViewController.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/26.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "QQFriend.h"
#import "QQCategory.h"
#import "QQCache.h"
#import "DataCenter.h"
#import "QQFriendCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "QQHeaderView.h"
#import "MJRefresh.h"
@interface ContactListTableViewController ()<UITableViewDataSource,UITableViewDelegate,QQHeaderViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) NSArray *friend;
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) UITableView *contactTableView;
@property (strong, nonatomic) UISearchBar *search;

@end

@implementation ContactListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self search];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    self.contactTableView.sectionHeaderHeight = 50;
    [self Refresh];
    
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - TableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.category.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QQCategory *qqcategory = self.category[section];
    if (qqcategory.isDisplay) {
        return qqcategory.friendArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QQCategory *category = self.category[indexPath.section];
    QQFriend *friend = category.friendArray[indexPath.row];
    QQFriendCell *cell = [QQFriendCell cellView];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.friends = friend;
    return cell;
}
//创建headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    QQCategory *category = self.category[section];
    
    QQHeaderView *headerView = [QQHeaderView headerViewWithTableView:tableView];
    
    //存储组
    headerView.tag = section;
    
    //指定控制器为代理
    headerView.delegate = self;
    
    headerView.category = category;
    
    return headerView;
    
}
//点击headerView按钮的时候触发
- (void)headerViewButtonDidClick:(QQHeaderView *)headerView {
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:headerView.tag];
    
    //刷新指定组
    [self.contactTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - 懒加载
- (UITableView *)contactTableView{
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height-40)];
        _contactTableView.userInteractionEnabled = YES;
        _contactTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_contactTableView];
    }
    return _contactTableView;
}

- (UISearchBar *)search{
    if (!_search) {
        _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
        _search.delegate = self;
        _search.barStyle = UIBarStyleDefault;
        _search.keyboardType = UIKeyboardTypeDefault;
        _search.placeholder = @"搜索";
        [self.view addSubview:_search];
    }
    return _search;
}


- (NSArray *)category{
    if (_category == nil) {
        _category = [QQCategory category];
    }
        return _category;
}

/**
 *  下拉刷新
 */
- (void)Refresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.contactTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws pullDownRefresh];
    }];
    // 马上进入刷新状态
    [self.contactTableView.mj_header beginRefreshing];
}

- (void)pullDownRefresh{
    [self.contactTableView reloadData];
    [self.contactTableView.mj_header endRefreshing];

}
@end
