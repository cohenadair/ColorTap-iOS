//
//  CAUserSettings.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-26.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//
//  Used for saving/retrieving NSUserDefault settings.
//

#import <Foundation/Foundation.h>

@interface CAUserSettings : NSObject

@property (nonatomic) BOOL muted;
@property (nonatomic) NSInteger highscore;

+ (id)sharedSettings;

- (void)updateHighscore:(NSInteger)anInteger;

@end
