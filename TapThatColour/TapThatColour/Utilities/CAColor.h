//
//  CAColor.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//
//  This is a wrapper class that makes color comparisons extremely easy.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface CAColor : NSObject

@property (nonatomic) SKColor *color;
@property (nonatomic) NSInteger comparisonId;

+ (CAColor *)redColor;
+ (CAColor *)orangeColor;
+ (CAColor *)yellowColor;
+ (CAColor *)greenColor;
+ (CAColor *)blueColor;
+ (CAColor *)purpleColor;
+ (CAColor *)magentaColor;
+ (CAColor *)cyanColor;
+ (CAColor *)brownColor;
+ (CAColor *)randomColor;

- (BOOL)isEqualToColor:(CAColor *)aColor;

@end
