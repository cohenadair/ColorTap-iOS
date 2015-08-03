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

#define kKeyMuted @"cohenadair.tapthatcolour.muted"
#define kKeyKidsMode @"cohenadair.tapthatcolour.kidsMode"
#define kKeyHighscore @"cohenadair.tapthatcolour.highscore"
#define kKeyDifficulty @"cohenadair.tapthatcolour.difficulty"

+ (id)sharedSettings {
    static CAUserSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSettings = [self new];
    });
    
    return sharedSettings;
}

- (void)setMuted:(BOOL)aBool {
    [[NSUserDefaults standardUserDefaults] setBool:aBool forKey:kKeyMuted];
}

- (BOOL)muted {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kKeyMuted];
}

- (void)setKidsMode:(BOOL)aBool {
    [[NSUserDefaults standardUserDefaults] setBool:aBool forKey:kKeyKidsMode];
}

- (BOOL)kidsMode {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kKeyKidsMode];
}

- (void)setHighscore:(NSInteger)anInteger {
    [[NSUserDefaults standardUserDefaults] setInteger:anInteger forKey:kKeyHighscore];
}

- (NSInteger)highscore {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kKeyHighscore];
}

- (void)setGameDifficulty:(CADifficulty)aGameDifficulty {
    [[NSUserDefaults standardUserDefaults] setInteger:aGameDifficulty forKey:kKeyDifficulty];
}

- (NSInteger)gameDifficulty {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kKeyDifficulty];
}

// updates local highscore and sends to Game Center if aScore is greater than the current highscore
- (void)updateHighscore:(NSInteger)aScore {
    if (![self kidsMode] && aScore > [self highscore]) {
        [self setHighscore:aScore];
        [[CAGameCenterManager sharedManager] reportScore:aScore];
    }
}

@end
