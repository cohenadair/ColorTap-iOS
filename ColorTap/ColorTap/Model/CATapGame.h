//
//  CATapGame.h
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-14.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATapGame : NSObject

+ (id)withScore:(NSInteger)aScore;
- (id)initWithScore:(NSInteger)aScore;

- (void)incScoreBy:(NSInteger)anInteger;

@end
