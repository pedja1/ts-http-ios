//
//  request_builder.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/1/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "request_builder.h"

@implementation RequestBuilder

static NSString *DEFAULT_REQUEST_URL = nil;
static ResponseMessagePolicy *DEFAULT_RESPONSE_MESSAGE_POLICY;

@synthesize retriesLeft = _retriesLeft;
@synthesize urlParts = _urlParts;
@synthesize requestBody = _requestBody;

-(id)initWithMethod: (Method)method
{
    self = [super init];
    if (self)
    {
        self.contentType = @"text/plain";
        self.fileParamName = @"file";
        self.maxRetires = 3;
        self.requestUrl = [RequestBuilder getDefaultRequestUrl];
        _retriesLeft = self.maxRetires;
        self.method = method;
        self.responseMessagePolicy = DEFAULT_RESPONSE_MESSAGE_POLICY;
        _urlParts = [[NSMutableString alloc] init];
    }
    return self;
}

+(NSString*)getDefaultRequestUrl
{
    return DEFAULT_REQUEST_URL;
}

+(void)setDefaultRequestUrl: (NSString*)requestUrl
{
    DEFAULT_REQUEST_URL = requestUrl;
}

+ (void) initialize
{
    if (self == [RequestBuilder class])
    {
        DEFAULT_RESPONSE_MESSAGE_POLICY = [[ResponseMessagePolicy alloc] init];
        DEFAULT_RESPONSE_MESSAGE_POLICY.showErrorMessages = TRUE;
        DEFAULT_RESPONSE_MESSAGE_POLICY.showSuccessMessages = TRUE;
    }
}

-(void)setRequestBody:(NSString *)requestBody
{
    _requestBody = requestBody;
    if([_requestBody length] > 0)
    {
        self.postMethod = FORM_DATA;
    }
}

-(NSString*)getRequestBody
{
    return self.requestBody;
}

@end