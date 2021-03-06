//
//  utility.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "TSHttpUtility.h"

@implementation TSHttpUtility

+(void)showToastWithMessage:(NSString *)message
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window makeToast:message];
}

+(NSString*)encodeString:(NSString *)string
{
    //return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    CFStringRef safeString = CFURLCreateStringByAddingPercentEscapes (
                                                                      NULL,
                                                                      (CFStringRef)string,
                                                                      NULL,
                                                                      CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                                                      kCFStringEncodingUTF8
                                                                      );
    return (__bridge NSString *)(safeString);
}

@end