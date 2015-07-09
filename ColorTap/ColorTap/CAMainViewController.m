//
//  ViewController.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAMainViewController.h"
#import "CAGameScene.h"

@interface CAMainViewController ()

@end

@implementation CAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    CAGameScene *gameScene = [[CAGameScene alloc] initWithSize:[CAUtilities screenSize]];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene: gameScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
