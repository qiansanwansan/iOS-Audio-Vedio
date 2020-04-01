//
//  AppDelegate.m
//  音视频学习
//
//  Created by macbook on 2020/3/31.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#import "AppDelegate.h"
#import "FYViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor lightGrayColor];
//        MyTabBarController *tabVC = [[MyTabBarController alloc]init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[FYViewController new]];
    return YES;
}




@end
