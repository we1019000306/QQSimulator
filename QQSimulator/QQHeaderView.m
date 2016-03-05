//
//  QQHeaderView.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQHeaderView.h"
#import "QQCategory.h"
@interface QQHeaderView ()
@property (weak, nonatomic) UIButton *btn;//headerView按钮
@property (weak, nonatomic) UILabel *lbl;//在线人数

@end

@implementation QQHeaderView

//返回一个headerView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *headerID = @"header";
    
    QQHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    if (headerView == nil) {
        headerView = [[QQHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}

//重写initWithReuseIdentifier:方法创建自定义headerView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIButton *btn = [[UIButton alloc] init];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [btn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeCenter;
        btn.imageView.clipsToBounds = NO;
        [self addSubview:btn];
        self.btn = btn;
        [self.btn addTarget:self action:@selector(headerViewButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:lbl];
        self.lbl = lbl;
        
    }
    return self;
}

//按钮单击事件
- (void)headerViewButtonDidClick {
    
    self.category.display = !self.category.isDisplay;
    
    if ([self.delegate respondsToSelector:@selector(headerViewButtonDidClick:)]) {
        [self.delegate headerViewButtonDidClick:self];
    }
}

//当一个新的headerView已经添加到某个父控件中的时候调用这个方法
- (void)didMoveToSuperview {
    if (self.category.isDisplay) {
        self.btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.btn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

//重写set方法为headerView赋值
- (void)setCategory:(QQCategory *)category{
    
    _category = category;
    
    //设置组名
    [self.btn setTitle:category.categoryname forState:UIControlStateNormal];
    
    //设置在线人数
    self.lbl.text = [NSString stringWithFormat:@"%d / %lu",category.online,(unsigned long)category.friendArray.count];
 
}

//当将这个控件真正添加到父控件的时候，会调用这个方法设置当前控件的所有子控件的frame
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.lbl.frame = CGRectMake(self.frame.size.width-80, 0, 60.0f, 44.0f);
}

@end