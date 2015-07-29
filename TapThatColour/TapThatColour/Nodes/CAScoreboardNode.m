//
//  CAScoreboardNode.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-28.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAUtilities.h"
#import "CAButtonNode.h"
#import "CAScoreboardNode.h"

@interface CAScoreboardNode ()

@property (nonatomic) SKLabelNode *scoreLabel;

@end

@implementation CAScoreboardNode

#define kScoreboardRadius 50.0

+ (id)withScore:(NSInteger)aScore color:(CAColor *)aColor {
    return [[self alloc] initWithScore:aScore color:aColor];
}

- (id)initWithScore:(NSInteger)aScore color:(CAColor *)aColor {
    CGPoint pos;
    pos.x = [CAUtilities screenSize].width / 2;
    pos.y = [CAUtilities screenSize].height - kScoreboardRadius - 5;
    
    if (self = [super initWithColor:aColor radius:kScoreboardRadius]) {
        [self setPosition:pos];
        [self setUserInteractionEnabled:NO];
        
        // score label init
        [self setScoreLabel:[SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"]];
        [self.scoreLabel setFontColor:[SKColor blackColor]];
        [self.scoreLabel setFontSize:40.0];
        [self.scoreLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
        [self updateScoreLabel:aScore];
        
        [self addChild:self.scoreLabel];
    }
    
    return self;
}

- (void)updateScoreLabel:(NSInteger)aScore {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)aScore]];
}

- (void)updateColor:(CAColor *)aColor {
    self.color = aColor;
    self.fillColor = self.color.color;
}

@end
