//
//  AppDelegate.m
//  QQSimulator
//
//  Created by Jackie Liu on 16/2/26.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[RootViewController alloc]init];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
