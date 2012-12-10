//
//  TOARequestKernel.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TANOTIF_CAPTCHA_LOADED             @"captchaCargado"

@interface TOARequestKernel : NSObject
@property (nonatomic, retain) UIImage *recaptcha;

-(void)reloadCaptcha;
-(void)doRequestForNumber:(NSString *)mobileNumber captcha:(NSString *)captchaStr;
@end