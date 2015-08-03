//
//  CABackgroundNode.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CABackgroundNode.h"
#import "CAConstants.h"
#import "CATexture.h"
#import "CAAppDelegate.h"
#import "CATapGame.h"

@interface CABackgroundNode ()

@property (nonatomic) BOOL doneFirstAnimation;
@property (nonatomic) NSInteger animationStart;
@property (nonatomic) NSInteger animationHeight;

@end

#define kMaxSpeed 4.0

@implementation CABackgroundNode

- (CATapGame *)tapGame {
    return [(CAAppDelegate *)[[UIApplication sharedApplication] delegate] tapGame];
}

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

#pragma mark - Animating

- (void)startAnimating {
    CGFloat duration = 2.5;
    CGFloat distance = [CAUtilities screenSize].height;
    
    SKAction *moveDown = [SKAction moveByX:0 y:-distance duration:duration];
    [self runAction:[SKAction repeatActionForever:moveDown]];
    
    // slightly increase starting speed for different screen sizes
    // narrows the difficulty gap for different devices
    CGFloat velocity = distance / duration;
    self.speed += velocity * 0.0001;
}

- (void)stopAnimatingWithReverse:(BOOL)shouldReverse completion:(void (^)())aCompletionBlock {
    [self removeAllActions];
    
    if (shouldReverse) {
        SKAction *moveUp = [SKAction moveByX:0 y:[CAUtilities screenSize].height / 2 duration:0.25];
        [self runAction:moveUp completion:^{
            if (aCompletionBlock)
                aCompletionBlock();
        }];
    } else
        if (aCompletionBlock)
            aCompletionBlock();
}

- (void)incAnimationSpeedBy:(CGFloat)aFloat {
    if (![[CAUserSettings sharedSettings] kidsMode] && self.speed + aFloat < kMaxSpeed)
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

// returns the position to reset to (i.e. above sibling)
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
    CGFloat radius = [CAUtilities buttonRadiusForTapGame:[self tapGame]];
    CGFloat diameter = (radius * 2);
    
    NSInteger numColumns = screen.width / diameter;
    NSInteger numRows = screen.height / diameter;
    
    // for any extra space
    CGFloat ySpacing = (screen.height - (numRows * diameter)) / (numRows + 1);
    CGFloat xSpacing = (screen.width - (numColumns * diameter)) / (numColumns + 1);
    
    for (int r = 0; r < numRows; r++)
        for (int c = 0; c < numColumns; c++) {
            CAButtonNode *btn = [CAButtonNode withRandomColor];
            
            btn.position =
                CGPointMake((c * diameter) + radius + ((c + 1) * xSpacing),
                            (r * diameter) + radius + ((r + 1) * ySpacing));
            
            [self addChild:btn];
        }
}

// returns the button at aTouch or nil of no button exists
- (CAButtonNode *)buttonAtTouch:(UITouch *)aTouch {
    return [self buttonAtPoint:[aTouch locationInNode:self]];
}

// returns the button at aPoint or nil of no button exists
- (CAButtonNode *)buttonAtPoint:(CGPoint)aPoint {
    id node = [self nodeAtPoint:aPoint];
    
    if ([node isKindOfClass:[CAButtonNode class]])
        return node;
    
    return nil;
}

- (CAButtonNode *)anyButton {
    return (CAButtonNode *)[self.children firstObject];
}

- (void)resetColors {
    for (CAButtonNode *btn in self.children)
        [btn reset];
}

@end
