//
//  CABackgroundNode.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CABackgroundNode.h"

@interface CABackgroundNode ()

@property BOOL doneFirstAnimation;
@property NSInteger animationStart;
@property NSInteger animationHeight;
@property NSInteger animationDuration;

@end

@implementation CABackgroundNode

+ (id)withName:(NSString *)aName color:(UIColor *)aColor yStartOffset:(NSInteger)anOffset {
    return [[self alloc] initWithName:aName color:aColor yStartOffset:anOffset];
}

- (id)initWithName:(NSString *)aName color:(UIColor *)aColor yStartOffset:(NSInteger)anOffset {
    if (self = [super initWithColor:aColor size:[CAUtilities screenSize]]) {
        [self setName:aName];
        [self setAnimationStart:[CAUtilities screenSize].height + ([CAUtilities screenSize].height / 2)];
        [self setPosition:CGPointMake(CGRectGetMidX([CAUtilities screenBounds]), self.animationStart + anOffset)];
        [self setDoneFirstAnimation:NO];
    }
    
    return self;
}

// aFactor: The animation height for the first animation is multipled by this.
- (void)startAnimatingWithInitialFactor:(NSInteger)aFactor {
    CABackgroundNode *node = self;
    
    // calculate the animation duration based velocity/distance
    NSInteger animationSpeed = 250;
    NSInteger animationHeight = -([CAUtilities screenSize].height * 2);
    
    self.animationHeight = animationHeight * aFactor;
    self.animationDuration = labs(self.animationHeight / animationSpeed);
    
    SKAction *moveDown = [SKAction moveByX:0 y:self.animationHeight duration:self.animationDuration];
    SKAction *moveSequence = [SKAction sequence:@[moveDown]];
    SKAction *moveForever = [SKAction repeatActionForever:moveSequence];
    
    [node runAction:moveForever];
}

// called in the scene's update method
- (void)updatePosition {
    // if top of frame is less than zero, reset to start position
    if (self.frame.origin.y + self.frame.size.height <= 0)
        [self setPosition:CGPointMake(self.position.x, self.animationStart)];
}

@end
