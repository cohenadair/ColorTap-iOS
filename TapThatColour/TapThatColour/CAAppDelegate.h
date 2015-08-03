//
//  AppDelegate.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATapGame.h"

@interface CAAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) CATapGame *tapGame;

@end

