//
//  Request.h
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "request_builder.h"

@interface Request : NSObject

@property RequestBuilder* requestBuilder;
@property int requestCode;
@property BOOL cancelled;

@end
