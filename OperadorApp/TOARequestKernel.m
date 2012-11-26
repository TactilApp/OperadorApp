//
//  TOARequestKernel.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TOARequestKernel.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define URL_CMT     @"http://www.cmt.es/pmovil/SelectOption.do"
#define URL_JS      @"http://api.recaptcha.net/challenge?k=6LfgLNkSAAAAAMp-P85nbmpfAiIS6xDwWwYZSsux"


@implementation TOARequestKernel
-(void)doRequest{
//        [[UIImageView alloc] setImageWithURL:[NSURL URLWithString:@"http://api.recaptcha.net/challenge?k=6LfgLNkSAAAAAMp-P85nbmpfAiIS6xDwWwYZSsux"]];
    
    
    NSMutableURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CMT]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Clase: %@", operation.responseString);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }
    ];
//    [operation start];

    
    AFHTTPRequestOperation *javascriptOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_JS]]];
    [javascriptOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Clase: %@", operation.responseString);
        
        
        NSString *strSource = operation.responseString;
        NSError *errRegex = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"challenge : '([A-Z0-9a-z._%+-]*)'"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&errRegex];
        
        [regex enumerateMatchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)
            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                NSLog(@"Challenge: %@", [strSource substringWithRange:[result rangeAtIndex:1]]);
            }
         ];
//        
//
//        
//        NSUInteger countMatches = [regex numberOfMatchesInString:strSource options:0 range:NSMakeRange(0, [strSource length])];
//        NSLog(@"Number of Matches: %d", countMatches);
//        
//        NSLog(@"-----");
//        
//        [regex enumerateMatchesInString:strSource options:0
//                                  range:NSMakeRange(0, [strSource length])
//                             usingBlock:^(NSTextCheckingResult *match,
//                                          NSMatchingFlags flags, BOOL *stop) {
//                                 NSLog(@"Ranges: %d", [match numberOfRanges]);
//                                 
//                                 NSString *matchFull = [strSource substringWithRange:[match range]];
//                                 NSLog(@"Match: %@", matchFull);
//                                 
//                                 for (int i = 0; i < [match numberOfRanges]; i++) {
//                                     NSLog(@"\tRange %i: %@", i, [strSource substringWithRange:[match rangeAtIndex:i]]);
//                                 }                              
//                             }];
        
        if (errRegex) {
            NSLog(@"%@", errRegex);
        }
        
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [javascriptOperation start];
    
}
@end