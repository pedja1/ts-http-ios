//
//  Request.m
//  ts-http
//
//  Created by Predrag Cokulov on 12/2/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import "ts_request_manager.h"
#import "NoInternetConnectionHandler.h"
#import "SimpleRequestHandler.h"
#import "utility.h"
#import "network.h"
#import "request.h"

@interface TSRequestManager()

@property (atomic) NSMutableArray *taskQue;
@property (atomic) NSMutableDictionary *runningTasks;

-(Request*)getRequestWithCode: (int)requestCode;

-(void)executeRequestAsync: (Request*)request;

-(void)handlePostRequestWithRequestCode: (int)requestCode andRequestBuilder:(RequestBuilder *)requestBuilder andResponseParser:(ResponseParser *)responseParser sync:(BOOL)sync;
-(ResponseParser*)handleRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;
-(BOOL)handlePreRequestWithRequestCode: (int)reqestCode sync: (BOOL)sync;
-(void)handleRequestCanceledWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;

@end

@implementation TSRequestManager

@synthesize requestHandlerDelegate = _requestHandlerDelegate;
@synthesize responseHandlerDelegate = _responseHandlerDelegate;
@synthesize noInternetConnectionHandler = _noInternetConnectionHandler;


-(id)init: (BOOL)syncExecution
{
    if(self = [super init])
    {
        _sync = syncExecution;
        if(!syncExecution)
        {
            _taskQue = [[NSMutableArray alloc]init];
            _runningTasks = [[NSMutableDictionary alloc]init];
            NoInternetConnectionHandler *nHandler = [[NoInternetConnectionHandler alloc]init];
            _noInternetConnectionHandler = nHandler;
            SimpleRequestHandler *requestHandler = [[SimpleRequestHandler alloc]init];
            _requestHandlerDelegate = requestHandler;
        }
    }
    return self;
}

-(id)init
{
    return [self init:false];
}

-(ResponseParser*)executeRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder
{
    if (self.sync)
    {
        BOOL canContinue = [self handlePreRequestWithRequestCode:requestCode sync:self.sync];
        if(canContinue)
        {
            ResponseParser *responseParser = [self handleRequestWithRequestCode:requestCode andRequestBuilder:requestBuilder sync:self.sync];
            [self handlePostRequestWithRequestCode:requestCode andRequestBuilder:requestBuilder andResponseParser:responseParser sync:self.sync];
            return responseParser;
        }
        return nil;
    }
    else
    {
        Request *request = [[Request alloc] init];
        request.requestCode = requestCode;
        request.requestBuilder = requestBuilder;
        
        if ([self.runningTasks objectForKey:[NSNumber numberWithInt:requestCode]] != nil)//task exists
        {
            [self.taskQue addObject:request];// add task to queue, don't execute it
        }
        else
        {
            [self.runningTasks setObject:request forKey:[NSNumber numberWithInt:requestCode]];//add this task to list of running tasks
            [self executeRequestAsync: request];//execute task async
        }
        
        return nil;
    }
}

-(void)executeRequestAsync:(Request *)request
{
    if(request.cancelled)
    {
        [self handleRequestCanceledWithRequestCode:request.requestCode andRequestBuilder:request.requestBuilder sync:self.sync];
        return;
    }
        BOOL canContinue = [self handlePreRequestWithRequestCode:request.requestCode sync:self.sync];
        if(!request.cancelled && canContinue)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                if(!request.cancelled)
                {
                    ResponseParser *responseParser = [self handleRequestWithRequestCode:request.requestCode andRequestBuilder:request.requestBuilder sync:self.sync];
                    if(!request.cancelled)
                    {
                        [self handlePostRequestWithRequestCode:request.requestCode andRequestBuilder:request.requestBuilder andResponseParser:responseParser sync:self.sync];
                    }
                    else
                    {
                        [self handleRequestCanceledWithRequestCode:request.requestCode andRequestBuilder:request.requestBuilder sync:self.sync];
                    }
                }
                else
                {
                    [self handleRequestCanceledWithRequestCode:request.requestCode andRequestBuilder:request.requestBuilder sync:self.sync];
                }
            });
        }
        else
        {
            [self handleRequestCanceledWithRequestCode:request.requestCode andRequestBuilder:request.requestBuilder sync:self.sync];
        }
}


-(void)handlePostRequestWithRequestCode: (int)requestCode andRequestBuilder:(RequestBuilder *)requestBuilder andResponseParser:(ResponseParser *)responseParser sync:(BOOL)sync
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        if(responseParser != nil)
        {
            if ([responseParser getResponseStatus] == RESPONSE_STATUS_SUCCESS)
            {
                if([responseParser getResponseMessage] != nil && (requestBuilder.responseMessagePolicy == nil || requestBuilder.responseMessagePolicy.showSuccessMessages))
                    [TSHttpUtility showToastWithMessage: [responseParser getResponseMessage]];
            }
            else
            {
                if(requestBuilder.responseMessagePolicy == nil || requestBuilder.responseMessagePolicy.showErrorMessages)
                {
                    NSString *responseMessage = [responseParser getResponseMessage];
                    [TSHttpUtility showToastWithMessage:responseMessage != nil ? responseMessage : @"An error occurred, please try again."];
                }
            }
        }
        if ([self.responseHandlerDelegate respondsToSelector:@selector(onResponseWithRequestCode:andResponseStatus:andResponseParser:)])
        {
            [self.responseHandlerDelegate onResponseWithRequestCode:requestCode andResponseStatus:[responseParser getResponseStatus] andResponseParser:responseParser];
        }
        if ([self.requestHandlerDelegate respondsToSelector:@selector(handlePostRequestWithRequestCode:andRequestBuilder:andResponseParser:sync:)])
        {
            [self.requestHandlerDelegate handlePostRequestWithRequestCode:requestCode andRequestBuilder:requestBuilder andResponseParser:responseParser sync:sync];
        }
    });
    
    if (!sync)
    {
        [self.runningTasks removeObjectForKey: [NSNumber numberWithInt:requestCode]];// remove this task from running tasks list
            
            //We only added tasks to queue if it already exists in runningTasks
            //We check here if there is a task in taskQueue with same id as this one, remove it from queue and execute it
        Request *request = [self getRequestWithCode:requestCode];
        if (request != nil)
        {
            [self.taskQue removeObject:request];
            if ([self.runningTasks objectForKey:[NSNumber numberWithInt:request.requestCode]] != nil)//task exists
            {
                [self.taskQue addObject:request];// add task to queue, don't execute it
            }
            else
            {
                [self.runningTasks setObject:request forKey:[NSNumber numberWithInt:request.requestCode]];//add this task to list of running tasks
                [self executeRequestAsync:request];//execute task
            }
        }
        
    }
}

-(ResponseParser*)handleRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;
{
    if ([self.requestHandlerDelegate respondsToSelector:@selector(handleRequestWithRequestCode:andRequestBuilder:sync:)])
    {
        return [self.requestHandlerDelegate handleRequestWithRequestCode:requestCode andRequestBuilder:requestBuilder sync:sync];
    }
    return nil;
}

-(BOOL)handlePreRequestWithRequestCode: (int)reqestCode sync: (BOOL)sync;
{
    if(![Network isNetworkAvailable])
    {
        if ([self.noInternetConnectionHandler respondsToSelector:@selector(handleNoInternetConnection)])
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.noInternetConnectionHandler handleNoInternetConnection];
            });
        }
        return false;
    }
    if ([self.requestHandlerDelegate respondsToSelector:@selector(handlePreRequestWithRequestCode:sync:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.requestHandlerDelegate handlePreRequestWithRequestCode:reqestCode sync:sync];
        });
    }
    return true;
}

-(void)handleRequestCanceledWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if ([self.requestHandlerDelegate respondsToSelector:@selector(handleRequestCanceledWithRequestCode:andRequestBuilder:sync:)])
        {
            [self.requestHandlerDelegate handleRequestCanceledWithRequestCode:requestCode andRequestBuilder:requestBuilder sync:sync];
        }
    });
}

-(void)cancelRequestWithRequestCode: (int)requestCode andCancelOtherRequestsWithSameCode: (BOOL)cancel
{
    Request *request;
    if ((request = [self.runningTasks objectForKey:[NSNumber numberWithInt:requestCode]]) != nil)
    {
        request.cancelled = true;
        [self.runningTasks removeObjectForKey:[NSNumber numberWithInt:requestCode]];
        if (cancel)//this will also cancel all other not yet executed tasks with same id
        {
            for(NSInteger i = self.taskQue.count - 1; i >= 0; i--)
            {
                if(((Request*)[self.taskQue objectAtIndex:i]).requestCode == requestCode)
                {
                    [self.taskQue removeObjectAtIndex:i];
                }
            }
        }
    }
}

-(void)cancelAllRequests
{
    if (!self.sync)
    {
        for(NSNumber *requestCode in [self.runningTasks allKeys])
        {
            ((Request*)[self.runningTasks objectForKey:requestCode]).cancelled = true;
            [self.runningTasks removeObjectForKey:requestCode];
        }
    }
}

-(Request*)getRequestWithCode:(int)requestCode
{
    for (Request* request in self.taskQue)
    {
        if (request.requestCode == requestCode)
        {
            return request;
        }
    }
    return nil;
}

@end
