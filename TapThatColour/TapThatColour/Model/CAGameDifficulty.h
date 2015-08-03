//
//  CAGameDifficulty.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-08-03.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAGameDifficulty : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *leaderboardId;
@property (nonatomic) NSInteger controlIndex;

+ (id)withName:(NSString *)aName leaderboardId:(NSString *)aLeaderboardId controlIndex:(NSInteger)anInteger;
- (id)initWithName:(NSString *)aName leaderboardId:(NSString *)aLeaderboardId controlIndex:(NSInteger)anInteger;

@end
