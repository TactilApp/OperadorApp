//
//  EnviarMail.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 11/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "EnviarMail.h"

#import "OAprivate-configure.h"

@implementation EnviarMail
@synthesize delegate, mailDestino, asunto, mensaje;

- (id)init {
    self = [super init];
    if (self) {
        mailDestino = MAIL_SOPORTE;
        asunto = @"";
        mensaje = @"";
        delegate = nil;
    }
    return self;
}

-(void) mostrarPanelDelEmail {
    MFMailComposeViewController *panelMail = [[MFMailComposeViewController alloc] init];
    panelMail.title = TITULO_VENTANA;
    [panelMail.navigationBar setTintColor:[UIColor colorWithRed:0.0156 green:0.211 blue:0.266 alpha:1]];
    [[panelMail.toolbarItems objectAtIndex:0] setTintColor:[UIColor redColor]];
    [panelMail setDelegate:self];
    panelMail.mailComposeDelegate = self;
    [panelMail setToRecipients:[NSArray arrayWithObject:mailDestino]];
    [panelMail setSubject:asunto];
    [panelMail setMessageBody:mensaje isHTML:YES];
    if (panelMail !=nil){
        [delegate presentModalViewController:panelMail animated:YES];
    }
    [panelMail release];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	switch (result)	{
		case MFMailComposeResultCancelled:
			[delegate dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSaved:
			[delegate dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSent:
			[delegate dismissModalViewControllerAnimated:YES];
			break;
		default:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ha ocurrido un error al intentar enviar el email, revise la configuración." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			break;
	}
}

@end

