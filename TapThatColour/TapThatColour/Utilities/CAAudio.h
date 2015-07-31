//
//  CAAudio.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-31.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//
//  A singleton class to store any sounds used in the application.
//  This fixes a SpriteKit issue with AVFoundation where the app would crash after returning from the background.
//  It also keeps one instance of each sound, rather than a new instance for each button.

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface CAAudio : NSObject

@property (nonatomic) SKAction *correctSound;
@property (nonatomic) SKAction *incorrectSound;

+ (id)sharedAudio;

@end
