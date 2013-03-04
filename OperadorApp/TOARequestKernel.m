//
//  TOARequestKernel.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TOARequestKernel.h"

#import "TAAPIClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+CropCaptcha.h"

@implementation NSURLRequest(Helpers)

+(NSURLRequest *)requestWithString:(NSString *)url_string{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
}

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
    self.captcha.image = nil;
    
    [[TAAPIClient sharedInstance] getPath:nil parameters:nil
       success:^(AFHTTPRequestOperation *operation, id JSON) {

           [self.captcha setImageWithURLRequest:[NSURLRequest requestWithString:JSON[@"captcha_url"]]
               placeholderImage:nil
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                            self.captcha.image = [image usefulRectangle];
                            [TAHelper registrarEvento:@"Carga Imagen" parametros:@{@"resultado" : @"OK"}];
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            [TAHelper registrarEvento:@"Carga Imagen"
                                           parametros:@{@"resultado" : @"NO", @"error" : error.localizedDescription, @"url" : request.URL.absoluteString}];
                        }
            ];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           [TAHelper registrarEvento:@"Error request" parametros:@{@"tipo" : @"GET", @"error": error.localizedDescription}];
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
                   NSMutableString *errorStr = [NSMutableString string];
                   for (NSString *jsonError in JSON[@"errors"]){
                       [errorStr appendFormat:@"%@\n", jsonError];
                   }
                    NSError *error = [NSError errorWithDomain:@"OperadorApp" code:1001 userInfo:@{NSLocalizedDescriptionKey : errorStr}];
                    [TAHelper registrarEvento:@"Error request" parametros:@{@"tipo" : @"POST", @"error": error.localizedDescription}];
                   failure(error);
               }else{
                   NSMutableString *errorStr = [NSMutableString string];
                   for (NSString *jsonError in JSON[@"errors"]){
                       [errorStr appendFormat:@"%@\n", jsonError];
                   }
                   NSError *error = [NSError errorWithDomain:@"OperadorApp" code:1002 userInfo:@{NSLocalizedDescriptionKey : errorStr}];
                   [TAHelper registrarEvento:@"Error request" parametros:@{@"tipo" : @"POST", @"error": error.localizedDescription}];
                   failure(error);
               }
               
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [TAHelper registrarEvento:@"Error request" parametros:@{@"tipo" : @"POST", @"error": error.localizedDescription}];
               failure(error);
           }
     ];
    
}
@end