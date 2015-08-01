//
//  CATexture.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-08-01.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAColor.h"

@interface CATexture : NSObject

@property (nonatomic) CGFloat radius;
@property (nonatomic) SKView *spriteView;

+ (id)sharedTexture;

- (NSDictionary *)redTexture;
- (NSDictionary *)orangeTexture;
- (NSDictionary *)yellowTexture;
- (NSDictionary *)greenTexture;
- (NSDictionary *)blueTexture;
- (NSDictionary *)purpleTexture;
- (NSDictionary *)magentaTexture;
- (NSDictionary *)cyanTexture;
- (NSDictionary *)brownTexture;
- (NSDictionary *)randomTexture;
- (NSDictionary *)newTextureWithRadius:(CGFloat)aRadius color:(CAColor *)aColor;

@end
