//
//  CATapGame.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-14.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAUtilities.h"
#import "CAUserSettings.h"
#import "CAConstants.h"
#import "CAGameDifficulty.h"

@interface CATapGame : NSObject

@property (nonatomic) NSMutableArray *allDifficulties;
@property (nonatomic) CAGameDifficulty *difficulty;
@property (nonatomic) NSInteger score;
@property (nonatomic) CAColor *currentColor;
@property (nonatomic, copy) void (^onColorChange)();

+ (id)withScore:(NSInteger)aScore;
- (id)initWithScore:(NSInteger)aScore;

- (void)setDifficultyForIndex:(CADifficultyIndex)aDifficultyIndex;
- (NSString *)difficultyAsString;
- (NSString *)scoreAsString;

- (void)incScoreBy:(NSInteger)anInteger;
- (void)updateHighscore;

@end
