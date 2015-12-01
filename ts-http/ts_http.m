//
//  ts_http.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/27/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "ts_http.h"

@implementation TSHttp

static BOOL logging;

+(void)setLoggingEnabled:(BOOL)enabled
{
    logging = enabled;
}

@end
