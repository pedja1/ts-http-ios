//
//  Internet.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "Internet.h"
#import "ts_http.h"
#import "utility.h"

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
                {
                    NSMutableString *params = [[NSMutableString alloc]init];
                    for (NSString *key in [requastBuilder.postParams allKeys])
                    {
                        [params appendString:@"&"];
                        [params appendString:key];
                        [params appendString:@"="];
                        [params appendString:[TSHttpUtility encodeString:[requastBuilder.postParams objectForKey:key]]];
                    }
                    NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                    [request addValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
                    [request setHTTPBody:postData];
                    break;
                }
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
    if([TSHttp isLoggingEnabled])
        NSLog(@"%@", [response toString]);
    return response;
}

@end
