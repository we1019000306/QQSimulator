//
//  DataCenter.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQFriend.h"
#import "QQMessage.h"
@interface DataCenter : NSObject
+ (void)addFriend:(QQFriend *)obj;
+ (void)addMessage:(QQMessage *)obj;
@end
