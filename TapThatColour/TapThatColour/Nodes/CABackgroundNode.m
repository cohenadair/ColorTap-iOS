//
//  CABackgroundNode.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CABackgroundNode.h"

@interface CABackgroundNode ()

@property (nonatomic) BOOL doneFirstAnimation;
@property (nonatomic) NSInteger animationStart;
@property (nonatomic) NSInteger animationHeight;

@end

#define kMaxSpeed 4.0

@implementation CABackgroundNode

#pragma mark - Initializing

+ (id)withName:(NSString *)aName color:(SKColor *)aColor yStartOffset:(NSInteger)anOffset {
    return [[self alloc] initWithName:aName color:aColor yStartOffset:anOffset];
}

- (id)initWithName:(NSString *)aName color:(SKColor *)aColor yStartOffset:(NSInteger)anOffset {
    if (self = [super initWithColor:aColor size:[CAUtilities screenSize]]) {
        [self setName:aName];
        [self setAnimationStart:[CAUtilities screenSize].height];
        [self setPosition:CGPointMake(0.0, self.animationStart + anOffset)];
        [self setAnchorPoint:CGPointMake(0.0, 0.0)];
        [self setDoneFirstAnimation:NO];
        [self addButtonNodes];
    }
    
    return self;
}

#pragma mark - Touch Events

#pragma mark - Animating

// aFactor: The animation height for the first animation is multipled by this.
- (void)startAnimating {
    SKAction *moveDown = [SKAction moveByX:0 y:-[CAUtilities screenSize].height duration:2.5];
    [self runAction:[SKAction repeatActionForever:moveDown]];
}

- (void)stopAnimating {
    self.speed = 0;
}

- (void)incAnimationSpeedBy:(CGFloat)aFloat {
    if (self.speed + aFloat < kMaxSpeed)
        self.speed += aFloat;
}

// called in the scene's update method
// resets the position and colors if scrolled off the screen
- (void)update {
    if ([self getTop] <= 0) {
        [self setPosition:[self getResetPosition]];
        [self resetColors];
    }
}

- (CGPoint)getResetPosition {
    return CGPointMake(self.position.x, [self.sibling getTop]);
}

// returns the coordinate of the top of the node
- (NSInteger)getTop {
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark - Buttons

// adds all the child button nodes
- (void)addButtonNodes {
    CGSize screen = [CAUtilities screenSize];
    
    CGFloat radius = (screen.width / 8);
    CGFloat diameter = (radius * 2);
    
    NSInteger numColumns = screen.width / diameter;
    NSInteger numRows = screen.height / diameter;
    
    // for any extra space
    CGFloat ySpacing = (screen.height - (numRows * diameter)) / (numRows + 1);
    CGFloat xSpacing = (screen.width - (numColumns * diameter)) / (numColumns + 1);
    
    for (int r = 0; r < numRows; r++)
        for (int c = 0; c < numColumns; c++) {
            CAButtonNode *btn = [CAButtonNode withColor:[CAColor randomColor] radius:radius];
            
            btn.position =
                CGPointMake((c * diameter) + radius + ((c + 1) * xSpacing),
                            (r * diameter) + radius + ((r + 1) * ySpacing));
            
            [self addChild:btn];
        }
}

- (CAButtonNode *)buttonAtTouch:(UITouch *)aTouch {
    id node = [self nodeAtPoint:[aTouch locationInNode:self]];
    
    if ([node isKindOfClass:[CAButtonNode class]])
        return node;
    
    return nil;
}

- (void)resetColors {
    for (CAButtonNode *btn in self.children)
        [btn reset];
}

@end
