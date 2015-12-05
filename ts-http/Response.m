//
//  Response.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "Response.h"

@implementation Response

static BOOL printResponse;

+ (void) initialize
{
    if (self == [Response class])
    {
        printResponse = true;
    }
}

+(void) setPrintResponse:(BOOL)enabled
{
    printResponse = enabled;
}

-(BOOL)isResponseOk
{
    return self.code > 0 && self.code < 400;
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"code='%d', responseMessage='%@', responseData='%@'", self.code, self.responseMessage, printResponse ? self.responseData : nil];
}

@end
