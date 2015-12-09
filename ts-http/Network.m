//
//  network.m
//  ts-http
//
//  Created by Predrag Cokulov on 11/28/15.
//  Copyright (c) 2015 Predrag Cokulov. All rights reserved.
//

#import "network.h"
#import "Reachability.h"

@implementation Network

+(BOOL)isNetworkAvailable
{
    return [Network getNetworkState] != OFFLINE;
}

+(BOOL)isWifiConnected
{
    return [Network getNetworkState] == ONLINE_WIFI;
}

+(NetworkState)getNetworkState
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == ReachableViaWiFi)
    {
        return ONLINE_WIFI;
    }
    else if (status == ReachableViaWWAN)
    {
        return ONLINE_3G;
    }
    else
    {
        return OFFLINE;
    }
}

@end