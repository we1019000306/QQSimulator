//
//  QQFriend.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQFriend.h"
NSString *const kFriend_FriendId = @"id";
NSString *const kFriend_FriendNickname = @"nickname";
NSString *const kFriend_FriendIntro = @"intro";
NSString *const kFriend_FriendAvatarURL = @"avatar";
NSString *const kFriend_FriendFollowStatus = @"followStatus";
NSString *const KFriend_FriendCategoryName = @"categoryname";

@implementation QQFriend
@synthesize objectId = _objectId;
@synthesize nickname = _nickname;
@synthesize intro = _intro;
@synthesize avatarURL = _avatarURL;
@synthesize followStatus = _followStatus;
@synthesize categoryname = _categoryname;

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.objectId = [dict objectOrNilForKey:kFriend_FriendId];
        self.nickname = [dict objectOrNilForKey:kFriend_FriendNickname];
        self.intro = [dict objectOrNilForKey:kFriend_FriendIntro];
        self.avatarURL = [dict objectOrNilForKey:kFriend_FriendAvatarURL];
        self.followStatus = [dict objectOrNilForKey:kFriend_FriendFollowStatus];
        self.categoryname = [dict objectOrNilForKey:KFriend_FriendCategoryName];
    }
    return self;
}

#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.objectId = [aDecoder decodeObjectForKey:kFriend_FriendId];
    self.nickname = [aDecoder decodeObjectForKey:kFriend_FriendNickname];
    self.intro = [aDecoder decodeObjectForKey:kFriend_FriendIntro];
    self.avatarURL = [aDecoder decodeObjectForKey:kFriend_FriendAvatarURL];
    self.followStatus = [aDecoder decodeObjectForKey:kFriend_FriendFollowStatus];
    self.categoryname = [aDecoder decodeObjectForKey:KFriend_FriendCategoryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_objectId forKey:kFriend_FriendId];
    [aCoder encodeObject:_nickname forKey:kFriend_FriendNickname];
    [aCoder encodeObject:_intro forKey:kFriend_FriendIntro];
    [aCoder encodeObject:_avatarURL forKey:kFriend_FriendAvatarURL];
    [aCoder encodeObject:_followStatus forKey:kFriend_FriendFollowStatus];
    [aCoder encodeObject:_categoryname forKey:KFriend_FriendCategoryName];
}

- (id)copyWithZone:(NSZone *)zone {
    QQFriend *copy = [[QQFriend alloc] init];
    copy.objectId = [self.objectId copyWithZone:zone];
    copy.nickname = [self.nickname copyWithZone:zone];
    copy.intro = [self.intro copyWithZone:zone];
    copy.avatarURL = [self.avatarURL copyWithZone:zone];
    copy.followStatus = [self.followStatus copyWithZone:zone];
    copy.categoryname = [self.categoryname copyWithZone:zone];
    return copy;
}


@end