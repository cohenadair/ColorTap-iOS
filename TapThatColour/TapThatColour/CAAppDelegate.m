//
//  AppDelegate.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
