//
//  request_builder.h
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "file.h"
#import "response_message_policy.h"

@interface RequestBuilder : NSObject

typedef enum method
{
    POST,
    PUT,
    GET,
    DELETE
} Method;

typedef enum postMethod
{
    BODY,
    X_WWW_FORM_URL_ENCODED,
    FORM_DATA
} PostMethod;

#pragma mark - properties

@property (readonly) NSMutableString *urlParts;
@property (readonly) NSMutableDictionary *urlParams;
@property (readonly) NSMutableDictionary *postParams;
@property (readonly) NSMutableDictionary *headers;
@property (readonly) NSInteger retriesLeft;
@property NSString *contentType;
@property NSString *requestUrl;
@property (setter=setRequestBody:, getter=getRequestBody)NSString *requestBody;
@property NSString *fileParamName;
@property NSInteger maxRetires;
@property Method method;
@property PostMethod postMethod;
@property ResponseMessagePolicy *responseMessagePolicy;

#pragma mark - constructor

-(id)initWithMethod: (Method)method;

#pragma mark - methods

+ (NSString*)getDefaultRequestUrl;
+ (void)setDefaultRequestUrl: (NSString*)requestUrl;

- (void)setRequestBody:(NSString *)requestBody;
- (NSString*)getRequestBody;

@end
