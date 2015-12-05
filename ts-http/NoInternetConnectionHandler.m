//
//  NoInternetConnectionHandler.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "NoInternetConnectionHandler.h"
#import <UIKit/UIKit.h>

@interface NoInternetConnectionHandler()

@property BOOL alertShowing;

@end

@implementation NoInternetConnectionHandler


- (void) handleNoInternetConnection
{
    if(_alertShowing)
        return;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                        message:@"An internet connection is required to continue.\n\nPlease check if your device is connected and try again"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alert show];
    _alertShowing = true;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _alertShowing = false;
}

@end
