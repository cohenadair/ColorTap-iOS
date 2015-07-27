//
//  ViewController.m
//  ColorTap
//
//  Created by Cohen Adair on 2015-07-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CAMainViewController.h"
#import "CAGameOverViewController.h"
#import "CAGameScene.h"
#import "CAUserSettings.h"

@interface CAMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *scoreboard;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;

@property (nonatomic) SKView *spriteView;
@property (nonatomic) CAGameScene *gameScene;
@property (nonatomic) BOOL autoStartGame;

@end

@implementation CAMainViewController

- (CAUserSettings *)userSettings {
    return [CAUserSettings sharedSettings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CAUtilities hideStatusBar];
    [self initSpriteView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showGameView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)scoreboardView {
    return self.scoreboard;
}

#pragma mark - Observing

#define kKeyPathScore @"gameScene.tapThatColor.score"
#define kKeyPathColor @"gameScene.tapThatColor.currentColor"

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kKeyPathScore])
        [self onScoreChange:change];
    
    if ([keyPath isEqualToString:kKeyPathColor])
        [self onColorChange:change];
}

- (void)onScoreChange:(NSDictionary *)aChange {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@", [aChange valueForKey:@"new"]]];
}

- (void)onColorChange:(NSDictionary *)aChange {
    id new = [aChange valueForKey:@"new"];
    if (![new isKindOfClass:[NSNull class]])
        [self.scoreboard setBackgroundColor:[new color]];
}

- (void)initObservers {
    // score
    [self setValue:[NSNumber numberWithInt:0] forKeyPath:kKeyPathScore];
    [self addObserver:self forKeyPath:kKeyPathScore options:NSKeyValueObservingOptionNew context:nil];
    
    // color
    [self setValue:@"" forKeyPath:kKeyPathColor];
    [self addObserver:self forKeyPath:kKeyPathColor options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Initializing

- (void)initSpriteView {
    self.spriteView = (SKView *)self.view;
    self.spriteView.showsDrawCount = YES;
    self.spriteView.showsNodeCount = YES;
    self.spriteView.showsFPS = YES;
}

- (void)showGameView {
    [self setGameScene:[[CAGameScene alloc] initWithSize:[CAUtilities screenSize]]];
    [self.gameScene setViewController:self];
    [self.gameScene setAutoStart:self.autoStartGame];
    
    [self initObservers];
    [self.spriteView presentScene:self.gameScene];
}

- (IBAction)tapSoundButton:(UIButton *)sender {
    CAUserSettings *userSettings = [self userSettings];
    userSettings.muted = !userSettings.muted;
    [self initSoundButton];
}

- (void)initSoundButton {
    if ([self userSettings].muted)
        [self.soundButton setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    else
        [self.soundButton setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)aSegue {
    [self setAutoStartGame:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender {
    CAGameOverViewController *dest = [aSegue destinationViewController];
    dest.score = [self.gameScene score];
}

@end
