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

@property (nonatomic) UIBarButtonItem *soundButton;
@property (nonatomic) UIBarButtonItem *flexibleSpace;
@property (nonatomic) UIBarButtonItem *playButton;
@property (nonatomic) UIBarButtonItem *pauseButton;

@property (nonatomic) SKView *spriteView;
@property (nonatomic) CAGameScene *gameScene;
@property (nonatomic) BOOL autoStartGame;

@end

@implementation CAMainViewController

- (CAUserSettings *)userSettings {
    return [CAUserSettings sharedSettings];
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CAUtilities hideStatusBar];
    
    [self initSpriteView];
    [self initToolbar];
    
    [self toggleSoundButton];
    [self togglePlayPauseButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showGameView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observing

#define kKeyPathColor @"gameScene.tapThatColor.currentColor"

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kKeyPathColor])
        [self onColorChange:change];
}

- (void)onColorChange:(NSDictionary *)aChange {
    id new = [aChange valueForKey:@"new"];
    if (![new isKindOfClass:[NSNull class]])
        [self.gameScene.scoreboardNode updateColor:(CAColor *)new];
}

- (void)initObservers {
    // color
    [self setValue:@"" forKeyPath:kKeyPathColor];
    [self addObserver:self forKeyPath:kKeyPathColor options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Sprite View

- (void)initSpriteView {
    self.spriteView = (SKView *)self.view;
    self.spriteView.showsDrawCount = YES;
    self.spriteView.showsNodeCount = YES;
    self.spriteView.showsFPS = YES;
}

- (void)showGameView {
    id __block blockSelf = self;
    
    [self setGameScene:[[CAGameScene alloc] initWithSize:[CAUtilities screenSize]]];
    [self.gameScene setViewController:self];
    [self.gameScene setAutoStart:self.autoStartGame];
    [self.gameScene setOnGameStart:^(void) {
        [[blockSelf pauseButton] setEnabled:YES];
    }];

    [self initObservers];
    [self.spriteView presentScene:self.gameScene];
}

#pragma mark - Toolbar

// done programatically so toggling between play/pause can be done with the system buttons
- (void)initToolbar {
    [CAUtilities makeToolbarTransparent:self.navigationController.toolbar];
    
    self.soundButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sound"] style:UIBarButtonItemStylePlain target:self action:@selector(tapSoundButton)];
    self.soundButton.tintColor = [UIColor blackColor];
    
    self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(tapPlayPauseButton)];
    self.pauseButton.tintColor = [UIColor blackColor];
    self.pauseButton.enabled = NO;
    
    self.playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(tapPlayPauseButton)];
    self.playButton.tintColor = [UIColor blackColor];
}

- (void)toggleSoundButton {
    if ([self userSettings].muted)
        [self.soundButton setImage:[UIImage imageNamed:@"mute"]];
    else
        [self.soundButton setImage:[UIImage imageNamed:@"sound"]];
}

- (void)togglePlayPauseButton {
    if (self.gameScene.paused)
        self.toolbarItems = @[self.soundButton, self.flexibleSpace, self.playButton];
    else
        self.toolbarItems = @[self.soundButton, self.flexibleSpace, self.pauseButton];
}

- (void)tapSoundButton {
    CAUserSettings *userSettings = [self userSettings];
    userSettings.muted = !userSettings.muted;
    [self toggleSoundButton];
}

- (void)tapPlayPauseButton {
    [self.gameScene togglePaused];
    [self togglePlayPauseButton];
}

#pragma mark - Navigation

- (IBAction)unwindToMain:(UIStoryboardSegue *)aSegue {
    [self setAutoStartGame:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender {
    CAGameOverViewController *dest = [aSegue destinationViewController];
    dest.score = [self.gameScene score];
}

@end
