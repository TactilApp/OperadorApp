//
//  Agenda.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "Agenda.h"
#import "OAprivate-configure.h"

@implementation Agenda
@synthesize viewController;

-(void)mostrarAgenda{
    [FlurryAnalytics logEvent:@"Mostrar agenda"];
    
    if([MKStoreManager isFeaturePurchased:AGENDA_PRODUCT_ID]){
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [viewController presentModalViewController:picker animated:YES];
        [picker release];
    }else{
        [self sugerirComprar];
        return;
    }
}

-(void)sugerirComprar{
    if ([SKPaymentQueue canMakePayments]){
        [FlurryAnalytics logEvent:@"Sugiere compra"];
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Cargar contactos desde la agenda" message:@"La opción de cargar los contactos desde la agenda del iPhone debe adquirirse por separado.\nEn caso de que ya hubiese comprado esta opción anteriormente CON SU CUENTA, indique que lo desea comprar de nuevo para activarla con total tranquilidad, ya que no se le va a volver a cobrar, ESTA OPCIÓN SOLO SE PAGA LA PRIMERA VEZ y después se puede utilizar sin límites."  delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles:nil];
        [alerta show];
        [alerta release];
    }else{
        [FlurryAnalytics logEvent:@"InAppPurchase desactivadas"];
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Cargar contactos desde la agenda" message:@"La opción de cargar los contactos desde la agenda del iPhone debe adquirirse por separado.\nPara ello, debe activar la opción de \"Compras integradas\" desde los ajustes de su iPhone.\nInformar de que el importe se abonará una única vez, sin importar el número de dispositivos en que se instale (con la misma cuenta de usuario)."  delegate:nil cancelButtonTitle:@"Continuar" otherButtonTitles:nil];
        [alerta show];
        [alerta release];
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [[MKStoreManager sharedManager] buyFeature:AGENDA_PRODUCT_ID];
    [FlurryAnalytics logEvent:@"Compra aceptada"];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *myProduct = response.products;
    NSLog(@"producto: %d", [myProduct count]);
    [request autorelease];
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (property == kABPersonPhoneProperty){
        ABMultiValueRef phones =(NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *mobile = [self telefonoLimpio:(NSString*)ABMultiValueCopyValueAtIndex(phones, identifier)];
        
		viewController.TFtelefono.text = [mobile stringByReplacingOccurrencesOfString:@"+34" withString:@""];

        [FlurryAnalytics logEvent:@"Teléfono cargado desde agenda"];
        
        [viewController dismissModalViewControllerAnimated:YES];
        return NO;
    }
    
    [viewController mostrarAlertaConTitulo:@"Teléfono incorrecto" mensaje:@"OperadorApp solo funciona con números de móviles en España"];
    
    return NO;   
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [viewController dismissModalViewControllerAnimated:YES];
}

-(NSString *)telefonoLimpio:(NSString *)telefono{
    return [[[[telefono stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
