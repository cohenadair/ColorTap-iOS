//
//  CABackgroundNode.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAUtilities.h"

@interface CABackgroundNode : SKSpriteNode

+ (id)withName:(NSString *)aName color:(UIColor *)aColor yStartOffset:(NSInteger)anOffset;
- (id)initWithName:(NSString *)aName color:(UIColor *)aColor yStartOffset:(NSInteger)anOffset;

- (void)startAnimatingWithInitialFactor:(NSInteger)aFactor;
- (void)updatePosition;

@end
