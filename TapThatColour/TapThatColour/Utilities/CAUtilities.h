//
//  CAUtilities.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//
//  Utility methods used throughout the application.
//

#import <Foundation/Foundation.h>
#import "CAColor.h"

@interface CAUtilities : NSObject

+ (CGRect)screenBounds;
+ (CGSize)screenSize;
+ (void)showStatusBar;
+ (void)hideStatusBar;
+ (void)makeToolbarTransparent:(UIToolbar *)aToolbar;
+ (void)openUrl:(NSString *)aUrl;
+ (CFTimeInterval)systemTime;
+ (void)executeBlockAfterMs:(NSInteger)milliseconds block:(void (^)())aBlock;

@end
