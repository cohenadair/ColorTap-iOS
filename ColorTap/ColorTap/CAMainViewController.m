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

@property (weak, nonatomic) IBOutlet UIView *scoreboard;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property SKView *spriteView;
@property CAGameScene *gameScene;

@end

@implementation CAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CAUtilities hideStatusBar];
    [self initSpriteView];
    [self initScoreboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showGameView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO

#define kKeyPathScore @"gameScene.colorTap.score"

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kKeyPathScore])
        [self onScoreChange:change];
}

- (void)onScoreChange:(NSDictionary *)aChange {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@", [aChange valueForKey:@"new"]]];
}

#pragma mark - Initializing

- (void)initSpriteView {
    self.spriteView = (SKView *)self.view;
    self.spriteView.showsDrawCount = YES;
    self.spriteView.showsNodeCount = YES;
    self.spriteView.showsFPS = YES;
}

- (void)initScoreboard {
    [self.scoreboard setBackgroundColor:[UIColor greenColor]];
    [self.scoreLabel setText:@"0"];
    [self.colorLabel setText:@"Green"];
}

- (void)showGameView {
    [self setGameScene:[[CAGameScene alloc] initWithSize:[CAUtilities screenSize]]];
    
    [self setValue:[NSNumber numberWithInt:0] forKeyPath:kKeyPathScore];
    [self addObserver:self forKeyPath:kKeyPathScore options:NSKeyValueObservingOptionNew context:nil];
    
    [self.spriteView presentScene:self.gameScene];
}

@end
