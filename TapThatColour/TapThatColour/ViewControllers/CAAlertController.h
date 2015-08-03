//
//  CAAlertController.h
//  AnglersLog
//
//  Created by Cohen Adair on 2015-04-09.
//  Copyright (c) 2015 Cohen Adair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAAlertController : UIAlertController

@property (strong, nonatomic)NSString *myTitle;
@property (strong, nonatomic)NSString *myMessage;
@property (strong, nonatomic)NSString *myActionButtonTitle;

@property (strong, nonatomic)void (^actionButtonBlock)();
@property (strong, nonatomic)void (^cancelBlock)();
@property (strong, nonatomic)void (^completionBlock)();

- (CAAlertController *)initWithTitle:(NSString *)aTitle
                             message:(NSString *)aMessage
                   actionButtonTitle:(NSString *)aButtonTitle
                         actionBlock:(void (^)())anActionBlock
                         cancelBlock:(void (^)())aCancelBlock
                      preferredStyle:(UIAlertControllerStyle)aStyle
                      iPadSourceView:(UIView *)aSourceView;

@end
