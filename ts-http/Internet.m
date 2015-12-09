//
//  Internet.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "Internet.h"
#import "TSHttp.h"
#import "TSHttpUtility.h"
#import "file.h"

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
                {
                    if (requastBuilder.requestBody == nil)
                        @throw [NSException
                         exceptionWithName:@"NSInvalidArgumentException"
                         reason:@"requestBody cannot be nil if post method is BODY"
                         userInfo:nil];
                    NSData *postData = [requastBuilder.requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                    [request setHTTPBody:postData];
                    [request addValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
                    break;
                }
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
                {
                    NSString *boundary = @"---------------------------14737809831466499882746641449";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
                    
                    NSMutableData *body = [NSMutableData data];
                    for (NSString *key in [requastBuilder.postParams allKeys])
                    {
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, [requastBuilder.postParams objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    for (File *file in requastBuilder.files)
                    {
                        NSError *fileLoadingError;
                        NSData* data = [NSData dataWithContentsOfURL:file.url options:NSDataReadingUncached error:&fileLoadingError];
                        if(!fileLoadingError)
                        {
                            [body appendData:[[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", requastBuilder.fileParamName, file.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[NSData dataWithData:data]];
                        }
                    }
                    
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [request setHTTPBody:body];
                    break;
                }
            }
            break;
        case GET:
            [request setHTTPMethod: @"GET"];
            break;
        case DELETE:
            [request setHTTPMethod: @"DELETE"];
            [request addValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
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
