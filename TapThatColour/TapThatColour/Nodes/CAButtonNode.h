//
//  CAButtonNode.h
//  TapThatColor
//
//  Created by Cohen Adair on 2015-07-18.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAUtilities.h"
#import "CAColor.h"

@interface CAButtonNode : SKShapeNode

@property CAColor *color;
@property BOOL wasTapped;

+ (id)withColor:(CAColor *)aColor radius:(CGFloat)aRadius;
- (id)initWithColor:(CAColor *)aColor radius:(CGFloat)aRadius;

- (void)onCorrectTouch;
- (void)onIncorrectTouchWithCompletion:(void (^)())aCompletionBlock;
- (void)reset;

@end
