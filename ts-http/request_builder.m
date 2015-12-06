//
//  request_builder.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/1/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "request_builder.h"
#import "ts_http.h"
#import "utility.h"

@implementation RequestBuilder

static NSString *DEFAULT_REQUEST_URL = nil;
static ResponseMessagePolicy *DEFAULT_RESPONSE_MESSAGE_POLICY;

@synthesize retriesLeft = _retriesLeft;
@synthesize urlParts = _urlParts;
@synthesize urlParams = _urlParams;
@synthesize postParams = _postParams;
@synthesize requestBody = _requestBody;
@synthesize postMethod = _postMethod;
@synthesize files = _files;
@synthesize maxRetries = _maxRetries;
@synthesize requestUrl = _requestUrl;

-(id)init
{
    return [self initWithMethod: GET];
}

-(id)initWithMethod: (Method)method
{
    self = [super init];
    if (self)
    {
        _contentType = @"text/plain";
        _fileParamName = @"file";
        _maxRetries = 3;
        _requestUrl = [RequestBuilder getDefaultRequestUrl];
        _retriesLeft = _maxRetries;
        _method = method;
        _postMethod = X_WWW_FORM_URL_ENCODED;
        _responseMessagePolicy = DEFAULT_RESPONSE_MESSAGE_POLICY;
        _urlParts = [[NSMutableString alloc] init];
        _urlParams = [[NSMutableDictionary alloc] init];
        _postParams = [[NSMutableDictionary alloc] init];
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

- (void)setPostMethod:(PostMethod)postMethod
{
    _postMethod = postMethod;
    if(postMethod != BODY && [_requestBody length] > 0)
    {
        if([TSHttp isLoggingEnabled])NSLog(@"Warning. requestBody is not empty, it will be ignored since new PostMethod is not PostMethod.BODY");
    }
    if(postMethod != FORM_DATA && (_files != nil && [_files count] > 0))
    {
        if([TSHttp isLoggingEnabled])NSLog(@"Warning. Files will be ignored since new PostMethod is not PostMethod.FORM_DATA");
    }
}

- (PostMethod)getPostMethod
{
    return _postMethod;
}

-(void)setFiles:(NSArray *)files
{
    _files = files;
    if([_files count] > 0)
    {
        self.postMethod = FORM_DATA;
    }
}

-(NSArray*)getFiles
{
    return self.files;
}

-(void)setMaxRetries:(NSInteger)maxRetries
{
    _maxRetries = maxRetries;
    _retriesLeft = maxRetries;
}

-(NSInteger)getMaxRetries
{
    return self.maxRetries;
}

-(void)addParamWithKey: (NSString*)key andValue: (NSString*)value;
{
    [self addParamWithKey:key andValue:value forceAddToUrl:false];
}

-(void)addParamWithKey: (NSString*)key andValue: (NSString*)value forceAddToUrl: (BOOL)force
{
    if([key length] == 0 || [value length] == 0)
    {
        if([TSHttp isLoggingEnabled])NSLog(@"RequestBuilder >> addParam : param not set");
        return;
    }
    if(force || _method == GET || _method == DELETE)
    {
        [_urlParams setObject:value forKey:[TSHttpUtility encodeString:key]];
    }
    else if(_method == POST || _method == PUT)
    {
        [_postParams setObject:value forKey:key];
    }
}

-(void)addUrlPart: (NSString*)part
{
    if([part length] == 0)
    {
        if([TSHttp isLoggingEnabled])NSLog(@"RequestBuilder >> addParam : param not set");
        return;
    }
    if([_urlParts length] == 0)
    {
        if(_requestUrl != nil && ![_requestUrl hasSuffix: @"/"])
            [_urlParts appendString:@"/"];
    }
    else if(![_requestUrl hasSuffix: @"/"])
    {
        [_urlParts appendString:@"/"];
    }
    [_urlParts appendString:part];
}

-(NSString*)getUrlParams
{
    NSMutableString *tmpString = [[NSMutableString alloc] init];
    [tmpString appendString:_urlParts];
    for(NSString *key in _urlParams)
    {
        if([tmpString rangeOfString:@"?"].location == NSNotFound)
            [tmpString appendString: @"?"];
        else
            [tmpString appendString: @"&"];
        [tmpString appendString: key];
        [tmpString appendString: @"="];
        [tmpString appendString: [_urlParams objectForKey:key]];
    }
    return tmpString;
}

-(NSString*)getRequestUrl
{
    return [NSString stringWithFormat:@"%@%@", _requestUrl, [self getUrlParams]];
}

-(NSString*) getParamWithKey: (NSString*)key
{
    NSString *urlParam = [_urlParams objectForKey:key];
    if(urlParam != nil)
        return urlParam;
    NSString *postParam = [_postParams objectForKey:key];
    if(postParam != nil)
        return postParam;
    return nil;
}

@end