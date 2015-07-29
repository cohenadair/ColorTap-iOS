//
//  CAScoreboardNode.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-28.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAButtonNode.h"

@interface CAScoreboardNode : CAButtonNode

+ (id)withScore:(NSInteger)aScore color:(CAColor *)aColor;
- (id)initWithScore:(NSInteger)aScore color:(CAColor *)aColor;

- (void)updateScoreLabel:(NSInteger)aScore;
- (void)updateColor:(CAColor *)aColor;

@end
