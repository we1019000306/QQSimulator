//
//  QQFriend.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModelBase.h"
@interface QQFriend : ModelBase<NSCopying,NSCoding>
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *intro;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) NSString *followStatus; //YES/online
@property (strong, nonatomic) NSString *categoryname;

@end
