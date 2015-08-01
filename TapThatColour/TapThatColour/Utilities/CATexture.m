//
//  CATexture.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-08-01.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CATexture.h"

@interface CATexture ()

@property (nonatomic) SKTexture *_redTexture;
@property (nonatomic) SKTexture *_orangeTexture;
@property (nonatomic) SKTexture *_yellowTexture;
@property (nonatomic) SKTexture *_greenTexture;
@property (nonatomic) SKTexture *_blueTexture;
@property (nonatomic) SKTexture *_purpleTexture;
@property (nonatomic) SKTexture *_magentaTexture;
@property (nonatomic) SKTexture *_cyanTexture;
@property (nonatomic) SKTexture *_brownTexture;

@end;

@implementation CATexture

+ (id)sharedTexture {
    static CATexture *sharedTexture = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedTexture = [self new];
    });
    
    return sharedTexture;
}

- (NSDictionary *)redTexture {
    if (!self._redTexture)
        self._redTexture = [self textureWithRadius:self.radius color:[SKColor redColor]];
    
    return [self dictionaryForTexture:self._redTexture color:[CAColor redColor]];
}

- (NSDictionary *)orangeTexture {
    if (!self._orangeTexture)
        self._orangeTexture = [self textureWithRadius:self.radius color:[SKColor orangeColor]];
    
    return [self dictionaryForTexture:self._orangeTexture color:[CAColor orangeColor]];
}

- (NSDictionary *)yellowTexture {
    if (!self._yellowTexture)
        self._yellowTexture = [self textureWithRadius:self.radius color:[SKColor yellowColor]];
    
    return [self dictionaryForTexture:self._yellowTexture color:[CAColor yellowColor]];
}

- (NSDictionary *)greenTexture {
    if (!self._greenTexture)
        self._greenTexture = [self textureWithRadius:self.radius color:[SKColor greenColor]];
    
    return [self dictionaryForTexture:self._greenTexture color:[CAColor greenColor]];
}

- (NSDictionary *)blueTexture {
    if (!self._blueTexture)
        self._blueTexture = [self textureWithRadius:self.radius color:[SKColor blueColor]];
    
    return [self dictionaryForTexture:self._blueTexture color:[CAColor blueColor]];
}

- (NSDictionary *)purpleTexture {
    if (!self._purpleTexture)
        self._purpleTexture = [self textureWithRadius:self.radius color:[SKColor purpleColor]];
    
    return [self dictionaryForTexture:self._purpleTexture color:[CAColor purpleColor]];
}

- (NSDictionary *)magentaTexture {
    if (!self._magentaTexture)
        self._magentaTexture = [self textureWithRadius:self.radius color:[SKColor magentaColor]];
    
    return [self dictionaryForTexture:self._magentaTexture color:[CAColor magentaColor]];
}

- (NSDictionary *)cyanTexture {
    if (!self._cyanTexture)
        self._cyanTexture = [self textureWithRadius:self.radius color:[SKColor cyanColor]];
    
    return [self dictionaryForTexture:self._cyanTexture color:[CAColor cyanColor]];
}

- (NSDictionary *)brownTexture {
    if (!self._brownTexture)
        self._brownTexture = [self textureWithRadius:self.radius color:[SKColor brownColor]];
    
    return [self dictionaryForTexture:self._brownTexture color:[CAColor brownColor]];
}

- (NSDictionary *)randomTexture {
    NSArray *textures =
        @[[self redTexture],
          [self orangeTexture],
          [self yellowTexture],
          [self greenTexture],
          [self blueTexture],
          [self magentaTexture],
          [self cyanTexture],
          [self purpleTexture],
          [self brownTexture]];
    
    return [textures objectAtIndex:arc4random_uniform((u_int32_t)[textures count])];
}

- (NSDictionary *)newTextureWithRadius:(CGFloat)aRadius color:(CAColor *)aColor {
    SKTexture *texture = [self textureWithRadius:aRadius color:aColor.color];
    return [self dictionaryForTexture:texture color:aColor];
}

// creates and returns a new texture
- (SKTexture *)textureWithRadius:(CGFloat)aRadius color:(SKColor *)aColor {
    
    if (!self.spriteView) {
        NSLog(@"Warning: Attemping to create texture before setting 'spriteView' value.");
        return nil;
    }
    
    if (aRadius <= 0) {
        NSLog(@"Warning: Attemping to create texture with radius of 0.");
        return nil;
    }
    
    SKShapeNode *textureNode = [SKShapeNode shapeNodeWithCircleOfRadius:aRadius];
    
    textureNode.antialiased = YES;
    textureNode.fillTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"texture"]];
    textureNode.fillColor = aColor;
    
    return [self.spriteView textureFromNode:textureNode];
}

- (NSDictionary *)dictionaryForTexture:(SKTexture *)aTexture color:(CAColor *)aColor {
    return [NSDictionary dictionaryWithObjectsAndKeys:aTexture, @"SKTexture", aColor, @"CAColor", nil];
}

@end
