//
//  TOARequestKernel.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TOARequestKernel.h"

#import "TAAPIClient.h"
#import <AFNetworking//UIImageView+AFNetworking.h>
#import "UIImage+CropCaptcha.h"

@implementation NSURLRequest(Helpers)
+(NSURLRequest *)requestWithString:(NSString *)url_string{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
}
@end


@interface TOARequestKernel()

@end


@implementation TOARequestKernel
#pragma mark - Singleton
+ (TOARequestKernel *)sharedRequestKernel {
    static dispatch_once_t pred;
    static TOARequestKernel *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[TOARequestKernel alloc] init];
    });
    return shared;
}


#pragma mark - Generic methods
-(void)reloadCaptcha{
    [[TAAPIClient sharedInstance] getPath:nil parameters:nil
       success:^(AFHTTPRequestOperation *operation, id JSON) {

           [self.captcha setImageWithURLRequest:[NSURLRequest requestWithString:JSON[@"captcha_url"]]
               placeholderImage:nil
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            self.captcha.image = [image usefulRectangle];
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            NSLog(@"FAIL image: %@", error.localizedDescription);
                        }
            ];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"ERROR: %@", error.localizedDescription); 
       }
     ];

}


-(void)doRequestForNumber:(NSString *)mobileNumber captcha:(NSString *)captchaStr
                  success:(void (^)(NSString *companyString))success
                  failure:(void (^)(NSError *error))failure{
    
    [[TAAPIClient sharedInstance] postPath:nil
                                parameters:@{@"mobile": mobileNumber, @"captcha_str": captchaStr}
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       if (JSON[@"result"][@"company"]){
                                           success(JSON[@"result"][@"company"]);
                                       }else if(JSON[@"errors"]){
                                           NSError *error = [NSError errorWithDomain:@"OperadorApp" code:1001 userInfo:@{NSLocalizedDescriptionKey : [(JSON[@"errors"]) description]}];
                                           failure(error);
                                       }else{
                                           NSError *error = [NSError errorWithDomain:@"OperadorApp" code:1001 userInfo:@{NSLocalizedDescriptionKey : @"Error desconocido"}];
                                           failure(error);
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       failure(error);
                                   }
     ];
    
}
@end