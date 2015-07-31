//
//  AppDelegate.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CAAppDelegate.h"
#import "CAGameCenterManager.h"
#import "CAMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[CAGameCenterManager sharedManager] authenticateInViewController:self.window.rootViewController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[self mainViewController] applicationWillEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[self mainViewController] applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[self mainViewController] applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (CAMainViewController *)mainViewController {
    return (CAMainViewController *)[(UINavigationController *)self.window.rootViewController topViewController];
}

@end
