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
    #ifdef FLURRY
        [FlurryAnalytics logEvent:@"Mostrar agenda"];
    #endif
    
    if([MKStoreManager isFeaturePurchased:AGENDA_PRODUCT_ID]){
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [viewController presentModalViewController:picker animated:YES];
    }else{
        [self sugerirComprar];
        return;
    }
}

-(void)sugerirComprar{
    if ([SKPaymentQueue canMakePayments]){
        #ifdef FLURRY
            [FlurryAnalytics logEvent:@"Sugiere compra"];
        #endif
        [TAHelper mostrarAlertaConTitulo:@"Cargar contactos desde la agenda"  mensaje:@"La opción de cargar los contactos desde la agenda del iPhone debe adquirirse por separado.\nEn caso de que ya hubiese comprado esta opción anteriormente CON SU CUENTA, indique que lo desea comprar de nuevo para activarla con total tranquilidad, ya que no se le va a volver a cobrar, ESTA OPCIÓN SOLO SE PAGA LA PRIMERA VEZ y después se puede utilizar sin límites."];
    }else{
        #ifdef FLURRY
            [FlurryAnalytics logEvent:@"InAppPurchase desactivadas"];
        #endif
        [TAHelper mostrarAlertaConTitulo:@"Cargar contactos desde la agenda" mensaje:@"La opción de cargar los contactos desde la agenda del iPhone debe adquirirse por separado.\nPara ello, debe activar la opción de \"Compras integradas\" desde los ajustes de su iPhone.\nInformar de que el importe se abonará una única vez, sin importar el número de dispositivos en que se instale (con la misma cuenta de usuario)."];
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    [[MKStoreManager sharedManager] buyFeature:AGENDA_PRODUCT_ID];
    #ifdef FLURRY
        [FlurryAnalytics logEvent:@"Compra aceptada"];
    #endif
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *myProduct = response.products;
    NSLog(@"producto: %d", [myProduct count]);
//    [request autorelease];
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (property == kABPersonPhoneProperty){
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonPhoneProperty)));
        NSString *mobile = [self telefonoLimpio:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, identifier))];
        
		viewController.TFtelefono.text = [mobile stringByReplacingOccurrencesOfString:@"+34" withString:@""];
        
        #ifdef FLURRY
            [FlurryAnalytics logEvent:@"Teléfono cargado desde agenda"];
        #endif
        
        [viewController dismissModalViewControllerAnimated:YES];
        return NO;
    }
    
    [TAHelper mostrarAlertaConTitulo:@"Teléfono incorrecto" mensaje:@"OperadorApp solo funciona con números de móviles en España"];
    
    return NO;   
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [viewController dismissModalViewControllerAnimated:YES];
}

-(NSString *)telefonoLimpio:(NSString *)telefono{
    return [[[[telefono stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
