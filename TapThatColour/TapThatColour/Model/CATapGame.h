//
//  CATapGame.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-14.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAUtilities.h"

@interface CATapGame : NSObject

@property NSInteger score;
@property CAColor *currentColor;

+ (id)withScore:(NSInteger)aScore;
- (id)initWithScore:(NSInteger)aScore;

- (void)incScoreBy:(NSInteger)anInteger;

@end
