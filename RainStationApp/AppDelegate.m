//
//  AppDelegate.m
//  RainStationApp
//
//  Created by vp on 2017/4/27.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "AppDelegate.h"
#import "ExceptionLabel.h"
#import "NetWorkManager.h"
@interface AppDelegate ()
{

    ExceptionLabel *exceptionLabel;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    exceptionLabel = [[ExceptionLabel alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exceptionMessage:) name:@"exceptionMessage" object:nil];
    [[NetWorkManager sharedInstance] checkAppVersionNeedUpdate];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)exceptionMessage:(NSNotification *)notification
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        
        NSDictionary *dic=[notification userInfo];
        NSException * me = [dic valueForKey:@"message"];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showExceptionLable:me.reason];
            });
 

        
    });
    
    
    
}
-(void)showExceptionLable:(NSString*)reason
{
    
    [self.window addSubview:exceptionLabel];
    
    NSLog(@"收到了!!!!!!!!!!!!!!!!!!!!!-*");
    
    [exceptionLabel showExceptionLableWithException:reason];
    
    
}

@end
