//
//  CAUserSettings.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-26.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAUserSettings : NSObject

@property (nonatomic) BOOL muted;
@property (nonatomic) NSInteger highscore;

+ (id)sharedSettings;

@end
