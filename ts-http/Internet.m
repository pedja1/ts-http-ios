//
//  Internet.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "Internet.h"

@implementation Internet

+(Response*)executeHttpRequestWithRequestBuilder: (RequestBuilder*)requastBuilder
{
    return [self executeHttpRequestWithRequestBuilder:requastBuilder toString:true];
}

+(Response*)executeHttpRequestWithRequestBuilder: (RequestBuilder*)requastBuilder toString: (BOOL)toString;
{
    Response *response = [[Response alloc]init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL
                                         URLWithString:[requastBuilder getRequestUrl]]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10
     ];
    
    for(NSString *key in requastBuilder.headers.allKeys)
    {
        [request addValue:[requastBuilder.headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    
    switch (requastBuilder.method)
    {
        case PUT:
            [request setHTTPMethod: @"PUT"];
#warning put?
            break;
        case POST:
            [request setHTTPMethod: @"POST"];
            switch (requastBuilder.postMethod)
            {
                case BODY:
                    break;
                case X_WWW_FORM_URL_ENCODED:
                    break;
                case FORM_DATA:
                    break;
            }
            break;
        case GET:
            [request setHTTPMethod: @"GET"];
            break;
        case DELETE:
            [request setHTTPMethod: @"DELETE"];
            break;
    }
    
    NSError *requestError = nil;
    NSHTTPURLResponse *urlResponse = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse error:&requestError];
    response.responseData = responseData;
    response.code = [urlResponse statusCode];
    
    if(requestError != nil)
    {
        response.responseMessage = [requestError description];
    }
    
    if(toString)
    {
        response.responseDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    return response;
}

@end
