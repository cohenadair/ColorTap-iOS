//
//  CAUserSettings.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-26.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAUserSettings.h"
#import "CAGameCenterManager.h"

@implementation CAUserSettings

@synthesize muted = _muted;
@synthesize highscore = _highscore;

#define kMutedKey @"cohenadair.tapthatcolor.muted"
#define kHighschoreKey @"cohenadair.tapthatcolor.highscore"

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

- (void)setHighscore:(NSInteger)anInteger {
    _highscore = anInteger;
    [[NSUserDefaults standardUserDefaults] setInteger:_highscore forKey:kHighschoreKey];
}

- (NSInteger)highscore {
    _highscore = [[NSUserDefaults standardUserDefaults] integerForKey:kHighschoreKey];
    return _highscore;
}

- (void)updateHighscore:(NSInteger)aScore {
    if (aScore > self.highscore) {
        [self setHighscore:aScore];
        [[CAGameCenterManager sharedManager] reportScore:aScore];
    }
}

@end
