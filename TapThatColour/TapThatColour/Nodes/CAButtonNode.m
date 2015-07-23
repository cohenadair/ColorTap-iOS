//
//  CAButtonNode.m
//  TapThatColor
//
//  Created by Cohen Adair on 2015-07-18.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAButtonNode.h"

@interface CAButtonNode ()

@property CGFloat radius;
@property BOOL shouldResetPath;

@property SKAction *correctSound;
@property SKAction *incorrectSound;

@end

@implementation CAButtonNode

#pragma mark - Initializing

+ (id)withColor:(CAColor *)aColor radius:(CGFloat)aRadius {
    return [[self alloc] initWithColor:aColor radius: aRadius];
}

- (id)initWithColor:(CAColor *)aColor radius:(CGFloat)aRadius {
    if (self = [super init]) {
        self.radius = aRadius;
        self.path = [CAUtilities pathForRadius:self.radius];
        self.color = aColor;
        self.fillColor = aColor.color;
        self.strokeColor = [SKColor clearColor];
        self.shouldResetPath = NO;
        self.wasTapped = NO;
        
        // preload the sound to remove lag
        self.correctSound = [SKAction playSoundFileNamed:@"correct.wav" waitForCompletion:YES];
        self.incorrectSound = [SKAction playSoundFileNamed:@"incorrect.wav" waitForCompletion:YES];
    }
    
    return self;
}

#pragma mark - Touching

- (void)onCorrectTouch {
    if (self.wasTapped)
        return;
    
    [self shrink];
    [self setShouldResetPath:YES];
    [self setWasTapped:YES];
}

- (void)onIncorrectTouch {
    id __block blockSelf = self;
    CGFloat __block zPos = self.zPosition;
    
    [self setZPosition:5000];
    
    SKAction *grow = [SKAction scaleBy:1.25 duration:0.25];
    SKAction *shrink = [SKAction scaleBy:0.8 duration:0.25];
    SKAction *sequence = [SKAction sequence:@[grow, shrink]];
    SKAction *repeat = [SKAction repeatAction:sequence count:2];
    SKAction *group = [SKAction group:@[repeat, self.incorrectSound]];
    
    [self runAction:group completion:^() {
        [blockSelf setZPosition:zPos];
    }];
}

#pragma mark - Animating

- (void)shrink {
    SKAction *shrink = [SKAction scaleBy:0.25 duration:0.25];
    SKAction *group = [SKAction group:@[shrink, self.correctSound]];
    
    [self runAction:group];
}

- (void)grow {
    [self runAction:[SKAction scaleBy:4 duration:0]];
}

- (void)reset {
    self.color = [CAUtilities randomColor];
    self.fillColor = self.color.color;
    
    if (self.shouldResetPath) {
        [self grow];
        [self setShouldResetPath:NO];
    }
    
    self.wasTapped = NO;
}

@end
