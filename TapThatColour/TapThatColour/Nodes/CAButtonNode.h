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
#import "CAUserSettings.h"

@interface CAButtonNode : SKSpriteNode

@property (nonatomic) CAColor *myColor;
@property (nonatomic) BOOL wasTapped; // so the same button can't be tapped twice for 2x the points

+ (id)withTexture:(SKTexture *)aTexture color:(CAColor *)aColor;
+ (id)withRandomColor;
- (id)initWithTexture:(SKTexture *)aTexture color:(CAColor *)aColor;

- (void)onCorrectTouch;
- (void)onIncorrectTouchWithCompletion:(void (^)())aCompletionBlock;
- (void)reset;

@end
