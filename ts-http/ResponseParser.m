//
//  ResponseParser.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/3/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "ResponseParser.h"

@implementation ResponseParser


-(id)initWithResponse: (Response*)response
{
    if (self = [super init])
    {
        self.response = response;
    }
    return self;
}

-(id)initWitString: (NSString*)response
{
    if (self = [super init])
    {
        _response = [[Response alloc] init];
        _response.code = 200;
        _response.request = nil;
        _response.responseData = response;
        _response.responseMessage = nil;
    }
    return self;
}

-(id)init
{
    NSException* e = [NSException
                                exceptionWithName:@"NSInvalidStateException"
                                reason:@"'init' is nit supported in ResponseParser. Use either 'initWithResponse' or 'initWithString'"
                                userInfo:nil];
    @throw e;
}

-(int)getResponseStatus
{
    if(self.response.code < 0)
        return RESPONSE_STATUS_CLIENT_ERROR;
    else if(self.response.code < 400)
        return RESPONSE_STATUS_SUCCESS;
    else
        return RESPONSE_STATUS_SERVER_ERROR;
}

-(NSString*)getResponseMessage;
{
    return self.response.responseMessage;
}

@end
