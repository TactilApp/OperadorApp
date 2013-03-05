//
//  Agenda.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//


#import "Agenda.h"

#import <MKStoreKit/MKStoreManager.h>

@implementation Agenda
-(void)mostrarAgenda{
    if([MKStoreManager isFeaturePurchased:AGENDA_PRODUCT_ID]){
        
        [TAHelper registrarEvento:@"Mostrar agenda"];
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [self.viewController presentModalViewController:picker animated:YES];
        
    }else{
        
        [TAHelper registrarEvento:@"Sugiere compra"];
        [self sugerirComprar];
        
        return;
        
    }
}

-(void)sugerirComprar{
    if ([SKPaymentQueue canMakePayments]){
        NSString *titulo = NSLocalizedString(@"AGENDA_SUGERIR_COMPRA_TIT", nil);
        NSString *mensaje = NSLocalizedString(@"AGENDA_SUGERIR_COMPRA_MSG", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        
        [alert show];
    }else{
        [TAHelper registrarEvento:@"InAppPurchase desactivadas"];
        [TAHelper mostrarAlertaConTitulo:@"AGENDA_INAPP_DESACTIVADAS_TIT" mensaje:@"AGENDA_INAPP_DESACTIVADAS_MSG"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[MKStoreManager sharedManager] buyFeature:AGENDA_PRODUCT_ID
            onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                
                [TAHelper registrarEvento:@"Compra" parametros:@{@"aceptada" : @"SI"} ];
                [self mostrarAgenda];
                
            } onCancelled:^{
                
                [TAHelper registrarEvento:@"Compra" parametros:@{@"aceptada" : @"NO"} ];
                
            }];
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (property == kABPersonPhoneProperty){
        
        [TAHelper registrarEvento:@"Teléfono cargado desde agenda"];
        
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonPhoneProperty)));
        NSString *mobile = [self telefonoLimpio:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, identifier))];
        
		self.viewController.TFtelefono.text = [mobile stringByReplacingOccurrencesOfString:@"+34" withString:@""];
        
        [self.viewController dismissModalViewControllerAnimated:YES];
        return NO;
    }
    
    [TAHelper
     mostrarAlertaConTitulo:NSLocalizedString(@"AGENDA_TELEFONO_INCORRECTO_TIT", nil)
     mensaje:NSLocalizedString(@"AGENDA_TELEFONO_INCORRECTO_MSG", nil)];
    
    return NO;   
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.viewController dismissModalViewControllerAnimated:YES];
}

-(NSString *)telefonoLimpio:(NSString *)telefono{
    return [[[[telefono stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
