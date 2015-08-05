//
//  AppDelegate.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>
#import "CAAppDelegate.h"
#import "CAMainViewController.h"
#import "CATexture.h"

@interface CAAppDelegate ()

@end

@implementation CAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self setTapGame:[CATapGame withScore:0]];
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

- (void)onOrientationChange {
    [[CATexture sharedTexture] resetWithRadius:[CAUtilities buttonRadius]];
}

@end
