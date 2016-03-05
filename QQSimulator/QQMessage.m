//
//  QQMessage.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/1.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQMessage.h"
NSString *const kMessage_MessageNickname = @"nickname";
NSString *const kMessage_MEssageAvatarURL = @"avatar";
NSString *const kMessage_MessageMessage = @"message";
NSString *const kMessage_MessageTime = @"time";

@implementation QQMessage
@synthesize nickname = _nickname;
@synthesize avatarURL = _avatarURL;
@synthesize message = _message;
@synthesize time = _time;

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.nickname = [dict objectOrNilForKey:kMessage_MessageNickname];
        self.avatarURL = [dict objectOrNilForKey:kMessage_MEssageAvatarURL];
        self.message = [dict objectOrNilForKey:kMessage_MessageMessage];
        self.time = [dict objectOrNilForKey:kMessage_MessageTime];

    }
    return self;
}

#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.nickname = [aDecoder decodeObjectForKey:kMessage_MessageNickname];
    self.avatarURL = [aDecoder decodeObjectForKey:kMessage_MEssageAvatarURL];
    self.message = [aDecoder decodeObjectForKey:kMessage_MessageMessage];
    self.time = [aDecoder decodeObjectForKey:kMessage_MessageTime];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_nickname forKey:kMessage_MessageNickname];
    [aCoder encodeObject:_avatarURL forKey:kMessage_MEssageAvatarURL];
    [aCoder encodeObject:_message forKey:kMessage_MessageMessage];
    [aCoder encodeObject:_time forKey:kMessage_MessageTime];

}

- (id)copyWithZone:(NSZone *)zone {
    QQMessage *copy = [[QQMessage alloc] init];
    copy.nickname = [self.nickname copyWithZone:zone];
    copy.avatarURL = [self.avatarURL copyWithZone:zone];
    copy.message = [self.message copyWithZone:zone];
    copy.time = [self.time copyWithZone:zone];
    return copy;
}


@end
