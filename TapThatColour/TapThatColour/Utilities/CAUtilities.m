//
//  CAUtilities.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAUtilities.h"
#import "CAAlertController.h"
#import "CAUserSettings.h"

@interface CAUtilities ()

@end

@implementation CAUtilities

+ (BOOL)iPad {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)orientationIsLandscape {
    return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
}

+ (CGRect)screenBounds {
    return [UIScreen mainScreen].bounds;
}

+ (CGSize)screenSize {
    return [self screenBounds].size;
}

+ (CGFloat)factorOfScreenHeight:(CGFloat)aFactor {
    return [self screenSize].height * aFactor;
}

+ (void)showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

+ (void)hideStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

+ (void)makeToolbarTransparent:(UIToolbar *)aToolbar {
    [aToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [aToolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
}

+ (void)makeNavigationBarTransparent:(UINavigationBar *)aNavigationBar {
    [aNavigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [aNavigationBar setShadowImage:[UIImage new]];
    [aNavigationBar setTranslucent:YES];
    [aNavigationBar setBackgroundColor:[UIColor clearColor]];
}

+ (void)openUrl:(NSString *)aUrl {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:aUrl]];
}

+ (CFTimeInterval)systemTime {
    return CACurrentMediaTime();
}

+ (void)executeBlockAfterMs:(NSInteger)milliseconds block:(void (^)())aBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, milliseconds * USEC_PER_SEC), dispatch_get_main_queue(), ^{
        aBlock();
    });
}

+ (void)presentShareActivityForViewController:(UIViewController *)aViewController items:(NSArray *)anArray {
    
    UIActivityViewController *act = [[UIActivityViewController alloc] initWithActivityItems:anArray applicationActivities:nil];
    
    // for iPads
    if ([act respondsToSelector:@selector(popoverPresentationController)])
        act.popoverPresentationController.sourceView = aViewController.view;
    
    [aViewController presentViewController:act animated:YES completion:nil];
}

+ (CGFloat)buttonRadius {
    NSInteger buttonsPerRow = ([CAUtilities iPad] ? 5 : 4);
    
    if ([[CAUserSettings sharedSettings] kidsMode])
        buttonsPerRow -= 2;
    else
        buttonsPerRow += [[CAUserSettings sharedSettings] gameDifficulty];
    
    // "-1" to add some spacing between buttons
    return ([CAUtilities screenSize].width / (buttonsPerRow * 2)) - 1;
}

+ (void)showAlertWithMessage:(NSString *)aString view:(UIViewController *)aViewController {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:nil message:aString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alert addAction:okAction];
    [aViewController presentViewController:alert animated:YES completion:nil];
}

@end
