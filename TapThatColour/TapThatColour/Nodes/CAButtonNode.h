//
//  CAButtonNode.h
//  TapThatColor
//
//  Created by Cohen Adair on 2015-07-18.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CAButtonNode : SKShapeNode

+ (id)withColor:(SKColor *)aColor radius:(CGFloat)aRadius;
- (id)initWithColor:(SKColor *)aColor radius:(CGFloat)aRadius;

- (void)onTouch;

@end
