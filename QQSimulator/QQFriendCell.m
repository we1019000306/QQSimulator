//
//  QQFriendCell.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQFriendCell.h"
#import "UIImageView+WebCache.h"
#import "QQFriend.h"
@implementation QQFriendCell
+ (QQFriendCell *)cellView{
    QQFriendCell *cellView = [[NSBundle mainBundle] loadNibNamed:@"QQFriendCell" owner:self options:nil].firstObject;
    cellView.avatarImgView.layer.cornerRadius = 30;
    cellView.avatarImgView.layer.masksToBounds = YES;
    return cellView;
}
- (void)setFriends:(QQFriend *)friends{
    _friends = friends;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:friends.avatarURL] placeholderImage:[UIImage imageNamed:@"icon_qq.png"] options:SDWebImageRetryFailed];
    self.nicknameLabel.text = friends.nickname;
    self.introLabel.text = friends.intro;
}
@end
