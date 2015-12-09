//
//  ts_http.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/27/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "TSHttp.h"

@implementation TSHttp

static BOOL logging = YES;

+(void)setLoggingEnabled:(BOOL)enabled
{
    logging = enabled;
}

+(BOOL)isLoggingEnabled
{
    return logging;
}

@end
