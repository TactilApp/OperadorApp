//
//  EnviarMail.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 11/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "EnviarMail.h"

@interface EnviarMail()

    @property (nonatomic, strong) UIViewController *delegate;

    @property (nonatomic, strong) NSString *mailDestino;
    @property (nonatomic, strong) NSString *asunto;
    @property (nonatomic, strong) NSString *mensaje;

@end


@implementation EnviarMail

+(EnviarMail *)mailASoporteConDelegado:(UIViewController *)delegate{
    EnviarMail *pantallaEmail = [[EnviarMail alloc] init];
    pantallaEmail.mailDestino = MAIL_SOPORTE;
    pantallaEmail.asunto = [NSString stringWithFormat:
                            NSLocalizedString(@"MAIL_TIT", nil), kVERSION];
    pantallaEmail.mensaje = NSLocalizedString(@"MAIL_MSG", nil);
    pantallaEmail.delegate = delegate;
    
    return pantallaEmail;
}

-(void)mostrarPanelDelEmail {
    MFMailComposeViewController *panelMail = [[MFMailComposeViewController alloc] init];
    panelMail.title = NSLocalizedString(@"MAIL_VENTANA_TITULO", nil);
    [panelMail.navigationBar setTintColor:[UIColor colorWithRed:0.0156 green:0.211 blue:0.266 alpha:1]];
    [panelMail setDelegate:self];
    panelMail.mailComposeDelegate = self;
    [panelMail setToRecipients:[NSArray arrayWithObject:self.mailDestino]];
    [panelMail setSubject:self.asunto];
    [panelMail setMessageBody:self.mensaje isHTML:YES];

    if (panelMail)
        [self.delegate presentModalViewController:panelMail animated:YES];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	switch (result)	{
		case MFMailComposeResultCancelled:
			[self.delegate dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSaved:
			[self.delegate dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSent:
			[self.delegate dismissModalViewControllerAnimated:YES];
			break;
		default:{
            [TAHelper mostrarAlertaConTitulo:@"Error" mensaje:NSLocalizedString(@"MAIL_ERROR_DESCONOCIDO", nil)];
		}
        break;
	}
}

@end

