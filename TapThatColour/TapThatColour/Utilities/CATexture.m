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

#define kKeyRed @"textureKeyRed"
#define kKeyOrange @"textureKeyOrange"
#define kKeyYellow @"textureKeyYellow"
#define kKeyGreen @"textureKeyGreen"
#define kKeyBlue @"textureKeyBlue"
#define kKeyPurple @"textureKeyPurple"
#define kKeyMagenta @"texureKeyMagenta"
#define kKeyCyan @"textureKeyCyan"
#define kKeyBrown @"textureKeyBrown"

// a dictionary of dictionaries
@property (nonatomic) NSMutableDictionary *textures;

@end;

@implementation CATexture

+ (id)sharedTexture {
    static CATexture *sharedTexture = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedTexture = [self new];
        sharedTexture.textures = [NSMutableDictionary dictionaryWithCapacity:9];
    });
    
    return sharedTexture;
}

// used on device orientation change (only applies to iPads)
- (void)resetWithRadius:(CGFloat)aRadius {
    self.radius = aRadius;
    [self.textures removeAllObjects];
}

- (NSDictionary *)redTexture {
    return [self textureForKey:kKeyRed color:[CAColor redColor]];
}

- (NSDictionary *)orangeTexture {
    return [self textureForKey:kKeyOrange color:[CAColor orangeColor]];
}

- (NSDictionary *)yellowTexture {
    return [self textureForKey:kKeyYellow color:[CAColor yellowColor]];
}

- (NSDictionary *)greenTexture {
    return [self textureForKey:kKeyGreen color:[CAColor greenColor]];
}

- (NSDictionary *)blueTexture {
    return [self textureForKey:kKeyBlue color:[CAColor blueColor]];
}

- (NSDictionary *)purpleTexture {
    return [self textureForKey:kKeyPurple color:[CAColor purpleColor]];
}

- (NSDictionary *)magentaTexture {
    return [self textureForKey:kKeyMagenta color:[CAColor magentaColor]];
}

- (NSDictionary *)cyanTexture {
    return [self textureForKey:kKeyCyan color:[CAColor cyanColor]];
}

- (NSDictionary *)brownTexture {
    return [self textureForKey:kKeyBrown color:[CAColor brownColor]];
}

- (NSDictionary *)randomTexture {
    // needed in case the textures need to be initialized
    NSArray *textures =
        @[[self redTexture],   [self orangeTexture], [self yellowTexture],
          [self greenTexture], [self blueTexture],   [self magentaTexture],
          [self cyanTexture],  [self purpleTexture], [self brownTexture]];
    
    return [textures objectAtIndex:arc4random_uniform((u_int32_t)[textures count])];
}

// adds a new texture for aKey with aColor to self.textures
// an NSDictionary is added as the object
- (void)addTextureForKey:(NSString *)aKey withColor:(CAColor *)aColor {
    SKTexture *texture = [self textureWithRadius:self.radius color:aColor];
    NSDictionary *dict = [self dictionaryForTexture:texture color:aColor];
    [self.textures setObject:dict forKey:aKey];
}

// retrives the texture dictionary at aKey
// if none is present, a new one is created
- (NSDictionary *)textureForKey:(NSString *)aKey color:(CAColor *)aColor {
    NSDictionary *obj = [self.textures objectForKey:aKey];
    
    if (!obj)
        [self addTextureForKey:aKey withColor:aColor];
    
    return [self.textures objectForKey:aKey];
}

// for use outsize the standard radius (i.e. the scoreboard)
- (NSDictionary *)newTextureWithRadius:(CGFloat)aRadius color:(CAColor *)aColor {
    SKTexture *texture = [self textureWithRadius:aRadius color:aColor];
    return [self dictionaryForTexture:texture color:aColor];
}

// creates and returns a new texture
- (SKTexture *)textureWithRadius:(CGFloat)aRadius color:(CAColor *)aColor {
    
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
    textureNode.fillColor = aColor.color;
    
    return [self.spriteView textureFromNode:textureNode];
}

// returns a dictionary object with the texture and color information
- (NSDictionary *)dictionaryForTexture:(SKTexture *)aTexture color:(CAColor *)aColor {
    return [NSDictionary dictionaryWithObjectsAndKeys:aTexture, @"SKTexture", aColor, @"CAColor", nil];
}

@end
