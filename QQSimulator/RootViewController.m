//
//  ViewController.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/26.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//
#define MYTabBarItemTitileColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "RootViewController.h"
#import "ContactListTableViewController.h"
#import "ConTelViewController.h"
#import "QQCache.h"
#import "DataCenter.h"
#import "MBProgressHUD.h"
@interface RootViewController ()<MBProgressHUDDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [QQCache openDB];
    ConTelViewController *contelVC = [[ConTelViewController alloc]init];
    [self addChildVC:contelVC title:@"消息" image:@"home1_tab_1@3x" selectedImage:@"home1_tab_12@3x"];
    ContactListTableViewController *contactTVC = [[ContactListTableViewController alloc]init];
    [self addChildVC:contactTVC title:@"联系人" image:@"home2_tab_2@3x" selectedImage:@"home2_tab_22@3x"];
    [self jsonParseToLocalDB];
    [NotificationCenter addObserver:self selector:@selector(addMessageHistoryToLocalDB) name:Notify_Contact_Save object:nil];
}


//快速初始化主界面属性
- (void)addChildVC:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    childVc.title = title;
    childVc.view.backgroundColor = [UIColor whiteColor];
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage =[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MYTabBarItemTitileColor(102, 102, 102);
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] =  MYTabBarItemTitileColor(76, 162, 247);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:childVc];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    [nvc.navigationBar setTitleTextAttributes:dict];
    [[UINavigationBar appearance] setBarTintColor:MYTabBarItemTitileColor(76, 162, 247)];
    [self addChildViewController:nvc];

}

//同步网站数据至数据库
- (void)jsonParseToLocalDB{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate = self;
        hud.color = [UIColor blackColor];//这儿表示无背景
        hud.labelText = @"数据加载中，请稍后!!!";
        hud.detailsLabelText = @"loading...";
        hud.dimBackground = YES;
        [self.view addSubview:hud];
        [hud show:YES];
        
        NSURL *url = [NSURL URLWithString:@"http://f.wallstcn.com/news.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                for (NSInteger i = 0; i<5 ;i++) {
                    NSDictionary *contentdict = array[i];
                    NSDictionary *categorydict = [contentdict objectForKey:@"category"];
                    QQCategory *category = [[QQCategory alloc]initWithDictionary:categorydict];
                    NSArray *authors = [contentdict objectForKey:@"authors"];
                    for (NSInteger m = 0; m < authors.count; m++) {
                        QQFriend *friend = [[QQFriend alloc]initWithDictionary:authors[m]];
                        friend.categoryname = category.categoryname;
                        NSString *uniqueId = [NSString stringWithFormat:@"%ld%ld",(long)i,(long)m];
                        friend.objectId = uniqueId;
                        [DataCenter addFriend:friend];
                    }
                }
                [hud hide:YES];
                
            } else {
                [hud hide:YES];
                WS(ws);
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:str_Error_Web message:str_Error_WebAlert preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"error!!!!!!!!!!");
                        [ws jsonParseToLocalDB];
                    }];
                    [errorAlert addAction:ok];
                    [self presentViewController:errorAlert animated:YES completion:nil];
                });
            }
            
        }];
        [dataTask resume];
    });
    
}

//初始化10条模拟消息至数据库
- (void)addMessageHistoryToLocalDB{
    if ([QQCache getFriend].count>10) {
        for (NSInteger i = 0; i < 10; i++) {
            QQFriend *friend = [[QQCache getFriend] objectAtIndex:i];
            QQMessage *message = [[QQMessage alloc]init];
            message.nickname = friend.nickname;
            message.avatarURL = friend.avatarURL;
            NSDate *now=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            NSString * nowString=[dateformatter stringFromDate:now];
            NSLog(@"%@",nowString);
            message.time = nowString;
            message.message = friend.intro;
            [DataCenter addMessage:message];
        }
        [NotificationCenter removeObserver:self name:Notify_Contact_Save object:nil];
    }else return;
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}
@end
