//
//  QQCategory.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/29.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ModelBase.h"

@interface QQCategory : ModelBase
@property (strong, nonatomic) NSString *categoryname;
@property (strong, nonatomic) NSArray *friendArray;
@property (assign, nonatomic) int online;
//是否陈列出好友列表，默认不陈列
@property (assign, nonatomic, getter=isDisplay) BOOL display;
+ (instancetype)categoryFromQQCache;
+ (NSArray *)category;
@end
