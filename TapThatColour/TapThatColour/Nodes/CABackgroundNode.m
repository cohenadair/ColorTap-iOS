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
@property CGFloat animationDuration;

@property SKAction *moveDownAction;

@end

@implementation CABackgroundNode

#pragma mark - Initializing

+ (id)withName:(NSString *)aName color:(SKColor *)aColor yStartOffset:(NSInteger)anOffset {
    return [[self alloc] initWithName:aName color:aColor yStartOffset:anOffset];
}

- (id)initWithName:(NSString *)aName color:(SKColor *)aColor yStartOffset:(NSInteger)anOffset {
    if (self = [super initWithColor:aColor size:[CAUtilities screenSize]]) {
        [self setName:aName];
        [self setAnimationStart:[CAUtilities screenSize].height];
        [self setAnimationDuration:3.0];
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
    SKAction *moveDown = [SKAction moveByX:0 y:-[CAUtilities screenSize].height duration:self.animationDuration];
    [self setMoveDownAction:[SKAction repeatActionForever:moveDown]];
    [self runAction:self.moveDownAction];
}

- (void)incAnimationSpeedBy:(CGFloat)aFloat {
    self.moveDownAction.speed += 0.5;
    NSLog(@"%f", self.moveDownAction.speed);
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
    
    CGFloat radius = 40.0;
    CGFloat diameter = (radius * 2);
    
    NSInteger numColumns = screen.width / diameter;
    NSInteger numRows = screen.height / diameter;
    
    // for any extra space
    CGFloat ySpacing = (screen.height - (numRows * diameter)) / (numRows + 1);
    CGFloat xSpacing = (screen.width - (numColumns * diameter)) / (numColumns + 1);
    
    for (int r = 0; r < numRows; r++)
        for (int c = 0; c < numColumns; c++) {
            CAButtonNode *btn = [CAButtonNode withColor:[CAUtilities randomColor] radius:radius];
            
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
        [btn setFillColor:[CAUtilities randomColor]];
}

@end
