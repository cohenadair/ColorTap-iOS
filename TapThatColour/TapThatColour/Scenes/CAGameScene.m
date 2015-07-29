//
//  CAGameScene.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameScene.h"

@interface CAGameScene()

@property (nonatomic) BOOL contentCreated;
@property (nonatomic) BOOL animationBegan;

@property (nonatomic) CABackgroundNode *redBackgroundNode;
@property (nonatomic) CABackgroundNode *blueBackgroundNode;

@property (nonatomic) CATapGame *tapThatColor;

@end

#define kRedName @"redNode"
#define kBlueName @"blueNode"

@implementation CAGameScene

#pragma mark - View Initializing

- (void)didMoveToView: (SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
        self.tapThatColor = [CATapGame withScore:0];
    }
    
    if (self.autoStart)
        [self handleBackgroundAnimation];
}

#pragma mark - Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleBackgroundAnimation];
    
    // so touches on the scoreboard don't register
    if ([self touchInScoreboard:[touches anyObject]])
        return;
    
    CAButtonNode *buttonTouched = [self buttonTouched:[touches anyObject]];
    if (buttonTouched) {
        // check for correct color touch
        if ([buttonTouched.color isEqualToColor:self.tapThatColor.currentColor]) {
            if (!buttonTouched.wasTapped) {
                [self handleCorrectTouch];
                [buttonTouched onCorrectTouch];
            }
        } else {
            [self handleGameOver];
            [self.tapThatColor updateHighscore];
            
            id __block blockSelf = self;
            [buttonTouched onIncorrectTouchWithCompletion:^() {
                [[blockSelf viewController] performSegueWithIdentifier:@"fromMainToGameOver" sender:self];
            }];
        }
    }
    
}

- (BOOL)touchInScoreboard:(UITouch *)aTouch {
    CGRect f = self.scoreboardNode.frame;
    
    // need to "reverse" the y-coordinate because the scoreboard node's position starts at the bottom left of the screen rather than the top left
    f.origin.y = [CAUtilities screenSize].height - (f.origin.y + f.size.height);

    return CGRectContainsPoint(f, [aTouch locationInView:self.view]);
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

- (void)handleGameOver {
    [self setUserInteractionEnabled:NO];
    [self stopBackgroundAnimation];
}

- (void)handleCorrectTouch {
    [self.tapThatColor incScoreBy:1];
    [self.scoreboardNode updateScoreLabel:self.tapThatColor.score];
    [self.blueBackgroundNode incAnimationSpeedBy:0.01];
    [self.redBackgroundNode incAnimationSpeedBy:0.01];
}

- (void)stopBackgroundAnimation {
    [self.redBackgroundNode stopAnimating];
    [self.blueBackgroundNode stopAnimating];
}

- (void)createSceneContents {
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    // backgrounds
    self.redBackgroundNode =
        [CABackgroundNode withName:kRedName color:[SKColor clearColor] yStartOffset:0];
    
    self.blueBackgroundNode =
        [CABackgroundNode withName:kBlueName color:[SKColor clearColor] yStartOffset:[CAUtilities screenSize].height];
    
    [self.redBackgroundNode setSibling:self.blueBackgroundNode];
    [self.blueBackgroundNode setSibling:self.redBackgroundNode];
    
    [self addChild:self.redBackgroundNode];
    [self addChild:self.blueBackgroundNode];
    
    // scoreboard
    [self setScoreboardNode:[CAScoreboardNode withScore:0 color:[CAColor blueColor]]];
    [self addChild:self.scoreboardNode];
}

- (NSInteger)score {
    return self.tapThatColor.score;
}

@end
