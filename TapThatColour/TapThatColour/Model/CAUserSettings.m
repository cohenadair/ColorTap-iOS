//
//  CAUserSettings.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-26.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAUserSettings.h"

@implementation CAUserSettings

@synthesize muted = _muted;

#define kMutedKey @"cohenadair.tapthatcolor.muted"

+ (id)sharedSettings {
    static CAUserSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSettings = [self new];
    });
    
    return sharedSettings;
}

- (void)setMuted:(BOOL)aBool {
    _muted = aBool;
    [[NSUserDefaults standardUserDefaults] setBool:_muted forKey:kMutedKey];
}

- (BOOL)muted {
    _muted = [[NSUserDefaults standardUserDefaults] boolForKey:kMutedKey];
    return _muted;
}

@end
