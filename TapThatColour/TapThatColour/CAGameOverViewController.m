//
//  CAGameOverViewController.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameOverViewController.h"

@interface CAGameOverViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CAGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)self.score]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
