//
//  CAGameScene.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameScene.h"

@interface CAGameScene()

@property BOOL contentCreated;
@property BOOL animationBegan;

@property NSInteger screenHeight;
@property NSInteger startY;

@property CABackgroundNode *redBackgroundNode;
@property CABackgroundNode *blueBackgroundNode;

@end

#define kRedName @"redNode"
#define kBlueName @"blueNode"

@implementation CAGameScene

- (void)didMoveToView: (SKView *)view {
    if (!self.contentCreated) {
        self.screenHeight = [CAUtilities screenSize].height;
        self.contentCreated = YES;
        [self createSceneContents];
    }
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {
    if (!self.animationBegan) {
        [self.redBackgroundNode startAnimatingWithInitialFactor:1];
        [self.blueBackgroundNode startAnimatingWithInitialFactor:2];
        self.animationBegan = YES;
    }
}

- (void)update:(NSTimeInterval)currentTime {
    [self.redBackgroundNode updatePosition];
    [self.blueBackgroundNode updatePosition];
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.redBackgroundNode =
        [CABackgroundNode withName:kRedName color:[SKColor redColor] yStartOffset:0];
    
    self.blueBackgroundNode =
        [CABackgroundNode withName:kBlueName color:[SKColor blueColor] yStartOffset:self.screenHeight];
    
    [self addChild:self.redBackgroundNode];
    [self addChild:self.blueBackgroundNode];
}

@end
