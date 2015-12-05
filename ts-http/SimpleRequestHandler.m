//
//  SimpleRequestHandler.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "SimpleRequestHandler.h"
#import "Response.h"
#import "Internet.h"
#import "MBProgressHUD.h"

@implementation SimpleRequestHandler

-(ResponseParser*)handleRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;
{
    Response *response = [Internet executeHttpRequestWithRequestBuilder:requestBuilder];
    return [[ResponseParser alloc]initWithResponse:response];
}

-(void)handlePreRequestWithRequestCode: (int)reqestCode sync: (BOOL)sync
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
}

-(void)handlePostRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder andResponseParser: (ResponseParser*) responseParser sync: (BOOL)sync
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

-(void)handleRequestCanceledWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:keyWindow animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

@end
