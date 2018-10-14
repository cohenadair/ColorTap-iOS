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
#import "CATexture.h"
#import "CAAppDelegate.h"
#import "CATapGame.h"

@interface CAScoreboardNode ()

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKView *spriteView;
@property (nonatomic) CGFloat radius;

@end

@implementation CAScoreboardNode

- (CATapGame *)tapGame {
    return [(CAAppDelegate *)[[UIApplication sharedApplication] delegate] tapGame];
}

+ (id)withScore:(NSInteger)aScore {
    return [[self alloc] initWithScore:aScore];
}

- (id)initWithScore:(NSInteger)aScore {
    CGFloat radius = [CAUtilities iPad] ? 90.0: 50.0;
    CGPoint pos;
    pos.x = [CAUtilities screenSize].width / 2;
    pos.y = [CAUtilities screenSize].height - radius - 20;
    
    if (@available(iOS 11.0, *)) {
        pos.y -= UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
    }
    
    // create a texture
    NSDictionary *dict = [[CATexture sharedTexture] newTextureWithRadius:radius color:[[self tapGame] currentColor]];
    
    if (self = [super initWithTexture:[dict objectForKey:@"SKTexture"] color:[dict objectForKey:@"CAColor"]]) {
        [self setRadius:radius];
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
    NSDictionary *dict = [[CATexture sharedTexture] newTextureWithRadius:self.radius color:aColor];
    [self setTexture:[dict objectForKey:@"SKTexture"]];
    [self setMyColor:[dict objectForKey:@"CAColor"]];
}

@end
