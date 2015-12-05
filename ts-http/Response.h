//
//  Response.h
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property NSInteger code;
@property NSString *responseMessage;
@property NSString *responseDataString;
@property NSString *request;
@property NSData *responseData;

-(BOOL)isResponseOk;
-(NSString*)toString;

+(void) setPrintResponse:(BOOL)enabled;

@end
