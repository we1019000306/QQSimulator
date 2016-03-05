//
//  QQMessageCell.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQMessageCell.h"
#import "QQMessage.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@implementation QQMessageCell

+ (QQMessageCell *)cellView{
    QQMessageCell *cellView = [[NSBundle mainBundle] loadNibNamed:@"QQMessageCell" owner:self options:nil].firstObject;
    cellView.badgeView = [[MKNumberBadgeView alloc]init];
    cellView.badgeView.value = 1;
    cellView.badgeView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cellView.badgeView.shadow = NO;
    [cellView addSubview:cellView.badgeView];
    cellView.badgeView.hidden = YES;
    [cellView.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellView.timeLabel.mas_bottom);
        make.right.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    cellView.avatarImgView.layer.cornerRadius = 30;
    cellView.avatarImgView.layer.masksToBounds = YES;
    return cellView;

}
- (void)setMessage:(QQMessage *)message{
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:message.avatarURL] placeholderImage:[UIImage imageNamed:@"icon_qq.png"] options:SDWebImageRetryFailed];
    self.timeLabel.text = message.time;
    self.nicknameLabel.text = message.nickname;
    self.messageLabel.text = message.message;
}
@end
