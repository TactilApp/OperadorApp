//
//  EnviarMail.h
//  operadorAppGH
//
//  Created by Jorge Maroto García on 11/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define TITULO_VENTANA @"Soporte"

@interface EnviarMail : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> {
    id delegate;
    
    NSString *mailDestino;
    NSString *asunto;
    NSString *mensaje;
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSString *mailDestino;
@property (nonatomic, retain) NSString *asunto;
@property (nonatomic, retain) NSString *mensaje;


-(void) mostrarPanelDelEmail;

@end
