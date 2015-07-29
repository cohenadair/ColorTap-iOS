//
//  CAGameOverViewController.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameOverViewController.h"
#import "CAGameCenterManager.h"
#import "CAUserSettings.h"
#import "CAUtilities.h"

@interface CAGameOverViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLabel;

@property (nonatomic) BOOL muted;

@end

@implementation CAGameOverViewController

#pragma mark - Initializing

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)self.score]];
    [self initHighscore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initHighscore {
    [self.highscoreLabel setText:[NSString stringWithFormat:@"Highscore: %ld", (long)[[CAUserSettings sharedSettings] highscore]]];
}

#pragma mark - Events

- (IBAction)tapShareButton:(UIButton *)aSender {
    NSArray *items = @[[NSString stringWithFormat:@"I just scored %ld on #TapThatColour! Check it out on the App Store!", (long)self.score]];
    UIActivityViewController *act = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:act animated:YES completion:nil];
}

- (IBAction)tapRateButton:(UIButton *)aSender {
    NSString *stringUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 1019522139];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
}

- (IBAction)tapLeaderboardsButton:(UIButton *)aSender {
    [[CAGameCenterManager sharedManager] presentLeaderboardsInViewController:self];
}

- (IBAction)tapIcons8Button:(UIButton *)sender {
    [CAUtilities openUrl:@"https://icons8.com/"];
}

#pragma mark - Game Center Delgate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
