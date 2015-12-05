//
//  NoInternetConnectionHandler.h
//  ts-http
//
//  Created by Predrag Cokulov on 12/5/15.
//  Copyright © 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ts_request_manager.h"
#import <UIKit/UIKit.h>

@interface NoInternetConnectionHandler : NSObject <NoInternetConnectionHandlerDelegate, UIAlertViewDelegate>

- (void) handleNoInternetConnection;

@end
