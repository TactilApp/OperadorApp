//
//  TOARequestKernel.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOARequestKernel : NSObject
@property (nonatomic, retain) UIImage *recaptcha;
-(void)doRequestWithCaptcha:(UIImageView *)captchaImgView;
@end