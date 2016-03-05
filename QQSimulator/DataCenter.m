//
//  DataCenter.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "DataCenter.h"
#import "QQFriend.h"
#import "SDWebImage/SDWebImageDownloader.h"
#import "QQCache.h"
@implementation DataCenter

+ (void)addFriend:(QQFriend *)obj {
    QQFriend *friend = [[QQFriend alloc]init];
    friend.objectId = obj.objectId;
    friend.nickname = obj.nickname;
    friend.intro = obj.intro;
    friend.followStatus = obj.followStatus;
    friend.categoryname = obj.categoryname;
    friend.avatarURL = obj.avatarURL;
    [QQCache storeFriends:friend];
}

+ (void)addMessage:(QQMessage *)obj {
    QQMessage *message = [[QQMessage alloc]init];
    message.nickname = obj.nickname;
    message.message = obj.message;
    message.time = obj.time;
    message.avatarURL= obj.avatarURL;
    [QQCache storeHistotyMessage:message];
}


@end
