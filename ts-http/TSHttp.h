//
//  ts_http.h
//  ts-http
//
//  Created by Predrag Cokulov on 11/27/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSHttp : NSObject

+ (void) setLoggingEnabled:(BOOL)enabled;
+ (BOOL) isLoggingEnabled;

@end
