//
//  CAUtilities.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAUtilities.h"

@interface CAUtilities ()

@end

@implementation CAUtilities

+ (BOOL)iPad {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

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

+ (void)makeToolbarTransparent:(UIToolbar *)aToolbar {
    [aToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [aToolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
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

@end
