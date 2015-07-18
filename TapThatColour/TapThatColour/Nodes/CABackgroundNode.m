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
    SKAction *moveDown = [SKAction moveByX:0 y:-[CAUtilities screenSize].height duration:1.0];
    SKAction *moveSequence = [SKAction sequence:@[moveDown]];
    SKAction *moveForever = [SKAction repeatActionForever:moveSequence];
    
    [self runAction:moveForever];
}

// called in the scene's update method
- (void)updatePosition {
    if ([self getTop] <= 0)
        [self setPosition:[self getResetPosition]];
}

- (CGPoint)getResetPosition {
    return CGPointMake(self.position.x, [self.sibling getTop] + (self.frame.size.height / 2));
}

// returns the coordinate of the top of the node
- (NSInteger)getTop {
    return self.frame.origin.y + self.frame.size.height;
}

@end
