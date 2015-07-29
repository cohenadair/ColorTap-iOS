//
//  CAGameCenterManager.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-28.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//
//  A singleton that manages Game Center communications and initializations.
//

#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>

@interface CAGameCenterManager : NSObject

+ (id)sharedManager;

- (void)authenticateInViewController:(UIViewController *)aViewController;
- (void)presentLeaderboardsInViewController:(UIViewController<GKGameCenterControllerDelegate> *)aViewController;
- (void)reportScore:(NSInteger)aScore;

@end
