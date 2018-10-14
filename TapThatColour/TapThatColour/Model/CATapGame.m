//
//  CATapGame.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-14.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CATapGame.h"
#import "CAUserSettings.h"
#import "CATexture.h"

@interface CATapGame ()

@end

@implementation CATapGame

@synthesize difficulty = _difficulty;

+ (id)withScore:(NSInteger)aScore {
    return [[self alloc] initWithScore:aScore];
}

- (id)initWithScore:(NSInteger)aScore {
    if (self = [super init]) {
        [self setScore:aScore];
        [self setCurrentColor:[CAColor randomColor]];
        [self initAllDifficulties];
    }
    
    return self;
}

- (void)initAllDifficulties {
    [self setAllDifficulties:[NSMutableArray array]];
    [self.allDifficulties addObject:[CAGameDifficulty withName:@"Easy" leaderboardId:@"tapthatcolour.highscore_easy" controlIndex:CADifficultyIndexEasy]];
    [self.allDifficulties addObject:[CAGameDifficulty withName:@"Regular" leaderboardId:@"tapthatcolour.highscore_regular" controlIndex:CADifficultyIndexMedium]];
    [self.allDifficulties addObject:[CAGameDifficulty withName:@"Expert" leaderboardId:@"tapthatcolour.highscore_expert" controlIndex:CADifficultyIndexExpert]];
}

#pragma mark - Getting and Setting

- (CAGameDifficulty *)difficulty {
    return [self difficultyAtIndex:[[CAUserSettings sharedSettings] difficultyIndex]];
}

- (void)setDifficultyForIndex:(CADifficultyIndex)aDifficultyIndex {
    [self setDifficulty:[self difficultyAtIndex:aDifficultyIndex]];
    [[CAUserSettings sharedSettings] setDifficultyIndex:aDifficultyIndex];
    [[CATexture sharedTexture] resetWithRadius:[CAUtilities buttonRadius]];
}

- (CAGameDifficulty *)difficultyAtIndex:(NSInteger)anIndex {
    return (CAGameDifficulty *)[self.allDifficulties objectAtIndex:anIndex];
}

- (NSString *)difficultyAsString {
    if ([[CAUserSettings sharedSettings] kidsMode])
        return @"Difficulty: Kids Mode";
    
    return [@"Difficulty: " stringByAppendingString:self.difficulty.name];
}

- (NSString *)scoreAsString {
    return [NSString stringWithFormat:@"%ld", (long)self.score];
}

#pragma mark - Modifying

// increments score by anInteger
// if score is a multiple of 10 the color changes
- (void)incScoreBy:(NSInteger)anInteger {
    self.score += anInteger;
    
    if (self.score % 10 == 0) {
        [self setCurrentColor:[CAColor randomColor]];
        
        if (self.onColorChange)
            self.onColorChange();
        else
            NSLog(@"Warning: 'onColorChange' for CATapGame instance is nil.");
    }
}

- (void)updateHighscore {
    [[CAUserSettings sharedSettings] updateHighscore:self.score];
}

@end
