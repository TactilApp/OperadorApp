//
//  Agenda.h
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <StoreKit/StoreKit.h>

#import "MKStoreManager.h"

#import "OperadorAppViewController.h"
@class OperadorAppViewController;


@interface Agenda : NSObject <SKProductsRequestDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>{
    OperadorAppViewController *viewController;
}

@property (nonatomic, assign) OperadorAppViewController *viewController;


-(void)mostrarAgenda;
-(void)sugerirComprar;
    
-(NSString *)telefonoLimpio:(NSString *)telefono;
@end
