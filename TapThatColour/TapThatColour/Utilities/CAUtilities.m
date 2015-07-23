//
//  CAUtilities.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAUtilities.h"

@implementation CAUtilities

+ (CGRect)screenBounds {
    return [UIScreen mainScreen].bounds;
}

+ (CGSize)screenSize {
    return [self screenBounds].size;
}

+ (void)showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

+ (void)hideStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

+ (CAColor *)randomColor {
    NSArray *colors =
        @[[CAColor redColor], [CAColor orangeColor], [CAColor yellowColor],
          [CAColor greenColor], [CAColor blueColor], [CAColor magentaColor],
          [CAColor cyanColor], [CAColor purpleColor], [CAColor brownColor]];
    
    return [colors objectAtIndex:arc4random_uniform((u_int32_t)[colors count])];
}

+ (CGPathRef)pathForRadius:(CGFloat)aRadius {
    return CGPathCreateWithEllipseInRect(CGRectMake(-aRadius, -aRadius, aRadius * 2, aRadius * 2), NULL);
}

@end
