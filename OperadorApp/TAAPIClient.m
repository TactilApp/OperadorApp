//
//  TAAPIClient.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 1/3/13.
//  Copyright (c) 2013 TactilApp.com. All rights reserved.
//

#import "TAAPIClient.h"


@implementation TAAPIClient
#define     API_URL @"http://operadorapp.herokuapp.com"


+ (id)sharedInstance {
    static TAAPIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[TAAPIClient alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
//        [self setDefaultHeader:@"x-api-token" value:BeersAPIToken];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}


@end