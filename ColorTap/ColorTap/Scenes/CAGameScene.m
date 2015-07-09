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

@property NSInteger screenHeight;

@end

#define kTileName @"tileNode"

@implementation CAGameScene

- (void)didMoveToView: (SKView *)view {
    if (!self.contentCreated) {
        self.screenHeight = [CAUtilities screenSize].height;
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {
    [self startAnimation];
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self addChild: [self newTileNode]];
}

- (SKSpriteNode *)newTileNode {
    SKSpriteNode *tile = [SKSpriteNode spriteNodeWithColor:[SKColor redColor]
                                                           size:CGSizeMake(50, 50)];

    CGFloat startY = [CAUtilities screenSize].height + 50;
    tile.name = kTileName;
    tile.position = CGPointMake(CGRectGetMidX(self.frame), startY);
    
    return tile;
}

- (void)startAnimation {
    SKNode __block *tileBoard = [self childNodeWithName:kTileName];
    NSInteger __block screenHeight = self.screenHeight;
    
    SKAction *completionBlock = [SKAction runBlock:^(void) {
        [tileBoard setPosition:CGPointMake(tileBoard.position.x, screenHeight)];
    }];
    
    SKAction *moveDown = [SKAction moveByX:0 y:-screenHeight - 25 duration:2.0];
    SKAction *moveSequence = [SKAction sequence:@[moveDown, completionBlock]];
    SKAction *moveForever = [SKAction repeatActionForever:moveSequence];
    
    [tileBoard runAction:moveForever];
}

@end
