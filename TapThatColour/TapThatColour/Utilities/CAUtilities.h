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

+ (BOOL)iPad;
+ (BOOL)orientationIsLandscape;
+ (CGRect)screenBounds;
+ (CGSize)screenSize;
+ (CGFloat)factorOfScreenHeight:(CGFloat)aFactor;
+ (void)showStatusBar;
+ (void)hideStatusBar;
+ (void)makeToolbarTransparent:(UIToolbar *)aToolbar;
+ (void)makeNavigationBarTransparent:(UINavigationBar *)aNavigationBar;
+ (void)openUrl:(NSString *)aUrl;
+ (CFTimeInterval)systemTime;
+ (void)executeBlockAfterMs:(NSInteger)milliseconds block:(void (^)())aBlock;
+ (void)presentShareActivityForViewController:(UIViewController *)aViewController items:(NSArray *)anArray;
+ (CGFloat)buttonRadius;
+ (void)showAlertWithMessage:(NSString *)aString view:(UIViewController *)aViewController;

@end
