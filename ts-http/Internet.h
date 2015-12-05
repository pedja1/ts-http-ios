//
//  Internet.h
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "request_builder.h"

@interface Internet : NSObject

+(Response*)executeHttpRequestWithRequestBuilder: (RequestBuilder*)requastBuilder;

+(Response*)executeHttpRequestWithRequestBuilder: (RequestBuilder*)requastBuilder toString: (BOOL)toString;

@end
