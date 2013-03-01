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
    id __weak delegate;
    
    NSString *mailDestino;
    NSString *asunto;
    NSString *mensaje;
}

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) NSString *mailDestino;
@property (nonatomic, strong) NSString *asunto;
@property (nonatomic, strong) NSString *mensaje;


-(void) mostrarPanelDelEmail;

@end
