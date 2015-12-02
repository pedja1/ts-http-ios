//
//  utility.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "utility.h"

@implementation TSHttpUtility

+(void)showToastWithMessage:(NSString *)message
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window makeToast:message];
}

+(NSString*)encodeString:(NSString *)string
{
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@end