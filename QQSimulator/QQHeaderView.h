//
//  QQHeaderView.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QQCategory;
@class QQHeaderView;
@protocol QQHeaderViewDelegate <NSObject>

- (void)headerViewButtonDidClick:(QQHeaderView *)headerView;

@end
@interface QQHeaderView : UITableViewHeaderFooterView
//返回一个headerView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) QQCategory *category;

//headerView的代理属性
@property (weak, nonatomic) id<QQHeaderViewDelegate> delegate;
@end
