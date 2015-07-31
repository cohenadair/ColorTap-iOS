//
//  CAAudio.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-31.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAAudio.h"

@implementation CAAudio

+ (id)sharedAudio {
    static CAAudio *sharedAudio = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedAudio = [self new];
        
        sharedAudio.correctSound =
            [SKAction playSoundFileNamed:@"correct.wav" waitForCompletion:YES];
        
        sharedAudio.incorrectSound =
            [SKAction playSoundFileNamed:@"incorrect.wav" waitForCompletion:YES];
    });
    
    return sharedAudio;
}

@end
