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

@property CABackgroundNode *redBackgroundNode;
@property CABackgroundNode *blueBackgroundNode;

@property CATapGame *tapThatColor;

@end

#define kRedName @"redNode"
#define kBlueName @"blueNode"

@implementation CAGameScene

- (void)didMoveToView: (SKView *)view {
    if (!self.contentCreated) {
        self.screenHeight = [CAUtilities screenSize].height;
        self.contentCreated = YES;
        self.tapThatColor = [CATapGame withScore:0];
        [self createSceneContents];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleBackgroundAnimation];
    
    CAButtonNode *buttonTouched = [self buttonTouched:[touches anyObject]];
    if (buttonTouched) {
        [buttonTouched onTouch];
        [self.tapThatColor incScoreBy:1];
        [self.blueBackgroundNode incAnimationSpeedBy:0.01];
        [self.redBackgroundNode incAnimationSpeedBy:0.01];
    }
    
}

- (CAButtonNode *)buttonTouched:(UITouch *)aTouch {
    CAButtonNode *btn1 = [self.blueBackgroundNode buttonAtTouch:aTouch];
    CAButtonNode *btn2 = [self.redBackgroundNode buttonAtTouch:aTouch];
    return btn1 ? btn1 : btn2;
}

// called once per frame
- (void)update:(NSTimeInterval)currentTime {
    [self.redBackgroundNode update];
    [self.blueBackgroundNode update];
}

- (void)handleBackgroundAnimation {
    if (!self.animationBegan) {
        [self.redBackgroundNode startAnimating];
        [self.blueBackgroundNode startAnimating];
        self.animationBegan = YES;
    }
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.redBackgroundNode =
        [CABackgroundNode withName:kRedName color:[SKColor clearColor] yStartOffset:0];
    
    self.blueBackgroundNode =
        [CABackgroundNode withName:kBlueName color:[SKColor clearColor] yStartOffset:self.screenHeight];
    
    [self.redBackgroundNode setSibling:self.blueBackgroundNode];
    [self.blueBackgroundNode setSibling:self.redBackgroundNode];
    
    [self addChild:self.redBackgroundNode];
    [self addChild:self.blueBackgroundNode];
}

@end
