//
//  AppDelegate.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLAppDelegate.h"
#import "JSLExampleController.h"

@implementation JSLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    JSLExampleController *tableCtr = [[JSLExampleController alloc] init];
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:tableCtr];
    self.window.rootViewController = navCtr;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
