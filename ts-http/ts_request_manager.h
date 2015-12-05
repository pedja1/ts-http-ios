//
//  Request.h
//  ts-http
//
//  Created by Predrag Cokulov on 12/2/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "response_parser.h"
#import "request_builder.h"

@class TSRequestManager;

@protocol ResponseHandlerDelegate <NSObject>

- (void) onResponseWithRequestCode: (int) requestCode andResponseStatus: (int) responseStatus andResponseParser: (ResponseParser*) responseParser;

@end

@protocol RequestHandlerDelegate <NSObject>

-(ResponseParser*)handleRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;

-(void)handlePreRequestWithRequestCode: (int)reqestCode sync: (BOOL)sync;

-(void)handlePostRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder andResponseParser: (ResponseParser*) responseParser sync: (BOOL)sync;

-(void)handleRequestCanceledWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder sync: (BOOL)sync;

@end

@protocol NoInternetConnectionHandlerDelegate <NSObject>

- (void) handleNoInternetConnection;

@end

@interface TSRequestManager : NSObject

@property (strong, nonatomic) id <ResponseHandlerDelegate> responseHandlerDelegate;
@property (strong, nonatomic) id <RequestHandlerDelegate> requestHandlerDelegate;
@property (strong, nonatomic) id <NoInternetConnectionHandlerDelegate> noInternetConnectionHandler;
@property (readonly) BOOL sync;

-(id)init: (BOOL)syncExecution;
-(id)init;

-(ResponseParser*)executeRequestWithRequestCode: (int)requestCode andRequestBuilder: (RequestBuilder*)requestBuilder;
-(void)cancelRequestWithRequestCode: (int)requestCode andCancelOtherRequestsWithSameCode: (BOOL)cancel;
-(void)cancelAllRequests;

@end
