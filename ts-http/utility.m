//
//  utility.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "utility.h"

@implementation Utility

+(void)showToastWithMessage:(NSString *)message
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window makeToast:message];
}

@end