//
//  TAAPIClient.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 1/3/13.
//  Copyright (c) 2013 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface TAAPIClient : AFHTTPClient
    +(TAAPIClient *)sharedInstance;
    + (id)sharedInstance:(NSURL *)url;
@end
