//
//  CATapGame.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-14.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CATapGame.h"

@interface CATapGame ()

@property NSInteger score;

@end

@implementation CATapGame

+ (id)withScore:(NSInteger)aScore {
    return [[self alloc] initWithScore:aScore];
}

- (id)initWithScore:(NSInteger)aScore {
    if (self = [super init]) {
        [self setScore:aScore];
    }
    
    return self;
}

- (void)incScoreBy:(NSInteger)anInteger {
    self.score += anInteger;
}

@end
