//
//  CASettingsViewController.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-08-02.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CASettingsViewController.h"
#import "CAAlertController.h"
#import "CAAppDelegate.h"
#import "CATapGame.h"
#import "CAUserSettings.h"
#import "CATexture.h"

@interface CASettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyControl;
@property (weak, nonatomic) IBOutlet UISwitch *kidsModeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UILabel *resetHighscoreLabel;

@end

@implementation CASettingsViewController

#define kSectionResetHighscore 1
#define kRowResetHighscore 1

- (CATapGame *)tapGame {
    return [(CAAppDelegate *)[[UIApplication sharedApplication] delegate] tapGame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.difficultyControl setSelectedSegmentIndex:[self tapGame].difficulty.controlIndex];
    [self.difficultyControl setEnabled:![[CAUserSettings sharedSettings] kidsMode]];
    [self.kidsModeSwitch setOn:[[CAUserSettings sharedSettings] kidsMode]];
    [self.soundSwitch setOn:![[CAUserSettings sharedSettings] muted]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSectionResetHighscore && indexPath.row == kRowResetHighscore)
        [self resetHighscore:[tableView cellForRowAtIndexPath:indexPath]];
}


#pragma mark - Events

- (IBAction)changeDifficulty:(UISegmentedControl *)aSender {
    [[self tapGame] setDifficultyForIndex:(CADifficultyIndex)aSender.selectedSegmentIndex];
}

- (IBAction)changeKidsMode:(UISwitch *)aSender {
    [[CAUserSettings sharedSettings] setKidsMode:aSender.on];
    [[CATexture sharedTexture] resetWithRadius:[CAUtilities buttonRadius]];
    [self.difficultyControl setEnabled:!aSender.on];
}

- (IBAction)changeSound:(UISwitch *)aSender {
    [[CAUserSettings sharedSettings] setMuted:!aSender.on];
}

- (void)resetHighscore:(UITableViewCell *)tappedCell {
    __weak typeof(self) weakSelf = self;
    
    CAAlertController *alert =
        [[CAAlertController new] initWithTitle:nil
                                       message:@"Reset highscore? This cannot be undone."
                             actionButtonTitle:@"Reset"
                                   actionBlock:^{
                                       [[CAUserSettings sharedSettings] setHighscore:0];
                                       [tappedCell setSelected:NO];
                                       [CAUtilities showAlertWithMessage:@"Highscore reset." view:weakSelf];
                                   }
                                   cancelBlock:^ {
                                       [tappedCell setSelected:NO];
                                   }
                                preferredStyle:UIAlertControllerStyleActionSheet
                                iPadSourceView:self.resetHighscoreLabel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
