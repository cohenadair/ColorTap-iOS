//
//  CAColor.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface CAColor : NSObject

@property SKColor *color;
@property NSInteger comparisonId;

+ (CAColor *)redColor;
+ (CAColor *)orangeColor;
+ (CAColor *)yellowColor;
+ (CAColor *)greenColor;
+ (CAColor *)blueColor;
+ (CAColor *)purpleColor;
+ (CAColor *)magentaColor;
+ (CAColor *)cyanColor;
+ (CAColor *)brownColor;

- (BOOL)isEqualToColor:(CAColor *)aColor;

@end
