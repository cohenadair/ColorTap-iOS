//
//  CABackgroundNode.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAUtilities.h"
#import "CAButtonNode.h"

@interface CABackgroundNode : SKSpriteNode

// the "other" background node needed to create an infinite scroll
@property CABackgroundNode *sibling;

#pragma mark - Initializing

+ (id)withName:(NSString *)aName color:(SKColor *)aColor yStartOffset:(NSInteger)anOffset;
- (id)initWithName:(NSString *)aName color:(SKColor *)aColor yStartOffset:(NSInteger)anOffset;

#pragma mark - Animating

- (void)startAnimating;
- (void)stopAnimating;
- (void)incAnimationSpeedBy:(CGFloat)aFloat;
- (void)update;
- (NSInteger)getTop;

#pragma mark - Buttons

- (void)addButtonNodes;
- (CAButtonNode *)buttonAtTouch:(UITouch *)aTouch;

@end
