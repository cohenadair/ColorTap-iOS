//
//  CAGameScene.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAMainViewController.h"
#import "CAScoreboardNode.h"
#import "CABackgroundNode.h"

@interface CAGameScene : SKScene

@property (nonatomic) CAMainViewController *viewController;
@property (nonatomic) CAScoreboardNode *scoreboardNode;
@property (nonatomic) BOOL autoStart; // used when users tap the "replay" button
@property (nonatomic, copy) void (^onGameStart)();
@property (nonatomic) BOOL isGameOver; // used to prevent unwanted update: calls
@property (nonatomic) BOOL animationBegan;

@end
