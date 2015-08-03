//
//  CAGameDifficulty.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-08-03.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameDifficulty.h"

@implementation CAGameDifficulty

+ (id)withName:(NSString *)aName leaderboardId:(NSString *)aLeaderboardId controlIndex:(NSInteger)anInteger {
    return [[self alloc] initWithName:aName leaderboardId:aLeaderboardId controlIndex:anInteger];
}

- (id)initWithName:(NSString *)aName leaderboardId:(NSString *)aLeaderboardId controlIndex:(NSInteger)anInteger {
    if (self = [super init]) {
        self.name = aName;
        self.leaderboardId = aLeaderboardId;
        self.controlIndex = anInteger;
    }
    
    return self;
}

@end
