//
//  CAAlertController.m
//  TapThatColour
//
//  Created by Cohen Adair on 2015-04-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import "CAAlertController.h"

@interface CAAlertController ()

@end

@implementation CAAlertController

- (CAAlertController *)initWithTitle:(NSString *)aTitle
                              message:(NSString *)aMessage
                    actionButtonTitle:(NSString *)aButtonTitle
                          actionBlock:(void (^)())anActionBlock
                          cancelBlock:(void (^)())aCancelBlock
                      preferredStyle:(UIAlertControllerStyle)aStyle {
    
    if ((self = (CAAlertController *)[UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:aStyle])) {
        UIAlertAction *action =
            [UIAlertAction actionWithTitle:aButtonTitle
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *a) {
                                       if (anActionBlock)
                                           anActionBlock();
                                   }];
        
        UIAlertAction *cancelAction =
            [UIAlertAction actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *a) {
                                       if (aCancelBlock)
                                           aCancelBlock();
                                   }];
        
        [self addAction:action];
        [self addAction:cancelAction];
    }
    
    return self;
}

@end
