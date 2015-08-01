//
//  CAButtonNode.m
//  TapThatColor
//
//  Created by Cohen Adair on 2015-07-18.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAButtonNode.h"
#import "CAAudio.h"
#import "CATexture.h"

@interface CAButtonNode ()

@property (nonatomic) BOOL shouldResetPath; // used to reset the button's size if it was correctly tapped

@property (nonatomic) SKAction *correctSound;
@property (nonatomic) SKAction *incorrectSound;

@end

@implementation CAButtonNode

#pragma mark - Initializing

+ (id)withTexture:(SKTexture *)aTexture color:(CAColor *)aColor {
    return [[self alloc] initWithTexture:aTexture color:aColor];
}

+ (id)withRandomColor {
    NSDictionary *dict = [[CATexture sharedTexture] randomTexture];
    return [[self alloc] initWithTexture:[dict objectForKey:@"SKTexture"] color:[dict objectForKey:@"CAColor"]];
}

- (id)initWithTexture:(SKTexture *)aTexture color:(CAColor *)aColor {
    if (self = [super initWithTexture:aTexture])
        [self initDefaultsWithColor:aColor];
    
    return self;
}
        
- (void)initDefaultsWithColor:(CAColor *)aColor {
    self.myColor = aColor;
    self.shouldResetPath = NO;
    self.wasTapped = NO;
    
    // preload the sound to remove lag
    self.correctSound = [[CAAudio sharedAudio] correctSound];
    self.incorrectSound = [[CAAudio sharedAudio] incorrectSound];
}

#pragma mark - Touching

- (void)onCorrectTouch {
    if (self.wasTapped)
        return;
    
    [self shrink];
    [self setShouldResetPath:YES];
    [self setWasTapped:YES];
}

- (void)onIncorrectTouchWithCompletion:(void (^)())aCompletionBlock {
    __weak typeof(self) weakSelf = self;
    CGFloat zPos = self.zPosition;
    
    [self setZPosition:5000];
    
    SKAction *grow = [SKAction scaleBy:1.25 duration:0.25];
    SKAction *shrink = [SKAction scaleBy:0.8 duration:0.25];
    SKAction *sequence = [SKAction sequence:@[grow, shrink]];
    SKAction *repeat = [SKAction repeatAction:sequence count:2];
    SKAction *group = [SKAction group:@[repeat, self.incorrectSound]];
    
    SKAction *action = ([[CAUserSettings sharedSettings] muted]) ? repeat : group;
    
    [self runAction:action completion:^() {
        [weakSelf setZPosition:zPos];
        if (aCompletionBlock)
            aCompletionBlock();
    }];
}

#pragma mark - Animating

- (void)shrink {
    SKAction *shrink = [SKAction scaleBy:0.25 duration:0.25];
    SKAction *group = [SKAction group:@[shrink, self.correctSound]];
    
    SKAction *action = ([[CAUserSettings sharedSettings] muted]) ? shrink : group;
    [self runAction:action];
}

- (void)grow {
    [self runAction:[SKAction scaleBy:4 duration:0]];
}

// resets color and path if necessary
- (void)reset {
    NSDictionary *dict = [[CATexture sharedTexture] randomTexture];
    
    self.texture = [dict objectForKey:@"SKTexture"];
    self.myColor = [dict objectForKey:@"CAColor"];
    
    if (self.shouldResetPath) {
        [self grow];
        [self setShouldResetPath:NO];
    }
    
    self.wasTapped = NO;
}

@end
