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

+ (SKColor *)randomColor {
    NSArray *colors =
        @[[SKColor redColor], [SKColor orangeColor], [SKColor yellowColor],
          [SKColor greenColor], [SKColor blueColor], [SKColor magentaColor],
          [SKColor cyanColor], [SKColor purpleColor], [SKColor brownColor]];
    
    return [colors objectAtIndex:arc4random_uniform((u_int32_t)[colors count])];
}

@end
