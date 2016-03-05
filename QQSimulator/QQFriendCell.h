//
//  QQFriendCell.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QQFriend;
@interface QQFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (nonatomic, strong) QQFriend *friends;
+ (QQFriendCell *)cellView;

@end
