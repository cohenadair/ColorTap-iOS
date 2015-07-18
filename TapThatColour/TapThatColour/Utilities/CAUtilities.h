//
//  CAUtilities.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAUtilities : NSObject

+ (CGRect)screenBounds;
+ (CGSize)screenSize;
+ (void)showStatusBar;
+ (void)hideStatusBar;
+ (SKColor *)randomColor;

@end
