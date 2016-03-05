//
//  QQMessage.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ModelBase.h"

@interface QQMessage : ModelBase<NSCopying,NSCoding>

@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *time;

@end
