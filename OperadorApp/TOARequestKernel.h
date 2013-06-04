//
//  TOARequestKernel.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TOARequestKernel : NSObject
    @property (nonatomic, weak) UIImageView *captcha;


    + (id)sharedRequestKernel;

    -(void)reloadCaptcha;
    -(void)doRequestForNumber:(NSString *)mobileNumber captcha:(NSString *)captchaStr
                  success:(void (^)(NSString *companyString, NSString *topColor, NSString *bottomColor))success
                  failure:(void (^)(NSError *error))failure;
@end