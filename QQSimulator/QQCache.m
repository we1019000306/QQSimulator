//
//  QQCache.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "QQCache.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#define FMDBQuickCheck(SomeBool, Title, Db) {\
if (!(SomeBool)) { \
NSLog(@"Failure on line %d, %@ error(%d): %@", __LINE__, Title, [Db lastErrorCode], [Db lastErrorMessage]);\
}}


NSString * dbFilePath(NSString * filename) {
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString * documentDirectory = [documentPaths objectAtIndex:0];
    NSString * pathName = [documentDirectory stringByAppendingPathComponent:@"cache"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathName])
        [fileManager createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
    
    pathName = [pathName stringByAppendingPathComponent:filename];
    
    return pathName;
};

NSData * encodePwd(NSString * pwd) {
    
    NSData * data = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
};

NSString * decodePwd(NSData * data) {
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
};


@implementation QQCache
static FMDatabase * __db;
static NSString *__currentPath;
static NSString *__currentPlistPath;
static NSString *__offlineMsgPlistPath;
static NSMutableDictionary * __contactsOnlineState;
+ (void)initialize {
    
    NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
    
}

#pragma mark -重置当前用户本地数据库链接
+ (void)resetCurrentLogin {
    
    [__db close];
    __db = nil;
    
    if (__currentPath) {
        __currentPath = nil;
    }
    
    if (__currentPlistPath) {
        __currentPlistPath = nil;
    }
    
    if (__offlineMsgPlistPath) {
        __offlineMsgPlistPath = nil;
    }
}


#pragma mark -打开当前用户本地数据库链接
+ (void)openDB{
    
    [QQCache resetCurrentLogin];
    
   
    
    NSString * fileName = dbFilePath(@"data.sqlite");
    
    __currentPath = [fileName copy];
    __db = [FMDatabase databaseWithPath:fileName];
    
    if (![__db open]) {
        NSLog(@"Could not open db:%@", fileName);
        
        return;
    }
    
    [__db setShouldCacheStatements:YES];
 

    // 好友列表
    if (![__db tableExists:str_TableName_Contact]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT,nickname TEXT,intro TEXT, avatarURL TEXT, followStatus TEXT, categoryname TEXT)", str_TableName_Contact];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);
        
        
    }
    // 消息列表
    if (![__db tableExists:str_TableName_Message]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (nickname TEXT, avatarURL TEXT, message TEXT, time TEXT)", str_TableName_Message];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);
        
    }
    
}

+ (void)storeFriends:(QQFriend *)friends{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return ;
            }
        }
        if (!friends.objectId) {
            friends.objectId = @"";
        }
        if (!friends.nickname) {
            friends.nickname = @"";
        }
        if (!friends.intro) {
            friends.intro = @"";
        }
        
        if (!friends.avatarURL) {
            friends.avatarURL = @"0";
        }
        if (!friends.followStatus) {
            friends.followStatus = @"NO";
        }
        if (!friends.categoryname) {
            friends.categoryname = @"";
        }
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id=?", str_TableName_Contact];
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[friends.objectId]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET nickname=?,intro=?, avatarURL=?, followStatus=?, categoryname=? WHERE id=?", str_TableName_Contact];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[friends.nickname,friends.intro,friends.avatarURL,friends.followStatus,friends.categoryname,friends.objectId]];
            
            FMDBQuickCheck(b, sqlString, __db);
            NSLog(@"更新已有记录");
            
        } else {
            
            sqlString = [NSString stringWithFormat:@"INSERT INTO %@(id, nickname, intro, avatarURL,followStatus,categoryname) values(?, ?, ?, ?, ?, ?)", str_TableName_Contact];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[friends.objectId,friends.nickname,friends.intro,friends.avatarURL,friends.followStatus,friends.categoryname]];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Contact_Save object:nil];
    }

    
}


+(void)storeHistotyMessage:(QQMessage *)messages{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return ;
            }
        }
        if (!messages.nickname) {
            messages.nickname = @"";
        }
        if (!messages.avatarURL) {
            messages.avatarURL = @"";
        }
        if (!messages.message) {
            messages.message = @"";
        }
        if (!messages.time) {
            messages.time = @"00:00";
        }
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@", str_TableName_Message];
        FMResultSet *rs = [__db executeQuery:sqlString];
        [rs close];
        sqlString = [NSString stringWithFormat:@"INSERT INTO %@(nickname, avatarURL, message, time) values(?, ?, ?, ?)", str_TableName_Message];
            
        BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[messages.nickname,messages.avatarURL,messages.message,messages.time]];
            
        FMDBQuickCheck(b, sqlString, __db);
        
        [NotificationCenter postNotificationName:Notify_Message_Refresh object:nil];

    }
    
    
}



+ (NSArray *)getFriend{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil;
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        
    
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@" , str_TableName_Contact];
        
        FMResultSet *rs = [__db executeQuery:sqlString];
        while ([rs next]) {
            QQFriend *friend = [[QQFriend alloc] init];
            friend.objectId = [rs stringForColumn:@"id"];
            friend.nickname = [rs stringForColumn:@"nickname"];
            friend.intro= [rs stringForColumn:@"intro"];
            friend.avatarURL = [rs stringForColumn:@"avatarURL"];
            friend.followStatus = [rs stringForColumn:@"followStatus"];
            friend.categoryname = [rs stringForColumn:@"categoryname"];
            [array addObject:friend];
        }
        [rs close];
        return array;
        
    }
}

+ (NSArray *)getFriendWithCategory:(NSString *)category {
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil;
            }
        }
        NSMutableArray *array = [NSMutableArray array];

        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT id, nickname, intro, avatarURL, followStatus, categoryname FROM %@ WHERE categoryname=?" , str_TableName_Contact];
        
        FMResultSet *rs = [__db executeQuery:sqlString withArgumentsInArray:@[category]];
        while ([rs next]) {
            QQFriend *friend = [[QQFriend alloc] init];
            friend.objectId = [rs stringForColumn:@"id"];
            friend.nickname = [rs stringForColumn:@"nickname"];
            friend.intro= [rs stringForColumn:@"intro"];
            friend.avatarURL = [rs stringForColumn:@"avatarURL"];
            friend.followStatus = [rs stringForColumn:@"followStatus"];
            friend.categoryname = [rs stringForColumn:@"categoryname"];
            [array addObject:friend];
        }
        [rs close];
        
        return array;
    }
}

+ (NSArray *)getCategory{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil;
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT DISTINCT categoryname FROM %@", str_TableName_Contact];
        
        FMResultSet *rs = [__db executeQuery:sqlString];
        while ([rs next]) {
            QQCategory *category = [[QQCategory alloc] init];
            category.categoryname = [rs stringForColumn:@"categoryname"];
            [array addObject:category];
        }
        [rs close];
        return array;
    }
}

+ (NSArray *)getHistoryMessage{
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil;
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@" , str_TableName_Message];
        
        FMResultSet *rs = [__db executeQuery:sqlString];
        while ([rs next]) {
            QQMessage *message = [[QQMessage alloc] init];
            message.nickname = [rs stringForColumn:@"nickname"];
            message.avatarURL = [rs stringForColumn:@"avatarURL"];
            message.message = [rs stringForColumn:@"message"];
            message.time = [rs stringForColumn:@"time"];
            [array addObject:message];
        }
        [rs close];
        return array;
        
    }
}



@end
