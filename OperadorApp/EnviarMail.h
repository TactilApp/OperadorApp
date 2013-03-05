//
//  EnviarMail.h
//  operadorAppGH
//
//  Created by Jorge Maroto García on 11/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface EnviarMail : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

    +(EnviarMail *)mailASoporteConDelegado:(UIViewController *)delegate;
    -(void)mostrarPanelDelEmail;
@end