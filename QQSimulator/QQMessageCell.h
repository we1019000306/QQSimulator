//
//  QQMessageCell.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"
@class QQMessage;
@interface QQMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) MKNumberBadgeView *badgeView;
+ (QQMessageCell *)cellView;
@property (nonatomic, strong) QQMessage *message;
@end
