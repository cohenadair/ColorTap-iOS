//
//  CAButtonNode.m
//  TapThatColor
//
//  Created by Cohen Adair on 2015-07-18.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAButtonNode.h"

@implementation CAButtonNode

+ (id)withColor:(SKColor *)aColor radius:(CGFloat)aRadius {
    return [[self alloc] initWithColor:aColor radius: aRadius];
}

- (id)initWithColor:(SKColor *)aColor radius:(CGFloat)aRadius {
    if (self = [super init]) {
        self.path = CGPathCreateWithEllipseInRect(CGRectMake(-aRadius, -aRadius, aRadius * 2, aRadius * 2), NULL);
        self.fillColor = aColor;
        self.strokeColor = [SKColor clearColor];
    }
    
    return self;
}

- (void)onTouch {
    [self setFillColor:[SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
}

@end
