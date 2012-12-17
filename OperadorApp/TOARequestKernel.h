//
//  TOARequestKernel.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TANOTIF_CAPTCHA_LOADED          @"captchaCargado"
#define TANOTIF_CAPTCHA_ERROR_LOAD      @"errorAlCargarElCaptcha"

@interface TOARequestKernel : NSObject
@property (nonatomic, retain) UIImage *recaptcha;


+ (id)sharedRequestKernel;

-(void)reloadCaptcha;
-(void)doRequestForNumber:(NSString *)mobileNumber captcha:(NSString *)captchaStr
                  success:(void (^)(NSString *companyString))success
                  failure:(void (^)(NSError *error))failure;
@end