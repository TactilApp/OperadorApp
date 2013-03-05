//
//  TAAPIClient.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 1/3/13.
//  Copyright (c) 2013 TactilApp.com. All rights reserved.
//

#import "TAAPIClient.h"

@implementation TAAPIClient

#define     API_URL @"http://operadorapp.com/api/v1"

TAAPIClient *__sharedInstance;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[TAAPIClient alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    });
    
    return __sharedInstance;
}

+ (id)sharedInstance:(NSURL *)url {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[TAAPIClient alloc] initWithBaseURL:url];
    });
    
    return __sharedInstance;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}
@end