//
//  CAGameCenterManager.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-28.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameCenterManager.h"
#import "CATapGame.h"
#import "CAAppDelegate.h"

@interface CAGameCenterManager ()

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) NSString *leaderboardId;

@end

@implementation CAGameCenterManager

- (CATapGame *)tapGame {
    return [(CAAppDelegate *)[[UIApplication sharedApplication] delegate] tapGame];
}

+ (id)sharedManager {
    static CAGameCenterManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    
    return sharedManager;
}

- (void)authenticateInViewController:(UIViewController *)aViewController {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak typeof(self) weakSelf = self;
    
    localPlayer.authenticateHandler =
        ^(UIViewController *authController, NSError *error) {
            if (error != nil)
                NSLog(@"Error authenticating player: %@", [error localizedDescription]);
            
            if (authController != nil)
                [aViewController presentViewController:authController animated:YES completion:nil];
            else
                weakSelf.isEnabled = [GKLocalPlayer localPlayer].authenticated;
        };
}

- (void)presentLeaderboardsInViewController:(UIViewController<GKGameCenterControllerDelegate> *)aViewController {
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = aViewController;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    
    [aViewController presentViewController:gcViewController animated:YES completion:nil];
}

- (void)reportScore:(NSInteger)aScore {
    if (!self.isEnabled)
        return;
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:[self tapGame].difficulty.leaderboardId];
    score.value = aScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil)
            NSLog(@"Error reporting score: %@", [error localizedDescription]);
    }];
}

@end
