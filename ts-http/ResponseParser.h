//
//  ResponseParser.h
//  ts-http
//
//  Created by Predrag Cokulov on 12/3/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface ResponseParser : NSObject

typedef enum responseStatus
{
    RESPONSE_STATUS_SUCCESS,
    RESPONSE_STATUS_SERVER_ERROR,
    RESPONSE_STATUS_RESPONSE_ERROR,
    RESPONSE_STATUS_CLIENT_ERROR
} ResponseStatus;

@property Response *response;
@property (readonly) id parseObject;

-(id)initWithResponse: (Response*)response;
-(id)initWitString: (NSString*)response;
-(int)getResponseStatus;
-(NSString*)getResponseMessage;

@end
