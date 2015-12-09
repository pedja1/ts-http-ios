//
//  network.h
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

typedef enum networkState
{
    ONLINE_3G,
    ONLINE_WIFI,
    OFFLINE
} NetworkState;

+(BOOL)isNetworkAvailable;

+(BOOL)isWifiConnected;

+(NetworkState)getNetworkState;

@end
