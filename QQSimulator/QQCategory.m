//
//  QQCategory.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQCategory.h"
#import "QQFriend.h"
#import "QQCache.h"
NSString *const KCategory_CategoryName = @"categoryName";

@implementation QQCategory

@synthesize categoryname = _categoryname;

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
      
        self.categoryname = [dict objectOrNilForKey:KCategory_CategoryName];
    }
    return self;
}

#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
        self.categoryname = [aDecoder decodeObjectForKey:KCategory_CategoryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
       [aCoder encodeObject:_categoryname forKey:KCategory_CategoryName];
}

- (id)copyWithZone:(NSZone *)zone {
    QQFriend *copy = [[QQFriend alloc] init];
    copy.categoryname = [self.categoryname copyWithZone:zone];
    return copy;
}
#pragma mark - 从数据库取出数据并初始化
- (instancetype)initWithQQCache {
    if (self = [super init]) {
        if ([QQCache getCategory].count>0) {
            if ([QQCache getFriendWithCategory:self.categoryname]) {
                self.friendArray = [QQCache getFriendWithCategory:self.categoryname];
            }

        }
    }
    return self;
}

+ (instancetype)categoryFromQQCache {
    return [[self alloc] initWithQQCache];
}

//返回组模型数组
+ (NSArray *)category {
    NSMutableArray *arrayM = [NSMutableArray array];
    if ([QQCache getCategory].count>0) {
        for (NSInteger i=0; i<[QQCache getCategory].count; i++) {
            QQCategory *QQcategory = [[QQCache getCategory] objectAtIndex:i];
            QQcategory.friendArray = [QQCache getFriendWithCategory:QQcategory.categoryname];
            [arrayM addObject:QQcategory];
        }
    }
    return arrayM;
}


@end