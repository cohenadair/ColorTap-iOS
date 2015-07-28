//
//  CAGameOverViewController.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-07-22.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAGameOverViewController.h"
#import "CAUserSettings.h"

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
    NSInteger highscore = [[CAUserSettings sharedSettings] highscore];
    if (self.score > highscore) {
        highscore = self.score;
        [[CAUserSettings sharedSettings] setHighscore:highscore];
    }
    
    [self.highscoreLabel setText:[NSString stringWithFormat:@"Highscore: %ld", (long)highscore]];
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

@end
