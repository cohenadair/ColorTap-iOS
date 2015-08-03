//
//  CATapGame.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-14.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CATapGame.h"
#import "CAUserSettings.h"

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
    }
    
    return self;
}

#pragma mark - Getting and Setting

- (void)setDifficulty:(CADifficulty)aDifficulty {
    _difficulty = aDifficulty;
    [[CAUserSettings sharedSettings] setDifficulty:aDifficulty];
}

- (NSString *)difficultyAsString {
    switch (self.difficulty) {
        case CADifficultyMedium:
            return @"Difficulty: Regular";
        
        case CADifficultyExpert:
            return @"Difficulty: Expert";
            
        default:
            NSLog(@"Invalid difficulty in difficultyAsString.");
            break;
    }
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
