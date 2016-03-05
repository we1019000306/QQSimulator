//
//  QQCache.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQFriend.h"
#import "QQMessage.h"
#import "QQCategory.h"
@interface QQCache : NSObject
+ (void)openDB;
+ (void)storeFriends:(QQFriend *)friends;
+ (void)storeHistotyMessage:(QQMessage *)messages;
+ (NSArray *)getFriend;
+ (NSArray *)getFriendWithCategory:(NSString *)category;
+ (NSArray *)getCategory;
+ (NSArray *)getHistoryMessage;
@end
