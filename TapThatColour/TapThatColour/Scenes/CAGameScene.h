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
#import "CATapGame.h"

@interface CAGameScene : SKScene

@property (nonatomic) CAMainViewController *viewController;
@property (nonatomic) CAScoreboardNode *scoreboardNode;
@property (nonatomic) BOOL autoStart;
@property (nonatomic, copy) void (^onGameStart)();

- (NSInteger)score;
- (void)togglePaused;

@end
