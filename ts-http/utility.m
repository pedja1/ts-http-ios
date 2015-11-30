//
//  utility.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "utility.h"
#import "iToast.h"

@implementation Utility

+(void)showToastWithMessage:(NSString *)message
{
    NSLog(@"bla bla");
    [[iToast makeText:message] show];
}

@end