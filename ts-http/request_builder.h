//
//  request_builder.h
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

typedef enum method
{
    POST,
    PUT,
    GET,
    DELETE
}: Method;

typedef enum postMethod
{
    BODY,
    X_WWW_FORM_URL_ENCODED,
    FORM_DATE
}: PostMethod;

NSMutableString urlParts;
Method method;
NSMutableDictionary urlParams;

-(id)initWithMethod: (Method *)method;


@end
