//
//  CAUserSettings.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-26.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//
//  Used for saving/retrieving NSUserDefault settings.
//

#import <Foundation/Foundation.h>
#import "CAConstants.h"

@interface CAUserSettings : NSObject

+ (id)sharedSettings;

- (void)setMuted:(BOOL)aBool;
- (BOOL)muted;
- (void)setKidsMode:(BOOL)aBool;
- (BOOL)kidsMode;
- (void)setHighscore:(NSInteger)anInteger;
- (NSInteger)highscore;
- (void)setDifficulty:(CADifficulty)aDifficulty;
- (NSInteger)difficulty;
- (void)updateHighscore:(NSInteger)anInteger;

@end
