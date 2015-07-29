//
//  CAGameOverViewController.h
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface CAGameOverViewController : UIViewController <GKGameCenterControllerDelegate>

@property (nonatomic) NSInteger score;

@end
