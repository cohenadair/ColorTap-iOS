//
//  CAColor.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAColor.h"

@implementation CAColor

#pragma mark - Initializing

+ (CAColor *)redColor {
    return [[self alloc] initWithColor:[UIColor redColor] comparisonId:0];
}

+ (CAColor *)orangeColor {
    return [[self alloc] initWithColor:[UIColor orangeColor] comparisonId:1];
}

+ (CAColor *)yellowColor {
    return [[self alloc] initWithColor:[UIColor yellowColor] comparisonId:2];
}

+ (CAColor *)greenColor {
    return [[self alloc] initWithColor:[UIColor greenColor] comparisonId:3];
}

+ (CAColor *)blueColor {
    return [[self alloc] initWithColor:[UIColor blueColor] comparisonId:4];
}

+ (CAColor *)purpleColor {
    return [[self alloc] initWithColor:[UIColor purpleColor] comparisonId:5];
}

+ (CAColor *)magentaColor {
    return [[self alloc] initWithColor:[UIColor magentaColor] comparisonId:6];
}

+ (CAColor *)cyanColor {
    return [[self alloc] initWithColor:[UIColor cyanColor] comparisonId:7];
}

+ (CAColor *)brownColor {
    return [[self alloc] initWithColor:[UIColor brownColor] comparisonId:8];
}

- (CAColor *)initWithColor:(UIColor *)aColor comparisonId:(NSInteger)anId {
    if (self = [super init]) {
        self.color = aColor;
        self.comparisonId = anId;
    }
    
    return self;
}

#pragma mark - Comparing

- (BOOL)isEqualToColor:(CAColor *)aColor {
    return (self.comparisonId == aColor.comparisonId);
}

@end
